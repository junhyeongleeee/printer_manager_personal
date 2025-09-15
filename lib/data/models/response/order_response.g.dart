// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderResponseImpl _$$OrderResponseImplFromJson(Map<String, dynamic> json) =>
    _$OrderResponseImpl(
      status: json['status'] as String,
      message: json['message'] as String,
      data: OrderResponseDataWrapper.fromJson(
          json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$$OrderResponseImplToJson(_$OrderResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };

_$OrderResponseDataWrapperImpl _$$OrderResponseDataWrapperImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderResponseDataWrapperImpl(
      orderCount: (json['orderCount'] as num).toInt(),
      orderList: (json['orderList'] as List<dynamic>)
          .map((e) => OrderResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$OrderResponseDataWrapperImplToJson(
        _$OrderResponseDataWrapperImpl instance) =>
    <String, dynamic>{
      'orderCount': instance.orderCount,
      'orderList': instance.orderList,
    };

_$OrderResponseDataImpl _$$OrderResponseDataImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderResponseDataImpl(
      orderId: (json['orderId'] as num).toInt(),
      institutionId: (json['institutionId'] as num).toInt(),
      institutionName: json['institutionName'] as String,
      itemId: (json['itemId'] as num).toInt(),
      itemName: json['itemName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      remainingQuantity: (json['remainingQuantity'] as num).toInt(),
      stock: (json['stock'] as num).toInt(),
      uniqueCode: json['uniqueCode'] as String,
      startCode: json['startCode'] as String,
      endCode: json['endCode'] as String,
      embeddingCode: json['embeddingCode'] as String,
      status: json['status'] as String,
      regDate: json['regDate'] as String,
    );

Map<String, dynamic> _$$OrderResponseDataImplToJson(
        _$OrderResponseDataImpl instance) =>
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
