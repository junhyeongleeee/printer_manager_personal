import 'dart:async';
import 'package:print_manager/core/infra/ngpcl_socket.dart';
import 'package:print_manager/core/services/logger_service.dart';

/// NGPCL 자동 인쇄 카운터
/// 프린터가 자체 센서를 통해 자동으로 인쇄하는 경우의 카운팅 처리
class NGPCLAutoPrintCounter {
  final NGPCLSocket socket;
  Timer? _pollingTimer;
  bool _isMonitoring = false;
  int _lastCount = 0;
  int _currentCount = 0;
  DateTime? _lastPrintTime;

  // 콜백 함수
  Function(int count)? onCountChanged;
  Function()? onPrintStarted;
  Function()? onPrintCompleted;

  NGPCLAutoPrintCounter(this.socket);

  /// 폴링 방식으로 인쇄 카운트 모니터링 시작
  ///
  /// [pollInterval]: 폴링 주기 (기본 500ms)
  /// [onCountChanged]: 카운트가 변경될 때 호출되는 콜백
  ///
  /// 장점:
  /// - 구현이 간단하고 확실함
  /// - 네트워크 지연에 덜 민감
  ///
  /// 단점:
  /// - 네트워크 부하 증가
  /// - 실시간성이 떨어질 수 있음
  /// - 폴링 주기에 따라 정확도가 달라짐
  Future<void> startPolling({
    Duration pollInterval = const Duration(milliseconds: 500),
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
    _lastCount = 0;
    _currentCount = 0;

    // 초기 카운트 조회
    await _updateCount();

    // 주기적으로 카운트 조회
    _pollingTimer = Timer.periodic(pollInterval, (timer) async {
      if (!_isMonitoring) {
        timer.cancel();
        return;
      }

      await _updateCount();
    });

    logger.i('NGPCL 폴링 모니터링 시작 (주기: ${pollInterval.inMilliseconds}ms)');
  }

  /// 카운트 업데이트
  Future<void> _updateCount() async {
    try {
      final response = await socket.getCounts();
      final newCount = _parseCountFromResponse(response);

      if (newCount != null && newCount != _currentCount) {
        final previousCount = _currentCount;
        _currentCount = newCount;

        // 카운트가 증가했는지 확인
        if (_currentCount > _lastCount) {
          final printCount = _currentCount - _lastCount;
          logger.i('인쇄 감지: $printCount장 인쇄됨 (총: $_currentCount장)');

          onCountChanged?.call(_currentCount);

          // 인쇄 시작 감지
          if (_lastPrintTime == null || DateTime.now().difference(_lastPrintTime!) > const Duration(seconds: 2)) {
            onPrintStarted?.call();
          }

          _lastPrintTime = DateTime.now();
          _lastCount = _currentCount;
        }

        // 인쇄 완료 감지 (카운트가 변하지 않고 일정 시간 경과)
        if (previousCount == _currentCount &&
            _lastPrintTime != null &&
            DateTime.now().difference(_lastPrintTime!) > const Duration(milliseconds: 1000)) {
          onPrintCompleted?.call();
        }
      }
    } catch (e) {
      logger.e('카운트 조회 실패: $e');
    }
  }

  /// Counts Response에서 카운트 값 파싱
  /// 응답 형식: ~CR|TOTAL|00000123|BATCH|00000050|...
  int? _parseCountFromResponse(String response) {
    try {
      // BATCH 카운트를 우선 사용 (현재 작업의 카운트)
      final batchMatch = RegExp(r'BATCH\|(\d+)').firstMatch(response);
      if (batchMatch != null) {
        return int.tryParse(batchMatch.group(1) ?? '');
      }

      // BATCH가 없으면 TOTAL 사용
      final totalMatch = RegExp(r'TOTAL\|(\d+)').firstMatch(response);
      if (totalMatch != null) {
        return int.tryParse(totalMatch.group(1) ?? '');
      }

      return null;
    } catch (e) {
      logger.e('카운트 파싱 실패: $e');
      return null;
    }
  }

  /// 모니터링 중지
  void stopPolling() {
    _isMonitoring = false;
    _pollingTimer?.cancel();
    _pollingTimer = null;
    logger.i('NGPCL 폴링 모니터링 중지');
  }

  /// 현재 카운트 조회
  int get currentCount => _currentCount;

  /// 모니터링 중인지 확인
  bool get isMonitoring => _isMonitoring;

  void dispose() {
    stopPolling();
  }
}
