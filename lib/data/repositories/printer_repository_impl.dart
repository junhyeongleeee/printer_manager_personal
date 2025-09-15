import 'package:print_manager/data/datasources/remote/api_service.dart';
import 'package:print_manager/domain/repositories/printer_repository.dart';
import 'package:print_manager/data/models/request/printers_request.dart';
import 'package:print_manager/data/models/response/printers_response.dart';
import 'package:print_manager/data/models/response/printer_list_response.dart';
import 'package:print_manager/data/models/response/get_printer_response.dart';

import 'package:print_manager/data/models/request/printerjob_request.dart';
import 'package:print_manager/data/models/response/printerjob_response.dart';
import 'package:print_manager/data/models/response/printerjob_list_response.dart';
import 'package:print_manager/data/models/request/update_printerjob_request.dart';
import 'package:print_manager/data/models/response/update_printerjob_response.dart';

class PrinterRepositoryImpl implements PrinterRepository {
  final ApiService api;

  PrinterRepositoryImpl(this.api);

  //printer
  @override
  Future<PrintersResponse> addPrinter(PrintersRequest request) async {
    return api.addPrinter(request);
  }
  @override
  Future<PrinterListResponse> printerList() async {
    return api.printerList();
  }
  @override
  Future<GetPrinterResponse> getPrinter(int printerId) async {
    return api.getPrinter(printerId);
  }

  @override
  Future<void> deletePrinter(int printerId) async {
    return api.deletePrinter(printerId);
  }

  //printer job
  @override
  Future<PrinterjobResponse> addPrinterJob(PrinterjobRequest request) async {
    return api.addPrinterJob(request);
  }
  @override
  Future<PrinterjobListResponse> printerJobList() async {
    return api.printerJobList();
  }
  @override
  Future<UpdatePrinterjobResponse> updatePrinterJob(int printerJobId, UpdatePrinterjobRequest request) async {
    return api.updatePrinterJob(printerJobId, request);

  }
}