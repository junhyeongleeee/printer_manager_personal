import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:print_manager/core/interfaces/printer_socket.dart';
import 'package:print_manager/core/services/logger_service.dart';
import 'package:print_manager/core/data/ngpcl_commands.dart';

/// NGPCL 프로토콜 소켓 구현
/// NGPCL Users Guide v25.pdf 기반 구현
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
        final rawData = utf8.decode(data);
        final messages = _parseNGPCLMessages(rawData);

        for (final message in messages) {
          if (message.isEmpty) continue;

          logger.i("NGPCL receive message: $message");

          // NGPCL 응답 메시지 식별
          // 응답 형식: STX ~ [응답코드] | [데이터] | ETX 또는 단순 응답
          final isCompletion = _isCompletionMessage(message);

          if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
            _responseBuffer.add(message);

            if (isCompletion) {
              logger.i("NGPCL 응답완료");
              _responseCompleter!.complete(_responseBuffer.join('\r'));
              _responseCompleter = null;
              _responseBuffer.clear();
            }
          } else {
            // Unsolicited data 처리
            unsolicitedData?.call(message);
            onData?.call(message);
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

  /// NGPCL 메시지 파싱
  /// STX/ETX 또는 레거시 ^A/^Z 구분자로 메시지 분리
  List<String> _parseNGPCLMessages(String rawData) {
    final messages = <String>[];
    final stx = NGPCLCommand.stx;
    const legacyStx = '\x01'; // ^A
    const etx = NGPCLCommand.etx;
    const legacyEtx = '\x1A'; // ^Z

    logger.i('rawData: $rawData');

    int start = 0;
    while (start < rawData.length) {
      // STX 또는 레거시 STX 찾기
      int stxIndex = rawData.indexOf(stx, start);
      int legacyStxIndex = rawData.indexOf(legacyStx, start);

      int messageStart = -1;
      String endMarker = etx;

      if (stxIndex != -1 && (legacyStxIndex == -1 || stxIndex < legacyStxIndex)) {
        messageStart = stxIndex;
        endMarker = etx;
      } else if (legacyStxIndex != -1) {
        messageStart = legacyStxIndex;
        endMarker = legacyEtx;
      } else {
        // 구분자가 없으면 \r로 분리 (레거시 호환)
        final crIndex = rawData.indexOf('\r', start);
        if (crIndex != -1) {
          messages.add(rawData.substring(start, crIndex).trim());
          start = crIndex + 1;
          continue;
        } else {
          break;
        }
      }

      if (messageStart == -1) break;

      // ETX 찾기
      final endIndex = rawData.indexOf(endMarker, messageStart + 1);
      if (endIndex == -1) break;

      messages.add(rawData.substring(messageStart, endIndex + 1));
      start = endIndex + 1;
    }

    return messages;
  }

  /// 완료 메시지인지 확인
  bool _isCompletionMessage(String message) {
    // NGPCL 응답 코드 확인
    const responsePrefixes = {
      '~JS', // Job Select Response
      '~JU', // Job Update Response
      '~PS', // Print Status Response
      '~PG', // Print Request Response
      '~DS', // Device Status Response
      '~CR', // Counts Response
      '~ST', // Setting Response
      '~FC', // Field Contents Response
      '~LF', // Logged Field Contents Response
      '~VO', // Virtual Output Response
      '~RC', // Clock Response
      '~CS', // Clock Set Response
      '~VR', // Version Response
      '~PV', // Protocol Version Response
      '~CT', // Clear to Send Response
      '~JP', // Job Preview Response
      '~NAK', // Negative Acknowledgment
    };

    // 레거시 응답 코드
    const legacyResponses = {'ACK', 'ERR', 'OK', 'STS', 'JDL', 'FLT', 'WRN', 'JOB'};

    final upperMessage = message.toUpperCase();

    // NGPCL 응답 확인
    if (responsePrefixes.any((prefix) => message.startsWith(prefix))) {
      return true;
    }

    // 레거시 응답 확인
    if (legacyResponses.contains(upperMessage) || legacyResponses.any((code) => upperMessage.startsWith(code))) {
      return true;
    }

    // ETX로 끝나는 메시지는 완료로 간주
    return message.endsWith(NGPCLCommand.etx) || message.endsWith('\x1A');
  }

  Future<String> _sendInternal(String message, {Duration timeout = const Duration(seconds: 15)}) async {
    if (_socket == null) {
      return Future.error(StateError("Socket not connected."));
    }
    if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
      return Future.error(StateError("Another request is in progress."));
    }

    _responseCompleter = Completer<String>();
    _responseBuffer.clear();

    logger.i("NGPCL send message: $message");

    // NGPCL 메시지는 이미 STX/ETX가 포함되어 있으므로 그대로 전송
    // 레거시 호환을 위해 \r 추가하지 않음
    _socket!.write(message);

    return _responseCompleter!.future.timeout(
      timeout,
      onTimeout: () {
        _responseCompleter = null;
        _responseBuffer.clear();
        throw TimeoutException("Response timeout for: $message");
      },
    );
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

  // ========== PrinterSocket 인터페이스 구현 ==========
  // 기존 인터페이스와의 호환성을 위한 래퍼 메서드들

  @override
  Future<String> setPrinterRunning() async {
    // NGPCL: State Change를 사용하여 PRODUCING 상태로 전환
    return _sendInternal(NGPCLCommand.stateChange('PRODUCING'));
  }

  @override
  Future<String> setPrinterOffline() async {
    // NGPCL: State Change를 사용하여 READY 상태로 전환 (Offline)
    return _sendInternal(NGPCLCommand.stateChange('READY'));
  }

  @override
  Future<String> setPrintState(int state) async {
    // NGPCL: State Change 사용
    // state 매핑: 0=READY, 1=PRODUCING, 2=HELD 등
    final stateMap = {
      0: 'READY',
      1: 'PRODUCING',
      2: 'HELD',
      3: 'PRODUCING', // Running
      4: 'READY', // Offline
    };
    final ngpclState = stateMap[state] ?? 'READY';
    return _sendInternal(NGPCLCommand.stateChange(ngpclState));
  }

  @override
  Future<String> selectJob(String jobName) async {
    // NGPCL: Job Select 명령어
    return _sendInternal(NGPCLCommand.jobSelect(jobName));
  }

  @override
  Future<String> requestJobData(String field) async {
    // NGPCL: Field Contents Request
    return _sendInternal(NGPCLCommand.fieldContentsRequest(field));
  }

  @override
  Future<String> updateField(String field, String value) async {
    // NGPCL: Job Update (단일 필드)
    // Image While Printing 패턴을 위해 replyWhenJobImaged 사용
    return _sendInternal(NGPCLCommand.jobUpdate(replyTiming: NGPCLCommand.replyWhenJobImaged, fields: {field: value}));
  }

  @override
  Future<String> printOnce() async {
    // NGPCL: Print Request
    // Image While Printing 패턴을 위해 replyWhenPrintStarted 사용
    return _sendInternal(NGPCLCommand.printRequest(replyTiming: NGPCLCommand.replyWhenPrintStarted, count: 1));
  }

  @override
  Future<String> getPrinterStatus() async {
    // NGPCL: Print Status Request
    // Image While Printing 패턴을 위해 replyWhenReadyToPrint 사용
    return _sendInternal(NGPCLCommand.printStatusRequest(replyTiming: NGPCLCommand.replyWhenReadyToPrint));
  }

  // ========== NGPCL 전용 메서드 ==========

  /// 여러 필드 업데이트 (NGPCL 전용)
  /// Image While Printing 패턴에 최적화
  Future<String> updateFields({
    required Map<String, String> fields,
    int replyTiming = NGPCLCommand.replyWhenJobImaged,
  }) async {
    return _sendInternal(NGPCLCommand.jobUpdate(replyTiming: replyTiming, fields: fields));
  }

  /// Device Status 요청 (NGPCL 전용)
  Future<String> getDeviceStatus() async {
    return _sendInternal(NGPCLCommand.deviceStatusRequest());
  }

  /// Counts 요청 (NGPCL 전용)
  Future<String> getCounts() async {
    return _sendInternal(NGPCLCommand.countsRequest());
  }

  /// Print Status 요청 (NGPCL 전용, 세밀한 제어)
  Future<String> requestPrintStatus({int replyTiming = NGPCLCommand.replyImmediately}) async {
    return _sendInternal(NGPCLCommand.printStatusRequest(replyTiming: replyTiming));
  }

  /// Print Request (NGPCL 전용, 세밀한 제어)
  Future<String> requestPrint({int replyTiming = NGPCLCommand.replyWhenPrintStarted, int count = 1}) async {
    return _sendInternal(NGPCLCommand.printRequest(replyTiming: replyTiming, count: count));
  }

  /// State Change (NGPCL 전용)
  Future<String> changeState(String state) async {
    return _sendInternal(NGPCLCommand.stateChange(state));
  }

  /// Setting 변경 (NGPCL 전용)
  Future<String> changeSetting(String settingName, String value) async {
    return _sendInternal(NGPCLCommand.settingChange(settingName, value));
  }

  /// Setting 요청 (NGPCL 전용)
  Future<String> requestSetting(String settingName) async {
    return _sendInternal(NGPCLCommand.settingRequest(settingName));
  }

  /// Virtual Input 설정 (NGPCL 전용)
  Future<String> setVirtualInput(int inputNumber, bool value) async {
    return _sendInternal(NGPCLCommand.setVirtualInput(inputNumber, value));
  }

  /// Virtual Output 요청 (NGPCL 전용)
  Future<String> requestVirtualOutput() async {
    return _sendInternal(NGPCLCommand.virtualOutputRequest());
  }

  /// Remote Purge (5600/5800 전용)
  Future<String> remotePurge(String printhead) async {
    return _sendInternal(NGPCLCommand.remotePurge(printhead));
  }

  /// Clear Print Queue (5600/5800 전용)
  Future<String> clearPrintQueue() async {
    return _sendInternal(NGPCLCommand.clearPrintQueue());
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
