// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) {
  return _OrderResponse.fromJson(json);
}

/// @nodoc
mixin _$OrderResponse {
  String get status => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  OrderResponseDataWrapper get data => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;

  /// Serializes this OrderResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderResponseCopyWith<OrderResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderResponseCopyWith<$Res> {
  factory $OrderResponseCopyWith(
          OrderResponse value, $Res Function(OrderResponse) then) =
      _$OrderResponseCopyWithImpl<$Res, OrderResponse>;
  @useResult
  $Res call(
      {String status,
      String message,
      OrderResponseDataWrapper data,
      String timestamp});

  $OrderResponseDataWrapperCopyWith<$Res> get data;
}

/// @nodoc
class _$OrderResponseCopyWithImpl<$Res, $Val extends OrderResponse>
    implements $OrderResponseCopyWith<$Res> {
  _$OrderResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderResponse
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
              as OrderResponseDataWrapper,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of OrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderResponseDataWrapperCopyWith<$Res> get data {
    return $OrderResponseDataWrapperCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderResponseImplCopyWith<$Res>
    implements $OrderResponseCopyWith<$Res> {
  factory _$$OrderResponseImplCopyWith(
          _$OrderResponseImpl value, $Res Function(_$OrderResponseImpl) then) =
      __$$OrderResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String status,
      String message,
      OrderResponseDataWrapper data,
      String timestamp});

  @override
  $OrderResponseDataWrapperCopyWith<$Res> get data;
}

