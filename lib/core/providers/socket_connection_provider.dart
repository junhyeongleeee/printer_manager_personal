// socket_connection_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:print_manager/core/zipher_socket.dart';
import 'package:print_manager/core/data/zipher_commands.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

class SocketConnectionNotifier extends StateNotifier<bool> {
  SocketConnectionNotifier() : super(false);
  Socket? _socket;

  // 👇 콜백 정의
  Function(String message)? onData;
  Function()? onDone;
  Function(Object error)? onSocketError;

  bool get isConnected => _socket != null;

  Future<void> connect(String host, int port) async {
    _socket = await Socket.connect(host, port);

    _socket!.listen(
          (data) {
        final message = utf8.decode(data).trim();
        onData?.call(message);
      },
      onDone: () {
        onDone?.call();
        dispose();
      },
      onError: (error) {
        onSocketError?.call(error);
        dispose();
      },
    );
  }

  void send(String message) {
    _socket?.write('$message\r');
  }

  void sendUtf16LE(String message) {
    final bytes = _encodeUtf16LE(message + '\r');
    _socket?.add(bytes);
  }

  void dispose() {
    _socket?.destroy();
    _socket = null;
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

  // Zipher 명령어 헬퍼 메서드
  void setPrinterRunning() => send(ZipherCommand.sst('1'));

  void setPrinterOffline() => send(ZipherCommand.sst('0'));

  void setPrintState(int state) => send(ZipherCommand.sst('$state'));

  void selectJob(String jobName) => send(ZipherCommand.sel(jobName));

  void requestJobData(String field) => send(ZipherCommand.gjd(field));

  void updateField(String field, String value) =>
      send(ZipherCommand.jda(field, value));

  void printOnce() => send(ZipherCommand.prn());
}