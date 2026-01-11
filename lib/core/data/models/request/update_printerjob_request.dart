import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_printerjob_request.freezed.dart';
part 'update_printerjob_request.g.dart';

@freezed
abstract class UpdatePrinterjobRequest with _$UpdatePrinterjobRequest {
  const factory UpdatePrinterjobRequest({
    required String status,
    required String message,
  }) = _UpdatePrinterjobRequest;

  factory UpdatePrinterjobRequest.fromJson(Map<String, dynamic> json) => _$UpdatePrinterjobRequestFromJson(json);
}