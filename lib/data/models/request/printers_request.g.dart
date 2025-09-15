// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printers_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrintersRequestImpl _$$PrintersRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$PrintersRequestImpl(
      name: json['name'] as String,
      model: json['model'] as String,
      status: json['status'] as String,
      ip: json['ip'] as String,
      port: json['port'] as String,
    );

Map<String, dynamic> _$$PrintersRequestImplToJson(
        _$PrintersRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'model': instance.model,
      'status': instance.status,
      'ip': instance.ip,
      'port': instance.port,
    };
