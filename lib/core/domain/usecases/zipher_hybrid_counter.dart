import 'dart:async';
import 'package:print_manager/core/data/enums/zipher_command_enum.dart';
import 'package:print_manager/core/infra/zipher_socket.dart';
import 'package:print_manager/core/services/logger_service.dart';

/// Zipher 프린터 모니터링
/// 폴링 방식으로 프린터의 카운트와 상태를 주기적으로 조회
///
/// Zipher 프로토콜 특성:
/// - GPC (Get Counts) 명령으로 카운트 조회
/// - GST (Get Status) 명령으로 프린터 상태 확인
///
/// 모니터링 기능:
/// - 실시간 카운트 추적
/// - 프린터 상태 실시간 확인
/// - 상태 변경 감지 및 콜백
class ZipherHybridCounter {
  final ZipherSocket socket;
  Timer? _verificationTimer;
  bool _isMonitoring = false;
  int _currentCount = 0;
  String? _lastStatus;
  bool _isVerifying = false; // 검증 중인지 추적
  int? _lastUpdatedCount; // 마지막으로 필드 값이 업데이트된 카운트

  // 필드 업데이트 설정
  String? _jobName;
  String? _fieldName;

  // 콜백 함수
  Function(int count)? onCountChanged;
  Function()? onPrintStarted;
  Function()? onPrintCompleted;
  Function(String status)? onStatusChanged; // 프린터 상태 변경 콜백

  // 필드 값 요청 콜백 (중앙 관리자에게 필드 값 요청)
  // 반환: 프린터에 바로 전송 가능한 포맷된 필드 값 (uniqueCode + HEX), null이면 사용 가능한 값이 없음
  Future<String?> Function()? onRequestFieldValue;

  ZipherHybridCounter(this.socket);

  /// 프린터 모니터링 시작
  ///
  /// [verificationInterval]: 폴링 주기 (기본 2초)
  /// [jobName]: 필드 업데이트에 사용할 Job 이름 (선택사항)
  /// [fieldName]: 필드 업데이트에 사용할 필드 이름 (선택사항, 기본값: 'Field00')
  /// [onRequestFieldValue]: 필드 값 요청 콜백 (중앙 관리자에게 필드 값 요청, 포맷된 문자열 반환)
  /// [onStatusChanged]: 프린터 상태 변경 콜백 (상태 코드 문자열 전달)
  /// 주기적으로 GPC와 GST 명령으로 카운트와 상태를 조회
  Future<void> startHybridMonitoring({
    Duration verificationInterval = const Duration(seconds: 2),
    String? jobName,
    String? fieldName,
    Function(int count)? onCountChanged,
    Function()? onPrintStarted,
    Function()? onPrintCompleted,
    Function(String status)? onStatusChanged,
    Future<String?> Function()? onRequestFieldValue,
  }) async {
    if (_isMonitoring) {
      logger.w('이미 모니터링 중입니다.');
      return;
    }

    this.onCountChanged = onCountChanged;
    this.onPrintStarted = onPrintStarted;
    this.onPrintCompleted = onPrintCompleted;
    this.onStatusChanged = onStatusChanged;
    this.onRequestFieldValue = onRequestFieldValue;

    // 필드 업데이트 설정
    _jobName = jobName;
    _fieldName = fieldName ?? 'Field00';

    _isMonitoring = true;
    _currentCount = 0;
    _lastUpdatedCount = null; // 초기화

    // 초기 상태 확인
    await _verifyStatus();

    // 주기적으로 상태 검증 (Timer.periodic 사용)
    _verificationTimer = Timer.periodic(verificationInterval, (timer) async {
      if (!_isMonitoring) {
        timer.cancel();
        return;
      }
      await _verifyStatus();
    });

    logger.i('Zipher 프린터 모니터링 시작 (폴링 주기: ${verificationInterval.inSeconds}초)');
  }

