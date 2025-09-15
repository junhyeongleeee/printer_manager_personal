// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patch_order_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PatchOrderResponse _$PatchOrderResponseFromJson(Map<String, dynamic> json) {
  return _PatchOrderResponse.fromJson(json);
}

/// @nodoc
mixin _$PatchOrderResponse {
  String get status => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;

  /// Serializes this PatchOrderResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PatchOrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PatchOrderResponseCopyWith<PatchOrderResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PatchOrderResponseCopyWith<$Res> {
  factory $PatchOrderResponseCopyWith(
          PatchOrderResponse value, $Res Function(PatchOrderResponse) then) =
      _$PatchOrderResponseCopyWithImpl<$Res, PatchOrderResponse>;
  @useResult
  $Res call({String status, String message, String timestamp});
}

/// @nodoc
class _$PatchOrderResponseCopyWithImpl<$Res, $Val extends PatchOrderResponse>
    implements $PatchOrderResponseCopyWith<$Res> {
  _$PatchOrderResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PatchOrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
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
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PatchOrderResponseImplCopyWith<$Res>
    implements $PatchOrderResponseCopyWith<$Res> {
  factory _$$PatchOrderResponseImplCopyWith(_$PatchOrderResponseImpl value,
          $Res Function(_$PatchOrderResponseImpl) then) =
      __$$PatchOrderResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status, String message, String timestamp});
}

/// @nodoc
class __$$PatchOrderResponseImplCopyWithImpl<$Res>
    extends _$PatchOrderResponseCopyWithImpl<$Res, _$PatchOrderResponseImpl>
    implements _$$PatchOrderResponseImplCopyWith<$Res> {
  __$$PatchOrderResponseImplCopyWithImpl(_$PatchOrderResponseImpl _value,
      $Res Function(_$PatchOrderResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PatchOrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
    Object? timestamp = null,
  }) {
    return _then(_$PatchOrderResponseImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PatchOrderResponseImpl implements _PatchOrderResponse {
  const _$PatchOrderResponseImpl(
      {required this.status, required this.message, required this.timestamp});

  factory _$PatchOrderResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PatchOrderResponseImplFromJson(json);

  @override
  final String status;
  @override
  final String message;
  @override
  final String timestamp;

  @override
  String toString() {
    return 'PatchOrderResponse(status: $status, message: $message, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PatchOrderResponseImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, message, timestamp);

  /// Create a copy of PatchOrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PatchOrderResponseImplCopyWith<_$PatchOrderResponseImpl> get copyWith =>
      __$$PatchOrderResponseImplCopyWithImpl<_$PatchOrderResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PatchOrderResponseImplToJson(
      this,
    );
  }
}

abstract class _PatchOrderResponse implements PatchOrderResponse {
  const factory _PatchOrderResponse(
      {required final String status,
      required final String message,
      required final String timestamp}) = _$PatchOrderResponseImpl;

  factory _PatchOrderResponse.fromJson(Map<String, dynamic> json) =
      _$PatchOrderResponseImpl.fromJson;

  @override
  String get status;
  @override
  String get message;
  @override
  String get timestamp;

  /// Create a copy of PatchOrderResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PatchOrderResponseImplCopyWith<_$PatchOrderResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
