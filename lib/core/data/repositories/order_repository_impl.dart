import 'package:print_manager/core/data/datasources/remote/api_service.dart';
import 'package:print_manager/core/data/models/request/warehouse_request.dart';
import 'package:print_manager/core/domain/repositories/order_repository.dart';
import 'package:print_manager/core/data/models/response/order_response.dart';
import 'package:print_manager/core/data/models/response/get_order_response.dart';
import 'package:print_manager/core/data/models/request/patch_order_request.dart';
import 'package:print_manager/core/data/models/response/patch_order_response.dart';
import 'package:print_manager/core/data/models/response/warehouse_response.dart';
import 'package:print_manager/core/data/models/response/order_history_response.dart';
import 'package:print_manager/core/data/models/response/order_shipment_response.dart';
import 'package:print_manager/core/data/models/request/print_event_request.dart';
import 'package:print_manager/core/data/models/response/print_event_response.dart';

class OrderRepositoryImpl implements OrderRepository {
  final ApiService api;

  OrderRepositoryImpl(this.api);

  @override
  Future<OrderResponse> orderList() async {
    return api.orderList();
  }

  @override
  Future<GetOrderResponse> getOrder(int orderId) async {
    return api.getOrder(orderId);
  }

  @override
  Future<PatchOrderResponse> updateOrder(int orderId, PatchOrderRequest request) async {
    return api.updateOrder(orderId, request);
  }

  @override
  Future<WarehouseResponse> sendToWarehouse(WarehouseRequest request) async {
    return api.sendToWarehouse(request);
  }

  @override
  Future<OrderHistoryListResponse> getOrderHistoryList(int orderId, int pageSize, int currentPage) async {
    return api.getOrderHistoryList(orderId, pageSize, currentPage);
  }

  @override
  Future<OrderShipmentListResponse> getOrderShipmentList(int orderId, int pageSize, int currentPage) async {
    return api.getOrderShipmentList(orderId, pageSize, currentPage);
  }

  @override
  Future<PrintEventResponse> sendPrintEvent(PrintEventRequest request) async {
    return api.sendPrintEvent(request);
  }
}
