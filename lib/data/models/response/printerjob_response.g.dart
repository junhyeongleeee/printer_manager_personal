// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printerjob_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrinterjobResponseImpl _$$PrinterjobResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PrinterjobResponseImpl(
      status: json['status'] as String,
      message: json['message'] as String,
      data:
          PrinterjobResponseData.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$$PrinterjobResponseImplToJson(
        _$PrinterjobResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };

_$PrinterjobResponseDataImpl _$$PrinterjobResponseDataImplFromJson(
        Map<String, dynamic> json) =>
    _$PrinterjobResponseDataImpl(
      jobId: (json['jobId'] as num).toInt(),
    );

Map<String, dynamic> _$$PrinterjobResponseDataImplToJson(
        _$PrinterjobResponseDataImpl instance) =>
    <String, dynamic>{
      'jobId': instance.jobId,
    };
