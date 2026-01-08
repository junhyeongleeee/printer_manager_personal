import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_printer_response.freezed.dart';
part 'get_printer_response.g.dart';

@freezed
abstract class GetPrinterResponse with _$GetPrinterResponse {
  const factory GetPrinterResponse({
    required String status,
    required String message,
    required GetPrinterResponseData data,
    required String timestamp,
  }) = _GetPrinterResponse;

  factory GetPrinterResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPrinterResponseFromJson(json);
}

@freezed
abstract class GetPrinterResponseData with _$GetPrinterResponseData {
  const factory GetPrinterResponseData({
    required int processingCompanyPrinterIndex,
    required String printerName,
    required String model,
    required String status,
    required String regDate,
  }) = _GetPrinterResponseData;

  factory GetPrinterResponseData.fromJson(Map<String, dynamic> json) =>
      _$GetPrinterResponseDataFromJson(json);
}