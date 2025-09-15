// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_printerjob_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdatePrinterjobRequest _$UpdatePrinterjobRequestFromJson(
    Map<String, dynamic> json) {
  return _UpdatePrinterjobRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdatePrinterjobRequest {
  String get status => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Serializes this UpdatePrinterjobRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdatePrinterjobRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdatePrinterjobRequestCopyWith<UpdatePrinterjobRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdatePrinterjobRequestCopyWith<$Res> {
  factory $UpdatePrinterjobRequestCopyWith(UpdatePrinterjobRequest value,
          $Res Function(UpdatePrinterjobRequest) then) =
      _$UpdatePrinterjobRequestCopyWithImpl<$Res, UpdatePrinterjobRequest>;
  @useResult
  $Res call({String status, String message});
}

/// @nodoc
class _$UpdatePrinterjobRequestCopyWithImpl<$Res,
        $Val extends UpdatePrinterjobRequest>
    implements $UpdatePrinterjobRequestCopyWith<$Res> {
  _$UpdatePrinterjobRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdatePrinterjobRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdatePrinterjobRequestImplCopyWith<$Res>
    implements $UpdatePrinterjobRequestCopyWith<$Res> {
  factory _$$UpdatePrinterjobRequestImplCopyWith(
          _$UpdatePrinterjobRequestImpl value,
          $Res Function(_$UpdatePrinterjobRequestImpl) then) =
      __$$UpdatePrinterjobRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status, String message});
}

/// @nodoc
class __$$UpdatePrinterjobRequestImplCopyWithImpl<$Res>
    extends _$UpdatePrinterjobRequestCopyWithImpl<$Res,
        _$UpdatePrinterjobRequestImpl>
    implements _$$UpdatePrinterjobRequestImplCopyWith<$Res> {
  __$$UpdatePrinterjobRequestImplCopyWithImpl(
      _$UpdatePrinterjobRequestImpl _value,
      $Res Function(_$UpdatePrinterjobRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdatePrinterjobRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? message = null,
  }) {
    return _then(_$UpdatePrinterjobRequestImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdatePrinterjobRequestImpl implements _UpdatePrinterjobRequest {
  const _$UpdatePrinterjobRequestImpl(
      {required this.status, required this.message});

  factory _$UpdatePrinterjobRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdatePrinterjobRequestImplFromJson(json);

  @override
  final String status;
  @override
  final String message;

  @override
  String toString() {
    return 'UpdatePrinterjobRequest(status: $status, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdatePrinterjobRequestImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, message);

  /// Create a copy of UpdatePrinterjobRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdatePrinterjobRequestImplCopyWith<_$UpdatePrinterjobRequestImpl>
      get copyWith => __$$UpdatePrinterjobRequestImplCopyWithImpl<
          _$UpdatePrinterjobRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdatePrinterjobRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdatePrinterjobRequest implements UpdatePrinterjobRequest {
  const factory _UpdatePrinterjobRequest(
      {required final String status,
      required final String message}) = _$UpdatePrinterjobRequestImpl;

  factory _UpdatePrinterjobRequest.fromJson(Map<String, dynamic> json) =
      _$UpdatePrinterjobRequestImpl.fromJson;

  @override
  String get status;
  @override
  String get message;

  /// Create a copy of UpdatePrinterjobRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdatePrinterjobRequestImplCopyWith<_$UpdatePrinterjobRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
