import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse_response.freezed.dart';
part 'warehouse_response.g.dart';

@freezed
abstract class WarehouseResponse with _$WarehouseResponse {
  const factory WarehouseResponse({
    required String status,
    required String message,
    required String timestamp,
  }) = _WarehouseResponse;

  factory WarehouseResponse.fromJson(Map<String, dynamic> json) => _$WarehouseResponseFromJson(json);
}