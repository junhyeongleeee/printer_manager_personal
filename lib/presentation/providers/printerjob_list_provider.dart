import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/printerjob_item.dart';
import 'package:print_manager/data/models/response/printerjob_list_response.dart';
import 'package:print_manager/data/mappers/printerjob_data_mapper.dart';
import 'package:collection/collection.dart';
import 'package:print_manager/core/services/logger_service.dart';


final printerjobListProvider =
StateNotifierProvider<PrinterjobListNotifier, List<PrinterjobItem>>(
      (ref) => PrinterjobListNotifier(),
);

class PrinterjobListNotifier extends StateNotifier<List<PrinterjobItem>> {
  PrinterjobListNotifier() : super([]);

  // void mergeNewPrinterJobs(PrinterjobListResponse response) {
  //   final currentItems = state;
  //   final currentKeys = currentItems
  //       .map((e) => '${e.orderId}-${e.processingCompanyPrinterId}')
  //       .toSet();
  //
  //   final newItems = response.data.toPrinterjobItems().where((item) {
  //     final key = '${item.orderId}-${item.processingCompanyPrinterId}';
  //     return !currentKeys.contains(key);
  //   }).toList();
  //
  //   state = [...currentItems, ...newItems];
  // }
  void mergeJobs(List<PrintJob> jobs) {
    final currentKeys = state
        .map((e) => '${e.orderPrintJobId}')
        .toSet();

    final newItems = jobs
        .where((job) => !currentKeys.contains('${job.orderPrintJobId}'))
        .map((job) => job.toPrinterjobItems())
        .toList();

    state = [...state, ...newItems];

    logger.i("🟢 PrinterjobList updated. Current size: ${state.length}");
  }

  String? getStratAtByOrderId(int orderId) {
    final printerjob = state.firstWhereOrNull((item) => item.orderId == orderId);
    return printerjob?.startedAt;
  }

  String? getEndAtByOrderId(int orderId) {
    final printerjob = state.firstWhereOrNull((item) => item.orderId == orderId);
    return printerjob?.completedAt;
  }

  int? getQuntityByOrderId(int orderId) {
    final printerjob = state.firstWhereOrNull((item) => item.orderId == orderId);
    return printerjob?.quantity;
  }

  void clear() {
    state = [];
  }
}
