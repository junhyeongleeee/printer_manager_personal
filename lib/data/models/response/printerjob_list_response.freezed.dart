// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'printerjob_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PrinterjobListResponse _$PrinterjobListResponseFromJson(
    Map<String, dynamic> json) {
  return _PrinterjobListResponse.fromJson(json);
}

/// @nodoc
mixin _$PrinterjobListResponse {
  String get status => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  PrinterjobListResponseData get data => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;

  /// Serializes this PrinterjobListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrinterjobListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrinterjobListResponseCopyWith<PrinterjobListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrinterjobListResponseCopyWith<$Res> {
  factory $PrinterjobListResponseCopyWith(PrinterjobListResponse value,
          $Res Function(PrinterjobListResponse) then) =
      _$PrinterjobListResponseCopyWithImpl<$Res, PrinterjobListResponse>;
  @useResult
  $Res call(
      {String status,
      String message,
      PrinterjobListResponseData data,
      String timestamp});

  $PrinterjobListResponseDataCopyWith<$Res> get data;
}

/// @nodoc
class _$PrinterjobListResponseCopyWithImpl<$Res,
        $Val extends PrinterjobListResponse>
    implements $PrinterjobListResponseCopyWith<$Res> {
  _$PrinterjobListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrinterjobListResponse
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
              as PrinterjobListResponseData,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of PrinterjobListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PrinterjobListResponseDataCopyWith<$Res> get data {
    return $PrinterjobListResponseDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PrinterjobListResponseImplCopyWith<$Res>
    implements $PrinterjobListResponseCopyWith<$Res> {
  factory _$$PrinterjobListResponseImplCopyWith(
          _$PrinterjobListResponseImpl value,
          $Res Function(_$PrinterjobListResponseImpl) then) =
      __$$PrinterjobListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String status,
      String message,
      PrinterjobListResponseData data,
      String timestamp});

  @override
  $PrinterjobListResponseDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$PrinterjobListResponseImplCopyWithImpl<$Res>
    extends _$PrinterjobListResponseCopyWithImpl<$Res,
        _$PrinterjobListResponseImpl>
    implements _$$PrinterjobListResponseImplCopyWith<$Res> {
  __$$PrinterjobListResponseImplCopyWithImpl(
      _$PrinterjobListResponseImpl _value,
      $Res Function(_$PrinterjobListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrinterjobListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
    Object? data = null,
    Object? timestamp = null,
  }) {
    return _then(_$PrinterjobListResponseImpl(
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
              as PrinterjobListResponseData,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrinterjobListResponseImpl implements _PrinterjobListResponse {
  const _$PrinterjobListResponseImpl(
      {required this.status,
      required this.message,
      required this.data,
      required this.timestamp});

  factory _$PrinterjobListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrinterjobListResponseImplFromJson(json);

  @override
  final String status;
  @override
  final String message;
  @override
  final PrinterjobListResponseData data;
  @override
  final String timestamp;

  @override
  String toString() {
    return 'PrinterjobListResponse(status: $status, message: $message, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrinterjobListResponseImpl &&
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

  /// Create a copy of PrinterjobListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrinterjobListResponseImplCopyWith<_$PrinterjobListResponseImpl>
      get copyWith => __$$PrinterjobListResponseImplCopyWithImpl<
          _$PrinterjobListResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrinterjobListResponseImplToJson(
      this,
    );
  }
}

abstract class _PrinterjobListResponse implements PrinterjobListResponse {
  const factory _PrinterjobListResponse(
      {required final String status,
      required final String message,
      required final PrinterjobListResponseData data,
      required final String timestamp}) = _$PrinterjobListResponseImpl;

  factory _PrinterjobListResponse.fromJson(Map<String, dynamic> json) =
      _$PrinterjobListResponseImpl.fromJson;

  @override
  String get status;
  @override
  String get message;
  @override
  PrinterjobListResponseData get data;
  @override
  String get timestamp;

  /// Create a copy of PrinterjobListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrinterjobListResponseImplCopyWith<_$PrinterjobListResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PrinterjobListResponseData _$PrinterjobListResponseDataFromJson(
    Map<String, dynamic> json) {
  return _PrinterjobListResponseData.fromJson(json);
}

/// @nodoc
mixin _$PrinterjobListResponseData {
  List<PrintJob> get printJobList => throw _privateConstructorUsedError;

  /// Serializes this PrinterjobListResponseData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrinterjobListResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrinterjobListResponseDataCopyWith<PrinterjobListResponseData>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrinterjobListResponseDataCopyWith<$Res> {
  factory $PrinterjobListResponseDataCopyWith(PrinterjobListResponseData value,
          $Res Function(PrinterjobListResponseData) then) =
      _$PrinterjobListResponseDataCopyWithImpl<$Res,
          PrinterjobListResponseData>;
  @useResult
  $Res call({List<PrintJob> printJobList});
}

/// @nodoc
class _$PrinterjobListResponseDataCopyWithImpl<$Res,
        $Val extends PrinterjobListResponseData>
    implements $PrinterjobListResponseDataCopyWith<$Res> {
  _$PrinterjobListResponseDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrinterjobListResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? printJobList = null,
  }) {
    return _then(_value.copyWith(
      printJobList: null == printJobList
          ? _value.printJobList
          : printJobList // ignore: cast_nullable_to_non_nullable
              as List<PrintJob>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrinterjobListResponseDataImplCopyWith<$Res>
    implements $PrinterjobListResponseDataCopyWith<$Res> {
  factory _$$PrinterjobListResponseDataImplCopyWith(
          _$PrinterjobListResponseDataImpl value,
          $Res Function(_$PrinterjobListResponseDataImpl) then) =
      __$$PrinterjobListResponseDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<PrintJob> printJobList});
}

/// @nodoc
class __$$PrinterjobListResponseDataImplCopyWithImpl<$Res>
    extends _$PrinterjobListResponseDataCopyWithImpl<$Res,
        _$PrinterjobListResponseDataImpl>
    implements _$$PrinterjobListResponseDataImplCopyWith<$Res> {
  __$$PrinterjobListResponseDataImplCopyWithImpl(
      _$PrinterjobListResponseDataImpl _value,
      $Res Function(_$PrinterjobListResponseDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrinterjobListResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? printJobList = null,
  }) {
    return _then(_$PrinterjobListResponseDataImpl(
      printJobList: null == printJobList
          ? _value._printJobList
          : printJobList // ignore: cast_nullable_to_non_nullable
              as List<PrintJob>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrinterjobListResponseDataImpl implements _PrinterjobListResponseData {
  const _$PrinterjobListResponseDataImpl(
      {required final List<PrintJob> printJobList})
      : _printJobList = printJobList;

  factory _$PrinterjobListResponseDataImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$PrinterjobListResponseDataImplFromJson(json);

  final List<PrintJob> _printJobList;
  @override
  List<PrintJob> get printJobList {
    if (_printJobList is EqualUnmodifiableListView) return _printJobList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_printJobList);
  }

  @override
  String toString() {
    return 'PrinterjobListResponseData(printJobList: $printJobList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrinterjobListResponseDataImpl &&
            const DeepCollectionEquality()
                .equals(other._printJobList, _printJobList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_printJobList));

  /// Create a copy of PrinterjobListResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrinterjobListResponseDataImplCopyWith<_$PrinterjobListResponseDataImpl>
      get copyWith => __$$PrinterjobListResponseDataImplCopyWithImpl<
          _$PrinterjobListResponseDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrinterjobListResponseDataImplToJson(
      this,
    );
  }
}

abstract class _PrinterjobListResponseData
    implements PrinterjobListResponseData {
  const factory _PrinterjobListResponseData(
          {required final List<PrintJob> printJobList}) =
      _$PrinterjobListResponseDataImpl;

  factory _PrinterjobListResponseData.fromJson(Map<String, dynamic> json) =
      _$PrinterjobListResponseDataImpl.fromJson;

  @override
  List<PrintJob> get printJobList;

  /// Create a copy of PrinterjobListResponseData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrinterjobListResponseDataImplCopyWith<_$PrinterjobListResponseDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PrintJob _$PrintJobFromJson(Map<String, dynamic> json) {
  return _PrintJob.fromJson(json);
}

/// @nodoc
mixin _$PrintJob {
  int get orderPrintJobId => throw _privateConstructorUsedError;
  int get processingCompanyPrinterId => throw _privateConstructorUsedError;
  int get orderId => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String? get startedAt => throw _privateConstructorUsedError;
  String? get completedAt => throw _privateConstructorUsedError;
  String get regDate => throw _privateConstructorUsedError;

  /// Serializes this PrintJob to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrintJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrintJobCopyWith<PrintJob> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrintJobCopyWith<$Res> {
  factory $PrintJobCopyWith(PrintJob value, $Res Function(PrintJob) then) =
      _$PrintJobCopyWithImpl<$Res, PrintJob>;
  @useResult
  $Res call(
      {int orderPrintJobId,
      int processingCompanyPrinterId,
      int orderId,
      String itemName,
      String status,
      int quantity,
      String? startedAt,
      String? completedAt,
      String regDate});
}

/// @nodoc
class _$PrintJobCopyWithImpl<$Res, $Val extends PrintJob>
    implements $PrintJobCopyWith<$Res> {
  _$PrintJobCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrintJob
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderPrintJobId = null,
    Object? processingCompanyPrinterId = null,
    Object? orderId = null,
    Object? itemName = null,
    Object? status = null,
    Object? quantity = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? regDate = null,
  }) {
    return _then(_value.copyWith(
      orderPrintJobId: null == orderPrintJobId
          ? _value.orderPrintJobId
          : orderPrintJobId // ignore: cast_nullable_to_non_nullable
              as int,
      processingCompanyPrinterId: null == processingCompanyPrinterId
          ? _value.processingCompanyPrinterId
          : processingCompanyPrinterId // ignore: cast_nullable_to_non_nullable
              as int,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      regDate: null == regDate
          ? _value.regDate
          : regDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrintJobImplCopyWith<$Res>
    implements $PrintJobCopyWith<$Res> {
  factory _$$PrintJobImplCopyWith(
          _$PrintJobImpl value, $Res Function(_$PrintJobImpl) then) =
      __$$PrintJobImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int orderPrintJobId,
      int processingCompanyPrinterId,
      int orderId,
      String itemName,
      String status,
      int quantity,
      String? startedAt,
      String? completedAt,
      String regDate});
}

/// @nodoc
class __$$PrintJobImplCopyWithImpl<$Res>
    extends _$PrintJobCopyWithImpl<$Res, _$PrintJobImpl>
    implements _$$PrintJobImplCopyWith<$Res> {
  __$$PrintJobImplCopyWithImpl(
      _$PrintJobImpl _value, $Res Function(_$PrintJobImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrintJob
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderPrintJobId = null,
    Object? processingCompanyPrinterId = null,
    Object? orderId = null,
    Object? itemName = null,
    Object? status = null,
    Object? quantity = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? regDate = null,
  }) {
    return _then(_$PrintJobImpl(
      orderPrintJobId: null == orderPrintJobId
          ? _value.orderPrintJobId
          : orderPrintJobId // ignore: cast_nullable_to_non_nullable
              as int,
      processingCompanyPrinterId: null == processingCompanyPrinterId
          ? _value.processingCompanyPrinterId
          : processingCompanyPrinterId // ignore: cast_nullable_to_non_nullable
              as int,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      regDate: null == regDate
          ? _value.regDate
          : regDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrintJobImpl implements _PrintJob {
  const _$PrintJobImpl(
      {required this.orderPrintJobId,
      required this.processingCompanyPrinterId,
      required this.orderId,
      required this.itemName,
      required this.status,
      required this.quantity,
      required this.startedAt,
      required this.completedAt,
      required this.regDate});

  factory _$PrintJobImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrintJobImplFromJson(json);

  @override
  final int orderPrintJobId;
  @override
  final int processingCompanyPrinterId;
  @override
  final int orderId;
  @override
  final String itemName;
  @override
  final String status;
  @override
  final int quantity;
  @override
  final String? startedAt;
  @override
  final String? completedAt;
  @override
  final String regDate;

  @override
  String toString() {
    return 'PrintJob(orderPrintJobId: $orderPrintJobId, processingCompanyPrinterId: $processingCompanyPrinterId, orderId: $orderId, itemName: $itemName, status: $status, quantity: $quantity, startedAt: $startedAt, completedAt: $completedAt, regDate: $regDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrintJobImpl &&
            (identical(other.orderPrintJobId, orderPrintJobId) ||
                other.orderPrintJobId == orderPrintJobId) &&
            (identical(other.processingCompanyPrinterId,
                    processingCompanyPrinterId) ||
                other.processingCompanyPrinterId ==
                    processingCompanyPrinterId) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.regDate, regDate) || other.regDate == regDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      orderPrintJobId,
      processingCompanyPrinterId,
      orderId,
      itemName,
      status,
      quantity,
      startedAt,
      completedAt,
      regDate);

  /// Create a copy of PrintJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrintJobImplCopyWith<_$PrintJobImpl> get copyWith =>
      __$$PrintJobImplCopyWithImpl<_$PrintJobImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrintJobImplToJson(
      this,
    );
  }
}

abstract class _PrintJob implements PrintJob {
  const factory _PrintJob(
      {required final int orderPrintJobId,
      required final int processingCompanyPrinterId,
      required final int orderId,
      required final String itemName,
      required final String status,
      required final int quantity,
      required final String? startedAt,
      required final String? completedAt,
      required final String regDate}) = _$PrintJobImpl;

  factory _PrintJob.fromJson(Map<String, dynamic> json) =
      _$PrintJobImpl.fromJson;

  @override
  int get orderPrintJobId;
  @override
  int get processingCompanyPrinterId;
  @override
  int get orderId;
  @override
  String get itemName;
  @override
  String get status;
  @override
  int get quantity;
  @override
  String? get startedAt;
  @override
  String? get completedAt;
  @override
  String get regDate;

  /// Create a copy of PrintJob
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrintJobImplCopyWith<_$PrintJobImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
