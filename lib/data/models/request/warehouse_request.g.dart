// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WarehouseRequestImpl _$$WarehouseRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$WarehouseRequestImpl(
      orderId: (json['orderId'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$$WarehouseRequestImplToJson(
        _$WarehouseRequestImpl instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'name': instance.name,
      'address': instance.address,
      'quantity': instance.quantity,
    };
