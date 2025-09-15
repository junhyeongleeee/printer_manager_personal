// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warehouse_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WarehouseRequest _$WarehouseRequestFromJson(Map<String, dynamic> json) {
  return _WarehouseRequest.fromJson(json);
}

/// @nodoc
mixin _$WarehouseRequest {
  int get orderId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  /// Serializes this WarehouseRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WarehouseRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WarehouseRequestCopyWith<WarehouseRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WarehouseRequestCopyWith<$Res> {
  factory $WarehouseRequestCopyWith(
          WarehouseRequest value, $Res Function(WarehouseRequest) then) =
      _$WarehouseRequestCopyWithImpl<$Res, WarehouseRequest>;
  @useResult
  $Res call({int orderId, String name, String address, int quantity});
}

/// @nodoc
class _$WarehouseRequestCopyWithImpl<$Res, $Val extends WarehouseRequest>
    implements $WarehouseRequestCopyWith<$Res> {
  _$WarehouseRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WarehouseRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? name = null,
    Object? address = null,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WarehouseRequestImplCopyWith<$Res>
    implements $WarehouseRequestCopyWith<$Res> {
  factory _$$WarehouseRequestImplCopyWith(_$WarehouseRequestImpl value,
          $Res Function(_$WarehouseRequestImpl) then) =
      __$$WarehouseRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int orderId, String name, String address, int quantity});
}

/// @nodoc
class __$$WarehouseRequestImplCopyWithImpl<$Res>
    extends _$WarehouseRequestCopyWithImpl<$Res, _$WarehouseRequestImpl>
    implements _$$WarehouseRequestImplCopyWith<$Res> {
  __$$WarehouseRequestImplCopyWithImpl(_$WarehouseRequestImpl _value,
      $Res Function(_$WarehouseRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of WarehouseRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? name = null,
    Object? address = null,
    Object? quantity = null,
  }) {
    return _then(_$WarehouseRequestImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WarehouseRequestImpl implements _WarehouseRequest {
  const _$WarehouseRequestImpl(
      {required this.orderId,
      required this.name,
      required this.address,
      required this.quantity});

  factory _$WarehouseRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$WarehouseRequestImplFromJson(json);

  @override
  final int orderId;
  @override
  final String name;
  @override
  final String address;
  @override
  final int quantity;

  @override
  String toString() {
    return 'WarehouseRequest(orderId: $orderId, name: $name, address: $address, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WarehouseRequestImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, orderId, name, address, quantity);

  /// Create a copy of WarehouseRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WarehouseRequestImplCopyWith<_$WarehouseRequestImpl> get copyWith =>
      __$$WarehouseRequestImplCopyWithImpl<_$WarehouseRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WarehouseRequestImplToJson(
      this,
    );
  }
}

abstract class _WarehouseRequest implements WarehouseRequest {
  const factory _WarehouseRequest(
      {required final int orderId,
      required final String name,
      required final String address,
      required final int quantity}) = _$WarehouseRequestImpl;

  factory _WarehouseRequest.fromJson(Map<String, dynamic> json) =
      _$WarehouseRequestImpl.fromJson;

  @override
  int get orderId;
  @override
  String get name;
  @override
  String get address;
  @override
  int get quantity;

  /// Create a copy of WarehouseRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WarehouseRequestImplCopyWith<_$WarehouseRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
