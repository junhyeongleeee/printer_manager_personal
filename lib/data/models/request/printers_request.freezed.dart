// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'printers_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PrintersRequest _$PrintersRequestFromJson(Map<String, dynamic> json) {
  return _PrintersRequest.fromJson(json);
}

/// @nodoc
mixin _$PrintersRequest {
  String get name => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get ip => throw _privateConstructorUsedError;
  String get port => throw _privateConstructorUsedError;

  /// Serializes this PrintersRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrintersRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrintersRequestCopyWith<PrintersRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrintersRequestCopyWith<$Res> {
  factory $PrintersRequestCopyWith(
          PrintersRequest value, $Res Function(PrintersRequest) then) =
      _$PrintersRequestCopyWithImpl<$Res, PrintersRequest>;
  @useResult
  $Res call({String name, String model, String status, String ip, String port});
}

/// @nodoc
class _$PrintersRequestCopyWithImpl<$Res, $Val extends PrintersRequest>
    implements $PrintersRequestCopyWith<$Res> {
  _$PrintersRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrintersRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? model = null,
    Object? status = null,
    Object? ip = null,
    Object? port = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      ip: null == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrintersRequestImplCopyWith<$Res>
    implements $PrintersRequestCopyWith<$Res> {
  factory _$$PrintersRequestImplCopyWith(_$PrintersRequestImpl value,
          $Res Function(_$PrintersRequestImpl) then) =
      __$$PrintersRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String model, String status, String ip, String port});
}

/// @nodoc
class __$$PrintersRequestImplCopyWithImpl<$Res>
    extends _$PrintersRequestCopyWithImpl<$Res, _$PrintersRequestImpl>
    implements _$$PrintersRequestImplCopyWith<$Res> {
  __$$PrintersRequestImplCopyWithImpl(
      _$PrintersRequestImpl _value, $Res Function(_$PrintersRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrintersRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? model = null,
    Object? status = null,
    Object? ip = null,
    Object? port = null,
  }) {
    return _then(_$PrintersRequestImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      ip: null == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrintersRequestImpl implements _PrintersRequest {
  const _$PrintersRequestImpl(
      {required this.name,
      required this.model,
      required this.status,
      required this.ip,
      required this.port});

  factory _$PrintersRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrintersRequestImplFromJson(json);

  @override
  final String name;
  @override
  final String model;
  @override
  final String status;
  @override
  final String ip;
  @override
  final String port;

  @override
  String toString() {
    return 'PrintersRequest(name: $name, model: $model, status: $status, ip: $ip, port: $port)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrintersRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.ip, ip) || other.ip == ip) &&
            (identical(other.port, port) || other.port == port));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, model, status, ip, port);

  /// Create a copy of PrintersRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrintersRequestImplCopyWith<_$PrintersRequestImpl> get copyWith =>
      __$$PrintersRequestImplCopyWithImpl<_$PrintersRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrintersRequestImplToJson(
      this,
    );
  }
}

abstract class _PrintersRequest implements PrintersRequest {
  const factory _PrintersRequest(
      {required final String name,
      required final String model,
      required final String status,
      required final String ip,
      required final String port}) = _$PrintersRequestImpl;

  factory _PrintersRequest.fromJson(Map<String, dynamic> json) =
      _$PrintersRequestImpl.fromJson;

  @override
  String get name;
  @override
  String get model;
  @override
  String get status;
  @override
  String get ip;
  @override
  String get port;

  /// Create a copy of PrintersRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrintersRequestImplCopyWith<_$PrintersRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
