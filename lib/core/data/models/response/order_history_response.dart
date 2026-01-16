import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_history_response.freezed.dart';
part 'order_history_response.g.dart';

@freezed
abstract class OrderHistoryListResponse with _$OrderHistoryListResponse {
  const factory OrderHistoryListResponse({
    required String status,
    required String message,
    required OrderHistoryListData data,
    required String timestamp,
  }) = _OrderHistoryListResponse;

  factory OrderHistoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderHistoryListResponseFromJson(json);
}

@freezed
abstract class OrderHistoryListData with _$OrderHistoryListData {
  const factory OrderHistoryListData({
    required List<OrderHistoryItem> historyList,
    required OrderHistoryPaging paging,
  }) = _OrderHistoryListData;

  factory OrderHistoryListData.fromJson(Map<String, dynamic> json) =>
      _$OrderHistoryListDataFromJson(json);
}

@freezed
abstract class OrderHistoryItem with _$OrderHistoryItem {
  const factory OrderHistoryItem({
    required int quantity,
    required String status,
    required String regDate,
  }) = _OrderHistoryItem;

  factory OrderHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$OrderHistoryItemFromJson(json);
}

@freezed
abstract class OrderHistoryPaging with _$OrderHistoryPaging {
  const factory OrderHistoryPaging({
    required int totalCount,
    required int pageSize,
    required int currentPage,
    required int totalPage,
    required bool canPrev,
    required bool canNext,
  }) = _OrderHistoryPaging;

  factory OrderHistoryPaging.fromJson(Map<String, dynamic> json) =>
      _$OrderHistoryPagingFromJson(json);
}
