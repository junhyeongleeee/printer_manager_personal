// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printerjob_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrinterjobListResponseImpl _$$PrinterjobListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PrinterjobListResponseImpl(
      status: json['status'] as String,
      message: json['message'] as String,
      data: PrinterjobListResponseData.fromJson(
          json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$$PrinterjobListResponseImplToJson(
        _$PrinterjobListResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };

_$PrinterjobListResponseDataImpl _$$PrinterjobListResponseDataImplFromJson(
        Map<String, dynamic> json) =>
    _$PrinterjobListResponseDataImpl(
      printJobList: (json['printJobList'] as List<dynamic>)
          .map((e) => PrintJob.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PrinterjobListResponseDataImplToJson(
        _$PrinterjobListResponseDataImpl instance) =>
    <String, dynamic>{
      'printJobList': instance.printJobList,
    };

_$PrintJobImpl _$$PrintJobImplFromJson(Map<String, dynamic> json) =>
    _$PrintJobImpl(
      orderPrintJobId: (json['orderPrintJobId'] as num).toInt(),
      processingCompanyPrinterId:
          (json['processingCompanyPrinterId'] as num).toInt(),
      orderId: (json['orderId'] as num).toInt(),
      itemName: json['itemName'] as String,
      status: json['status'] as String,
      quantity: (json['quantity'] as num).toInt(),
      startedAt: json['startedAt'] as String?,
      completedAt: json['completedAt'] as String?,
      regDate: json['regDate'] as String,
    );

Map<String, dynamic> _$$PrintJobImplToJson(_$PrintJobImpl instance) =>
    <String, dynamic>{
      'orderPrintJobId': instance.orderPrintJobId,
      'processingCompanyPrinterId': instance.processingCompanyPrinterId,
      'orderId': instance.orderId,
      'itemName': instance.itemName,
      'status': instance.status,
      'quantity': instance.quantity,
      'startedAt': instance.startedAt,
      'completedAt': instance.completedAt,
      'regDate': instance.regDate,
    };
