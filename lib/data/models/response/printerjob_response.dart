import 'package:freezed_annotation/freezed_annotation.dart';

part 'printerjob_response.freezed.dart';
part 'printerjob_response.g.dart';
//등록
@freezed
class PrinterjobResponse with _$PrinterjobResponse {
  const factory PrinterjobResponse({
    required String status,
    required String message,
    required PrinterjobResponseData data,
    required String timestamp,
  }) = _PrinterjobResponse;

  factory PrinterjobResponse.fromJson(Map<String, dynamic> json) =>
      _$PrinterjobResponseFromJson(json);
}

@freezed
class PrinterjobResponseData with _$PrinterjobResponseData {
  const factory PrinterjobResponseData({
    required int jobId,
  }) = _PrinterjobResponseData;

  factory PrinterjobResponseData.fromJson(Map<String, dynamic> json) =>
      _$PrinterjobResponseDataFromJson(json);
}