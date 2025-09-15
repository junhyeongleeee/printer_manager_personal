// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'printerjob_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PrinterjobRequest _$PrinterjobRequestFromJson(Map<String, dynamic> json) {
  return _PrinterjobRequest.fromJson(json);
}

/// @nodoc
mixin _$PrinterjobRequest {
  int get orderId => throw _privateConstructorUsedError;
  int get processingCompanyPrinterId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  /// Serializes this PrinterjobRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrinterjobRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrinterjobRequestCopyWith<PrinterjobRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrinterjobRequestCopyWith<$Res> {
  factory $PrinterjobRequestCopyWith(
          PrinterjobRequest value, $Res Function(PrinterjobRequest) then) =
      _$PrinterjobRequestCopyWithImpl<$Res, PrinterjobRequest>;
  @useResult
  $Res call({int orderId, int processingCompanyPrinterId, int quantity});
}

/// @nodoc
class _$PrinterjobRequestCopyWithImpl<$Res, $Val extends PrinterjobRequest>
    implements $PrinterjobRequestCopyWith<$Res> {
  _$PrinterjobRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrinterjobRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? processingCompanyPrinterId = null,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      processingCompanyPrinterId: null == processingCompanyPrinterId
          ? _value.processingCompanyPrinterId
          : processingCompanyPrinterId // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrinterjobRequestImplCopyWith<$Res>
    implements $PrinterjobRequestCopyWith<$Res> {
  factory _$$PrinterjobRequestImplCopyWith(_$PrinterjobRequestImpl value,
          $Res Function(_$PrinterjobRequestImpl) then) =
      __$$PrinterjobRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int orderId, int processingCompanyPrinterId, int quantity});
}

/// @nodoc
class __$$PrinterjobRequestImplCopyWithImpl<$Res>
    extends _$PrinterjobRequestCopyWithImpl<$Res, _$PrinterjobRequestImpl>
    implements _$$PrinterjobRequestImplCopyWith<$Res> {
  __$$PrinterjobRequestImplCopyWithImpl(_$PrinterjobRequestImpl _value,
      $Res Function(_$PrinterjobRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrinterjobRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? processingCompanyPrinterId = null,
    Object? quantity = null,
  }) {
    return _then(_$PrinterjobRequestImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      processingCompanyPrinterId: null == processingCompanyPrinterId
          ? _value.processingCompanyPrinterId
          : processingCompanyPrinterId // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrinterjobRequestImpl implements _PrinterjobRequest {
  const _$PrinterjobRequestImpl(
      {required this.orderId,
      required this.processingCompanyPrinterId,
      required this.quantity});

  factory _$PrinterjobRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrinterjobRequestImplFromJson(json);

  @override
  final int orderId;
  @override
  final int processingCompanyPrinterId;
  @override
  final int quantity;

  @override
  String toString() {
    return 'PrinterjobRequest(orderId: $orderId, processingCompanyPrinterId: $processingCompanyPrinterId, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrinterjobRequestImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.processingCompanyPrinterId,
                    processingCompanyPrinterId) ||
                other.processingCompanyPrinterId ==
                    processingCompanyPrinterId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, orderId, processingCompanyPrinterId, quantity);

  /// Create a copy of PrinterjobRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrinterjobRequestImplCopyWith<_$PrinterjobRequestImpl> get copyWith =>
      __$$PrinterjobRequestImplCopyWithImpl<_$PrinterjobRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrinterjobRequestImplToJson(
      this,
    );
  }
}

abstract class _PrinterjobRequest implements PrinterjobRequest {
  const factory _PrinterjobRequest(
      {required final int orderId,
      required final int processingCompanyPrinterId,
      required final int quantity}) = _$PrinterjobRequestImpl;

  factory _PrinterjobRequest.fromJson(Map<String, dynamic> json) =
      _$PrinterjobRequestImpl.fromJson;

  @override
  int get orderId;
  @override
  int get processingCompanyPrinterId;
  @override
  int get quantity;

  /// Create a copy of PrinterjobRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrinterjobRequestImplCopyWith<_$PrinterjobRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
