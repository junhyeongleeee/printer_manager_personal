// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printers_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrintersResponseImpl _$$PrintersResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PrintersResponseImpl(
      status: json['status'] as String,
      message: json['message'] as String,
      data: PrintersResponseData.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$$PrintersResponseImplToJson(
        _$PrintersResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };

_$PrintersResponseDataImpl _$$PrintersResponseDataImplFromJson(
        Map<String, dynamic> json) =>
    _$PrintersResponseDataImpl(
      processingCompanyPrinterIndex:
          (json['processingCompanyPrinterIndex'] as num).toInt(),
      printerName: json['printerName'] as String,
      ip: json['ip'] as String,
      port: json['port'] as String,
      status: json['status'] as String,
      regDate: json['regDate'] as String,
    );

Map<String, dynamic> _$$PrintersResponseDataImplToJson(
        _$PrintersResponseDataImpl instance) =>
    <String, dynamic>{
      'processingCompanyPrinterIndex': instance.processingCompanyPrinterIndex,
      'printerName': instance.printerName,
      'ip': instance.ip,
      'port': instance.port,
      'status': instance.status,
      'regDate': instance.regDate,
    };
