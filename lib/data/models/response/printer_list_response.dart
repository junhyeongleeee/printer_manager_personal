import 'package:freezed_annotation/freezed_annotation.dart';

part 'printer_list_response.freezed.dart';
part 'printer_list_response.g.dart';

@freezed
class PrinterListResponse with _$PrinterListResponse {
  const factory PrinterListResponse({
    required String status,
    required String message,
    required PrinterListResponseData data,
    required String timestamp,
  }) = _PrinterListResponse;

  factory PrinterListResponse.fromJson(Map<String, dynamic> json) =>
      _$PrinterListResponseFromJson(json);
}

@freezed
class PrinterListResponseData with _$PrinterListResponseData {
  const factory PrinterListResponseData({
    required List<PrinterData> printerList,
  }) = _PrinterListResponseData;

  factory PrinterListResponseData.fromJson(Map<String, dynamic> json) =>
      _$PrinterListResponseDataFromJson(json);
}

@freezed
class PrinterData with _$PrinterData {
  const factory PrinterData({
    required int processingCompanyPrinterIndex,
    required String printerName,
    required String model,
    required String? ip,
    required String? port,
    required String status,
    required String regDate,
  }) = _PrinterData;

  factory PrinterData.fromJson(Map<String, dynamic> json) =>
      _$PrinterDataFromJson(json);
}

