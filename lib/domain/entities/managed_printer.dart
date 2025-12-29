import 'package:print_manager/core/interfaces/printer_socket.dart';
import 'package:print_manager/core/enums/printer_protocol.dart';
import 'package:print_manager/core/factories/printer_socket_factory.dart';
import 'package:print_manager/core/services/logger_service.dart';
import 'package:print_manager/infra/zipher_socket.dart';
import 'package:print_manager/domain/usecases/zipher_hybrid_counter.dart';

class ManagedPrinter {
  final int index;
  int? id;
  final String name;
  final String ip;
  final int port;
  final PrinterSocket socket; // 프로토콜 독립적으로 변경
  final PrinterProtocol protocol; // 프로토콜 타입 추가
  final String regDate;
  //final PrinterRepository repository;

  String connectStatus = '미연결';
  String? status;
  String? code;
  String? item;
  String? printStatus = "인쇄 대기";
  int? totalPrintWork;
  int? completePrintWork;
  String? startDate;
  String? endDate;

  // Zipher 인쇄 감지 카운터
  ZipherHybridCounter? _printCounter;
  int _currentPrintCount = 0;

  ManagedPrinter({
    required this.index,
    required this.id,
    required this.name,
    required this.ip,
    required this.port,
    required this.regDate,
    PrinterProtocol? protocol,
    PrinterSocket? socket,
    //required this.repository,
  }) : protocol = protocol ?? PrinterProtocol.zipher,
       socket = socket ?? PrinterSocketFactory.create(protocol ?? PrinterProtocol.zipher) {
    this.socket.setOnData(_handleData);
    this.socket.setOnDone(() => _updateStatus('연결 종료'));
    this.socket.setOnError((e) => _updateStatus('에러: $e'));
  }

  Future<bool> connect() async {
    try {
      await socket.connect(ip, port);
      _updateStatus('연결됨');

      // Zipher 프로토콜일 때 인쇄 감지 모니터링 시작
      if (protocol == PrinterProtocol.zipher && socket is ZipherSocket) {
        _startPrintMonitoring(socket as ZipherSocket);
      }

      return true;
    } catch (_) {
      _updateStatus('연결 실패');
      return false;
    }
  }

  /// Zipher 인쇄 감지 모니터링 시작
  void _startPrintMonitoring(ZipherSocket zipherSocket) {
    try {
      // 기존 카운터가 있으면 정리
      _printCounter?.dispose();

      // 새로운 하이브리드 카운터 생성 및 시작
      _printCounter = ZipherHybridCounter(zipherSocket);

      _printCounter!.startHybridMonitoring(
        verificationInterval: const Duration(seconds: 2),
        onCountChanged: (count) {
          _currentPrintCount = count;
          logger.i('[$name] 인쇄 카운트 변경: $count장');
          // 여기서 UI 업데이트나 상태 변경 로직 추가 가능
          _updatePrinterStatus('인쇄 중 (${count}장)');
        },
        onPrintStarted: () {
          logger.i('[$name] 인쇄 시작 감지');
          _updatePrinterStatus('인쇄 시작');
        },
        onPrintCompleted: () {
          logger.i('[$name] 인쇄 완료 감지 (총: $_currentPrintCount장)');
          _updatePrinterStatus('인쇄 완료 (${_currentPrintCount}장)');
        },
      );

      logger.i('[$name] Zipher 인쇄 감지 모니터링 시작');
    } catch (e) {
      logger.e('[$name] 인쇄 감지 모니터링 시작 실패: $e');
    }
  }

  /// 인쇄 감지 모니터링 중지
  void stopPrintMonitoring() {
    _printCounter?.dispose();
    _printCounter = null;
    logger.i('[$name] 인쇄 감지 모니터링 중지');
  }

  /// 현재 인쇄 카운트 조회
  int get currentPrintCount => _currentPrintCount;

  Future<void> sendPrintJob(String jobName, int start, int end) async {
    logger.i("sendPrinterJob Start");
    final field = 'Field00';
    final jobName = "0611textTest";
    await socket.setPrinterRunning();
    _updatePrinterStatus("인쇄 중");

    Future.delayed(Duration(milliseconds: 200)).then((_) async {
      for (int i = start; i <= end; i++) {
        //socket.selectJob(jobName);
        await socket.selectJob(jobName);
        await socket.requestJobData(field);
        await socket.updateField(field, _toHex(i));
        await Future.delayed(Duration(milliseconds: 300));
      }
      await socket.setPrinterOffline();
    });

    _updatePrinterStatus("인쇄 완료");
    //repository.updatePrinterJob(index);
  }

  String toSixDigitHex(int number) {
    return number.toRadixString(16).padLeft(6, '0').toUpperCase();
  }

  Future<void> getPrinterStatus() async {
    await socket.getPrinterStatus();
    //프린터 구조를 동기로 바꾸고 응답 받은 값으로 상태 표시 필요
  }

  Future<void> printJobRepeatedly({
    required String jobName,
    required String uniqueCode,
    required int start,
    required int end,
  }) async {
    if (!socket.isConnected) throw Exception('Not connected to printer');
    final field = 'Field00';
    final jobName = "0625yi6";
    //final jobName = "0625yi";
    // 프린터 Running 상태로
    //await socket.setPrinterRunning(); //socket.send(ZipherCommand.sst('3'));
    await Future.delayed(Duration(milliseconds: 200));
    for (int i = start; i <= end; i++) {
      await socket.selectJob(jobName);
      await socket.requestJobData(field);

      final printString = uniqueCode + toSixDigitHex(i);
      //final printString = toSixDigitHex(i);
      logger.i("printString : $printString");
      await socket.updateField(field, printString);
      await Future.delayed(Duration(milliseconds: 300)); // 프린터 속도에 따라 조정
      await socket.printOnce();

      await Future.delayed(Duration(milliseconds: 200)); // 프린터 속도에 따라 조정
    }
    printStatus = "인쇄 완료";
    // 프린터 Offline으로
    await socket.setPrinterOffline();
  }

  void _handleData(String message) {
    if (message.contains('QFULL')) {
      //printStatus = '큐 가득참';
    } else {
      //printStatus = message;
    }
  }

  void _updatePrinterStatus(String newStatus) {
    connectStatus = newStatus;
    // 여기서 notifyListeners(), state 갱신 등 처리 필요
  }

  void _updateStatus(String newStatus) {
    connectStatus = newStatus;
    // 여기서 notifyListeners(), state 갱신 등 처리 필요
  }

  void dispose() {
    stopPrintMonitoring();
    socket.dispose();
  }

  String _toHex(int number) => number.toRadixString(16).padLeft(8, '0').toUpperCase();

  void updateFields({
    int? id,
    String? code,
    String? item,
    String? connectStatus,
    String? status,
    String? printStatus,
    String? startDate,
    String? endDate,
    int? totalPrintWork,
    int? completePrintWork,
  }) {
    if (id != null) this.id = id;
    if (code != null) this.code = code;
    if (item != null) this.item = item;
    if (connectStatus != null) this.connectStatus = connectStatus;
    if (status != null) this.status = status;
    if (printStatus != null) this.printStatus = printStatus;
    if (startDate != null) this.startDate = startDate;
    if (endDate != null) this.endDate = endDate;
    if (totalPrintWork != null) this.totalPrintWork = totalPrintWork;
    if (completePrintWork != null) this.completePrintWork = completePrintWork;
  }
}
