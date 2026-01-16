import 'package:freezed_annotation/freezed_annotation.dart';

part 'printerjob_list_response.freezed.dart';
part 'printerjob_list_response.g.dart';

@freezed
abstract class PrinterjobListResponse with _$PrinterjobListResponse {
  const factory PrinterjobListResponse({
    required String status,
    required String message,
    required PrinterjobListResponseData data,
    required String timestamp,
  }) = _PrinterjobListResponse;

  factory PrinterjobListResponse.fromJson(Map<String, dynamic> json) => _$PrinterjobListResponseFromJson(json);
}

@freezed
abstract class PrinterjobListResponseData with _$PrinterjobListResponseData {
  const factory PrinterjobListResponseData({
    required List<PrintJob> printJobList,
  }) = _PrinterjobListResponseData;

  factory PrinterjobListResponseData.fromJson(Map<String, dynamic> json) => _$PrinterjobListResponseDataFromJson(json);
}

@freezed
abstract class PrintJob with _$PrintJob {
  const factory PrintJob({
    required int orderPrintJobId,
    required int processingCompanyPrinterId,
    required int orderId,
    required String itemName,
    required String status,
    required int quantity,
    required String? startedAt,
    required String? completedAt,
    required String regDate,
  }) = _PrintJob;

  factory PrintJob.fromJson(Map<String, dynamic> json) => _$PrintJobFromJson(json);
}
