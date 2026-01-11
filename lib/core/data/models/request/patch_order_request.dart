import 'package:freezed_annotation/freezed_annotation.dart';

part 'patch_order_request.freezed.dart';
part 'patch_order_request.g.dart';

@freezed
abstract class PatchOrderRequest with _$PatchOrderRequest {
  const factory PatchOrderRequest({
    required String status,
  }) = _PatchOrderRequest;

  factory PatchOrderRequest.fromJson(Map<String, dynamic> json) => _$PatchOrderRequestFromJson(json);
}