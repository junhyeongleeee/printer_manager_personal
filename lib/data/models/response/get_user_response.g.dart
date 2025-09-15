// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetUserResponseImpl _$$GetUserResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetUserResponseImpl(
      status: json['status'] as String,
      message: json['message'] as String,
      data: GetUserResponseData.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$$GetUserResponseImplToJson(
        _$GetUserResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };

_$GetUserResponseDataImpl _$$GetUserResponseDataImplFromJson(
        Map<String, dynamic> json) =>
    _$GetUserResponseDataImpl(
      userId: json['userId'] as String,
      companyName: json['companyName'] as String,
      address: json['address'] as String,
      username: json['username'] as String,
      phone: json['phone'] as String,
      status: json['status'] as String,
      data: InstitutionData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GetUserResponseDataImplToJson(
        _$GetUserResponseDataImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'companyName': instance.companyName,
      'address': instance.address,
      'username': instance.username,
      'phone': instance.phone,
      'status': instance.status,
      'data': instance.data,
    };

_$InstitusionDataImpl _$$InstitusionDataImplFromJson(
        Map<String, dynamic> json) =>
    _$InstitusionDataImpl(
      institutionId: json['institutionId'] as String,
      institutionName: json['institutionName'] as String,
    );

Map<String, dynamic> _$$InstitusionDataImplToJson(
        _$InstitusionDataImpl instance) =>
    <String, dynamic>{
      'institutionId': instance.institutionId,
      'institutionName': instance.institutionName,
    };
