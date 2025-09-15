// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printerjob_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrinterjobRequestImpl _$$PrinterjobRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$PrinterjobRequestImpl(
      orderId: (json['orderId'] as num).toInt(),
      processingCompanyPrinterId:
          (json['processingCompanyPrinterId'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$$PrinterjobRequestImplToJson(
        _$PrinterjobRequestImpl instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'processingCompanyPrinterId': instance.processingCompanyPrinterId,
      'quantity': instance.quantity,
    };
