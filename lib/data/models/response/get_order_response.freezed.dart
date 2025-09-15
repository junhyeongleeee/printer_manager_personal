// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_order_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetOrderResponse _$GetOrderResponseFromJson(Map<String, dynamic> json) {
  return _GetOrderResponse.fromJson(json);
}

/// @nodoc
mixin _$GetOrderResponse {
  String get status => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  GetOrderResponseData get data => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;

  /// Serializes this GetOrderResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetOrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetOrderResponseCopyWith<GetOrderResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetOrderResponseCopyWith<$Res> {
  factory $GetOrderResponseCopyWith(
          GetOrderResponse value, $Res Function(GetOrderResponse) then) =
      _$GetOrderResponseCopyWithImpl<$Res, GetOrderResponse>;
  @useResult
  $Res call(
      {String status,
      String message,
      GetOrderResponseData data,
      String timestamp});

  $GetOrderResponseDataCopyWith<$Res> get data;
}

/// @nodoc
class _$GetOrderResponseCopyWithImpl<$Res, $Val extends GetOrderResponse>
    implements $GetOrderResponseCopyWith<$Res> {
  _$GetOrderResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetOrderResponse
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
              as GetOrderResponseData,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of GetOrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GetOrderResponseDataCopyWith<$Res> get data {
    return $GetOrderResponseDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GetOrderResponseImplCopyWith<$Res>
    implements $GetOrderResponseCopyWith<$Res> {
  factory _$$GetOrderResponseImplCopyWith(_$GetOrderResponseImpl value,
          $Res Function(_$GetOrderResponseImpl) then) =
      __$$GetOrderResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String status,
      String message,
      GetOrderResponseData data,
      String timestamp});

  @override
  $GetOrderResponseDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$GetOrderResponseImplCopyWithImpl<$Res>
    extends _$GetOrderResponseCopyWithImpl<$Res, _$GetOrderResponseImpl>
    implements _$$GetOrderResponseImplCopyWith<$Res> {
  __$$GetOrderResponseImplCopyWithImpl(_$GetOrderResponseImpl _value,
      $Res Function(_$GetOrderResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetOrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
    Object? data = null,
    Object? timestamp = null,
  }) {
    return _then(_$GetOrderResponseImpl(
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
              as GetOrderResponseData,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetOrderResponseImpl implements _GetOrderResponse {
  const _$GetOrderResponseImpl(
      {required this.status,
      required this.message,
      required this.data,
      required this.timestamp});

  factory _$GetOrderResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetOrderResponseImplFromJson(json);

  @override
  final String status;
  @override
  final String message;
  @override
  final GetOrderResponseData data;
  @override
  final String timestamp;

  @override
  String toString() {
    return 'GetOrderResponse(status: $status, message: $message, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetOrderResponseImpl &&
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

  /// Create a copy of GetOrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetOrderResponseImplCopyWith<_$GetOrderResponseImpl> get copyWith =>
      __$$GetOrderResponseImplCopyWithImpl<_$GetOrderResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetOrderResponseImplToJson(
      this,
    );
  }
}

abstract class _GetOrderResponse implements GetOrderResponse {
  const factory _GetOrderResponse(
      {required final String status,
      required final String message,
      required final GetOrderResponseData data,
      required final String timestamp}) = _$GetOrderResponseImpl;

  factory _GetOrderResponse.fromJson(Map<String, dynamic> json) =
      _$GetOrderResponseImpl.fromJson;

  @override
  String get status;
  @override
  String get message;
  @override
  GetOrderResponseData get data;
  @override
  String get timestamp;

  /// Create a copy of GetOrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetOrderResponseImplCopyWith<_$GetOrderResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GetOrderResponseData _$GetOrderResponseDataFromJson(Map<String, dynamic> json) {
  return _GetOrderResponseData.fromJson(json);
}

/// @nodoc
mixin _$GetOrderResponseData {
  int get orderId => throw _privateConstructorUsedError;
  int get institutionId => throw _privateConstructorUsedError;
  String get institutionName => throw _privateConstructorUsedError;
  int get itemId => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get remainingQuantity => throw _privateConstructorUsedError;
  String get stock => throw _privateConstructorUsedError;
  String get uniqueCode => throw _privateConstructorUsedError;
  String get startCode => throw _privateConstructorUsedError;
  String get endCode => throw _privateConstructorUsedError;
  String get embeddingCode => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get regDate => throw _privateConstructorUsedError;

  /// Serializes this GetOrderResponseData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GetOrderResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetOrderResponseDataCopyWith<GetOrderResponseData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetOrderResponseDataCopyWith<$Res> {
  factory $GetOrderResponseDataCopyWith(GetOrderResponseData value,
          $Res Function(GetOrderResponseData) then) =
      _$GetOrderResponseDataCopyWithImpl<$Res, GetOrderResponseData>;
  @useResult
  $Res call(
      {int orderId,
      int institutionId,
      String institutionName,
      int itemId,
      String itemName,
      int quantity,
      int remainingQuantity,
      String stock,
      String uniqueCode,
      String startCode,
      String endCode,
      String embeddingCode,
      String status,
      String regDate});
}

/// @nodoc
class _$GetOrderResponseDataCopyWithImpl<$Res,
        $Val extends GetOrderResponseData>
    implements $GetOrderResponseDataCopyWith<$Res> {
  _$GetOrderResponseDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetOrderResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? institutionId = null,
    Object? institutionName = null,
    Object? itemId = null,
    Object? itemName = null,
    Object? quantity = null,
    Object? remainingQuantity = null,
    Object? stock = null,
    Object? uniqueCode = null,
    Object? startCode = null,
    Object? endCode = null,
    Object? embeddingCode = null,
    Object? status = null,
    Object? regDate = null,
  }) {
    return _then(_value.copyWith(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      institutionId: null == institutionId
          ? _value.institutionId
          : institutionId // ignore: cast_nullable_to_non_nullable
              as int,
      institutionName: null == institutionName
          ? _value.institutionName
          : institutionName // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as int,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      remainingQuantity: null == remainingQuantity
          ? _value.remainingQuantity
          : remainingQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as String,
      uniqueCode: null == uniqueCode
          ? _value.uniqueCode
          : uniqueCode // ignore: cast_nullable_to_non_nullable
              as String,
      startCode: null == startCode
          ? _value.startCode
          : startCode // ignore: cast_nullable_to_non_nullable
              as String,
      endCode: null == endCode
          ? _value.endCode
          : endCode // ignore: cast_nullable_to_non_nullable
              as String,
      embeddingCode: null == embeddingCode
          ? _value.embeddingCode
          : embeddingCode // ignore: cast_nullable_to_non_nullable
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
abstract class _$$GetOrderResponseDataImplCopyWith<$Res>
    implements $GetOrderResponseDataCopyWith<$Res> {
  factory _$$GetOrderResponseDataImplCopyWith(_$GetOrderResponseDataImpl value,
          $Res Function(_$GetOrderResponseDataImpl) then) =
      __$$GetOrderResponseDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int orderId,
      int institutionId,
      String institutionName,
      int itemId,
      String itemName,
      int quantity,
      int remainingQuantity,
      String stock,
      String uniqueCode,
      String startCode,
      String endCode,
      String embeddingCode,
      String status,
      String regDate});
}

/// @nodoc
class __$$GetOrderResponseDataImplCopyWithImpl<$Res>
    extends _$GetOrderResponseDataCopyWithImpl<$Res, _$GetOrderResponseDataImpl>
    implements _$$GetOrderResponseDataImplCopyWith<$Res> {
  __$$GetOrderResponseDataImplCopyWithImpl(_$GetOrderResponseDataImpl _value,
      $Res Function(_$GetOrderResponseDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetOrderResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? institutionId = null,
    Object? institutionName = null,
    Object? itemId = null,
    Object? itemName = null,
    Object? quantity = null,
    Object? remainingQuantity = null,
    Object? stock = null,
    Object? uniqueCode = null,
    Object? startCode = null,
    Object? endCode = null,
    Object? embeddingCode = null,
    Object? status = null,
    Object? regDate = null,
  }) {
    return _then(_$GetOrderResponseDataImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      institutionId: null == institutionId
          ? _value.institutionId
          : institutionId // ignore: cast_nullable_to_non_nullable
              as int,
      institutionName: null == institutionName
          ? _value.institutionName
          : institutionName // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as int,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      remainingQuantity: null == remainingQuantity
          ? _value.remainingQuantity
          : remainingQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as String,
      uniqueCode: null == uniqueCode
          ? _value.uniqueCode
          : uniqueCode // ignore: cast_nullable_to_non_nullable
              as String,
      startCode: null == startCode
          ? _value.startCode
          : startCode // ignore: cast_nullable_to_non_nullable
              as String,
      endCode: null == endCode
          ? _value.endCode
          : endCode // ignore: cast_nullable_to_non_nullable
              as String,
      embeddingCode: null == embeddingCode
          ? _value.embeddingCode
          : embeddingCode // ignore: cast_nullable_to_non_nullable
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
class _$GetOrderResponseDataImpl implements _GetOrderResponseData {
  const _$GetOrderResponseDataImpl(
      {required this.orderId,
      required this.institutionId,
      required this.institutionName,
      required this.itemId,
      required this.itemName,
      required this.quantity,
      required this.remainingQuantity,
      required this.stock,
      required this.uniqueCode,
      required this.startCode,
      required this.endCode,
      required this.embeddingCode,
      required this.status,
      required this.regDate});

  factory _$GetOrderResponseDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetOrderResponseDataImplFromJson(json);

  @override
  final int orderId;
  @override
  final int institutionId;
  @override
  final String institutionName;
  @override
  final int itemId;
  @override
  final String itemName;
  @override
  final int quantity;
  @override
  final int remainingQuantity;
  @override
  final String stock;
  @override
  final String uniqueCode;
  @override
  final String startCode;
  @override
  final String endCode;
  @override
  final String embeddingCode;
  @override
  final String status;
  @override
  final String regDate;

  @override
  String toString() {
    return 'GetOrderResponseData(orderId: $orderId, institutionId: $institutionId, institutionName: $institutionName, itemId: $itemId, itemName: $itemName, quantity: $quantity, remainingQuantity: $remainingQuantity, stock: $stock, uniqueCode: $uniqueCode, startCode: $startCode, endCode: $endCode, embeddingCode: $embeddingCode, status: $status, regDate: $regDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetOrderResponseDataImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.institutionId, institutionId) ||
                other.institutionId == institutionId) &&
            (identical(other.institutionName, institutionName) ||
                other.institutionName == institutionName) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.remainingQuantity, remainingQuantity) ||
                other.remainingQuantity == remainingQuantity) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.uniqueCode, uniqueCode) ||
                other.uniqueCode == uniqueCode) &&
            (identical(other.startCode, startCode) ||
                other.startCode == startCode) &&
            (identical(other.endCode, endCode) || other.endCode == endCode) &&
            (identical(other.embeddingCode, embeddingCode) ||
                other.embeddingCode == embeddingCode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.regDate, regDate) || other.regDate == regDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      orderId,
      institutionId,
      institutionName,
      itemId,
      itemName,
      quantity,
      remainingQuantity,
      stock,
      uniqueCode,
      startCode,
      endCode,
      embeddingCode,
      status,
      regDate);

  /// Create a copy of GetOrderResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetOrderResponseDataImplCopyWith<_$GetOrderResponseDataImpl>
      get copyWith =>
          __$$GetOrderResponseDataImplCopyWithImpl<_$GetOrderResponseDataImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetOrderResponseDataImplToJson(
      this,
    );
  }
}

abstract class _GetOrderResponseData implements GetOrderResponseData {
  const factory _GetOrderResponseData(
      {required final int orderId,
      required final int institutionId,
      required final String institutionName,
      required final int itemId,
      required final String itemName,
      required final int quantity,
      required final int remainingQuantity,
      required final String stock,
      required final String uniqueCode,
      required final String startCode,
      required final String endCode,
      required final String embeddingCode,
      required final String status,
      required final String regDate}) = _$GetOrderResponseDataImpl;

  factory _GetOrderResponseData.fromJson(Map<String, dynamic> json) =
      _$GetOrderResponseDataImpl.fromJson;

  @override
  int get orderId;
  @override
  int get institutionId;
  @override
  String get institutionName;
  @override
  int get itemId;
  @override
  String get itemName;
  @override
  int get quantity;
  @override
  int get remainingQuantity;
  @override
  String get stock;
  @override
  String get uniqueCode;
  @override
  String get startCode;
  @override
  String get endCode;
  @override
  String get embeddingCode;
  @override
  String get status;
  @override
  String get regDate;

  /// Create a copy of GetOrderResponseData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetOrderResponseDataImplCopyWith<_$GetOrderResponseDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
