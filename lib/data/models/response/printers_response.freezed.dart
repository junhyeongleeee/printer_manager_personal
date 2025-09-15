// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'printers_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PrintersResponse _$PrintersResponseFromJson(Map<String, dynamic> json) {
  return _PrintersResponse.fromJson(json);
}

/// @nodoc
mixin _$PrintersResponse {
  String get status => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  PrintersResponseData get data => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;

  /// Serializes this PrintersResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrintersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrintersResponseCopyWith<PrintersResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrintersResponseCopyWith<$Res> {
  factory $PrintersResponseCopyWith(
          PrintersResponse value, $Res Function(PrintersResponse) then) =
      _$PrintersResponseCopyWithImpl<$Res, PrintersResponse>;
  @useResult
  $Res call(
      {String status,
      String message,
      PrintersResponseData data,
      String timestamp});

  $PrintersResponseDataCopyWith<$Res> get data;
}

/// @nodoc
class _$PrintersResponseCopyWithImpl<$Res, $Val extends PrintersResponse>
    implements $PrintersResponseCopyWith<$Res> {
  _$PrintersResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrintersResponse
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
              as PrintersResponseData,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of PrintersResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PrintersResponseDataCopyWith<$Res> get data {
    return $PrintersResponseDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PrintersResponseImplCopyWith<$Res>
    implements $PrintersResponseCopyWith<$Res> {
  factory _$$PrintersResponseImplCopyWith(_$PrintersResponseImpl value,
          $Res Function(_$PrintersResponseImpl) then) =
      __$$PrintersResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String status,
      String message,
      PrintersResponseData data,
      String timestamp});

  @override
  $PrintersResponseDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$PrintersResponseImplCopyWithImpl<$Res>
    extends _$PrintersResponseCopyWithImpl<$Res, _$PrintersResponseImpl>
    implements _$$PrintersResponseImplCopyWith<$Res> {
  __$$PrintersResponseImplCopyWithImpl(_$PrintersResponseImpl _value,
      $Res Function(_$PrintersResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrintersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
    Object? data = null,
    Object? timestamp = null,
  }) {
    return _then(_$PrintersResponseImpl(
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
              as PrintersResponseData,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrintersResponseImpl implements _PrintersResponse {
  const _$PrintersResponseImpl(
      {required this.status,
      required this.message,
      required this.data,
      required this.timestamp});

  factory _$PrintersResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrintersResponseImplFromJson(json);

  @override
  final String status;
  @override
  final String message;
  @override
  final PrintersResponseData data;
  @override
  final String timestamp;

  @override
  String toString() {
    return 'PrintersResponse(status: $status, message: $message, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrintersResponseImpl &&
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

  /// Create a copy of PrintersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrintersResponseImplCopyWith<_$PrintersResponseImpl> get copyWith =>
      __$$PrintersResponseImplCopyWithImpl<_$PrintersResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrintersResponseImplToJson(
      this,
    );
  }
}

abstract class _PrintersResponse implements PrintersResponse {
  const factory _PrintersResponse(
      {required final String status,
      required final String message,
      required final PrintersResponseData data,
      required final String timestamp}) = _$PrintersResponseImpl;

  factory _PrintersResponse.fromJson(Map<String, dynamic> json) =
      _$PrintersResponseImpl.fromJson;

  @override
  String get status;
  @override
  String get message;
  @override
  PrintersResponseData get data;
  @override
  String get timestamp;

  /// Create a copy of PrintersResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrintersResponseImplCopyWith<_$PrintersResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PrintersResponseData _$PrintersResponseDataFromJson(Map<String, dynamic> json) {
  return _PrintersResponseData.fromJson(json);
}

/// @nodoc
mixin _$PrintersResponseData {
  int get processingCompanyPrinterIndex => throw _privateConstructorUsedError;
  String get printerName => throw _privateConstructorUsedError;
  String get ip => throw _privateConstructorUsedError;
  String get port => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError; //연결상태
  String get regDate => throw _privateConstructorUsedError;

  /// Serializes this PrintersResponseData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrintersResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrintersResponseDataCopyWith<PrintersResponseData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrintersResponseDataCopyWith<$Res> {
  factory $PrintersResponseDataCopyWith(PrintersResponseData value,
          $Res Function(PrintersResponseData) then) =
      _$PrintersResponseDataCopyWithImpl<$Res, PrintersResponseData>;
  @useResult
  $Res call(
      {int processingCompanyPrinterIndex,
      String printerName,
      String ip,
      String port,
      String status,
      String regDate});
}

/// @nodoc
class _$PrintersResponseDataCopyWithImpl<$Res,
        $Val extends PrintersResponseData>
    implements $PrintersResponseDataCopyWith<$Res> {
  _$PrintersResponseDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrintersResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? processingCompanyPrinterIndex = null,
    Object? printerName = null,
    Object? ip = null,
    Object? port = null,
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
      ip: null == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PrintersResponseDataImplCopyWith<$Res>
    implements $PrintersResponseDataCopyWith<$Res> {
  factory _$$PrintersResponseDataImplCopyWith(_$PrintersResponseDataImpl value,
          $Res Function(_$PrintersResponseDataImpl) then) =
      __$$PrintersResponseDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int processingCompanyPrinterIndex,
      String printerName,
      String ip,
      String port,
      String status,
      String regDate});
}

/// @nodoc
class __$$PrintersResponseDataImplCopyWithImpl<$Res>
    extends _$PrintersResponseDataCopyWithImpl<$Res, _$PrintersResponseDataImpl>
    implements _$$PrintersResponseDataImplCopyWith<$Res> {
  __$$PrintersResponseDataImplCopyWithImpl(_$PrintersResponseDataImpl _value,
      $Res Function(_$PrintersResponseDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrintersResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? processingCompanyPrinterIndex = null,
    Object? printerName = null,
    Object? ip = null,
    Object? port = null,
    Object? status = null,
    Object? regDate = null,
  }) {
    return _then(_$PrintersResponseDataImpl(
      processingCompanyPrinterIndex: null == processingCompanyPrinterIndex
          ? _value.processingCompanyPrinterIndex
          : processingCompanyPrinterIndex // ignore: cast_nullable_to_non_nullable
              as int,
      printerName: null == printerName
          ? _value.printerName
          : printerName // ignore: cast_nullable_to_non_nullable
              as String,
      ip: null == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
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
class _$PrintersResponseDataImpl implements _PrintersResponseData {
  const _$PrintersResponseDataImpl(
      {required this.processingCompanyPrinterIndex,
      required this.printerName,
      required this.ip,
      required this.port,
      required this.status,
      required this.regDate});

  factory _$PrintersResponseDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrintersResponseDataImplFromJson(json);

  @override
  final int processingCompanyPrinterIndex;
  @override
  final String printerName;
  @override
  final String ip;
  @override
  final String port;
  @override
  final String status;
//연결상태
  @override
  final String regDate;

  @override
  String toString() {
    return 'PrintersResponseData(processingCompanyPrinterIndex: $processingCompanyPrinterIndex, printerName: $printerName, ip: $ip, port: $port, status: $status, regDate: $regDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrintersResponseDataImpl &&
            (identical(other.processingCompanyPrinterIndex,
                    processingCompanyPrinterIndex) ||
                other.processingCompanyPrinterIndex ==
                    processingCompanyPrinterIndex) &&
            (identical(other.printerName, printerName) ||
                other.printerName == printerName) &&
            (identical(other.ip, ip) || other.ip == ip) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.regDate, regDate) || other.regDate == regDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, processingCompanyPrinterIndex,
      printerName, ip, port, status, regDate);

  /// Create a copy of PrintersResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrintersResponseDataImplCopyWith<_$PrintersResponseDataImpl>
      get copyWith =>
          __$$PrintersResponseDataImplCopyWithImpl<_$PrintersResponseDataImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrintersResponseDataImplToJson(
      this,
    );
  }
}

abstract class _PrintersResponseData implements PrintersResponseData {
  const factory _PrintersResponseData(
      {required final int processingCompanyPrinterIndex,
      required final String printerName,
      required final String ip,
      required final String port,
      required final String status,
      required final String regDate}) = _$PrintersResponseDataImpl;

  factory _PrintersResponseData.fromJson(Map<String, dynamic> json) =
      _$PrintersResponseDataImpl.fromJson;

  @override
  int get processingCompanyPrinterIndex;
  @override
  String get printerName;
  @override
  String get ip;
  @override
  String get port;
  @override
  String get status; //연결상태
  @override
  String get regDate;

  /// Create a copy of PrintersResponseData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrintersResponseDataImplCopyWith<_$PrintersResponseDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
