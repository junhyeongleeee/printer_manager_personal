// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WarehouseResponseImpl _$$WarehouseResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$WarehouseResponseImpl(
      status: json['status'] as String,
      message: json['message'] as String,
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$$WarehouseResponseImplToJson(
        _$WarehouseResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'timestamp': instance.timestamp,
    };
