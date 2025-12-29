import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_manager/data/mappers/printer_response_data_mapper.dart';
import 'package:print_manager/data/models/response/printer_list_response.dart';
import 'package:print_manager/data/repositories/printer_repository_provider.dart';
import '../../domain/entities/managed_printer.dart';
import 'package:print_manager/data/models/request/update_printerjob_request.dart';
import 'package:print_manager/presentation/providers/prototype_printer_provider.dart';
import 'package:print_manager/domain/usecases/print_job_usecase.dart';
import 'package:print_manager/presentation/pages/tcp_chat_page.dart';
import 'package:print_manager/core/services/logger_service.dart';

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
    //printer.dispose(); // 소켓 연결 해제
    state.where((p) => p == printer).first.dispose();
    state = state.where((p) => p != printer).toList(); // 리스트에서 제거
  }

  bool exists(String ip, int port) {
    return state.any((p) => p.ip == ip && p.port == port);
  }

  Future<void> connect(ManagedPrinter printer) async {
    await state.firstWhere((p) => p == printer).connect();
  }

  void clear() {
    for (final printer in state) {
      printer.dispose();
    }
    state = [];
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

    printer.totalPrintWork = (printer.totalPrintWork ?? 0) + (end - start + 1);
    printer.startDate = formatted;
    printer.printStatus = '인쇄 중';
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
    printer.endDate = formatted;
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

    notifier.state = [...currentItems, ...newItems];
    logger.i("notifier.state = ${notifier.state}");
  }
}
