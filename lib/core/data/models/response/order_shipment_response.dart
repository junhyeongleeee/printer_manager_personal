import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_shipment_response.freezed.dart';
part 'order_shipment_response.g.dart';

@freezed
abstract class OrderShipmentListResponse with _$OrderShipmentListResponse {
  const factory OrderShipmentListResponse({
    required String status,
    required String message,
    required OrderShipmentListData data,
    required String timestamp,
  }) = _OrderShipmentListResponse;

  factory OrderShipmentListResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderShipmentListResponseFromJson(json);
}

@freezed
abstract class OrderShipmentListData with _$OrderShipmentListData {
  const factory OrderShipmentListData({
    required List<OrderShipmentItem> shipmentList,
    required OrderShipmentPaging paging,
  }) = _OrderShipmentListData;

  factory OrderShipmentListData.fromJson(Map<String, dynamic> json) =>
      _$OrderShipmentListDataFromJson(json);
}

@freezed
abstract class OrderShipmentItem with _$OrderShipmentItem {
  const factory OrderShipmentItem({
    required int stock,
    required String warehouseName,
    required String address,
    required String regDate,
  }) = _OrderShipmentItem;

  factory OrderShipmentItem.fromJson(Map<String, dynamic> json) =>
      _$OrderShipmentItemFromJson(json);
}

@freezed
abstract class OrderShipmentPaging with _$OrderShipmentPaging {
  const factory OrderShipmentPaging({
    required int totalCount,
    required int pageSize,
    required int currentPage,
    required int totalPage,
    required bool canPrev,
    required bool canNext,
  }) = _OrderShipmentPaging;

  factory OrderShipmentPaging.fromJson(Map<String, dynamic> json) =>
      _$OrderShipmentPagingFromJson(json);
}
