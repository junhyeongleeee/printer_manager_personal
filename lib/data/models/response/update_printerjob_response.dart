import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_printerjob_response.freezed.dart';
part 'update_printerjob_response.g.dart';

@freezed
class UpdatePrinterjobResponse with _$UpdatePrinterjobResponse {
  const factory UpdatePrinterjobResponse({
    required String status,
    required String message,
    required String timestamp,
  }) = _UpdatePrinterjobResponse;

  factory UpdatePrinterjobResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdatePrinterjobResponseFromJson(json);
}
