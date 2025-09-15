import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../models/user_model.dart';
import 'package:print_manager/domain/entities/user.dart';
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

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  //user
  @POST("/api/v1/print-manager/login")
  Future<LoginResponse> login(@Body() LoginRequest request);

  @PATCH("/api/v1/print-manager/user")
  Future<UserResponse> updateUser(@Body() UserRequest request);

  @GET("/api/v1/print-manager/user")
  Future<GetUserResponse> getUser();

  //printer
  @POST("/api/v1/print-manager/printers")
  Future<PrintersResponse> addPrinter(@Body() PrintersRequest request);

  @GET("/api/v1/print-manager/printers")
  Future<PrinterListResponse> printerList();

  @GET("/api/v1/print-manager/printers/{printerId}")
  Future<GetPrinterResponse> getPrinter(@Path() int printerId);

  @DELETE("/api/v1/print-manager/printers/{printerId}")
  Future<void> deletePrinter(@Path() int printerId);

  //printer job
  @POST("/api/v1/print-manager/print-jobs")
  Future<PrinterjobResponse> addPrinterJob(@Body() PrinterjobRequest request);

  @GET("/api/v1/print-manager/print-jobs")
  Future<PrinterjobListResponse> printerJobList();

  @PATCH("/api/v1/print-manager/print-jobs/{printerJobId}")
  Future<UpdatePrinterjobResponse> updatePrinterJob(@Path() int printerJobId, @Body() UpdatePrinterjobRequest request);

  //order
  @GET("/api/v1/print-manager/Orders")
  Future<OrderResponse> orderList();

  @GET("/api/v1/print-manager/Orders/{orderId}")
  Future<GetOrderResponse> getOrder(@Path() int orderId);

  @PATCH("/api/v1/print-manager/Orders/{orderId}")
  Future<PatchOrderResponse> updateOrder(@Path() int orderId, @Body() PatchOrderRequest request);

  @POST("/api/v1/print-manager/Orders/warehouse")
  Future<WarehouseResponse> sendToWarehouse(@Body() WarehouseRequest request);
}
