// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrinterListResponseImpl _$$PrinterListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PrinterListResponseImpl(
      status: json['status'] as String,
      message: json['message'] as String,
      data: PrinterListResponseData.fromJson(
          json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$$PrinterListResponseImplToJson(
        _$PrinterListResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };

_$PrinterListResponseDataImpl _$$PrinterListResponseDataImplFromJson(
        Map<String, dynamic> json) =>
    _$PrinterListResponseDataImpl(
      printerList: (json['printerList'] as List<dynamic>)
          .map((e) => PrinterData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PrinterListResponseDataImplToJson(
        _$PrinterListResponseDataImpl instance) =>
    <String, dynamic>{
      'printerList': instance.printerList,
    };

_$PrinterDataImpl _$$PrinterDataImplFromJson(Map<String, dynamic> json) =>
    _$PrinterDataImpl(
      processingCompanyPrinterIndex:
          (json['processingCompanyPrinterIndex'] as num).toInt(),
      printerName: json['printerName'] as String,
      model: json['model'] as String,
      ip: json['ip'] as String?,
      port: json['port'] as String?,
      status: json['status'] as String,
      regDate: json['regDate'] as String,
    );

Map<String, dynamic> _$$PrinterDataImplToJson(_$PrinterDataImpl instance) =>
    <String, dynamic>{
      'processingCompanyPrinterIndex': instance.processingCompanyPrinterIndex,
      'printerName': instance.printerName,
      'model': instance.model,
      'ip': instance.ip,
      'port': instance.port,
      'status': instance.status,
      'regDate': instance.regDate,
    };
