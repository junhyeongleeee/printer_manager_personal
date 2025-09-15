// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserRequestImpl _$$UserRequestImplFromJson(Map<String, dynamic> json) =>
    _$UserRequestImpl(
      companyName: json['companyName'] as String,
      address: json['address'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$$UserRequestImplToJson(_$UserRequestImpl instance) =>
    <String, dynamic>{
      'companyName': instance.companyName,
      'address': instance.address,
      'username': instance.username,
      'password': instance.password,
      'phone': instance.phone,
      'status': instance.status,
    };
