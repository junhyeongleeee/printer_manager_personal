import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:print_manager/data/zipher_commands.dart';
import 'package:print_manager/core/interfaces/printer_socket.dart';
import 'package:print_manager/core/services/logger_service.dart';

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
          const completionPrefixCodes = {'STS', 'JDL', 'FLT', 'WRN', 'JOB', 'PCS'};

          logger.i("receive message: $trimmed");

          if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
            _responseBuffer.add(trimmed);

            if (completionCodes.contains(trimmed) || completionPrefixCodes.any((code) => trimmed.startsWith(code))) {
              logger.i("응답완료");
              _responseCompleter!.complete(_responseBuffer.join('\r'));
              _responseCompleter = null;
              _responseBuffer.clear();
            }
          } else {
            unsolicitedData?.call(trimmed);
            onData?.call(trimmed);
          }
        }
        logger.i("receive end");
      },
      onDone: () {
        if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
          _responseCompleter!.completeError(StateError("Socket closed before response."));
        }
        _cleanup();
        logger.i("receieve message done, disconnect");
        onDone?.call();
      },
      onError: (error) {
        if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
          _responseCompleter!.completeError(error);
        }
        _cleanup();
        logger.i("receieve message error, disconnect");
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
    logger.i("send message: $message");
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

    return _responseCompleter!.future.timeout(
      timeout,
      onTimeout: () {
        _responseCompleter = null;
        _responseBuffer.clear();
        throw TimeoutException("Response timeout for: $message");
      },
    );
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

  // ========== PrinterSocket 인터페이스 구현 ==========

  @override
  Future<String> getPrinterStatus() => send(ZipherCommand.gst());

  @override
  Future<String> setPrinterRunning() => send(ZipherCommand.sst('3'));

  @override
  Future<String> setPrinterOffline() => send(ZipherCommand.sst('4'));

  @override
  Future<String> setPrintState(int state) => send(ZipherCommand.sst('$state'));

  @override
  Future<String> selectJob(String jobName) => send(ZipherCommand.sel(jobName));

  @override
  Future<String> requestJobData(String field) => send(ZipherCommand.gjd(field));

  @override
  Future<String> updateField(String field, String value) => send(ZipherCommand.jda(field, value));

  @override
  Future<String> printOnce() => send(ZipherCommand.prn());

  // ========== Zipher 전용 메서드 ==========

  /// 여러 필드 업데이트 (Zipher 전용)
  Future<String> updateFields(Map<String, String> fields) => send(ZipherCommand.jdu(fields));

  /// Job 선택 및 필드 할당 (Zipher 전용)
  Future<String> selectJobWithFields(String jobName, Map<String, String> fields) =>
      send(ZipherCommand.sla(jobName, fields));

  /// 카운트 조회 (Zipher 전용)
  /// 응답: GPC|total|batch|...
  Future<String> getCounts() => send(ZipherCommand.gpc());

  /// 카운트 설정 (Zipher 전용)
  Future<String> setCounts({int? total, int? batch}) => send(ZipherCommand.spc(total: total, batch: batch));

  /// 큐 크기 조회 (Zipher 전용)
  Future<String> getQueueSize() => send(ZipherCommand.qsz());

  /// 큐 길이 조회 (Zipher 전용)
  Future<String> getQueueLength() => send(ZipherCommand.qln());

  /// 현재 Job 이름 조회 (Zipher 전용)
  Future<String> getJobName() => send(ZipherCommand.gjn());

  /// Job 목록 조회 (Zipher 전용)
  Future<String> getJobList() => send(ZipherCommand.gjl());

  /// Job 필드 목록 조회 (Zipher 전용)
  Future<String> getJobFields() => send(ZipherCommand.gjf());

  /// 시간 및 날짜 조회 (Zipher 전용)
  Future<String> getTimeAndDate() => send(ZipherCommand.gtd());

  /// 날짜 및 시간 설정 (Zipher 전용)
  Future<String> setTimeAndDate(String dateTime) => send(ZipherCommand.tad(dateTime));

  /// 프로토콜 버전 조회 (Zipher 전용)
  Future<String> getVersion() => send(ZipherCommand.ver());

  /// 테스트 인쇄 (Zipher 전용)
  Future<String> testPrint() => send(ZipherCommand.tpr());

  // 오류 관련
  Future<String> clearFault() => send(ZipherCommand.caf());
  Future<String> getFault() => send(ZipherCommand.gft());
  Future<String> clearWarning() => send(ZipherCommand.caw());
  Future<String> getWarning() => send(ZipherCommand.gwn());
  Future<String> clearSingleError(int errorCode) => send(ZipherCommand.cem(errorCode));

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
