import 'package:flutter/foundation.dart';
import 'package:print_manager/core/interfaces/printer_socket.dart';
import 'package:print_manager/core/enums/printer_protocol.dart';
import 'package:print_manager/core/factories/printer_socket_factory.dart';
import 'package:print_manager/core/services/logger_service.dart';
import 'package:print_manager/infra/zipher_socket.dart';
import 'package:print_manager/domain/usecases/zipher_hybrid_counter.dart';

class ManagedPrinter extends ChangeNotifier {
  final int index;
  int? id;
  final String name;
  final String ip;
  final int port;
  final PrinterSocket socket; // 프로토콜 독립적으로 변경
  final PrinterProtocol protocol; // 프로토콜 타입 추가
  final String regDate;
  //final PrinterRepository repository;

  // 연결 상태 (네트워크 연결 상태)
  String _connectionStatus = '미연결';
  String get connectionStatus => _connectionStatus;

  // 프린터 작동 상태 (인쇄 상태)
  String _printStatus = "인쇄 대기";
  String get printStatus => _printStatus;

  // 하위 호환성을 위한 getter (기존 코드 호환)
  @Deprecated('Use connectionStatus instead')
  String get connectStatus => _connectionStatus;

  String? _status;
  String? get status => _status;

  String? _code;
  String? get code => _code;

  String? _item;
  String? get item => _item;

  int? _totalPrintWork;
  int? get totalPrintWork => _totalPrintWork;

  int? _completePrintWork;
  int? get completePrintWork => _completePrintWork;

  String? _startDate;
  String? get startDate => _startDate;

  String? _endDate;
  String? get endDate => _endDate;

  // 프린터 on/off 상태
  bool? _isPrinterOn; // null = 알 수 없음, true = ON (Running), false = OFF (Offline/Ready)
  bool? get isPrinterOn => _isPrinterOn;

  // Zipher 인쇄 감지 카운터
  ZipherHybridCounter? _printCounter;
  int _currentPrintCount = 0;

