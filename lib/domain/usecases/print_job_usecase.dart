import 'package:print_manager/infra/zipher_socket.dart';

class PrintJobUseCase {
  final ZipherSocket socket;

  PrintJobUseCase(this.socket);

  Future<void> printJobRepeatedly({
    required String jobName,
    required int start,
    required int end
  }) async {
    if (!socket.isConnected) throw Exception('Not connected to printer');
    //final field = 'Field00';
    final field = '0625yi6';
    // 프린터 Running 상태로
    socket.setPrinterRunning(); //socket.send(ZipherCommand.sst('1'));
    await Future.delayed(Duration(milliseconds: 200));
    for (int i = start; i <= end; i++) {
      socket.selectJob(jobName);
      socket.requestJobData(field);
      socket.updateField(field, toSixDigitHex(i));
      socket.printOnce();

      await Future.delayed(Duration(milliseconds: 300)); // 프린터 속도에 따라 조정
    }

    // 프린터 Offline으로
    socket.setPrinterOffline();
  }

  String toSixDigitHex(int number) {
    return number.toRadixString(16).padLeft(8, '0').toUpperCase();
  }

  Future<void> printJobRepeatedly2({
    required String jobName,
    required String uniqueCode,
    required int start,
    required int end
  }) async {
    if (!socket.isConnected) throw Exception('Not connected to printer');
    final field = 'Field00';
    // 프린터 Running 상태로
    socket.setPrinterRunning(); //socket.send(ZipherCommand.sst('1'));
    await Future.delayed(Duration(milliseconds: 200));
    for (int i = start; i <= end; i++) {
      socket.selectJob(jobName);
      socket.requestJobData(field);
      socket.updateField(field, uniqueCode+toSixDigitHex(i));
      socket.printOnce();

      await Future.delayed(Duration(milliseconds: 300)); // 프린터 속도에 따라 조정
    }

    // 프린터 Offline으로
    socket.setPrinterOffline();
  }
}