  /// 상태 응답 처리
  void _processStatusResponse(String response) {
    try {
      final parts = response.split('|');
      if (parts.length > 1) {
        final statusCode = parts[1];

        // 상태 변경 감지
        if (_lastStatus != statusCode) {
          final previousStatus = _lastStatus;
          _lastStatus = statusCode;

          logger.i('프린터 상태 변경: $previousStatus -> $statusCode');

          // 상태 변경 콜백 호출
          onStatusChanged?.call(statusCode);

          // // 인쇄 시작 (상태가 인쇄 중으로 변경)
          // if (_isPrintingStatus(statusCode) && !_isPrintingStatus(previousStatus ?? '')) {
          //   logger.i('인쇄 시작 감지 ($previousStatus -> $statusCode)');
          //   onPrintStarted?.call();
          // }

          // // 인쇄 완료 (인쇄 중에서 다른 상태로 변경)
          // if (_isPrintingStatus(previousStatus ?? '') && !_isPrintingStatus(statusCode)) {
          //   logger.i('인쇄 완료 감지 ($previousStatus -> $statusCode)');
          //   onPrintCompleted?.call();
          // }
        }
      }
    } catch (e) {
      logger.e('상태 응답 처리 실패: $e');
    }
  }

  /// 인쇄 중 상태인지 확인
  bool _isPrintingStatus(String status) {
    if (status.isEmpty) return false;

    final upperStatus = status.toUpperCase();
    return upperStatus.contains('PRINTING') ||
        upperStatus.contains('PRINT') ||
        upperStatus.contains('RUNNING') ||
        upperStatus.contains('PRS') ||
        upperStatus.contains('PRODUCING') ||
        upperStatus == '3'; // Zipher 상태 코드 3 = Running
  }

  /// 프린터 모니터링 (카운트 및 상태 확인)
  /// GPC 명령으로 카운트 조회, GST 명령으로 상태 확인
  Future<void> _verifyStatus() async {
    // 이미 검증 중이면 스킵 (동시 실행 방지)
    if (_isVerifying) {
      logger.d('검증이 이미 진행 중입니다. 스킵합니다.');
      return;
    }

    // 모니터링이 중지되었으면 요청하지 않음
    if (!_isMonitoring) {
      logger.d('모니터링이 중지되어 검증을 스킵합니다.');
      return;
    }

    // logger.i('카운트 검증 시작');

    _isVerifying = true;
    try {
      // 모니터링 중지 확인 (요청 전)
      if (!_isMonitoring) {
        logger.d('모니터링이 중지되어 검증을 취소합니다.');
        return;
      }

      // GPC로 카운트 직접 조회
      final countsResponse = await socket.getCounts();

      // 모니터링 중지 확인 (요청 후)
      if (!_isMonitoring) {
        logger.d('모니터링이 중지되어 검증 결과를 무시합니다.');
        return;
      }

      final counts = _parseCountsFromResponse(countsResponse);

      // logger.i('countsResponse: $countsResponse currentCount: $_currentCount');

      if (counts != null) {
        final newCount = counts['total'] ?? counts['batch'] ?? 0;

        // logger.i('newCount: $newCount');

        // 모니터링 중지 확인 (카운트 업데이트 전)
        if (!_isMonitoring) {
          logger.d('모니터링이 중지되어 카운트 업데이트를 취소합니다.');
          return;
        }

        // 폴링 결과로 카운트 업데이트 (변경 여부와 관계없이 필드 값 업데이트)
        if (newCount != _currentCount) {
          await _updateCount(newCount);
        }
      }

      // 모니터링 중지 확인 (상태 확인 전)
      if (!_isMonitoring) {
        logger.d('모니터링이 중지되어 상태 확인을 취소합니다.');
        return;
      }

      // GST로 프린터 상태 확인
      final statusResponse = await socket.getPrinterStatus();

      // 모니터링 중지 확인 (상태 처리 전)
      if (!_isMonitoring) {
        logger.d('모니터링이 중지되어 상태 처리를 취소합니다.');
        return;
      }

      // 상태 응답 처리
      _processStatusResponse(statusResponse);
    } catch (e) {
      // 모니터링이 중지된 경우의 에러는 무시
      if (_isMonitoring) {
        logger.e('프린터 모니터링 실패: $e');
      } else {
        logger.d('모니터링 중지로 인한 검증 취소: $e');
      }
    } finally {
      _isVerifying = false;
    }
  }

  /// 카운트 업데이트
  Future<void> _updateCount(int newCount) async {
    if (newCount > _currentCount) {
      final printCount = newCount - _currentCount;
      logger.i('인쇄 감지: $printCount장 인쇄됨 (총: $newCount장)');

      _currentCount = newCount;
      _lastUpdatedCount = newCount; // 필드 값 업데이트 추적

      // 필드 값 업데이트
      await _updateFieldValue(newCount);

      onCountChanged?.call(_currentCount);
    }
    // else if (newCount < _currentCount) {
    //   // 카운트가 감소한 경우 (리셋 등)
    //   logger.w('카운트 감소 감지: $_currentCount -> $newCount');
    //   _currentCount = newCount;
    //   _lastUpdatedCount = newCount; // 필드 값 업데이트 추적

    //   // 필드 값 업데이트
    //   await _updateFieldValue(newCount);

    //   onCountChanged?.call(_currentCount);
    // }
  }

