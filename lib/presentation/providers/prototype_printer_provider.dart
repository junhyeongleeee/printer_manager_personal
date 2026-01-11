import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_manager/core/data/repositories/printer_repository_provider.dart';
import 'package:print_manager/core/domain/entities/managed_printer.dart';
import 'package:print_manager/core/domain/entities/order_item.dart';
import 'package:print_manager/core/domain/entities/managed_printer.dart';
import 'package:print_manager/core/infra/zipher_socket.dart';
import 'package:print_manager/core/domain/repositories/order_repository.dart';
import 'package:print_manager/core/domain/repositories/printer_repository.dart';
import 'package:print_manager/presentation/providers/printer_list_provider.dart';
import 'package:print_manager/core/services/logger_service.dart';




final prototypePrinterProvider =
StateNotifierProvider<PrototypePrinterNotifier, PrototypePrinterState>(
        (ref) => PrototypePrinterNotifier(ref));

class PrototypePrinterNotifier extends StateNotifier<PrototypePrinterState> {
  final Ref ref;

  PrototypePrinterNotifier(this.ref) : super(PrototypePrinterState());

  void setPrinter(ManagedPrinter printer) {
    state = state.copyWith(printer: printer);
  }

  void setOrder(OrderItem order) {
    state = state.copyWith(order: order);
  }

  void setSocket(ZipherSocket socket) {
    state = state.copyWith(socket: socket);
  }

  void clear() {
    state = PrototypePrinterState();
  }

  void orderPrintJob() {
    final printer = state.printer?.id;
    final order = state.order?.itemName;
    final startCode = state.order?.startCode;
    final endCode = state.order?.endCode;

    logger.i("Printer: $printer, Order: $order, Start Code: $startCode, End Code: $endCode");

    // ref.read(printerListProvider.notifier).assignPrintJob(
    //   printer?? 0,
    //   order?? "", // 필요 시 o.code나 o.item 등으로 대체 가능
    //   int.parse(startCode?? "0"), // 시작 번호 (실제 로직 필요시 index나 누적값 기반으로 변경)
    //   int.parse(endCode?? "1"), // 할당량만큼
    // );

  }

  Future<void> updatePrinterStatus() async {
    final printerRepo = ref.read(printerRepositoryProvider);
    final printer = state.printer;
    if (printer != null) {
      //final data = await printerRepo.fetchPrinterStatus(printer.id);
      // 상태 업데이트
    }
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}

class PrototypePrinterState {
  final ManagedPrinter? printer;
  final OrderItem? order;
  final ZipherSocket? socket;

  PrototypePrinterState({
    this.printer,
    this.order,
    this.socket,
  });

  PrototypePrinterState copyWith({
    ManagedPrinter? printer,
    OrderItem? order,
    ZipherSocket? socket,
  }) {
    return PrototypePrinterState(
      printer: printer ?? this.printer,
      order: order ?? this.order,
      socket: socket ?? this.socket,
    );
  }
}
