import 'package:freezed_annotation/freezed_annotation.dart';

part 'print_event_response.freezed.dart';
part 'print_event_response.g.dart';

@freezed
abstract class PrintEventResponse with _$PrintEventResponse {
  const factory PrintEventResponse({
    required String status,
    required String message,
    required PrintEventResponseData data,
    required String timestamp,
  }) = _PrintEventResponse;

  factory PrintEventResponse.fromJson(Map<String, dynamic> json) => _$PrintEventResponseFromJson(json);
}

@freezed
abstract class PrintEventResponseData with _$PrintEventResponseData {
  const factory PrintEventResponseData({
    required int totalPrintedQuantity,
  }) = _PrintEventResponseData;

  factory PrintEventResponseData.fromJson(Map<String, dynamic> json) => _$PrintEventResponseDataFromJson(json);
}
