import 'package:freezed_annotation/freezed_annotation.dart';

part 'printers_response.freezed.dart';
part 'printers_response.g.dart';

@freezed
abstract class PrintersResponse with _$PrintersResponse {
  const factory PrintersResponse({
    required String status,
    required String message,
    required PrintersResponseData data,
    required String timestamp
  }) = _PrintersResponse;

  factory PrintersResponse.fromJson(Map<String, dynamic> json) => _$PrintersResponseFromJson(json);
}

@freezed
abstract class PrintersResponseData with _$PrintersResponseData {
  const factory PrintersResponseData({
    required int processingCompanyPrinterIndex,
    required String printerName,
    required String ip,
    required String port,
    required String status, //연결상태
    required String regDate,
  }) = _PrintersResponseData;

  factory PrintersResponseData.fromJson(Map<String, dynamic> json) => _$PrintersResponseDataFromJson(json);
}