/// @nodoc
class __$$OrderResponseImplCopyWithImpl<$Res>
    extends _$OrderResponseCopyWithImpl<$Res, _$OrderResponseImpl>
    implements _$$OrderResponseImplCopyWith<$Res> {
  __$$OrderResponseImplCopyWithImpl(
      _$OrderResponseImpl _value, $Res Function(_$OrderResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
    Object? data = null,
    Object? timestamp = null,
  }) {
    return _then(_$OrderResponseImpl(
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
              as OrderResponseDataWrapper,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderResponseImpl implements _OrderResponse {
  const _$OrderResponseImpl(
      {required this.status,
      required this.message,
      required this.data,
      required this.timestamp});

  factory _$OrderResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderResponseImplFromJson(json);

  @override
  final String status;
  @override
  final String message;
  @override
  final OrderResponseDataWrapper data;
  @override
  final String timestamp;

  @override
  String toString() {
    return 'OrderResponse(status: $status, message: $message, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderResponseImpl &&
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

  /// Create a copy of OrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderResponseImplCopyWith<_$OrderResponseImpl> get copyWith =>
      __$$OrderResponseImplCopyWithImpl<_$OrderResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderResponseImplToJson(
      this,
    );
  }
}

abstract class _OrderResponse implements OrderResponse {
  const factory _OrderResponse(
      {required final String status,
      required final String message,
      required final OrderResponseDataWrapper data,
      required final String timestamp}) = _$OrderResponseImpl;

  factory _OrderResponse.fromJson(Map<String, dynamic> json) =
      _$OrderResponseImpl.fromJson;

  @override
  String get status;
  @override
  String get message;
  @override
  OrderResponseDataWrapper get data;
  @override
  String get timestamp;

  /// Create a copy of OrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderResponseImplCopyWith<_$OrderResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderResponseDataWrapper _$OrderResponseDataWrapperFromJson(
    Map<String, dynamic> json) {
  return _OrderResponseDataWrapper.fromJson(json);
}

/// @nodoc
mixin _$OrderResponseDataWrapper {
  int get orderCount => throw _privateConstructorUsedError;
  List<OrderResponseData> get orderList => throw _privateConstructorUsedError;

  /// Serializes this OrderResponseDataWrapper to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderResponseDataWrapper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderResponseDataWrapperCopyWith<OrderResponseDataWrapper> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderResponseDataWrapperCopyWith<$Res> {
  factory $OrderResponseDataWrapperCopyWith(OrderResponseDataWrapper value,
          $Res Function(OrderResponseDataWrapper) then) =
      _$OrderResponseDataWrapperCopyWithImpl<$Res, OrderResponseDataWrapper>;
  @useResult
  $Res call({int orderCount, List<OrderResponseData> orderList});
}

/// @nodoc
class _$OrderResponseDataWrapperCopyWithImpl<$Res,
        $Val extends OrderResponseDataWrapper>
    implements $OrderResponseDataWrapperCopyWith<$Res> {
  _$OrderResponseDataWrapperCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderResponseDataWrapper
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderCount = null,
    Object? orderList = null,
  }) {
    return _then(_value.copyWith(
      orderCount: null == orderCount
          ? _value.orderCount
          : orderCount // ignore: cast_nullable_to_non_nullable
              as int,
      orderList: null == orderList
          ? _value.orderList
          : orderList // ignore: cast_nullable_to_non_nullable
              as List<OrderResponseData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderResponseDataWrapperImplCopyWith<$Res>
    implements $OrderResponseDataWrapperCopyWith<$Res> {
  factory _$$OrderResponseDataWrapperImplCopyWith(
          _$OrderResponseDataWrapperImpl value,
          $Res Function(_$OrderResponseDataWrapperImpl) then) =
      __$$OrderResponseDataWrapperImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int orderCount, List<OrderResponseData> orderList});
}

/// @nodoc
class __$$OrderResponseDataWrapperImplCopyWithImpl<$Res>
    extends _$OrderResponseDataWrapperCopyWithImpl<$Res,
        _$OrderResponseDataWrapperImpl>
    implements _$$OrderResponseDataWrapperImplCopyWith<$Res> {
  __$$OrderResponseDataWrapperImplCopyWithImpl(
      _$OrderResponseDataWrapperImpl _value,
      $Res Function(_$OrderResponseDataWrapperImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderResponseDataWrapper
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderCount = null,
    Object? orderList = null,
  }) {
    return _then(_$OrderResponseDataWrapperImpl(
      orderCount: null == orderCount
          ? _value.orderCount
          : orderCount // ignore: cast_nullable_to_non_nullable
              as int,
      orderList: null == orderList
          ? _value._orderList
          : orderList // ignore: cast_nullable_to_non_nullable
              as List<OrderResponseData>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderResponseDataWrapperImpl implements _OrderResponseDataWrapper {
  const _$OrderResponseDataWrapperImpl(
      {required this.orderCount,
      required final List<OrderResponseData> orderList})
      : _orderList = orderList;

  factory _$OrderResponseDataWrapperImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderResponseDataWrapperImplFromJson(json);

  @override
  final int orderCount;
  final List<OrderResponseData> _orderList;
  @override
  List<OrderResponseData> get orderList {
    if (_orderList is EqualUnmodifiableListView) return _orderList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderList);
  }

  @override
  String toString() {
    return 'OrderResponseDataWrapper(orderCount: $orderCount, orderList: $orderList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderResponseDataWrapperImpl &&
            (identical(other.orderCount, orderCount) ||
                other.orderCount == orderCount) &&
            const DeepCollectionEquality()
                .equals(other._orderList, _orderList));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, orderCount, const DeepCollectionEquality().hash(_orderList));

  /// Create a copy of OrderResponseDataWrapper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderResponseDataWrapperImplCopyWith<_$OrderResponseDataWrapperImpl>
      get copyWith => __$$OrderResponseDataWrapperImplCopyWithImpl<
          _$OrderResponseDataWrapperImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderResponseDataWrapperImplToJson(
      this,
    );
  }
}

abstract class _OrderResponseDataWrapper implements OrderResponseDataWrapper {
  const factory _OrderResponseDataWrapper(
          {required final int orderCount,
          required final List<OrderResponseData> orderList}) =
      _$OrderResponseDataWrapperImpl;

  factory _OrderResponseDataWrapper.fromJson(Map<String, dynamic> json) =
      _$OrderResponseDataWrapperImpl.fromJson;

  @override
  int get orderCount;
  @override
  List<OrderResponseData> get orderList;

  /// Create a copy of OrderResponseDataWrapper
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderResponseDataWrapperImplCopyWith<_$OrderResponseDataWrapperImpl>
      get copyWith => throw _privateConstructorUsedError;
}

OrderResponseData _$OrderResponseDataFromJson(Map<String, dynamic> json) {
  return _OrderResponseData.fromJson(json);
}

/// @nodoc
mixin _$OrderResponseData {
  int get orderId => throw _privateConstructorUsedError;
  int get institutionId => throw _privateConstructorUsedError;
  String get institutionName => throw _privateConstructorUsedError;
  int get itemId => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get remainingQuantity => throw _privateConstructorUsedError;
  int get stock => throw _privateConstructorUsedError;
  String get uniqueCode => throw _privateConstructorUsedError;
  String get startCode => throw _privateConstructorUsedError;
  String get endCode => throw _privateConstructorUsedError;
  String get embeddingCode => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get regDate => throw _privateConstructorUsedError;

  /// Serializes this OrderResponseData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderResponseDataCopyWith<OrderResponseData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderResponseDataCopyWith<$Res> {
  factory $OrderResponseDataCopyWith(
          OrderResponseData value, $Res Function(OrderResponseData) then) =
      _$OrderResponseDataCopyWithImpl<$Res, OrderResponseData>;
  @useResult
  $Res call(
      {int orderId,
      int institutionId,
      String institutionName,
      int itemId,
      String itemName,
      int quantity,
      int remainingQuantity,
      int stock,
      String uniqueCode,
      String startCode,
      String endCode,
      String embeddingCode,
      String status,
      String regDate});
}

/// @nodoc
class _$OrderResponseDataCopyWithImpl<$Res, $Val extends OrderResponseData>
    implements $OrderResponseDataCopyWith<$Res> {
  _$OrderResponseDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderResponseData
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
              as int,
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
abstract class _$$OrderResponseDataImplCopyWith<$Res>
    implements $OrderResponseDataCopyWith<$Res> {
  factory _$$OrderResponseDataImplCopyWith(_$OrderResponseDataImpl value,
          $Res Function(_$OrderResponseDataImpl) then) =
      __$$OrderResponseDataImplCopyWithImpl<$Res>;
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
      int stock,
      String uniqueCode,
      String startCode,
      String endCode,
      String embeddingCode,
      String status,
      String regDate});
}

/// @nodoc
class __$$OrderResponseDataImplCopyWithImpl<$Res>
    extends _$OrderResponseDataCopyWithImpl<$Res, _$OrderResponseDataImpl>
    implements _$$OrderResponseDataImplCopyWith<$Res> {
  __$$OrderResponseDataImplCopyWithImpl(_$OrderResponseDataImpl _value,
      $Res Function(_$OrderResponseDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderResponseData
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
    return _then(_$OrderResponseDataImpl(
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
              as int,
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
class _$OrderResponseDataImpl implements _OrderResponseData {
  const _$OrderResponseDataImpl(
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

  factory _$OrderResponseDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderResponseDataImplFromJson(json);

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
  final int stock;
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
    return 'OrderResponseData(orderId: $orderId, institutionId: $institutionId, institutionName: $institutionName, itemId: $itemId, itemName: $itemName, quantity: $quantity, remainingQuantity: $remainingQuantity, stock: $stock, uniqueCode: $uniqueCode, startCode: $startCode, endCode: $endCode, embeddingCode: $embeddingCode, status: $status, regDate: $regDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderResponseDataImpl &&
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

  /// Create a copy of OrderResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderResponseDataImplCopyWith<_$OrderResponseDataImpl> get copyWith =>
      __$$OrderResponseDataImplCopyWithImpl<_$OrderResponseDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderResponseDataImplToJson(
      this,
    );
  }
}

abstract class _OrderResponseData implements OrderResponseData {
  const factory _OrderResponseData(
      {required final int orderId,
      required final int institutionId,
      required final String institutionName,
      required final int itemId,
      required final String itemName,
      required final int quantity,
      required final int remainingQuantity,
      required final int stock,
      required final String uniqueCode,
      required final String startCode,
      required final String endCode,
      required final String embeddingCode,
      required final String status,
      required final String regDate}) = _$OrderResponseDataImpl;

  factory _OrderResponseData.fromJson(Map<String, dynamic> json) =
      _$OrderResponseDataImpl.fromJson;

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
  int get stock;
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

  /// Create a copy of OrderResponseData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderResponseDataImplCopyWith<_$OrderResponseDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
