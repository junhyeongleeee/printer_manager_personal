import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_manager/core/data/mappers/printer_response_data_mapper.dart';
import 'package:print_manager/core/data/models/response/printer_list_response.dart';
import 'package:print_manager/core/domain/entities/managed_printer.dart';
import 'package:print_manager/core/services/logger_service.dart';
import 'package:print_manager/presentation/providers/field_value_manager_registry_provider.dart';

final printerListProvider = StateNotifierProvider<PrinterListNotifier, List<ManagedPrinter>>(
  (ref) => PrinterListNotifier(ref),
);

class PrinterListNotifier extends StateNotifier<List<ManagedPrinter>> {
  final Ref ref;
  PrinterListNotifier(this.ref) : super([]);

  void addPrinter(ManagedPrinter printer) {
    state = [...state, printer];
  }

  Future<void> removePrinter(ManagedPrinter printer) async {
    // 모니터링 중지 후 dispose
    await printer.stopPrintMonitoring();

    // 필드 값 해제 (발주별 Manager에서 해제)
    if (printer.id != null && printer.selectedOrder != null) {
      final registry = ref.read(fieldValueManagerRegistryProvider);
      final manager = registry.getManager(printer.selectedOrder!.orderId);
      if (manager != null) {
        manager.releaseFieldValue(printer.id!);
      }
    }

    printer.dispose(); // 소켓 연결 해제
    state = state.where((p) => p != printer).toList(); // 리스트에서 제거
  }

  bool exists(String ip, int port) {
    return state.any((p) => p.ip == ip && p.port == port);
  }

  /// 프린터 연결
  /// [onCompletedCountCheck] 콜백을 통해 발주 완료 여부를 체크할 수 있습니다.
  ///
  /// 주의: 필드 값 관리자는 발주별로 생성되므로, 프린터 연결 시점에는 초기화하지 않습니다.
  /// 발주가 선택될 때 `_initializeFieldValueManagerForOrder()`를 통해 발주별 Manager가 생성됩니다.
  Future<void> connect(ManagedPrinter printer, {bool Function()? onCompletedCountCheck}) async {
    final connectedPrinter = state.firstWhere((p) => p == printer);
    await connectedPrinter.connect(onCompletedCountCheck: onCompletedCountCheck);
  }

  Future<void> clear() async {
    // 모든 프린터의 필드 값 해제
    for (final printer in state) {
      await printer.stopPrintMonitoring();
      if (printer.id != null && printer.selectedOrder != null) {
        final registry = ref.read(fieldValueManagerRegistryProvider);
        final manager = registry.getManager(printer.selectedOrder!.orderId);
        if (manager != null) {
          manager.releaseFieldValue(printer.id!);
        }
      }
      printer.dispose();
    }
    state = [];

    // 발주별 FieldValueManager 정리
    final registry = ref.read(fieldValueManagerRegistryProvider);
    registry.dispose();
  }

  /// 상태 갱신 (카운트 변경 등으로 인한 UI 업데이트용)
  void refreshState() {
    state = [...state];
  }

  void mergeNewData(WidgetRef ref, PrinterListResponse newDtos) {
    final notifier = ref.read(printerListProvider.notifier);
    final currentItems = ref.read(printerListProvider);

    final currentIds = currentItems.map((e) => e.id).toSet();

    final newItems = newDtos.data.printerList
        .where((dto) => dto.status != '삭제' && !currentIds.contains(dto.processingCompanyPrinterIndex))
        .map((dto) => dto.toManagedPrinter())
        .toList();

    notifier.state = [...currentItems, ...newItems];
    logger.i("notifier.state = ${notifier.state}");
  }
}
