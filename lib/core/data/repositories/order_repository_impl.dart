import 'package:print_manager/core/data/datasources/remote/api_service.dart';
import 'package:print_manager/core/data/models/request/warehouse_request.dart';
import 'package:print_manager/core/domain/repositories/order_repository.dart';
import 'package:print_manager/core/data/models/request/printers_request.dart';
import 'package:print_manager/core/data/models/response/order_response.dart';
import 'package:print_manager/core/data/models/response/get_order_response.dart';
import 'package:print_manager/core/data/models/request/patch_order_request.dart';
import 'package:print_manager/core/data/models/response/patch_order_response.dart';
import 'package:print_manager/core/data/models/request/warehouse_request.dart';
import 'package:print_manager/core/data/models/response/warehouse_response.dart';

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
}