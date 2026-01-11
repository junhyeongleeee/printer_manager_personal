import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse_request.freezed.dart';
part 'warehouse_request.g.dart';

@freezed
abstract class WarehouseRequest with _$WarehouseRequest {
  const factory WarehouseRequest({
    required int orderId,
    required String name,
    required String address,
    required int quantity,
  }) = _WarehouseRequest;

  factory WarehouseRequest.fromJson(Map<String, dynamic> json) => _$WarehouseRequestFromJson(json);
}