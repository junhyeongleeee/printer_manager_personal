import 'package:dio/dio.dart';
import 'package:print_manager/data/models/request/login_request.dart';
import 'package:print_manager/data/models/response/login_response.dart';
import 'package:print_manager/data/models/request/user_request.dart';
import 'package:print_manager/data/models/response/user_response.dart';
import 'package:print_manager/data/models/response/get_user_response.dart';

import 'package:print_manager/data/models/request/printers_request.dart';
import 'package:print_manager/data/models/response/printers_response.dart';
import 'package:print_manager/data/models/response/get_printer_response.dart';
import 'package:print_manager/data/models/response/printer_list_response.dart';

import 'package:print_manager/data/models/response/order_response.dart';
import 'package:print_manager/data/models/response/get_order_response.dart';
import 'package:print_manager/data/models/request/patch_order_request.dart';
import 'package:print_manager/data/models/response/patch_order_response.dart';
import 'package:print_manager/data/models/request/warehouse_request.dart';
import 'package:print_manager/data/models/response/warehouse_response.dart';

import 'package:print_manager/data/models/request/printerjob_request.dart';
import 'package:print_manager/data/models/response/printerjob_response.dart';
import 'package:print_manager/data/models/response/printerjob_list_response.dart';
import 'package:print_manager/data/models/request/update_printerjob_request.dart';
import 'package:print_manager/data/models/response/update_printerjob_response.dart';

class ApiService {
  final Dio _dio;
  final String? baseUrl;

  ApiService(this._dio, {this.baseUrl});

  // User APIs
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      '/api/v1/print-manager/login',
      data: request.toJson(),
    );
    return LoginResponse.fromJson(response.data);
  }

  Future<UserResponse> updateUser(UserRequest request) async {
    final response = await _dio.patch(
      '/api/v1/print-manager/user',
      data: request.toJson(),
    );
    return UserResponse.fromJson(response.data);
  }

  Future<GetUserResponse> getUser() async {
    final response = await _dio.get('/api/v1/print-manager/user');
    return GetUserResponse.fromJson(response.data);
  }

  // Printer APIs
  Future<PrintersResponse> addPrinter(PrintersRequest request) async {
    final response = await _dio.post(
      '/api/v1/print-manager/printers',
      data: request.toJson(),
    );
    return PrintersResponse.fromJson(response.data);
  }

  Future<PrinterListResponse> printerList() async {
    final response = await _dio.get('/api/v1/print-manager/printers');
    return PrinterListResponse.fromJson(response.data);
  }

  Future<GetPrinterResponse> getPrinter(int printerId) async {
    final response = await _dio.get('/api/v1/print-manager/printers/$printerId');
    return GetPrinterResponse.fromJson(response.data);
  }

  Future<void> deletePrinter(int printerId) async {
    await _dio.delete('/api/v1/print-manager/printers/$printerId');
  }

  // Printer Job APIs
  Future<PrinterjobResponse> addPrinterJob(PrinterjobRequest request) async {
    final response = await _dio.post(
      '/api/v1/print-manager/print-jobs',
      data: request.toJson(),
    );
    return PrinterjobResponse.fromJson(response.data);
  }

  Future<PrinterjobListResponse> printerJobList() async {
    final response = await _dio.get('/api/v1/print-manager/print-jobs');
    return PrinterjobListResponse.fromJson(response.data);
  }

  Future<UpdatePrinterjobResponse> updatePrinterJob(
    int printerJobId,
    UpdatePrinterjobRequest request,
  ) async {
    final response = await _dio.patch(
      '/api/v1/print-manager/print-jobs/$printerJobId',
      data: request.toJson(),
    );
    return UpdatePrinterjobResponse.fromJson(response.data);
  }

  // Order APIs
  Future<OrderResponse> orderList() async {
    final response = await _dio.get('/api/v1/print-manager/Orders');
    return OrderResponse.fromJson(response.data);
  }

  Future<GetOrderResponse> getOrder(int orderId) async {
    final response = await _dio.get('/api/v1/print-manager/Orders/$orderId');
    return GetOrderResponse.fromJson(response.data);
  }

  Future<PatchOrderResponse> updateOrder(
    int orderId,
    PatchOrderRequest request,
  ) async {
    final response = await _dio.patch(
      '/api/v1/print-manager/Orders/$orderId',
      data: request.toJson(),
    );
    return PatchOrderResponse.fromJson(response.data);
  }

  Future<WarehouseResponse> sendToWarehouse(WarehouseRequest request) async {
    final response = await _dio.post(
      '/api/v1/print-manager/Orders/warehouse',
      data: request.toJson(),
    );
    return WarehouseResponse.fromJson(response.data);
  }
}
