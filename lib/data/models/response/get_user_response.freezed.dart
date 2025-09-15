// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_user_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetUserResponse _$GetUserResponseFromJson(Map<String, dynamic> json) {
  return _GetUserResponse.fromJson(json);
}

/// @nodoc
mixin _$GetUserResponse {
  String get status => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  GetUserResponseData get data => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;

  /// Serializes this GetUserResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetUserResponseCopyWith<GetUserResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetUserResponseCopyWith<$Res> {
  factory $GetUserResponseCopyWith(
          GetUserResponse value, $Res Function(GetUserResponse) then) =
      _$GetUserResponseCopyWithImpl<$Res, GetUserResponse>;
  @useResult
  $Res call(
      {String status,
      String message,
      GetUserResponseData data,
      String timestamp});

  $GetUserResponseDataCopyWith<$Res> get data;
}

/// @nodoc
class _$GetUserResponseCopyWithImpl<$Res, $Val extends GetUserResponse>
    implements $GetUserResponseCopyWith<$Res> {
  _$GetUserResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
    Object? data = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as GetUserResponseData,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of GetUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GetUserResponseDataCopyWith<$Res> get data {
    return $GetUserResponseDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GetUserResponseImplCopyWith<$Res>
    implements $GetUserResponseCopyWith<$Res> {
  factory _$$GetUserResponseImplCopyWith(_$GetUserResponseImpl value,
          $Res Function(_$GetUserResponseImpl) then) =
      __$$GetUserResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String status,
      String message,
      GetUserResponseData data,
      String timestamp});

  @override
  $GetUserResponseDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$GetUserResponseImplCopyWithImpl<$Res>
    extends _$GetUserResponseCopyWithImpl<$Res, _$GetUserResponseImpl>
    implements _$$GetUserResponseImplCopyWith<$Res> {
  __$$GetUserResponseImplCopyWithImpl(
      _$GetUserResponseImpl _value, $Res Function(_$GetUserResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
    Object? data = null,
    Object? timestamp = null,
  }) {
    return _then(_$GetUserResponseImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as GetUserResponseData,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetUserResponseImpl implements _GetUserResponse {
  const _$GetUserResponseImpl(
      {required this.status,
      required this.message,
      required this.data,
      required this.timestamp});

  factory _$GetUserResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetUserResponseImplFromJson(json);

  @override
  final String status;
  @override
  final String message;
  @override
  final GetUserResponseData data;
  @override
  final String timestamp;

  @override
  String toString() {
    return 'GetUserResponse(status: $status, message: $message, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserResponseImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, status, message, data, timestamp);

  /// Create a copy of GetUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserResponseImplCopyWith<_$GetUserResponseImpl> get copyWith =>
      __$$GetUserResponseImplCopyWithImpl<_$GetUserResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetUserResponseImplToJson(
      this,
    );
  }
}

abstract class _GetUserResponse implements GetUserResponse {
  const factory _GetUserResponse(
      {required final String status,
      required final String message,
      required final GetUserResponseData data,
      required final String timestamp}) = _$GetUserResponseImpl;

  factory _GetUserResponse.fromJson(Map<String, dynamic> json) =
      _$GetUserResponseImpl.fromJson;

  @override
  String get status;
  @override
  String get message;
  @override
  GetUserResponseData get data;
  @override
  String get timestamp;

  /// Create a copy of GetUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetUserResponseImplCopyWith<_$GetUserResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GetUserResponseData _$GetUserResponseDataFromJson(Map<String, dynamic> json) {
  return _GetUserResponseData.fromJson(json);
}

/// @nodoc
mixin _$GetUserResponseData {
  String get userId => throw _privateConstructorUsedError;
  String get companyName => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  InstitutionData get data => throw _privateConstructorUsedError;

  /// Serializes this GetUserResponseData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetUserResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetUserResponseDataCopyWith<GetUserResponseData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetUserResponseDataCopyWith<$Res> {
  factory $GetUserResponseDataCopyWith(
          GetUserResponseData value, $Res Function(GetUserResponseData) then) =
      _$GetUserResponseDataCopyWithImpl<$Res, GetUserResponseData>;
  @useResult
  $Res call(
      {String userId,
      String companyName,
      String address,
      String username,
      String phone,
      String status,
      InstitutionData data});

  $InstitutionDataCopyWith<$Res> get data;
}

/// @nodoc
class _$GetUserResponseDataCopyWithImpl<$Res, $Val extends GetUserResponseData>
    implements $GetUserResponseDataCopyWith<$Res> {
  _$GetUserResponseDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetUserResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? companyName = null,
    Object? address = null,
    Object? username = null,
    Object? phone = null,
    Object? status = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as InstitutionData,
    ) as $Val);
  }

  /// Create a copy of GetUserResponseData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InstitutionDataCopyWith<$Res> get data {
    return $InstitutionDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GetUserResponseDataImplCopyWith<$Res>
    implements $GetUserResponseDataCopyWith<$Res> {
  factory _$$GetUserResponseDataImplCopyWith(_$GetUserResponseDataImpl value,
          $Res Function(_$GetUserResponseDataImpl) then) =
      __$$GetUserResponseDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String companyName,
      String address,
      String username,
      String phone,
      String status,
      InstitutionData data});

  @override
  $InstitutionDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$GetUserResponseDataImplCopyWithImpl<$Res>
    extends _$GetUserResponseDataCopyWithImpl<$Res, _$GetUserResponseDataImpl>
    implements _$$GetUserResponseDataImplCopyWith<$Res> {
  __$$GetUserResponseDataImplCopyWithImpl(_$GetUserResponseDataImpl _value,
      $Res Function(_$GetUserResponseDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetUserResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? companyName = null,
    Object? address = null,
    Object? username = null,
    Object? phone = null,
    Object? status = null,
    Object? data = null,
  }) {
    return _then(_$GetUserResponseDataImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as InstitutionData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetUserResponseDataImpl implements _GetUserResponseData {
  const _$GetUserResponseDataImpl(
      {required this.userId,
      required this.companyName,
      required this.address,
      required this.username,
      required this.phone,
      required this.status,
      required this.data});

  factory _$GetUserResponseDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetUserResponseDataImplFromJson(json);

  @override
  final String userId;
  @override
  final String companyName;
  @override
  final String address;
  @override
  final String username;
  @override
  final String phone;
  @override
  final String status;
  @override
  final InstitutionData data;

  @override
  String toString() {
    return 'GetUserResponseData(userId: $userId, companyName: $companyName, address: $address, username: $username, phone: $phone, status: $status, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserResponseDataImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, userId, companyName, address, username, phone, status, data);

  /// Create a copy of GetUserResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserResponseDataImplCopyWith<_$GetUserResponseDataImpl> get copyWith =>
      __$$GetUserResponseDataImplCopyWithImpl<_$GetUserResponseDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetUserResponseDataImplToJson(
      this,
    );
  }
}

abstract class _GetUserResponseData implements GetUserResponseData {
  const factory _GetUserResponseData(
      {required final String userId,
      required final String companyName,
      required final String address,
      required final String username,
      required final String phone,
      required final String status,
      required final InstitutionData data}) = _$GetUserResponseDataImpl;

  factory _GetUserResponseData.fromJson(Map<String, dynamic> json) =
      _$GetUserResponseDataImpl.fromJson;

  @override
  String get userId;
  @override
  String get companyName;
  @override
  String get address;
  @override
  String get username;
  @override
  String get phone;
  @override
  String get status;
  @override
  InstitutionData get data;

  /// Create a copy of GetUserResponseData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetUserResponseDataImplCopyWith<_$GetUserResponseDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InstitutionData _$InstitutionDataFromJson(Map<String, dynamic> json) {
  return _InstitusionData.fromJson(json);
}

/// @nodoc
mixin _$InstitutionData {
  String get institutionId => throw _privateConstructorUsedError;
  String get institutionName => throw _privateConstructorUsedError;

  /// Serializes this InstitutionData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InstitutionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InstitutionDataCopyWith<InstitutionData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstitutionDataCopyWith<$Res> {
  factory $InstitutionDataCopyWith(
          InstitutionData value, $Res Function(InstitutionData) then) =
      _$InstitutionDataCopyWithImpl<$Res, InstitutionData>;
  @useResult
  $Res call({String institutionId, String institutionName});
}

/// @nodoc
class _$InstitutionDataCopyWithImpl<$Res, $Val extends InstitutionData>
    implements $InstitutionDataCopyWith<$Res> {
  _$InstitutionDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InstitutionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? institutionId = null,
    Object? institutionName = null,
  }) {
    return _then(_value.copyWith(
      institutionId: null == institutionId
          ? _value.institutionId
          : institutionId // ignore: cast_nullable_to_non_nullable
              as String,
      institutionName: null == institutionName
          ? _value.institutionName
          : institutionName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InstitusionDataImplCopyWith<$Res>
    implements $InstitutionDataCopyWith<$Res> {
  factory _$$InstitusionDataImplCopyWith(_$InstitusionDataImpl value,
          $Res Function(_$InstitusionDataImpl) then) =
      __$$InstitusionDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String institutionId, String institutionName});
}

/// @nodoc
class __$$InstitusionDataImplCopyWithImpl<$Res>
    extends _$InstitutionDataCopyWithImpl<$Res, _$InstitusionDataImpl>
    implements _$$InstitusionDataImplCopyWith<$Res> {
  __$$InstitusionDataImplCopyWithImpl(
      _$InstitusionDataImpl _value, $Res Function(_$InstitusionDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of InstitutionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? institutionId = null,
    Object? institutionName = null,
  }) {
    return _then(_$InstitusionDataImpl(
      institutionId: null == institutionId
          ? _value.institutionId
          : institutionId // ignore: cast_nullable_to_non_nullable
              as String,
      institutionName: null == institutionName
          ? _value.institutionName
          : institutionName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InstitusionDataImpl implements _InstitusionData {
  const _$InstitusionDataImpl(
      {required this.institutionId, required this.institutionName});

  factory _$InstitusionDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstitusionDataImplFromJson(json);

  @override
  final String institutionId;
  @override
  final String institutionName;

  @override
  String toString() {
    return 'InstitutionData(institutionId: $institutionId, institutionName: $institutionName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstitusionDataImpl &&
            (identical(other.institutionId, institutionId) ||
                other.institutionId == institutionId) &&
            (identical(other.institutionName, institutionName) ||
                other.institutionName == institutionName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, institutionId, institutionName);

  /// Create a copy of InstitutionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InstitusionDataImplCopyWith<_$InstitusionDataImpl> get copyWith =>
      __$$InstitusionDataImplCopyWithImpl<_$InstitusionDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InstitusionDataImplToJson(
      this,
    );
  }
}

abstract class _InstitusionData implements InstitutionData {
  const factory _InstitusionData(
      {required final String institutionId,
      required final String institutionName}) = _$InstitusionDataImpl;

  factory _InstitusionData.fromJson(Map<String, dynamic> json) =
      _$InstitusionDataImpl.fromJson;

  @override
  String get institutionId;
  @override
  String get institutionName;

  /// Create a copy of InstitutionData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InstitusionDataImplCopyWith<_$InstitusionDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
