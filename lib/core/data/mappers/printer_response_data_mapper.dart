import 'package:print_manager/core/domain/entities/managed_printer.dart';
import 'package:print_manager/core/data/models/response/printer_list_response.dart';
import 'package:print_manager/core/enums/printer_protocol.dart';
import 'package:print_manager/core/factories/printer_socket_factory.dart';

extension PrinterResponseDataMapper on PrinterData {
  ManagedPrinter toManagedPrinter() {
    // 모델명으로부터 프로토콜 타입 추론
    final protocol = PrinterProtocolExtension.fromModel(model);
    
    // 프로토콜에 맞는 소켓 생성
    final socket = PrinterSocketFactory.create(protocol);
    
    return ManagedPrinter(
      index: processingCompanyPrinterIndex,
      id: processingCompanyPrinterIndex,
      name: printerName,
      ip: ip?? "0",
      port: int.tryParse(port?? "") ?? 0,
      regDate: regDate,
      protocol: protocol,
      socket: socket,
    );
  }
}
