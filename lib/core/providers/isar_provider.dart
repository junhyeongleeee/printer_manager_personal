import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:print_manager/core/data/models/order_field_value_state.dart';
import 'package:print_manager/core/data/models/order_field_value_metadata.dart';
import 'package:print_manager/core/data/models/order_printer_count.dart';
import 'package:print_manager/core/data/models/printer_last_order.dart';

/// Isar 데이터베이스 Provider
/// 앱 시작 시 Isar 인스턴스를 초기화하고 제공합니다.
final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();

  return await Isar.open(
    [OrderFieldValueStateSchema, OrderFieldValueMetadataSchema, OrderPrinterCountSchema, PrinterLastOrderSchema],
    directory: dir.path,
    name: 'print_manager',
  );
});
