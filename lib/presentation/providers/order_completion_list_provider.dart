import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/entities/order_completion_item.dart';

final orderCompletionListProvider = StateNotifierProvider<OrderCompletionListNotifier, List<OrderCompletionItem>>((ref) {
  return OrderCompletionListNotifier();
});

class OrderCompletionListNotifier extends StateNotifier<List<OrderCompletionItem>> {
  OrderCompletionListNotifier() : super([
    OrderCompletionItem(id: 20250617100000, agency: '용인시' ,orderCode: 'A1ZZ00', item: '음식물-2L', total: 100, assignedAmount: 100, orderDate: '2024-06-01', startedAt: DateTime.parse('2024-06-03T10:00:00'), completedAt: DateTime.parse('2024-06-03T10:00:00')),
    OrderCompletionItem(id: 20250617100000, agency: '용인시',orderCode: 'B2ZZ00', item: '재활용-1L', total: 50, assignedAmount: 50, orderDate: '2024-06-10', startedAt: DateTime.parse('2024-06-02T10:00:00'), completedAt: DateTime.parse('2024-06-03T10:00:00')),
  ]);

  void addCompletion({
    required String agency,
    required String orderCode,
    required String item,
    required int total,
    required int assignedAmount,
    required String orderDate,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final digitsOnly = timestamp.replaceAll(RegExp(r'[^0-9]'), '');
    final short = digitsOnly.substring(0, 14);
    final uuid = int.parse(short);
    final newCompletion = OrderCompletionItem(
      id: uuid,
      agency: agency,
      //id: int.parse(DateTime.now().toIso8601String().replaceAll(RegExp(r'[^0-9]'), '').substring(0, 14)),
      orderCode: orderCode,
      item: item,
      total: total,
      assignedAmount: assignedAmount,
      orderDate: orderDate,
      startedAt: DateTime.now(),
      completedAt: null,
    );
    state = [...state, newCompletion];
  }

  void markCompleted(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(completedAt: DateTime.now())
        else
          item,
    ];
  }
  void clear() {
    state = [];
  }
}