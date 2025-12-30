import 'dart:async';
import 'package:print_manager/data/enums/zipher_command_enum.dart';
import 'package:print_manager/infra/zipher_socket.dart';
import 'package:print_manager/core/services/logger_service.dart';

/// Zipher 폴링 카운터
/// 폴링 방식으로 카운트를 주기적으로 조회
///
/// Zipher 프로토콜 특성:
/// - GPC (Get Counts) 명령으로 카운트 조회
/// - GST (Get Status) 명령으로 상태 확인
class ZipherHybridCounter {
  final ZipherSocket socket;
  Timer? _verificationTimer;
  bool _isMonitoring = false;
  int _currentCount = 0;
  String? _lastStatus;
  bool _isVerifying = false; // 검증 중인지 추적

  // 콜백 함수
  Function(int count)? onCountChanged;
  Function()? onPrintStarted;
  Function()? onPrintCompleted;

  ZipherHybridCounter(this.socket);

  /// 폴링 모니터링 시작
  ///
  /// [verificationInterval]: 폴링 주기 (기본 2초)
  /// 주기적으로 GPC와 GST 명령으로 카운트와 상태를 조회
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

    logger.i('Zipher 폴링 모니터링 시작 (폴링 주기: ${verificationInterval.inSeconds}초)');
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
    // 이미 검증 중이면 스킵 (동시 실행 방지)
    if (_isVerifying) {
      logger.d('검증이 이미 진행 중입니다. 스킵합니다.');
      return;
    }

    // logger.i('카운트 검증 시작');

    _isVerifying = true;
    try {
      // GPC로 카운트 직접 조회
      final countsResponse = await socket.getCounts();
      final counts = _parseCountsFromResponse(countsResponse);

      logger.i('countsResponse: $countsResponse currentCount: $_currentCount');

      if (counts != null) {
        final newCount = counts['total'] ?? counts['batch'] ?? 0;

        logger.i('newCount: $newCount');

        // 폴링 결과로 카운트 업데이트
        if (newCount != _currentCount) {
          _updateCount(newCount);
        } else {
          logger.d('카운트 검증: $newCount (변화 없음)');
        }
      }

      // GST로 상태도 확인 (백업)
      final statusResponse = await socket.getPrinterStatus();
      _processStatusResponse(statusResponse);
    } catch (e) {
      logger.e('카운트 검증 실패: $e');
    } finally {
      _isVerifying = false;
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
  /// 응답 형식: PCS|total|batch|...
  Map<String, int>? _parseCountsFromResponse(String response) {
    try {
      logger.i('response: $response');
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
  void stopMonitoring() {
    _isMonitoring = false;
    _verificationTimer?.cancel();
    _verificationTimer = null;
    logger.i('Zipher 폴링 모니터링 중지');
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
