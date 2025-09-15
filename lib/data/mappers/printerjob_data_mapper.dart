import 'package:print_manager/domain/entities/printerjob_item.dart';
import 'package:print_manager/data/models/response/printerjob_list_response.dart';

extension PrinterjobDataMapper on PrintJob {
  PrinterjobItem toPrinterjobItems() {
      return PrinterjobItem(
        orderPrintJobId: orderPrintJobId,
        printerId: processingCompanyPrinterId,
        orderId: orderId,
        itemName: itemName,
        status: status,
        quantity: quantity,
        startedAt: startedAt ?? "-",
        completedAt: completedAt ?? "-",
        regDate: regDate,
      );
  }
}
