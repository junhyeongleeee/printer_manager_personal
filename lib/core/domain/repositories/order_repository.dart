import 'package:print_manager/core/data/models/response/order_response.dart';
import 'package:print_manager/core/data/models/response/get_order_response.dart';
import 'package:print_manager/core/data/models/response/patch_order_response.dart';
import 'package:print_manager/core/data/models/request/patch_order_request.dart';
import 'package:print_manager/core/data/models/request/warehouse_request.dart';
import 'package:print_manager/core/data/models/response/warehouse_response.dart';
import 'package:print_manager/core/data/models/response/order_history_response.dart';
import 'package:print_manager/core/data/models/response/order_shipment_response.dart';
import 'package:print_manager/core/data/models/request/print_event_request.dart';
import 'package:print_manager/core/data/models/response/print_event_response.dart';


abstract class OrderRepository {
  Future<OrderResponse> orderList();
  Future<GetOrderResponse> getOrder(int orderId);
  Future<PatchOrderResponse> updateOrder(int orderId, PatchOrderRequest request);
  Future<WarehouseResponse> sendToWarehouse(WarehouseRequest request);
  Future<OrderHistoryListResponse> getOrderHistoryList(int orderId, int pageSize, int currentPage);
  Future<OrderShipmentListResponse> getOrderShipmentList(int orderId, int pageSize, int currentPage);
  Future<PrintEventResponse> sendPrintEvent(PrintEventRequest request);
}
