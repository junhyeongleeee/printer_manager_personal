import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:print_manager/core/data/models/response/order_response.dart';

part 'get_order_response.freezed.dart';
part 'get_order_response.g.dart';

@freezed
abstract class GetOrderResponse with _$GetOrderResponse {
  const factory GetOrderResponse({
    required String status,
    required String message,
    required OrderResponseData data,
    required String timestamp,
  }) = _GetOrderResponse;

  factory GetOrderResponse.fromJson(Map<String, dynamic> json) => _$GetOrderResponseFromJson(json);
}
