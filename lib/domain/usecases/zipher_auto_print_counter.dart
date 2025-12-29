import 'dart:async';
import 'package:print_manager/infra/zipher_socket.dart';
import 'package:print_manager/core/services/logger_service.dart';

/// Zipher 프로토콜 자동 인쇄 카운터
/// 폴링 방식으로 인쇄 상태를 확인하여 카운팅
class ZipherAutoPrintCounter {
  final ZipherSocket socket;
  Timer? _pollingTimer;
  bool _isMonitoring = false;
  int _currentCount = 0;
  int _lastCount = 0;
  DateTime? _lastPrintTime;
  String _lastStatus = '';

  // 콜백 함수
  Function(int count)? onCountChanged;
  Function()? onPrintStarted;
  Function()? onPrintCompleted;

  ZipherAutoPrintCounter(this.socket);

  /// 폴링 방식으로 인쇄 카운트 모니터링 시작
  ///
  /// [pollInterval]: 폴링 주기 (기본 500ms)
  ///
  /// Zipher는 상태 기반 추적:
  /// - GST 명령으로 상태 확인
  /// - STS 응답에서 상태 파싱
  /// - PRS, PRC 같은 이벤트 감지
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
    _currentCount = 0;
    _lastCount = 0;
    _lastStatus = '';

    // 초기 상태 확인
    await _updateStatus();

    // 주기적으로 상태 확인
    _pollingTimer = Timer.periodic(pollInterval, (timer) async {
      if (!_isMonitoring) {
        timer.cancel();
        return;
      }

      await _updateStatus();
    });

    logger.i('Zipher 폴링 모니터링 시작 (주기: ${pollInterval.inMilliseconds}ms)');
  }

  /// 상태 업데이트 (GST 명령 또는 GPC 명령)
  /// GPC를 사용하면 카운트를 직접 조회할 수 있음
  Future<void> _updateStatus() async {
    try {
      // 방법 1: GPC로 카운트 직접 조회 (더 정확)
      try {
        final countsResponse = await socket.getCounts();
        final counts = _parseCountsFromResponse(countsResponse);
        if (counts != null) {
          _handleCountsChange(counts['total'] ?? 0, counts['batch'] ?? 0);
        }
      } catch (e) {
        logger.d('GPC 실패, GST로 대체: $e');
      }

      // 방법 2: GST로 상태 확인 (백업)
      final response = await socket.getPrinterStatus();
      final status = _parseStatusFromResponse(response);

      if (status != null) {
        _handleStatusChange(status);
      }
    } catch (e) {
      logger.e('상태 조회 실패: $e');
    }
  }

  /// 카운트 변경 처리 (GPC 응답 기반)
  void _handleCountsChange(int total, int batch) {
    // BATCH 카운트를 우선 사용 (현재 작업의 카운트)
    final newCount = batch > 0 ? batch : total;

    if (newCount != _currentCount) {
      final previousCount = _currentCount;
      _currentCount = newCount;

      // 카운트가 증가했는지 확인
      if (_currentCount > _lastCount) {
        final printCount = _currentCount - _lastCount;
        logger.i('인쇄 감지: $printCount장 인쇄됨 (총: $_currentCount장, 배치: $batch)');

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

  /// 상태 변경 처리
  void _handleStatusChange(String status) {
    final previousStatus = _lastStatus;
    _lastStatus = status;

    // 인쇄 시작 감지
    // Zipher에서 인쇄 중 상태는 보통 "PRINTING", "RUNNING" 등
    if (_isPrintingStatus(status) && !_isPrintingStatus(previousStatus)) {
      final now = DateTime.now();
      // 이전 인쇄와의 간격 확인 (중복 감지 방지)
      if (_lastPrintTime == null || now.difference(_lastPrintTime!) > const Duration(seconds: 1)) {
        logger.i('인쇄 시작 감지: $status');
        onPrintStarted?.call();
        _lastPrintTime = now;
      }
    }

    // 인쇄 완료 감지
    // 인쇄 중이었다가 완료 상태로 변경
    if (_isPrintingStatus(previousStatus) && !_isPrintingStatus(status)) {
      logger.i('인쇄 완료 감지: $previousStatus -> $status');

      // 인쇄 완료 시 카운트 증가
      _currentCount++;
      _lastCount = _currentCount;

      logger.i('인쇄 카운트 증가: $_currentCount장 (이전: ${_lastCount - 1})');
      onCountChanged?.call(_currentCount);
      onPrintCompleted?.call();
    }

    // PRC (Print Complete) 이벤트 직접 감지
    if (status.contains('PRC') || status.contains('PRINT COMPLETE')) {
      _currentCount++;
      _lastCount = _currentCount;
      logger.i('PRC 이벤트 감지: $_currentCount장 (이전: ${_lastCount - 1})');
      onCountChanged?.call(_currentCount);
      onPrintCompleted?.call();
    }
  }

  /// 인쇄 중 상태인지 확인
  bool _isPrintingStatus(String status) {
    if (status.isEmpty) return false;

    final upperStatus = status.toUpperCase();
    return upperStatus.contains('PRINTING') ||
        upperStatus.contains('PRINT') ||
        upperStatus.contains('RUNNING') ||
        upperStatus.contains('PRS') || // Print Start
        upperStatus.contains('PRODUCING');
  }

  /// GST 응답에서 상태 파싱
  /// 응답 형식: STS|상태코드|...| 또는 단순 상태 문자열
  String? _parseStatusFromResponse(String response) {
    try {
      // STS|...| 형식 파싱
      if (response.startsWith('STS')) {
        final parts = response.split('|');
        if (parts.length > 1) {
          // 상태 코드는 보통 2번째 필드
          return parts[1];
        }
      }

      // PRS, PRC 같은 이벤트 직접 확인
      if (response.contains('PRS') || response.contains('PRC')) {
        return response;
      }

      // 단순 상태 문자열
      return response.trim();
    } catch (e) {
      logger.e('상태 파싱 실패: $e');
      return null;
    }
  }

  /// 모니터링 중지
  void stopPolling() {
    _isMonitoring = false;
    _pollingTimer?.cancel();
    _pollingTimer = null;
    logger.i('Zipher 폴링 모니터링 중지');
  }

  /// 현재 카운트 조회
  int get currentCount => _currentCount;

  /// 모니터링 중인지 확인
  bool get isMonitoring => _isMonitoring;

  /// 카운트 리셋
  void resetCount() {
    _currentCount = 0;
    _lastCount = 0;
    logger.i('카운트 리셋');
  }

  void dispose() {
    stopPolling();
  }
}
