import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_response.freezed.dart';
part 'order_response.g.dart';

@freezed
abstract class OrderResponse with _$OrderResponse {
  const factory OrderResponse({
    required String status,
    required String message,
    required OrderResponseDataWrapper data,
    required String timestamp,
  }) = _OrderResponse;

  factory OrderResponse.fromJson(Map<String, dynamic> json) => _$OrderResponseFromJson(json);
}

@freezed
abstract class OrderResponseDataWrapper with _$OrderResponseDataWrapper {
  const factory OrderResponseDataWrapper({
    required int orderCount,
    required List<OrderResponseData> orderList,
  }) = _OrderResponseDataWrapper;

  factory OrderResponseDataWrapper.fromJson(Map<String, dynamic> json) => _$OrderResponseDataWrapperFromJson(json);
}

@freezed
abstract class OrderResponseData with _$OrderResponseData {
  const factory OrderResponseData({
    required int orderId,
    required int institutionId,
    required String institutionName,
    required int itemId,
    required String itemName,
    required int quantity,
    required int? baseQuantity, // nullable: null일 경우 quantity와 같은 값으로 설정
    required int printedQuantity,
    required String? printStartedAt,
    required String? printCompletedAt,
    required int stock,
    required String uniqueCode,
    required String startCode,
    required String endCode,
    required String embeddingCode,
    required String status,
    required String regDate,
  }) = _OrderResponseData;

  factory OrderResponseData.fromJson(Map<String, dynamic> json) => _$OrderResponseDataFromJson(json);
}
