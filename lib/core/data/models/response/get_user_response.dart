import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_user_response.freezed.dart';
part 'get_user_response.g.dart';

@freezed
abstract class GetUserResponse with _$GetUserResponse {
  const factory GetUserResponse({
    required String status,
    required String message,
    required GetUserResponseData data,
    required String timestamp,
  }) = _GetUserResponse;

  factory GetUserResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserResponseFromJson(json);
}

@freezed
abstract class GetUserResponseData with _$GetUserResponseData {
  const factory GetUserResponseData({
    required String userId,
    required String companyName,
    required String address,
    required String username,
    required String phone,
    required String status,
    required InstitutionData data,
  }) = _GetUserResponseData;

  factory GetUserResponseData.fromJson(Map<String, dynamic> json) =>
      _$GetUserResponseDataFromJson(json);
}

@freezed
abstract class InstitutionData with _$InstitutionData {
  const factory InstitutionData({
    required String institutionId,
    required String institutionName,
  }) = _InstitusionData;

  factory InstitutionData.fromJson(Map<String, dynamic> json) =>
      _$InstitutionDataFromJson(json);
}