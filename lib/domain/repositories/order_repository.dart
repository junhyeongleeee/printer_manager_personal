import 'package:print_manager/data/models/response/order_response.dart';
import 'package:print_manager/data/models/response/get_order_response.dart';
import 'package:print_manager/data/models/response/patch_order_response.dart';
import 'package:print_manager/data/models/request/patch_order_request.dart';
import 'package:print_manager/data/models/request/warehouse_request.dart';
import 'package:print_manager/data/models/response/warehouse_response.dart';


abstract class OrderRepository {
  Future<OrderResponse> orderList();
  Future<GetOrderResponse> getOrder(int orderId);
  Future<PatchOrderResponse> updateOrder(int orderId, PatchOrderRequest request);
  Future<WarehouseResponse> sendToWarehouse(WarehouseRequest request);
}
