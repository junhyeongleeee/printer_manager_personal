// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'printerjob_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PrinterjobResponse _$PrinterjobResponseFromJson(Map<String, dynamic> json) {
  return _PrinterjobResponse.fromJson(json);
}

/// @nodoc
mixin _$PrinterjobResponse {
  String get status => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  PrinterjobResponseData get data => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;

  /// Serializes this PrinterjobResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrinterjobResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrinterjobResponseCopyWith<PrinterjobResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrinterjobResponseCopyWith<$Res> {
  factory $PrinterjobResponseCopyWith(
          PrinterjobResponse value, $Res Function(PrinterjobResponse) then) =
      _$PrinterjobResponseCopyWithImpl<$Res, PrinterjobResponse>;
  @useResult
  $Res call(
      {String status,
      String message,
      PrinterjobResponseData data,
      String timestamp});

  $PrinterjobResponseDataCopyWith<$Res> get data;
}

/// @nodoc
class _$PrinterjobResponseCopyWithImpl<$Res, $Val extends PrinterjobResponse>
    implements $PrinterjobResponseCopyWith<$Res> {
  _$PrinterjobResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrinterjobResponse
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
              as PrinterjobResponseData,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of PrinterjobResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PrinterjobResponseDataCopyWith<$Res> get data {
    return $PrinterjobResponseDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PrinterjobResponseImplCopyWith<$Res>
    implements $PrinterjobResponseCopyWith<$Res> {
  factory _$$PrinterjobResponseImplCopyWith(_$PrinterjobResponseImpl value,
          $Res Function(_$PrinterjobResponseImpl) then) =
      __$$PrinterjobResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String status,
      String message,
      PrinterjobResponseData data,
      String timestamp});

  @override
  $PrinterjobResponseDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$PrinterjobResponseImplCopyWithImpl<$Res>
    extends _$PrinterjobResponseCopyWithImpl<$Res, _$PrinterjobResponseImpl>
    implements _$$PrinterjobResponseImplCopyWith<$Res> {
  __$$PrinterjobResponseImplCopyWithImpl(_$PrinterjobResponseImpl _value,
      $Res Function(_$PrinterjobResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrinterjobResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
    Object? data = null,
    Object? timestamp = null,
  }) {
    return _then(_$PrinterjobResponseImpl(
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
              as PrinterjobResponseData,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrinterjobResponseImpl implements _PrinterjobResponse {
  const _$PrinterjobResponseImpl(
      {required this.status,
      required this.message,
      required this.data,
      required this.timestamp});

  factory _$PrinterjobResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrinterjobResponseImplFromJson(json);

  @override
  final String status;
  @override
  final String message;
  @override
  final PrinterjobResponseData data;
  @override
  final String timestamp;

  @override
  String toString() {
    return 'PrinterjobResponse(status: $status, message: $message, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrinterjobResponseImpl &&
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

  /// Create a copy of PrinterjobResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrinterjobResponseImplCopyWith<_$PrinterjobResponseImpl> get copyWith =>
      __$$PrinterjobResponseImplCopyWithImpl<_$PrinterjobResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrinterjobResponseImplToJson(
      this,
    );
  }
}

abstract class _PrinterjobResponse implements PrinterjobResponse {
  const factory _PrinterjobResponse(
      {required final String status,
      required final String message,
      required final PrinterjobResponseData data,
      required final String timestamp}) = _$PrinterjobResponseImpl;

  factory _PrinterjobResponse.fromJson(Map<String, dynamic> json) =
      _$PrinterjobResponseImpl.fromJson;

  @override
  String get status;
  @override
  String get message;
  @override
  PrinterjobResponseData get data;
  @override
  String get timestamp;

  /// Create a copy of PrinterjobResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrinterjobResponseImplCopyWith<_$PrinterjobResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PrinterjobResponseData _$PrinterjobResponseDataFromJson(
    Map<String, dynamic> json) {
  return _PrinterjobResponseData.fromJson(json);
}

/// @nodoc
mixin _$PrinterjobResponseData {
  int get jobId => throw _privateConstructorUsedError;

  /// Serializes this PrinterjobResponseData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrinterjobResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrinterjobResponseDataCopyWith<PrinterjobResponseData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrinterjobResponseDataCopyWith<$Res> {
  factory $PrinterjobResponseDataCopyWith(PrinterjobResponseData value,
          $Res Function(PrinterjobResponseData) then) =
      _$PrinterjobResponseDataCopyWithImpl<$Res, PrinterjobResponseData>;
  @useResult
  $Res call({int jobId});
}

/// @nodoc
class _$PrinterjobResponseDataCopyWithImpl<$Res,
        $Val extends PrinterjobResponseData>
    implements $PrinterjobResponseDataCopyWith<$Res> {
  _$PrinterjobResponseDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrinterjobResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jobId = null,
  }) {
    return _then(_value.copyWith(
      jobId: null == jobId
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrinterjobResponseDataImplCopyWith<$Res>
    implements $PrinterjobResponseDataCopyWith<$Res> {
  factory _$$PrinterjobResponseDataImplCopyWith(
          _$PrinterjobResponseDataImpl value,
          $Res Function(_$PrinterjobResponseDataImpl) then) =
      __$$PrinterjobResponseDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int jobId});
}

/// @nodoc
class __$$PrinterjobResponseDataImplCopyWithImpl<$Res>
    extends _$PrinterjobResponseDataCopyWithImpl<$Res,
        _$PrinterjobResponseDataImpl>
    implements _$$PrinterjobResponseDataImplCopyWith<$Res> {
  __$$PrinterjobResponseDataImplCopyWithImpl(
      _$PrinterjobResponseDataImpl _value,
      $Res Function(_$PrinterjobResponseDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrinterjobResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jobId = null,
  }) {
    return _then(_$PrinterjobResponseDataImpl(
      jobId: null == jobId
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrinterjobResponseDataImpl implements _PrinterjobResponseData {
  const _$PrinterjobResponseDataImpl({required this.jobId});

  factory _$PrinterjobResponseDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrinterjobResponseDataImplFromJson(json);

  @override
  final int jobId;

  @override
  String toString() {
    return 'PrinterjobResponseData(jobId: $jobId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrinterjobResponseDataImpl &&
            (identical(other.jobId, jobId) || other.jobId == jobId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, jobId);

  /// Create a copy of PrinterjobResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrinterjobResponseDataImplCopyWith<_$PrinterjobResponseDataImpl>
      get copyWith => __$$PrinterjobResponseDataImplCopyWithImpl<
          _$PrinterjobResponseDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrinterjobResponseDataImplToJson(
      this,
    );
  }
}

abstract class _PrinterjobResponseData implements PrinterjobResponseData {
  const factory _PrinterjobResponseData({required final int jobId}) =
      _$PrinterjobResponseDataImpl;

  factory _PrinterjobResponseData.fromJson(Map<String, dynamic> json) =
      _$PrinterjobResponseDataImpl.fromJson;

  @override
  int get jobId;

  /// Create a copy of PrinterjobResponseData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrinterjobResponseDataImplCopyWith<_$PrinterjobResponseDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
