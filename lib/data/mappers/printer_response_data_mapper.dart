import 'package:print_manager/domain/entities/managed_printer.dart';
import 'package:print_manager/data/models/response/printer_list_response.dart';

extension PrinterResponseDataMapper on PrinterData {
  ManagedPrinter toManagedPrinter() {
    return ManagedPrinter(
      index: processingCompanyPrinterIndex,
      id: processingCompanyPrinterIndex,
      name: printerName,
      ip: ip?? "0",
      port: int.tryParse(port?? "") ?? 0,
      regDate: regDate,
    );
  }
}
