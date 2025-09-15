class PrinterjobItem {
  final int orderPrintJobId;
  final int printerId;
  final int orderId;
  final String itemName;
  final String status;
  final int quantity;
  final String? startedAt;
  final String? completedAt;
  final String regDate;

  PrinterjobItem({
    required this.orderPrintJobId,
    required this.printerId,
    required this.orderId,
    required this.itemName,
    required this.status,
    required this.quantity,
    required this.startedAt,
    required this.completedAt,
    required this.regDate,
  });

  PrinterjobItem copyWith({
    int? orderPrintJobId,
    int? printerId,
    int? orderId,
    String? itemName,
    String? status,
    int? quantity,
    String? startedAt,
    String? completedAt,
    String? regDate,
  }) {
    return PrinterjobItem(
      orderPrintJobId: orderPrintJobId ?? this.orderPrintJobId,
      printerId: printerId ?? this.printerId,
      orderId: orderId ?? this.orderId,
      itemName: itemName ?? this.itemName,
      status: status ?? this.status,
      quantity: quantity ?? this.quantity,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      regDate: regDate ?? this.regDate,
    );
  }
}
