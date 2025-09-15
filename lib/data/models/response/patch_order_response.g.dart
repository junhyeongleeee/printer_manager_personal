// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch_order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PatchOrderResponseImpl _$$PatchOrderResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PatchOrderResponseImpl(
      status: json['status'] as String,
      message: json['message'] as String,
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$$PatchOrderResponseImplToJson(
        _$PatchOrderResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'timestamp': instance.timestamp,
    };
