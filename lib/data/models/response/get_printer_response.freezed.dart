// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_printer_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetPrinterResponse _$GetPrinterResponseFromJson(Map<String, dynamic> json) {
  return _GetPrinterResponse.fromJson(json);
}

/// @nodoc
mixin _$GetPrinterResponse {
  String get status => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  GetPrinterResponseData get data => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;

  /// Serializes this GetPrinterResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetPrinterResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetPrinterResponseCopyWith<GetPrinterResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetPrinterResponseCopyWith<$Res> {
  factory $GetPrinterResponseCopyWith(
          GetPrinterResponse value, $Res Function(GetPrinterResponse) then) =
      _$GetPrinterResponseCopyWithImpl<$Res, GetPrinterResponse>;
  @useResult
  $Res call(
      {String status,
      String message,
      GetPrinterResponseData data,
      String timestamp});

  $GetPrinterResponseDataCopyWith<$Res> get data;
}

/// @nodoc
class _$GetPrinterResponseCopyWithImpl<$Res, $Val extends GetPrinterResponse>
    implements $GetPrinterResponseCopyWith<$Res> {
  _$GetPrinterResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetPrinterResponse
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
              as GetPrinterResponseData,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of GetPrinterResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GetPrinterResponseDataCopyWith<$Res> get data {
    return $GetPrinterResponseDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GetPrinterResponseImplCopyWith<$Res>
    implements $GetPrinterResponseCopyWith<$Res> {
  factory _$$GetPrinterResponseImplCopyWith(_$GetPrinterResponseImpl value,
          $Res Function(_$GetPrinterResponseImpl) then) =
      __$$GetPrinterResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String status,
      String message,
      GetPrinterResponseData data,
      String timestamp});

  @override
  $GetPrinterResponseDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$GetPrinterResponseImplCopyWithImpl<$Res>
    extends _$GetPrinterResponseCopyWithImpl<$Res, _$GetPrinterResponseImpl>
    implements _$$GetPrinterResponseImplCopyWith<$Res> {
  __$$GetPrinterResponseImplCopyWithImpl(_$GetPrinterResponseImpl _value,
      $Res Function(_$GetPrinterResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetPrinterResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
    Object? data = null,
    Object? timestamp = null,
  }) {
    return _then(_$GetPrinterResponseImpl(
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
              as GetPrinterResponseData,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetPrinterResponseImpl implements _GetPrinterResponse {
  const _$GetPrinterResponseImpl(
      {required this.status,
      required this.message,
      required this.data,
      required this.timestamp});

  factory _$GetPrinterResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetPrinterResponseImplFromJson(json);

  @override
  final String status;
  @override
  final String message;
  @override
  final GetPrinterResponseData data;
  @override
  final String timestamp;

  @override
  String toString() {
    return 'GetPrinterResponse(status: $status, message: $message, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetPrinterResponseImpl &&
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

  /// Create a copy of GetPrinterResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetPrinterResponseImplCopyWith<_$GetPrinterResponseImpl> get copyWith =>
      __$$GetPrinterResponseImplCopyWithImpl<_$GetPrinterResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetPrinterResponseImplToJson(
      this,
    );
  }
}

abstract class _GetPrinterResponse implements GetPrinterResponse {
  const factory _GetPrinterResponse(
      {required final String status,
      required final String message,
      required final GetPrinterResponseData data,
      required final String timestamp}) = _$GetPrinterResponseImpl;

  factory _GetPrinterResponse.fromJson(Map<String, dynamic> json) =
      _$GetPrinterResponseImpl.fromJson;

  @override
  String get status;
  @override
  String get message;
  @override
  GetPrinterResponseData get data;
  @override
  String get timestamp;

  /// Create a copy of GetPrinterResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetPrinterResponseImplCopyWith<_$GetPrinterResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GetPrinterResponseData _$GetPrinterResponseDataFromJson(
    Map<String, dynamic> json) {
  return _GetPrinterResponseData.fromJson(json);
}

/// @nodoc
mixin _$GetPrinterResponseData {
  int get processingCompanyPrinterIndex => throw _privateConstructorUsedError;
  String get printerName => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get regDate => throw _privateConstructorUsedError;

  /// Serializes this GetPrinterResponseData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetPrinterResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetPrinterResponseDataCopyWith<GetPrinterResponseData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetPrinterResponseDataCopyWith<$Res> {
  factory $GetPrinterResponseDataCopyWith(GetPrinterResponseData value,
          $Res Function(GetPrinterResponseData) then) =
      _$GetPrinterResponseDataCopyWithImpl<$Res, GetPrinterResponseData>;
  @useResult
  $Res call(
      {int processingCompanyPrinterIndex,
      String printerName,
      String model,
      String status,
      String regDate});
}

/// @nodoc
class _$GetPrinterResponseDataCopyWithImpl<$Res,
        $Val extends GetPrinterResponseData>
    implements $GetPrinterResponseDataCopyWith<$Res> {
  _$GetPrinterResponseDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetPrinterResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? processingCompanyPrinterIndex = null,
    Object? printerName = null,
    Object? model = null,
    Object? status = null,
    Object? regDate = null,
  }) {
    return _then(_value.copyWith(
      processingCompanyPrinterIndex: null == processingCompanyPrinterIndex
          ? _value.processingCompanyPrinterIndex
          : processingCompanyPrinterIndex // ignore: cast_nullable_to_non_nullable
              as int,
      printerName: null == printerName
          ? _value.printerName
          : printerName // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      regDate: null == regDate
          ? _value.regDate
          : regDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetPrinterResponseDataImplCopyWith<$Res>
    implements $GetPrinterResponseDataCopyWith<$Res> {
  factory _$$GetPrinterResponseDataImplCopyWith(
          _$GetPrinterResponseDataImpl value,
          $Res Function(_$GetPrinterResponseDataImpl) then) =
      __$$GetPrinterResponseDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int processingCompanyPrinterIndex,
      String printerName,
      String model,
      String status,
      String regDate});
}

/// @nodoc
class __$$GetPrinterResponseDataImplCopyWithImpl<$Res>
    extends _$GetPrinterResponseDataCopyWithImpl<$Res,
        _$GetPrinterResponseDataImpl>
    implements _$$GetPrinterResponseDataImplCopyWith<$Res> {
  __$$GetPrinterResponseDataImplCopyWithImpl(
      _$GetPrinterResponseDataImpl _value,
      $Res Function(_$GetPrinterResponseDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetPrinterResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? processingCompanyPrinterIndex = null,
    Object? printerName = null,
    Object? model = null,
    Object? status = null,
    Object? regDate = null,
  }) {
    return _then(_$GetPrinterResponseDataImpl(
      processingCompanyPrinterIndex: null == processingCompanyPrinterIndex
          ? _value.processingCompanyPrinterIndex
          : processingCompanyPrinterIndex // ignore: cast_nullable_to_non_nullable
              as int,
      printerName: null == printerName
          ? _value.printerName
          : printerName // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      regDate: null == regDate
          ? _value.regDate
          : regDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetPrinterResponseDataImpl implements _GetPrinterResponseData {
  const _$GetPrinterResponseDataImpl(
      {required this.processingCompanyPrinterIndex,
      required this.printerName,
      required this.model,
      required this.status,
      required this.regDate});

  factory _$GetPrinterResponseDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetPrinterResponseDataImplFromJson(json);

  @override
  final int processingCompanyPrinterIndex;
  @override
  final String printerName;
  @override
  final String model;
  @override
  final String status;
  @override
  final String regDate;

  @override
  String toString() {
    return 'GetPrinterResponseData(processingCompanyPrinterIndex: $processingCompanyPrinterIndex, printerName: $printerName, model: $model, status: $status, regDate: $regDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetPrinterResponseDataImpl &&
            (identical(other.processingCompanyPrinterIndex,
                    processingCompanyPrinterIndex) ||
                other.processingCompanyPrinterIndex ==
                    processingCompanyPrinterIndex) &&
            (identical(other.printerName, printerName) ||
                other.printerName == printerName) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.regDate, regDate) || other.regDate == regDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, processingCompanyPrinterIndex,
      printerName, model, status, regDate);

  /// Create a copy of GetPrinterResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetPrinterResponseDataImplCopyWith<_$GetPrinterResponseDataImpl>
      get copyWith => __$$GetPrinterResponseDataImplCopyWithImpl<
          _$GetPrinterResponseDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetPrinterResponseDataImplToJson(
      this,
    );
  }
}

abstract class _GetPrinterResponseData implements GetPrinterResponseData {
  const factory _GetPrinterResponseData(
      {required final int processingCompanyPrinterIndex,
      required final String printerName,
      required final String model,
      required final String status,
      required final String regDate}) = _$GetPrinterResponseDataImpl;

  factory _GetPrinterResponseData.fromJson(Map<String, dynamic> json) =
      _$GetPrinterResponseDataImpl.fromJson;

  @override
  int get processingCompanyPrinterIndex;
  @override
  String get printerName;
  @override
  String get model;
  @override
  String get status;
  @override
  String get regDate;

  /// Create a copy of GetPrinterResponseData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetPrinterResponseDataImplCopyWith<_$GetPrinterResponseDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