  /// 필드 값 업데이트 (managed_printer.dart의 sendPrintJob 로직 참고)
  /// 중앙 관리자에게 포맷된 필드 값을 요청하고 업데이트
  Future<void> _updateFieldValue(int count) async {
    // jobName과 fieldName이 설정되어 있을 때만 필드 업데이트 수행
    if (_jobName == null || _fieldName == null) {
      logger.d('필드 업데이트 스킵: jobName 또는 fieldName이 설정되지 않음');
      return;
    }

    try {
      // 중앙 관리자에게 포맷된 필드 값 요청
      String? fieldValue;
      if (onRequestFieldValue != null) {
        fieldValue = await onRequestFieldValue!();
      }

      if (fieldValue == null) {
        logger.w('필드 값 할당 실패: 사용 가능한 필드 값이 없습니다.');
        return;
      }
      logger.d('중앙 관리자로부터 필드 값 할당받음: $fieldValue (카운트: $count)');

      // 1. Job 선택
      await socket.selectJob(_jobName!);

      // 2. 작업 데이터 요청
      await socket.requestJobData(_fieldName!);

      // 3. 필드 값 업데이트
      await socket.updateField(_fieldName!, fieldValue);

      logger.i('필드 값 업데이트 완료: $_fieldName = $fieldValue (카운트: $count)');
    } catch (e) {
      logger.e('필드 값 업데이트 실패: $e');
    }
  }

  /// 숫자를 8자리 hex 문자열로 변환 (managed_printer.dart의 _toHex 로직 참고)
  String _toHex(int number) => number.toRadixString(16).padLeft(6, '0').toUpperCase();

  /// GPC 응답에서 카운트 값 파싱
  /// 응답 형식: PCS|total|batch|...
  Map<String, int>? _parseCountsFromResponse(String response) {
    try {
      // logger.i('response: $response');
      if (response.startsWith(ZipherCommandEnum.pcs.code)) {
        final parts = response.split('|');
        if (parts.length >= 3) {
          final total = int.tryParse(parts[1]) ?? 0;
          final batch = int.tryParse(parts[2]) ?? 0;
          return {'total': total, 'batch': batch};
        }
      }
      return null;
    } catch (e) {
      logger.e('카운트 파싱 실패: $e');
      return null;
    }
  }

  /// 모니터링 중지
  /// 진행 중인 요청이 완료될 때까지 대기하여 안전하게 중지
  Future<void> stopMonitoring() async {
    if (!_isMonitoring) {
      logger.d('이미 모니터링이 중지되어 있습니다.');
      return;
    }

    logger.i('모니터링 중지 요청...');

    // 모니터링 플래그를 먼저 false로 설정하여 새로운 요청 방지
    _isMonitoring = false;

    // 타이머 취소
    _verificationTimer?.cancel();
    _verificationTimer = null;

    // 진행 중인 검증이 완료될 때까지 대기 (최대 5초)
    int waitCount = 0;
    while (_isVerifying && waitCount < 50) {
      await Future.delayed(const Duration(milliseconds: 100));
      waitCount++;
    }

    if (_isVerifying) {
      logger.w('모니터링 중지 대기 시간 초과 (5초). 강제 중지합니다.');
      _isVerifying = false;
    }

    logger.i('Zipher 프린터 모니터링 중지 완료');
  }

  /// 필드 값 요청 콜백 업데이트 (발주 선택 시 호출)
  void updateFieldValueCallback(Future<String?> Function()? callback) {
    onRequestFieldValue = callback;
    logger.i('필드 값 요청 콜백 업데이트됨');
  }

  /// 현재 카운트 조회
  int get currentCount => _currentCount;

  /// 현재 프린터 상태 조회
  String? get currentStatus => _lastStatus;

  /// 모니터링 중인지 확인
  bool get isMonitoring => _isMonitoring;

  /// 카운트 리셋
  void resetCount() {
    _currentCount = 0;
    logger.i('카운트 리셋');
  }

  Future<void> dispose() async {
    await stopMonitoring();
  }
}
