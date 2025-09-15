import 'package:print_manager/domain/entities/order_item.dart';
import 'package:print_manager/data/models/response/order_response.dart';

extension OrderResponseDataMapper on OrderResponseData {
  OrderItem toOrderItem() {
    return OrderItem(
      orderId: orderId,
      institutionId: institutionId,
      institutionName: institutionName,
      itemId: itemId,
      itemName: itemName.toString(),
      quantity: quantity,
      remainingQuantity: remainingQuantity,
      stock: stock,
      uniqueCode: uniqueCode,
      startCode: startCode,
      endCode: endCode,
      embeddingCode: embeddingCode,
      regDate: regDate,
      status: status,      // 기본 상태
      available: quantity,   // 기본 할당 가능량
    );
  }
}
