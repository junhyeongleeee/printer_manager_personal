import 'package:print_manager/core/domain/entities/order_item.dart';
import 'package:print_manager/core/data/models/response/order_response.dart';

extension OrderResponseDataMapper on OrderResponseData {
  OrderItem toOrderItem() {
    // baseQuantity가 null일 경우 quantity와 같은 값으로 설정
    final effectiveBaseQuantity = baseQuantity ?? quantity;

    return OrderItem(
      orderId: orderId,
      institutionId: institutionId,
      institutionName: institutionName,
      itemId: itemId,
      itemName: itemName.toString(),
      quantity: quantity,
      baseQuantity: effectiveBaseQuantity,
      printedQuantity: printedQuantity,
      printStartedAt: printStartedAt,
      printCompletedAt: printCompletedAt,
      stock: stock,
      uniqueCode: uniqueCode,
      startCode: startCode,
      endCode: endCode,
      embeddingCode: embeddingCode,
      regDate: regDate,
      status: status, // 기본 상태
      available: quantity, // 기본 할당 가능량
    );
  }
}
