import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order_item.dart';
import 'package:print_manager/data/models/response/order_response.dart';
import 'package:print_manager/data/mappers/order_response_data_mapper.dart';
import 'package:collection/collection.dart';
import 'package:print_manager/core/services/logger_service.dart';

// orderListProvider 정의
final orderListProvider = StateNotifierProvider<OrderListNotifier, List<OrderItem>>((ref) {
  return OrderListNotifier();
});

class OrderListNotifier extends StateNotifier<List<OrderItem>> {
  OrderListNotifier()
      : super([
    //OrderItem(code: 'A1AA00', item: '음식물-1L', status: '배송중', total: 100, available: 100, orderDate: '2024-06-01'),
    //OrderItem(code: 'B2BB00', item: '재활용-2L', status: '배송중', total: 50, available: 50, orderDate: '2024-06-10'),
  ]);

  void allocateOrder(int index, int amount) {
    final item = state[index];
    if (item.available >= amount) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index)
            item.copyWith(available: item.available - amount)
          else
            state[i],
      ];
    }
  }

  String? getItemNameByOrderId(int orderId) {
    final order = state.firstWhereOrNull((item) => item.orderId == orderId);
    return order?.itemName;
  }

  void completeOrder(int index) {
    final item = state[index];
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          item.copyWith(status: '배송완료')
        else
          state[i],
    ];
  }

  // void mergeNewOrdersIntoProvider(WidgetRef ref, OrderResponse newDtos) {
  //   final notifier = ref.read(orderListProvider.notifier);
  //   final currentItems = ref.read(orderListProvider);
  //
  //   final currentIds = currentItems.map((e) => e.orderId).toSet();
  //
  //   final newItems = newDtos.data
  //       .where((dto) => !currentIds.contains(dto.orderId))
  //       .map((dto) => dto.toOrderItem())
  //       .toList();
  //
  //   final mergedList = [...currentItems, ...newItems];
  //   notifier.state = mergedList;
  //
  //   print("notifier.state = $mergedList");
  // }

  void mergeNewOrdersIntoProvider(WidgetRef ref, OrderResponse newDtos) {
    final notifier = ref.read(orderListProvider.notifier);
    final currentItems = ref.read(orderListProvider);

    final updatedItems = currentItems.map((item) {
      final matchingDto = newDtos.data.orderList.firstWhereOrNull(
            (dto) => dto.orderId == item.orderId,
      );

      // 매칭된 DTO가 있다면 status만 교체한 새 OrderItem 반환
      if (matchingDto != null) {
        // return item.copyWith(status: matchingDto.status, remainingQuantity: matchingDto.remainingQuantity);
        return item.copyWith(status: matchingDto.status);
      }

      // 없으면 기존 item 유지
      return item;
    }).toList();

    // 새로운 orderId를 가진 항목만 따로 추가
    final currentIds = currentItems.map((e) => e.orderId).toSet();
    final newItems = newDtos.data.orderList
        .where((dto) => !currentIds.contains(dto.orderId))
        .map((dto) => dto.toOrderItem())
        .toList();

    notifier.state = [...updatedItems, ...newItems];
    logger.i("notifier.state = ${notifier.state}");
  }

  void replaceOrderListInProvider(WidgetRef ref, OrderResponse newDtos) {
    final notifier = ref.read(orderListProvider.notifier);
    notifier.state = newDtos.data.orderList.map((dto) => dto.toOrderItem()).toList();

    logger.i("orderListProvider replaced with ${notifier.state.length} items");
  }


  void clear() {
    state = [];
  }
}