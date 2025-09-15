import 'package:freezed_annotation/freezed_annotation.dart';

part 'patch_order_response.freezed.dart';
part 'patch_order_response.g.dart';

@freezed
class PatchOrderResponse with _$PatchOrderResponse {
  const factory PatchOrderResponse({
    required String status,
    required String message,
    required String timestamp,
  }) = _PatchOrderResponse;

  factory PatchOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$PatchOrderResponseFromJson(json);
}