  // 카운트 변경 콜백 (UI 업데이트용)
  Function(ManagedPrinter)? onCountUpdate;

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
    this.socket.setOnDone(() => _updateConnectionStatus('연결 종료'));
    this.socket.setOnError((e) => _updateConnectionStatus('에러: $e'));
  }

  Future<bool> connect() async {
    try {
      await socket.connect(ip, port);
      _updateConnectionStatus('연결됨');

      // 프린터 상태 읽기
      await _readPrinterState();

      // Zipher 프로토콜일 때 프린터가 ON 상태일 때만 인쇄 감지 모니터링 시작
      if (protocol == PrinterProtocol.zipher && socket is ZipherSocket && _isPrinterOn == true) {
        _startPrintMonitoring(socket as ZipherSocket);
      }

      return true;
    } catch (_) {
      _updateConnectionStatus('연결 실패');
      return false;
    }
  }

  /// 프린터 상태 읽기 (GST 명령)
  Future<void> _readPrinterState() async {
    try {
      final statusResponse = await socket.getPrinterStatus();
      final stateCode = _parseStateFromResponse(statusResponse);

      // 상태 코드: 3=Running (ON), 4=Offline (OFF), 1=Ready (OFF)
      bool? newIsPrinterOn;
      if (stateCode == '3') {
        newIsPrinterOn = true;
      } else if (stateCode == '4' || stateCode == '1') {
        newIsPrinterOn = false;
      } else {
        newIsPrinterOn = null; // 알 수 없음
      }

      if (_isPrinterOn != newIsPrinterOn) {
        final previousState = _isPrinterOn;
        _isPrinterOn = newIsPrinterOn;

        // 상태 변경에 따라 모니터링 제어
        if (protocol == PrinterProtocol.zipher && socket is ZipherSocket) {
          if (newIsPrinterOn == true && previousState != true) {
            // OFF -> ON: 모니터링 시작
            if (_printCounter == null) {
              _startPrintMonitoring(socket as ZipherSocket);
            }
          } else if (newIsPrinterOn == false && previousState != false) {
            // ON -> OFF: 모니터링 중지
            await stopPrintMonitoring();
          }
        }

        notifyListeners();
      }

      logger.i('[$name] 프린터 상태 읽기: $stateCode (isPrinterOn: $_isPrinterOn)');
    } catch (e) {
      logger.e('[$name] 프린터 상태 읽기 실패: $e');
      if (_isPrinterOn != null) {
        _isPrinterOn = null;
        notifyListeners();
      }
    }
  }

  /// GST 응답에서 상태 코드 파싱
  /// 응답 형식: STS|상태코드|...|
  String? _parseStateFromResponse(String response) {
    try {
      if (response.startsWith('STS')) {
        final parts = response.split('|');
        if (parts.length > 1) {
          return parts[1];
        }
      }
      return null;
    } catch (e) {
      logger.e('상태 파싱 실패: $e');
      return null;
    }
  }

  /// 프린터 상태 변경 (ON/OFF)
  Future<void> setPrinterState(bool on) async {
    try {
      if (on) {
        await socket.setPrinterRunning();
        _isPrinterOn = true;
        logger.i('[$name] 프린터 상태 변경: ON (Running)');

        // 프린터가 ON일 때 카운트 모니터링 시작
        if (protocol == PrinterProtocol.zipher && socket is ZipherSocket && _printCounter == null) {
          _startPrintMonitoring(socket as ZipherSocket);
        }
      } else {
        await socket.setPrinterOffline();
        _isPrinterOn = false;
        logger.i('[$name] 프린터 상태 변경: OFF (Offline)');

        // 프린터가 OFF일 때 카운트 모니터링 중지
        await stopPrintMonitoring();
      }
      notifyListeners();
      // 기존 콜백 방식도 유지 (하위 호환성)
      onCountUpdate?.call(this);
    } catch (e) {
      logger.e('[$name] 프린터 상태 변경 실패: $e');
      rethrow;
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
        jobName: "____sacheon_1",
        fieldName: "Field00",
        verificationInterval: const Duration(milliseconds: 200),
        onCountChanged: (count) {
          _currentPrintCount = count;
          logger.i('[$name] 인쇄 카운트 변경: $count장');
          // 여기서 UI 업데이트나 상태 변경 로직 추가 가능
          _updatePrinterStatus('인쇄 중 (${count}장)');
          // ChangeNotifier로 UI 자동 업데이트
          notifyListeners();
          // 기존 콜백 방식도 유지 (하위 호환성)
          onCountUpdate?.call(this);
        },
        onPrintStarted: () {
          logger.i('[$name] 인쇄 시작 감지');
          _updatePrinterStatus('인쇄 시작');
        },
        onPrintCompleted: () {
          logger.i('[$name] 인쇄 완료 감지 (총: $_currentPrintCount장)');
          _updatePrinterStatus('인쇄 완료 ($_currentPrintCount장)');
        },
      );

      logger.i('[$name] Zipher 인쇄 감지 모니터링 시작');
    } catch (e) {
      logger.e('[$name] 인쇄 감지 모니터링 시작 실패: $e');
    }
  }

  /// 인쇄 감지 모니터링 중지
  Future<void> stopPrintMonitoring() async {
    if (_printCounter != null) {
      await _printCounter!.dispose();
      _printCounter = null;
      logger.i('[$name] 인쇄 감지 모니터링 중지');
    }
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
    _printStatus = "인쇄 완료";
    notifyListeners();
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

  /// 프린터 작동 상태 업데이트 (인쇄 상태)
  void _updatePrinterStatus(String newStatus) {
    if (_printStatus != newStatus) {
      _printStatus = newStatus;
      notifyListeners();
      // 기존 콜백 방식도 유지 (하위 호환성)
      onCountUpdate?.call(this);
    }
  }

  /// 연결 상태 업데이트 (네트워크 연결 상태)
  void _updateConnectionStatus(String newStatus) {
    if (_connectionStatus != newStatus) {
      _connectionStatus = newStatus;
      notifyListeners();
      // 기존 콜백 방식도 유지 (하위 호환성)
      onCountUpdate?.call(this);
    }
  }

  // 하위 호환성을 위한 메서드
  @Deprecated('Use _updateConnectionStatus instead')
  void _updateStatus(String newStatus) {
    _updateConnectionStatus(newStatus);
  }

  @override
  void dispose() {
    // 비동기 처리를 시작하되 완료를 기다리지 않음 (dispose는 동기적이어야 함)
    stopPrintMonitoring().catchError((e) {
      logger.e('[$name] 모니터링 중지 중 오류 발생: $e');
    });
    socket.dispose();
    super.dispose(); // ChangeNotifier의 dispose 호출
  }

  String _toHex(int number) => number.toRadixString(16).padLeft(8, '0').toUpperCase();

  void updateFields({
    int? id,
    String? code,
    String? item,
    String? connectionStatus,
    String? connectStatus, // 하위 호환성 (deprecated)
    String? status,
    String? printStatus,
    String? startDate,
    String? endDate,
    int? totalPrintWork,
    int? completePrintWork,
  }) {
    bool hasChanged = false;

    if (id != null && this.id != id) {
      this.id = id;
      hasChanged = true;
    }
    if (code != null && _code != code) {
      _code = code;
      hasChanged = true;
    }
    if (item != null && _item != item) {
      _item = item;
      hasChanged = true;
    }
    // connectionStatus 우선, 없으면 connectStatus (하위 호환성)
    final newConnectionStatus = connectionStatus ?? connectStatus;
    if (newConnectionStatus != null && _connectionStatus != newConnectionStatus) {
      _connectionStatus = newConnectionStatus;
      hasChanged = true;
    }
    if (status != null && _status != status) {
      _status = status;
      hasChanged = true;
    }
    if (printStatus != null && _printStatus != printStatus) {
      _printStatus = printStatus;
      hasChanged = true;
    }
    if (startDate != null && _startDate != startDate) {
      _startDate = startDate;
      hasChanged = true;
    }
    if (endDate != null && _endDate != endDate) {
      _endDate = endDate;
      hasChanged = true;
    }
    if (totalPrintWork != null && _totalPrintWork != totalPrintWork) {
      _totalPrintWork = totalPrintWork;
      hasChanged = true;
    }
    if (completePrintWork != null && _completePrintWork != completePrintWork) {
      _completePrintWork = completePrintWork;
      hasChanged = true;
    }

    if (hasChanged) {
      notifyListeners();
      // 기존 콜백 방식도 유지 (하위 호환성)
      onCountUpdate?.call(this);
    }
  }
}
