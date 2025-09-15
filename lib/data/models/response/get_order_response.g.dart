// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetOrderResponseImpl _$$GetOrderResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetOrderResponseImpl(
      status: json['status'] as String,
      message: json['message'] as String,
      data: GetOrderResponseData.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$$GetOrderResponseImplToJson(
        _$GetOrderResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };

_$GetOrderResponseDataImpl _$$GetOrderResponseDataImplFromJson(
        Map<String, dynamic> json) =>
    _$GetOrderResponseDataImpl(
      orderId: (json['orderId'] as num).toInt(),
      institutionId: (json['institutionId'] as num).toInt(),
      institutionName: json['institutionName'] as String,
      itemId: (json['itemId'] as num).toInt(),
      itemName: json['itemName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      remainingQuantity: (json['remainingQuantity'] as num).toInt(),
      stock: json['stock'] as String,
      uniqueCode: json['uniqueCode'] as String,
      startCode: json['startCode'] as String,
      endCode: json['endCode'] as String,
      embeddingCode: json['embeddingCode'] as String,
      status: json['status'] as String,
      regDate: json['regDate'] as String,
    );

Map<String, dynamic> _$$GetOrderResponseDataImplToJson(
        _$GetOrderResponseDataImpl instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'institutionId': instance.institutionId,
      'institutionName': instance.institutionName,
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'quantity': instance.quantity,
      'remainingQuantity': instance.remainingQuantity,
      'stock': instance.stock,
      'uniqueCode': instance.uniqueCode,
      'startCode': instance.startCode,
      'endCode': instance.endCode,
      'embeddingCode': instance.embeddingCode,
      'status': instance.status,
      'regDate': instance.regDate,
    };
