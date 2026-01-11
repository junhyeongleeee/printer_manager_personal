import 'package:freezed_annotation/freezed_annotation.dart';

part 'printers_request.freezed.dart';
part 'printers_request.g.dart';

@freezed
abstract class PrintersRequest with _$PrintersRequest {
  const factory PrintersRequest({
    required String name,
    required String model,
    required String status,
    required String ip,
    required String port,
  }) = _PrintersRequest;

  factory PrintersRequest.fromJson(Map<String, dynamic> json) => _$PrintersRequestFromJson(json);
}