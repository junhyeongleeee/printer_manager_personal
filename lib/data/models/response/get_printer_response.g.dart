// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_printer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetPrinterResponseImpl _$$GetPrinterResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetPrinterResponseImpl(
      status: json['status'] as String,
      message: json['message'] as String,
      data:
          GetPrinterResponseData.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$$GetPrinterResponseImplToJson(
        _$GetPrinterResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };

_$GetPrinterResponseDataImpl _$$GetPrinterResponseDataImplFromJson(
        Map<String, dynamic> json) =>
    _$GetPrinterResponseDataImpl(
      processingCompanyPrinterIndex:
          (json['processingCompanyPrinterIndex'] as num).toInt(),
      printerName: json['printerName'] as String,
      model: json['model'] as String,
      status: json['status'] as String,
      regDate: json['regDate'] as String,
    );

Map<String, dynamic> _$$GetPrinterResponseDataImplToJson(
        _$GetPrinterResponseDataImpl instance) =>
    <String, dynamic>{
      'processingCompanyPrinterIndex': instance.processingCompanyPrinterIndex,
      'printerName': instance.printerName,
      'model': instance.model,
      'status': instance.status,
      'regDate': instance.regDate,
    };
