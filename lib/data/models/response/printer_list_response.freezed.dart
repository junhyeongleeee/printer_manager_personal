// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'printer_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PrinterListResponse _$PrinterListResponseFromJson(Map<String, dynamic> json) {
  return _PrinterListResponse.fromJson(json);
}

/// @nodoc
mixin _$PrinterListResponse {
  String get status => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  PrinterListResponseData get data => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;

  /// Serializes this PrinterListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrinterListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrinterListResponseCopyWith<PrinterListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrinterListResponseCopyWith<$Res> {
  factory $PrinterListResponseCopyWith(
          PrinterListResponse value, $Res Function(PrinterListResponse) then) =
      _$PrinterListResponseCopyWithImpl<$Res, PrinterListResponse>;
  @useResult
  $Res call(
      {String status,
      String message,
      PrinterListResponseData data,
      String timestamp});

  $PrinterListResponseDataCopyWith<$Res> get data;
}

/// @nodoc
class _$PrinterListResponseCopyWithImpl<$Res, $Val extends PrinterListResponse>
    implements $PrinterListResponseCopyWith<$Res> {
  _$PrinterListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrinterListResponse
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
              as PrinterListResponseData,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of PrinterListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PrinterListResponseDataCopyWith<$Res> get data {
    return $PrinterListResponseDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PrinterListResponseImplCopyWith<$Res>
    implements $PrinterListResponseCopyWith<$Res> {
  factory _$$PrinterListResponseImplCopyWith(_$PrinterListResponseImpl value,
          $Res Function(_$PrinterListResponseImpl) then) =
      __$$PrinterListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String status,
      String message,
      PrinterListResponseData data,
      String timestamp});

  @override
  $PrinterListResponseDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$PrinterListResponseImplCopyWithImpl<$Res>
    extends _$PrinterListResponseCopyWithImpl<$Res, _$PrinterListResponseImpl>
    implements _$$PrinterListResponseImplCopyWith<$Res> {
  __$$PrinterListResponseImplCopyWithImpl(_$PrinterListResponseImpl _value,
      $Res Function(_$PrinterListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrinterListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
    Object? data = null,
    Object? timestamp = null,
  }) {
    return _then(_$PrinterListResponseImpl(
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
              as PrinterListResponseData,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrinterListResponseImpl implements _PrinterListResponse {
  const _$PrinterListResponseImpl(
      {required this.status,
      required this.message,
      required this.data,
      required this.timestamp});

  factory _$PrinterListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrinterListResponseImplFromJson(json);

  @override
  final String status;
  @override
  final String message;
  @override
  final PrinterListResponseData data;
  @override
  final String timestamp;

  @override
  String toString() {
    return 'PrinterListResponse(status: $status, message: $message, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrinterListResponseImpl &&
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

  /// Create a copy of PrinterListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrinterListResponseImplCopyWith<_$PrinterListResponseImpl> get copyWith =>
      __$$PrinterListResponseImplCopyWithImpl<_$PrinterListResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrinterListResponseImplToJson(
      this,
    );
  }
}

abstract class _PrinterListResponse implements PrinterListResponse {
  const factory _PrinterListResponse(
      {required final String status,
      required final String message,
      required final PrinterListResponseData data,
      required final String timestamp}) = _$PrinterListResponseImpl;

  factory _PrinterListResponse.fromJson(Map<String, dynamic> json) =
      _$PrinterListResponseImpl.fromJson;

  @override
  String get status;
  @override
  String get message;
  @override
  PrinterListResponseData get data;
  @override
  String get timestamp;

  /// Create a copy of PrinterListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrinterListResponseImplCopyWith<_$PrinterListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PrinterListResponseData _$PrinterListResponseDataFromJson(
    Map<String, dynamic> json) {
  return _PrinterListResponseData.fromJson(json);
}

/// @nodoc
mixin _$PrinterListResponseData {
  List<PrinterData> get printerList => throw _privateConstructorUsedError;

  /// Serializes this PrinterListResponseData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrinterListResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrinterListResponseDataCopyWith<PrinterListResponseData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrinterListResponseDataCopyWith<$Res> {
  factory $PrinterListResponseDataCopyWith(PrinterListResponseData value,
          $Res Function(PrinterListResponseData) then) =
      _$PrinterListResponseDataCopyWithImpl<$Res, PrinterListResponseData>;
  @useResult
  $Res call({List<PrinterData> printerList});
}

/// @nodoc
class _$PrinterListResponseDataCopyWithImpl<$Res,
        $Val extends PrinterListResponseData>
    implements $PrinterListResponseDataCopyWith<$Res> {
  _$PrinterListResponseDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrinterListResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? printerList = null,
  }) {
    return _then(_value.copyWith(
      printerList: null == printerList
          ? _value.printerList
          : printerList // ignore: cast_nullable_to_non_nullable
              as List<PrinterData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrinterListResponseDataImplCopyWith<$Res>
    implements $PrinterListResponseDataCopyWith<$Res> {
  factory _$$PrinterListResponseDataImplCopyWith(
          _$PrinterListResponseDataImpl value,
          $Res Function(_$PrinterListResponseDataImpl) then) =
      __$$PrinterListResponseDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<PrinterData> printerList});
}

/// @nodoc
class __$$PrinterListResponseDataImplCopyWithImpl<$Res>
    extends _$PrinterListResponseDataCopyWithImpl<$Res,
        _$PrinterListResponseDataImpl>
    implements _$$PrinterListResponseDataImplCopyWith<$Res> {
  __$$PrinterListResponseDataImplCopyWithImpl(
      _$PrinterListResponseDataImpl _value,
      $Res Function(_$PrinterListResponseDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrinterListResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? printerList = null,
  }) {
    return _then(_$PrinterListResponseDataImpl(
      printerList: null == printerList
          ? _value._printerList
          : printerList // ignore: cast_nullable_to_non_nullable
              as List<PrinterData>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrinterListResponseDataImpl implements _PrinterListResponseData {
  const _$PrinterListResponseDataImpl(
      {required final List<PrinterData> printerList})
      : _printerList = printerList;

  factory _$PrinterListResponseDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrinterListResponseDataImplFromJson(json);

  final List<PrinterData> _printerList;
  @override
  List<PrinterData> get printerList {
    if (_printerList is EqualUnmodifiableListView) return _printerList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_printerList);
  }

  @override
  String toString() {
    return 'PrinterListResponseData(printerList: $printerList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrinterListResponseDataImpl &&
            const DeepCollectionEquality()
                .equals(other._printerList, _printerList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_printerList));

  /// Create a copy of PrinterListResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrinterListResponseDataImplCopyWith<_$PrinterListResponseDataImpl>
      get copyWith => __$$PrinterListResponseDataImplCopyWithImpl<
          _$PrinterListResponseDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrinterListResponseDataImplToJson(
      this,
    );
  }
}

abstract class _PrinterListResponseData implements PrinterListResponseData {
  const factory _PrinterListResponseData(
          {required final List<PrinterData> printerList}) =
      _$PrinterListResponseDataImpl;

  factory _PrinterListResponseData.fromJson(Map<String, dynamic> json) =
      _$PrinterListResponseDataImpl.fromJson;

  @override
  List<PrinterData> get printerList;

  /// Create a copy of PrinterListResponseData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrinterListResponseDataImplCopyWith<_$PrinterListResponseDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PrinterData _$PrinterDataFromJson(Map<String, dynamic> json) {
  return _PrinterData.fromJson(json);
}

/// @nodoc
mixin _$PrinterData {
  int get processingCompanyPrinterIndex => throw _privateConstructorUsedError;
  String get printerName => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  String? get ip => throw _privateConstructorUsedError;
  String? get port => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get regDate => throw _privateConstructorUsedError;

  /// Serializes this PrinterData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrinterData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrinterDataCopyWith<PrinterData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrinterDataCopyWith<$Res> {
  factory $PrinterDataCopyWith(
          PrinterData value, $Res Function(PrinterData) then) =
      _$PrinterDataCopyWithImpl<$Res, PrinterData>;
  @useResult
  $Res call(
      {int processingCompanyPrinterIndex,
      String printerName,
      String model,
      String? ip,
      String? port,
      String status,
      String regDate});
}

/// @nodoc
class _$PrinterDataCopyWithImpl<$Res, $Val extends PrinterData>
    implements $PrinterDataCopyWith<$Res> {
  _$PrinterDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrinterData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? processingCompanyPrinterIndex = null,
    Object? printerName = null,
    Object? model = null,
    Object? ip = freezed,
    Object? port = freezed,
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
      ip: freezed == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String?,
      port: freezed == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$PrinterDataImplCopyWith<$Res>
    implements $PrinterDataCopyWith<$Res> {
  factory _$$PrinterDataImplCopyWith(
          _$PrinterDataImpl value, $Res Function(_$PrinterDataImpl) then) =
      __$$PrinterDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int processingCompanyPrinterIndex,
      String printerName,
      String model,
      String? ip,
      String? port,
      String status,
      String regDate});
}

/// @nodoc
class __$$PrinterDataImplCopyWithImpl<$Res>
    extends _$PrinterDataCopyWithImpl<$Res, _$PrinterDataImpl>
    implements _$$PrinterDataImplCopyWith<$Res> {
  __$$PrinterDataImplCopyWithImpl(
      _$PrinterDataImpl _value, $Res Function(_$PrinterDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrinterData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? processingCompanyPrinterIndex = null,
    Object? printerName = null,
    Object? model = null,
    Object? ip = freezed,
    Object? port = freezed,
    Object? status = null,
    Object? regDate = null,
  }) {
    return _then(_$PrinterDataImpl(
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
      ip: freezed == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String?,
      port: freezed == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$PrinterDataImpl implements _PrinterData {
  const _$PrinterDataImpl(
      {required this.processingCompanyPrinterIndex,
      required this.printerName,
      required this.model,
      required this.ip,
      required this.port,
      required this.status,
      required this.regDate});

  factory _$PrinterDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrinterDataImplFromJson(json);

  @override
  final int processingCompanyPrinterIndex;
  @override
  final String printerName;
  @override
  final String model;
  @override
  final String? ip;
  @override
  final String? port;
  @override
  final String status;
  @override
  final String regDate;

  @override
  String toString() {
    return 'PrinterData(processingCompanyPrinterIndex: $processingCompanyPrinterIndex, printerName: $printerName, model: $model, ip: $ip, port: $port, status: $status, regDate: $regDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrinterDataImpl &&
            (identical(other.processingCompanyPrinterIndex,
                    processingCompanyPrinterIndex) ||
                other.processingCompanyPrinterIndex ==
                    processingCompanyPrinterIndex) &&
            (identical(other.printerName, printerName) ||
                other.printerName == printerName) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.ip, ip) || other.ip == ip) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.regDate, regDate) || other.regDate == regDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, processingCompanyPrinterIndex,
      printerName, model, ip, port, status, regDate);

  /// Create a copy of PrinterData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrinterDataImplCopyWith<_$PrinterDataImpl> get copyWith =>
      __$$PrinterDataImplCopyWithImpl<_$PrinterDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrinterDataImplToJson(
      this,
    );
  }
}

abstract class _PrinterData implements PrinterData {
  const factory _PrinterData(
      {required final int processingCompanyPrinterIndex,
      required final String printerName,
      required final String model,
      required final String? ip,
      required final String? port,
      required final String status,
      required final String regDate}) = _$PrinterDataImpl;

  factory _PrinterData.fromJson(Map<String, dynamic> json) =
      _$PrinterDataImpl.fromJson;

  @override
  int get processingCompanyPrinterIndex;
  @override
  String get printerName;
  @override
  String get model;
  @override
  String? get ip;
  @override
  String? get port;
  @override
  String get status;
  @override
  String get regDate;

  /// Create a copy of PrinterData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrinterDataImplCopyWith<_$PrinterDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
