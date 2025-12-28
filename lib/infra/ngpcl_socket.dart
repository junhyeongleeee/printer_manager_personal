import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:print_manager/core/interfaces/printer_socket.dart';

/// NGPCL 프로토콜 소켓 구현
/// NGPCL 프로토콜 명령어를 처리합니다.
class NGPCLSocket implements PrinterSocket {
  Socket? _socket;
  Completer<String>? _responseCompleter;
  List<String> _responseBuffer = [];

  Function(String message)? unsolicitedData;
  Function(String message)? onData;
  Function()? onDone;
  Function(Object error)? onError;

  bool get isConnected => _socket != null;

  @override
  Future<void> connect(String host, int port) async {
    if (_socket != null) {
      await disconnect();
    }

    _socket = await Socket.connect(host, port);

    _socket!.listen(
      (data) {
        final messages = utf8.decode(data).trim().split('\r');
        for (final message in messages) {
          final trimmed = message.trim();
          if (trimmed.isEmpty) continue;

          print("NGPCL receive message: $trimmed");

          // NGPCL 프로토콜 응답 처리
          // TODO: NGPCL 프로토콜의 실제 응답 형식에 맞게 수정 필요
          const completionCodes = {'ACK', 'ERR', 'OK'};
          const completionPrefixCodes = {'STS', 'JDL', 'FLT', 'WRN', 'JOB'};

          if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
            _responseBuffer.add(trimmed);

            if (completionCodes.contains(trimmed) ||
                completionPrefixCodes.any((code) => trimmed.startsWith(code))) {
              print("NGPCL 응답완료");
              _responseCompleter!.complete(_responseBuffer.join('\r'));
              _responseCompleter = null;
              _responseBuffer.clear();
            }
          } else {
            // Unsolicited data 처리
            unsolicitedData?.call(trimmed);
            onData?.call(trimmed);
          }
        }
      },
      onDone: () {
        if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
          _responseCompleter!.completeError(StateError("Socket closed before response."));
        }
        _cleanup();
        onDone?.call();
      },
      onError: (error) {
        if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
          _responseCompleter!.completeError(error);
        }
        _cleanup();
        onError?.call(error);
      },
      cancelOnError: true,
    );
  }

  Future<void> disconnect() async {
    if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
      _responseCompleter!.completeError(StateError("Socket disconnected manually."));
    }
    await _socket?.close();
    _socket?.destroy();
    _cleanup();
  }

  void _cleanup() {
    _responseCompleter = null;
    _responseBuffer.clear();
    _socket = null;
  }

  Future<String> _sendInternal(
    String message, {
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_socket == null) {
      return Future.error(StateError("Socket not connected."));
    }
    if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
      return Future.error(StateError("Another request is in progress."));
    }

    _responseCompleter = Completer<String>();
    _responseBuffer.clear();

    print("NGPCL send message: $message");
    _socket!.write('$message\r');

    return _responseCompleter!.future.timeout(timeout, onTimeout: () {
      _responseCompleter = null;
      _responseBuffer.clear();
      throw TimeoutException("Response timeout for: $message");
    });
  }

  @override
  Future<String> send(String message) async {
    return _sendInternal(message);
  }

  @override
  void sendUtf16LE(String message) {
    // NGPCL은 UTF-8 사용 (필요시 UTF-16 LE 지원 추가)
    final bytes = utf8.encode(message + '\r');
    _socket?.add(bytes);
  }

  @override
  void dispose() {
    _socket?.destroy();
    _cleanup();
  }

  // NGPCL 프로토콜 명령어 구현
  // NGPCL은 Zipher와 유사한 명령어 구조를 사용하지만 일부 차이가 있을 수 있음
  // 실제 NGPCL 프로토콜 스펙에 맞게 조정 필요
  
  @override
  Future<String> setPrinterRunning() async {
    // NGPCL: 프린터 Running 상태로 전환
    // NGPCL은 Zipher와 동일한 SST 명령어를 사용할 수 있음
    return _sendInternal('SST|3|');
  }

  @override
  Future<String> setPrinterOffline() async {
    // NGPCL: 프린터 Offline 상태로 전환
    return _sendInternal('SST|4|');
  }

  @override
  Future<String> setPrintState(int state) async {
    // NGPCL: 프린터 상태 설정
    return _sendInternal('SST|$state|');
  }

  @override
  Future<String> selectJob(String jobName) async {
    // NGPCL: Job 선택
    return _sendInternal('SEL|$jobName|');
  }

  @override
  Future<String> requestJobData(String field) async {
    // NGPCL: Job 데이터 요청
    return _sendInternal('GJD|$field|');
  }

  @override
  Future<String> updateField(String field, String value) async {
    // NGPCL: 필드 업데이트
    return _sendInternal('JDA|$field=$value|');
  }

  @override
  Future<String> printOnce() async {
    // NGPCL: 인쇄 실행
    return _sendInternal('PRN');
  }

  @override
  Future<String> getPrinterStatus() async {
    // NGPCL: 프린터 상태 조회
    return _sendInternal('GST');
  }

  @override
  void setOnData(Function(String message) callback) {
    onData = callback;
  }

  @override
  void setOnDone(Function() callback) {
    onDone = callback;
  }

  @override
  void setOnError(Function(Object error) callback) {
    onError = callback;
  }
}

