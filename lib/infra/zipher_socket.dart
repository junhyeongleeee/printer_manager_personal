import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:print_manager/data/zipher_commands.dart';
import 'package:print_manager/core/interfaces/printer_socket.dart';

class ZipherSocket implements PrinterSocket {
  Socket? _socket;
  Completer<String>? _responseCompleter;

  List<String> _responseBuffer = [];
  //Set<String> _expectedTags = {};
  //Set<String> _receivedTags = {};

  Function(String message)? unsolicitedData;
  Function(String message)? onData;
  Function()? onDone;
  Function(Object error)? onError;

  bool get isConnected => _socket != null;

  Future<void> connect(String host, int port) async {
    if (_socket != null) {
      await disconnect(); // 기존 연결 종료
    }

    _socket = await Socket.connect(host, port);

    _socket!.listen(
          (data) {
        final messages = utf8.decode(data).trim().split('\r');
        for (final message in messages) {
          final trimmed = message.trim();

          const completionCodes = {'ACK', 'ERR'};
          const completionPrefixCodes = {'STS','JDL', 'FLT', 'WRN', 'JOB'};

          print("receive message: $trimmed");

          if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
            _responseBuffer.add(trimmed);

            if (completionCodes.contains(trimmed) || completionPrefixCodes.any((code) => trimmed.startsWith(code))) {
              print("응답완료");
              _responseCompleter!.complete(_responseBuffer.join('\r'));
              _responseCompleter = null;
              _responseBuffer.clear();
            }
          } else {
            unsolicitedData?.call(trimmed);
            onData?.call(trimmed);
          }
        }
        print("receive end");
      },
      onDone: () {
        if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
          _responseCompleter!.completeError(StateError("Socket closed before response."));
        }
        _cleanup();
        print("receieve message done, disconnect");
        onDone?.call();
      },
      onError: (error) {
        if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
          _responseCompleter!.completeError(error);
        }
        _cleanup();
        print("receieve message error, disconnect");
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
    //_expectedTags.clear();
    //_receivedTags.clear();
    _socket = null;
  }

  Future<String> send(String message, {Duration timeout = const Duration(seconds: 5)}) async {
    print("send message: $message");
    return _sendInternal(message, useAckEnding: true);
  }

  // Future<String> sendMulti(String message, Set<String> expectedTags, {Duration timeout = const Duration(seconds: 5)}) async {
  //   return _sendInternal(message, expectedTags: expectedTags);
  // }

  Future<String> _sendInternal(
      String message, {
        bool useAckEnding = false,
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

    _socket!.write('$message\r');

    return _responseCompleter!.future.timeout(timeout, onTimeout: () {
      _responseCompleter = null;
      _responseBuffer.clear();
      throw TimeoutException("Response timeout for: $message");
    });
  }


  void sendUtf16LE(String message) {
    final bytes = _encodeUtf16LE(message + '\r');
    _socket?.add(bytes);
  }

  Uint8List _encodeUtf16LE(String input) {
    final codeUnits = input.codeUnits;
    final bytes = <int>[];
    for (final unit in codeUnits) {
      bytes.add(unit & 0xFF);
      bytes.add((unit >> 8) & 0xFF);
    }
    return Uint8List.fromList(bytes);
  }

  void dispose() {
    _socket?.destroy();
    _cleanup();
  }

  // Zipher 명령어 헬퍼 메서드 (단일 응답 기반)
  Future<String> getPrinterStatus() => send(ZipherCommand.gst());
  Future<String> setPrinterRunning() => send(ZipherCommand.sst('3'));
  Future<String> setPrinterOffline() => send(ZipherCommand.sst('4'));
  Future<String> setPrintState(int state) => send(ZipherCommand.sst('$state'));
  Future<String> selectJob(String jobName) => send(ZipherCommand.sel(jobName));
  Future<String> requestJobData(String field) => send(ZipherCommand.gjd(field));
  Future<String> updateField(String field, String value) => send(ZipherCommand.jda(field, value));

  /// 이 명령은 PRS + PRC + ACK 세 개의 응답을 예상하므로 sendMulti 사용
  // Future<String> printOnce() => sendMulti(
  //   ZipherCommand.prn(),
  //   {'PRS', 'PRC', 'ACK'},
  // );

  Future<String> printOnce() => send(
    ZipherCommand.prn(),
  );

  // 오류 관련
  Future<String> clearFault() => send(ZipherCommand.caf());
  Future<String> getFault() => send(ZipherCommand.gft());
  Future<String> clearWarning() => send(ZipherCommand.caw());
  Future<String> getWarning() => send(ZipherCommand.gwn());

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
