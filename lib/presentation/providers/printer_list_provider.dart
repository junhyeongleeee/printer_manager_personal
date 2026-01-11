import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:print_manager/core/data/mappers/printer_response_data_mapper.dart';
import 'package:print_manager/core/data/models/request/update_printerjob_request.dart';
import 'package:print_manager/core/data/models/response/printer_list_response.dart';
import 'package:print_manager/core/data/repositories/printer_repository_provider.dart';
import 'package:print_manager/core/domain/entities/managed_printer.dart';
import 'package:print_manager/core/domain/usecases/print_job_usecase.dart';
import 'package:print_manager/presentation/providers/prototype_printer_provider.dart';
import 'package:print_manager/presentation/pages/tcp_chat_page.dart';
import 'package:print_manager/core/services/logger_service.dart';
import 'package:print_manager/presentation/providers/field_value_manager_provider.dart';
import 'package:print_manager/presentation/providers/order_list_provider.dart';

final printerListProvider = StateNotifierProvider<PrinterListNotifier, List<ManagedPrinter>>(
  (ref) => PrinterListNotifier(ref),
);

class PrinterListNotifier extends StateNotifier<List<ManagedPrinter>> {
  final Ref ref;
  PrinterListNotifier(this.ref) : super([]);

  late PrintJobUseCase _useCase;

  void addPrinter(ManagedPrinter printer) {
    state = [...state, printer];
  }

  Future<void> removePrinter(ManagedPrinter printer) async {
    // 모니터링 중지 후 dispose
    await printer.stopPrintMonitoring();

    // 필드 값 해제
    if (printer.id != null) {
      ref.read(fieldValueManagerProvider.notifier).releaseFieldValue(printer.id!);
    }

    printer.dispose(); // 소켓 연결 해제
    state = state.where((p) => p != printer).toList(); // 리스트에서 제거
  }

  bool exists(String ip, int port) {
    return state.any((p) => p.ip == ip && p.port == port);
  }

  Future<void> connect(ManagedPrinter printer) async {
    final connectedPrinter = state.firstWhere((p) => p == printer);

    // 필드 값 관리자 초기화 (프린터 연결 시점)
    _initializeFieldValueManager();

    // 필드 값 요청 콜백 설정
    if (connectedPrinter.id != null) {
      final printerId = connectedPrinter.id!;
      connectedPrinter.setFieldValueRequestCallback(() async {
        // 중앙 관리자에서 포맷된 필드 값 (uniqueCode + 6자리 HEX)을 바로 받아서 사용
        return ref.read(fieldValueManagerProvider.notifier).requestFormattedFieldValue(printerId);
      });
    }

    await connectedPrinter.connect();
  }

  /// 필드 값 관리자 초기화
  /// 주문 정보가 있으면 그 정보로, 없으면 기본값으로 초기화
  void _initializeFieldValueManager() {
    final fieldValueManager = ref.read(fieldValueManagerProvider.notifier);
    final orders = ref.read(orderListProvider);

    // 활성 주문 찾기 (인쇄/가공 중 또는 인쇄/가공 완료 상태)
    final activeOrder = orders.firstWhereOrNull(
      (order) => order.status == '4' || order.status == '5', // 인쇄/가공 중 또는 완료
    );

    if (activeOrder != null) {
      // 주문 정보로 초기화
      final startCode = int.tryParse(activeOrder.startCode) ?? 1;
      final endCode = int.tryParse(activeOrder.endCode) ?? 1000000;
      fieldValueManager.initialize(startCode: startCode, endCode: endCode, uniqueCode: activeOrder.uniqueCode);
      logger.i('필드 값 관리자 초기화 (주문 정보): startCode=$startCode, endCode=$endCode, uniqueCode=${activeOrder.uniqueCode}');
    } else {
      // 기본값으로 초기화 (넓은 범위)
      fieldValueManager.initialize(startCode: 1, endCode: 1000000, uniqueCode: '00000');
      logger.i('필드 값 관리자 초기화 (기본값): startCode=1, endCode=1000000, uniqueCode=00000');
    }
  }

