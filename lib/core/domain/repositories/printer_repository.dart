import 'package:print_manager/core/data/models/request/printers_request.dart';
import 'package:print_manager/core/data/models/response/printers_response.dart';
import 'package:print_manager/core/data/models/response/get_printer_response.dart';
import 'package:print_manager/core/data/models/response/printer_list_response.dart';

import 'package:print_manager/core/data/models/request/printerjob_request.dart';
import 'package:print_manager/core/data/models/response/printerjob_response.dart';
import 'package:print_manager/core/data/models/response/printerjob_list_response.dart';
import 'package:print_manager/core/data/models/request/update_printerjob_request.dart';
import 'package:print_manager/core/data/models/response/update_printerjob_response.dart';


abstract class PrinterRepository {
  //printer
  Future<PrintersResponse> addPrinter(PrintersRequest request);
  Future<PrinterListResponse> printerList();
  Future<GetPrinterResponse> getPrinter(int printerId);
  Future<void> deletePrinter(int printerId);

  //printer-job
  Future<PrinterjobResponse> addPrinterJob(PrinterjobRequest request);
  Future<PrinterjobListResponse> printerJobList();
  Future<UpdatePrinterjobResponse> updatePrinterJob(int printerJobId, UpdatePrinterjobRequest request);
}
