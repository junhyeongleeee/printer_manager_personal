import 'dart:async';
import 'package:print_manager/infra/zipher_socket.dart';
import 'package:print_manager/core/services/logger_service.dart';

/// Zipher 하이브리드 카운터
/// Unsolicited Data + 폴링 백업 방식
///
/// Zipher 프로토콜 특성:
/// - PRS (Print Start), PRC (Print Complete) 이벤트 활용
/// - Unsolicited Data로 자동 이벤트 수신
/// - GST로 상태 확인 (백업)
class ZipherHybridCounter {
  final ZipherSocket socket;
  Timer? _verificationTimer;
  bool _isMonitoring = false;
  int _currentCount = 0;
  DateTime? _lastUnsolicitedTime;
  String? _lastStatus;

  // 콜백 함수
  Function(int count)? onCountChanged;
  Function()? onPrintStarted;
  Function()? onPrintCompleted;

  ZipherHybridCounter(this.socket);

  /// 하이브리드 모니터링 시작
  ///
  /// [verificationInterval]: 검증 폴링 주기 (기본 2초)
  /// Unsolicited Data를 주로 사용하고, 주기적으로 상태로 검증
  Future<void> startHybridMonitoring({
    Duration verificationInterval = const Duration(seconds: 2),
    Function(int count)? onCountChanged,
    Function()? onPrintStarted,
    Function()? onPrintCompleted,
  }) async {
    if (_isMonitoring) {
      logger.w('이미 모니터링 중입니다.');
      return;
    }

    this.onCountChanged = onCountChanged;
    this.onPrintStarted = onPrintStarted;
    this.onPrintCompleted = onPrintCompleted;

    _isMonitoring = true;
    _currentCount = 0;

    // Unsolicited Data 리스너 설정
    socket.unsolicitedData = _handleUnsolicitedData;

    // 초기 상태 확인
    await _verifyStatus();

    // 주기적으로 상태 검증 (Unsolicited Data 누락 대비)
    _verificationTimer = Timer.periodic(verificationInterval, (timer) async {
      if (!_isMonitoring) {
        timer.cancel();
        return;
      }

      await _verifyStatus();
    });

    logger.i('Zipher 하이브리드 모니터링 시작 (검증 주기: ${verificationInterval.inSeconds}초)');
  }

  /// Unsolicited Data 처리
  /// 프린터가 자동으로 보내는 메시지 처리
  void _handleUnsolicitedData(String message) {
    _lastUnsolicitedTime = DateTime.now();

    logger.d('Unsolicited Data: $message');

    // PRS (Print Start) 감지
    if (message.contains('PRS') ||
        message.toUpperCase().contains('PRINT START') ||
        message.toUpperCase().contains('PRINTING')) {
      logger.i('PRS 이벤트 감지: 인쇄 시작');
      onPrintStarted?.call();
      _lastStatus = 'PRINTING';
    }

    // PRC (Print Complete) 감지
    if (message.contains('PRC') ||
        message.toUpperCase().contains('PRINT COMPLETE') ||
        message.toUpperCase().contains('PRINTED')) {
      logger.i('PRC 이벤트 감지: 인쇄 완료');

      // 카운트 증가
      _currentCount++;
      logger.i('인쇄 카운트 증가: $_currentCount장');
      onCountChanged?.call(_currentCount);
      onPrintCompleted?.call();
      _lastStatus = 'READY';
    }

    // GPC (Get Counts) 응답 확인
    if (message.startsWith('GPC') || message.contains('GPC')) {
      logger.i('Unsolicited Counts: $message');
      final counts = _parseCountsFromResponse(message);
      if (counts != null) {
        final newCount = counts['batch'] ?? counts['total'] ?? 0;
        if (newCount != _currentCount) {
          _updateCount(newCount);
        }
      }
    }

    // STS (Status) 응답 확인
    if (message.startsWith('STS')) {
      logger.d('Unsolicited Status: $message');
      _processStatusResponse(message);
    }

    // ACK, ERR 등 기타 응답
    if (message == 'ACK' || message == 'ERR') {
      logger.d('Unsolicited Response: $message');
    }
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

          // 인쇄 시작 (상태가 인쇄 중으로 변경)
          if (_isPrintingStatus(statusCode) && !_isPrintingStatus(previousStatus ?? '')) {
            logger.i('상태 변경: 인쇄 시작 ($previousStatus -> $statusCode)');
            onPrintStarted?.call();
          }

          // 인쇄 완료 (인쇄 중에서 다른 상태로 변경)
          if (_isPrintingStatus(previousStatus ?? '') && !_isPrintingStatus(statusCode)) {
            logger.i('상태 변경: 인쇄 완료 ($previousStatus -> $statusCode)');
            _currentCount++;
            logger.i('인쇄 카운트 증가: $_currentCount장');
            onCountChanged?.call(_currentCount);
            onPrintCompleted?.call();
          }
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

  /// 카운트 검증 (GPC 명령)
  Future<void> _verifyStatus() async {
    try {
      // GPC로 카운트 직접 조회
      final countsResponse = await socket.getCounts();
      final counts = _parseCountsFromResponse(countsResponse);

      if (counts != null) {
        // Unsolicited Data가 오래 안 왔으면 강제 업데이트
        final timeSinceLastUnsolicited =
            _lastUnsolicitedTime != null ? DateTime.now().difference(_lastUnsolicitedTime!) : const Duration(hours: 1);

        final newCount = counts['batch'] ?? counts['total'] ?? 0;

        if (timeSinceLastUnsolicited > const Duration(seconds: 5)) {
          // Unsolicited Data가 5초 이상 없으면 폴링 결과로 업데이트
          logger.w('Unsolicited Data 누락 감지, 폴링 결과로 업데이트');
          if (newCount != _currentCount) {
            _updateCount(newCount);
          }
        } else {
          // Unsolicited Data가 최근에 있었으면 검증만
          logger.d('카운트 검증: $newCount (현재: $_currentCount)');
        }
      }

      // GST로 상태도 확인 (백업)
      final statusResponse = await socket.getPrinterStatus();
      _processStatusResponse(statusResponse);
    } catch (e) {
      logger.e('카운트 검증 실패: $e');
    }
  }

  /// 카운트 업데이트
  void _updateCount(int newCount) {
    if (newCount > _currentCount) {
      final printCount = newCount - _currentCount;
      logger.i('인쇄 감지: $printCount장 인쇄됨 (총: $newCount장)');

      _currentCount = newCount;
      onCountChanged?.call(_currentCount);
    } else if (newCount < _currentCount) {
      // 카운트가 감소한 경우 (리셋 등)
      logger.w('카운트 감소 감지: $_currentCount -> $newCount');
      _currentCount = newCount;
      onCountChanged?.call(_currentCount);
    }
  }

  /// GPC 응답에서 카운트 값 파싱
  /// 응답 형식: GPC|total|batch|...
  Map<String, int>? _parseCountsFromResponse(String response) {
    try {
      if (response.startsWith('GPC')) {
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
  void stopMonitoring() {
    _isMonitoring = false;
    _verificationTimer?.cancel();
    _verificationTimer = null;
    socket.unsolicitedData = null;
    logger.i('Zipher 하이브리드 모니터링 중지');
  }

  /// 현재 카운트 조회
  int get currentCount => _currentCount;

  /// 모니터링 중인지 확인
  bool get isMonitoring => _isMonitoring;

  /// 카운트 리셋
  void resetCount() {
    _currentCount = 0;
    logger.i('카운트 리셋');
  }

  void dispose() {
    stopMonitoring();
  }
}