  Future<void> clear() async {
    // 모든 프린터의 필드 값 해제
    for (final printer in state) {
      await printer.stopPrintMonitoring();
      if (printer.id != null) {
        ref.read(fieldValueManagerProvider.notifier).releaseFieldValue(printer.id!);
      }
      printer.dispose();
    }
    state = [];

    // 필드 값 관리자 초기화
    ref.read(fieldValueManagerProvider.notifier).clearAll();
  }

  /// 상태 갱신 (카운트 변경 등으로 인한 UI 업데이트용)
  void refreshState() {
    state = [...state];
  }

  //test job
  void testPrint({String jobName = "0625yi6", String code = "1234564568911", int start = 0, int end = 1}) {
    _useCase = ref.read(printJobUseCaseProvider);
    _useCase.printJobRepeatedly(jobName: jobName, start: start, end: end);
    //_useCase.execute(jobName, code, start, end);
  }

  void assignPrintJob(
    int printerid,
    int jobId,
    String itemName,
    String code,
    int start,
    int end,
    bool isLastPrint,
  ) async {
    _useCase = ref.read(printJobUseCaseProvider);

    logger.i("assignPrintJob Start");
    final now = DateTime.now();
    final formatted =
        "${now.year}-${_two(now.month)}-${_two(now.day)} "
        "${_two(now.hour)}:${_two(now.minute)}:${_two(now.second)}";

    final printer = state.firstWhere(
      (p) => p.id == printerid,
      orElse: () => throw Exception("프린터 $printerid 를 찾을 수 없습니다."),
    );

    final orderId = ref.read(prototypePrinterProvider).order?.orderId;

    // 필드 값 관리자 범위 업데이트 (주문 할당 시)
    // 이미 연결 시점에 초기화되어 있으므로, 범위만 업데이트
    final fieldValueManager = ref.read(fieldValueManagerProvider.notifier);
    fieldValueManager.resetRange(startCode: start, endCode: end, uniqueCode: code);
    logger.i("필드 값 관리자 범위 업데이트: startCode=$start, endCode=$end, uniqueCode=$code");

    printer.updateFields(
      totalPrintWork: (printer.totalPrintWork ?? 0) + (end - start + 1),
      startDate: formatted,
      printStatus: '인쇄 중',
    );
    String jobName = "a";
    logger.i("printer.printStatus: ${printer.printStatus}");
    final request_start = UpdatePrinterjobRequest(status: "IN_PROGRESS", message: "인쇄 중");
    // final request = PrinterjobRequest(
    //   orderId: orderId?? 0,
    //   processingCompanyPrinterIndex: printer.id?? 0,
    //   quantity: end - start + 1,
    // );
    logger.i("printerId: $printerid, jobId: $jobId, itemName: $itemName, code: $code, start: $start, end: $end");
    final printerRepository = ref.read(printerRepositoryProvider);
    final response = await printerRepository.updatePrinterJob(jobId, request_start);
    logger.i("updatePrinterJob response: $response");
    await printer.printJobRepeatedly(jobName: jobName, uniqueCode: code, start: start, end: end);

    final request_complete = UpdatePrinterjobRequest(status: "COMPLETED", message: "인쇄 완료");
    printer.updateFields(endDate: formatted);
    final response2 = await printerRepository.updatePrinterJob(jobId, request_complete);
    logger.i("updatePrinterJob response: $response2");

    // 상태 반영을 위해 state를 새로 할당 (동일 객체지만 참조 변경 필요 시)
    state = [...state];
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  void mergeNewData(WidgetRef ref, PrinterListResponse newDtos) {
    final notifier = ref.read(printerListProvider.notifier);
    final currentItems = ref.read(printerListProvider);

    final currentIds = currentItems.map((e) => e.id).toSet();

    final newItems =
        newDtos.data.printerList
            .where((dto) => dto.status != '삭제' && !currentIds.contains(dto.processingCompanyPrinterIndex))
            .map((dto) => dto.toManagedPrinter())
            .toList();

    // 새로 추가된 프린터에 필드 값 요청 콜백 설정
    for (final printer in newItems) {
      if (printer.id != null) {
        final printerId = printer.id!;
        printer.setFieldValueRequestCallback(() async {
          return ref.read(fieldValueManagerProvider.notifier).requestFormattedFieldValue(printerId);
        });
      }
    }

    notifier.state = [...currentItems, ...newItems];
    logger.i("notifier.state = ${notifier.state}");
  }
}
