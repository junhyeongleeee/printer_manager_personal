import 'package:freezed_annotation/freezed_annotation.dart';

part 'print_event_request.freezed.dart';
part 'print_event_request.g.dart';

@freezed
class PrintEventRequest with _$PrintEventRequest {
  const factory PrintEventRequest({
    required int orderId,
    required int quantity,
    required String eventKey,
  }) = _PrintEventRequest;

  factory PrintEventRequest.fromJson(Map<String, dynamic> json) => _$PrintEventRequestFromJson(json);
}

