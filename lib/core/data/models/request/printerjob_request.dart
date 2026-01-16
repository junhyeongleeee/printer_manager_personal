import 'package:freezed_annotation/freezed_annotation.dart';

part 'printerjob_request.freezed.dart';
part 'printerjob_request.g.dart';

@freezed
abstract class PrinterjobRequest with _$PrinterjobRequest {
  const factory PrinterjobRequest({
    required int orderId,
    required int processingCompanyPrinterId,
  }) = _PrinterjobRequest;

  factory PrinterjobRequest.fromJson(Map<String, dynamic> json) => _$PrinterjobRequestFromJson(json);
}
