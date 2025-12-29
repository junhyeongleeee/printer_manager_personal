import 'dart:async';
import 'package:print_manager/infra/ngpcl_socket.dart';
import 'package:print_manager/core/services/logger_service.dart';

/// NGPCL 하이브리드 카운터
/// Unsolicited Data + 폴링 백업 방식
/// 
/// 권장 방식:
/// 1. Unsolicited Data를 우선 활용 (이벤트 기반, 실시간)
/// 2. 폴링을 백업으로 사용 (Unsolicited Data 누락 시 대비)
/// 3. Counts Request로 주기적으로 검증
class NGPCLHybridCounter {
  final NGPCLSocket socket;
  Timer? _verificationTimer;
  bool _isMonitoring = false;
  int _currentCount = 0;
  DateTime? _lastUnsolicitedTime;
  
  // 콜백 함수
  Function(int count)? onCountChanged;
  Function()? onPrintStarted;
  Function()? onPrintCompleted;

  NGPCLHybridCounter(this.socket);

  /// 하이브리드 모니터링 시작
  /// 
  /// [verificationInterval]: 검증 폴링 주기 (기본 2초)
  /// Unsolicited Data를 주로 사용하고, 주기적으로 Counts로 검증
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

    // 초기 카운트 조회
    await _verifyCount();

    // 주기적으로 카운트 검증 (Unsolicited Data 누락 대비)
    _verificationTimer = Timer.periodic(verificationInterval, (timer) async {
      if (!_isMonitoring) {
        timer.cancel();
        return;
      }

      await _verifyCount();
    });

    logger.i('NGPCL 하이브리드 모니터링 시작 (검증 주기: ${verificationInterval.inSeconds}초)');
  }

  /// Unsolicited Data 처리
  /// 프린터가 자동으로 보내는 메시지 처리
  void _handleUnsolicitedData(String message) {
    _lastUnsolicitedTime = DateTime.now();
    
    // Print Status 응답 확인
    if (message.contains('~PS') || message.contains('PRINTING') || message.contains('COMPLETE')) {
      logger.i('Unsolicited Print Status: $message');
      
      // 인쇄 시작/완료 감지
      if (message.contains('PRINTING') || message.contains('PRODUCING')) {
        onPrintStarted?.call();
      } else if (message.contains('COMPLETE') || message.contains('READY')) {
        onPrintCompleted?.call();
        // 완료 시 카운트 검증
        _verifyCount();
      }
    }
    
    // Counts 응답 확인
    if (message.contains('~CR') || message.contains('TOTAL') || message.contains('BATCH')) {
      logger.i('Unsolicited Counts: $message');
      final newCount = _parseCountFromResponse(message);
      if (newCount != null && newCount != _currentCount) {
        _updateCount(newCount);
      }
    }
  }

  /// 카운트 검증 (Counts Request)
  Future<void> _verifyCount() async {
    try {
      final response = await socket.getCounts();
      final newCount = _parseCountFromResponse(response);
      
      if (newCount != null) {
        // Unsolicited Data가 오래 안 왔으면 강제 업데이트
        final timeSinceLastUnsolicited = _lastUnsolicitedTime != null
            ? DateTime.now().difference(_lastUnsolicitedTime!)
            : const Duration(hours: 1);
        
        if (newCount != _currentCount) {
          if (timeSinceLastUnsolicited > const Duration(seconds: 5)) {
            // Unsolicited Data가 5초 이상 없으면 폴링 결과로 업데이트
            logger.w('Unsolicited Data 누락 감지, 폴링 결과로 업데이트');
            _updateCount(newCount);
          } else {
            // Unsolicited Data가 최근에 있었으면 검증만
            logger.d('카운트 검증: $newCount (현재: $_currentCount)');
          }
        }
        
        // 검증 완료
      }
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

  /// Counts Response에서 카운트 값 파싱
  int? _parseCountFromResponse(String response) {
    try {
      // BATCH 카운트를 우선 사용
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
  void stopMonitoring() {
    _isMonitoring = false;
    _verificationTimer?.cancel();
    _verificationTimer = null;
    socket.unsolicitedData = null;
    logger.i('NGPCL 하이브리드 모니터링 중지');
  }

  /// 현재 카운트 조회
  int get currentCount => _currentCount;

  /// 모니터링 중인지 확인
  bool get isMonitoring => _isMonitoring;

  void dispose() {
    stopMonitoring();
  }
}

