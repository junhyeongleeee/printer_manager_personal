import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_order_response.freezed.dart';
part 'get_order_response.g.dart';

@freezed
abstract class GetOrderResponse with _$GetOrderResponse {
  const factory GetOrderResponse({
    required String status,
    required String message,
    required GetOrderResponseData data,
    required String timestamp,
  }) = _GetOrderResponse;

  factory GetOrderResponse.fromJson(Map<String, dynamic> json) => _$GetOrderResponseFromJson(json);
}

@freezed
abstract class GetOrderResponseData with _$GetOrderResponseData {
  const factory GetOrderResponseData({
    required int orderId,
    required int institutionId,
    required String institutionName,
    required int itemId,
    required String itemName,
    required int quantity,
    required int remainingQuantity,
    required String stock,
    required String uniqueCode,
    required String startCode,
    required String endCode,
    required String embeddingCode,
    required String status,
    required String regDate,
  }) = _GetOrderResponseData;

  factory GetOrderResponseData.fromJson(Map<String, dynamic> json) => _$GetOrderResponseDataFromJson(json);
}
