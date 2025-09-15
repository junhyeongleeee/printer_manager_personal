// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patch_order_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PatchOrderRequest _$PatchOrderRequestFromJson(Map<String, dynamic> json) {
  return _PatchOrderRequest.fromJson(json);
}

/// @nodoc
mixin _$PatchOrderRequest {
  String get status => throw _privateConstructorUsedError;

  /// Serializes this PatchOrderRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PatchOrderRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PatchOrderRequestCopyWith<PatchOrderRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PatchOrderRequestCopyWith<$Res> {
  factory $PatchOrderRequestCopyWith(
          PatchOrderRequest value, $Res Function(PatchOrderRequest) then) =
      _$PatchOrderRequestCopyWithImpl<$Res, PatchOrderRequest>;
  @useResult
  $Res call({String status});
}

/// @nodoc
class _$PatchOrderRequestCopyWithImpl<$Res, $Val extends PatchOrderRequest>
    implements $PatchOrderRequestCopyWith<$Res> {
  _$PatchOrderRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PatchOrderRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PatchOrderRequestImplCopyWith<$Res>
    implements $PatchOrderRequestCopyWith<$Res> {
  factory _$$PatchOrderRequestImplCopyWith(_$PatchOrderRequestImpl value,
          $Res Function(_$PatchOrderRequestImpl) then) =
      __$$PatchOrderRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status});
}

/// @nodoc
class __$$PatchOrderRequestImplCopyWithImpl<$Res>
    extends _$PatchOrderRequestCopyWithImpl<$Res, _$PatchOrderRequestImpl>
    implements _$$PatchOrderRequestImplCopyWith<$Res> {
  __$$PatchOrderRequestImplCopyWithImpl(_$PatchOrderRequestImpl _value,
      $Res Function(_$PatchOrderRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of PatchOrderRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_$PatchOrderRequestImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PatchOrderRequestImpl implements _PatchOrderRequest {
  const _$PatchOrderRequestImpl({required this.status});

  factory _$PatchOrderRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PatchOrderRequestImplFromJson(json);

  @override
  final String status;

  @override
  String toString() {
    return 'PatchOrderRequest(status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PatchOrderRequestImpl &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status);

  /// Create a copy of PatchOrderRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PatchOrderRequestImplCopyWith<_$PatchOrderRequestImpl> get copyWith =>
      __$$PatchOrderRequestImplCopyWithImpl<_$PatchOrderRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PatchOrderRequestImplToJson(
      this,
    );
  }
}

abstract class _PatchOrderRequest implements PatchOrderRequest {
  const factory _PatchOrderRequest({required final String status}) =
      _$PatchOrderRequestImpl;

  factory _PatchOrderRequest.fromJson(Map<String, dynamic> json) =
      _$PatchOrderRequestImpl.fromJson;

  @override
  String get status;

  /// Create a copy of PatchOrderRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PatchOrderRequestImplCopyWith<_$PatchOrderRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
