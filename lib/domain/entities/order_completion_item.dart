class OrderCompletionItem {
  final int id; // 고유 ID (UUID 등)
  final String agency;
  final String orderCode; // OrderItem.code 참조
  final String item;
  final int total;
  final int assignedAmount;
  final String orderDate;
  final DateTime? startedAt;
  final DateTime? completedAt;

  OrderCompletionItem({
    required this.id,
    required this.agency,
    required this.orderCode,
    required this.item,
    required this.total,
    required this.assignedAmount,
    required this.orderDate,
    this.startedAt,
    this.completedAt,
  });

  OrderCompletionItem copyWith({
    int? id,
    String? agency,
    String? orderCode,
    String? item,
    int? total,
    int? assignedAmount,
    String? orderDate,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return OrderCompletionItem(
      id: id ?? this.id,
      agency: this.agency,
      orderCode: orderCode ?? this.orderCode,
      item: item ?? this.item,
      total: total ?? this.total,
      assignedAmount: assignedAmount ?? this.assignedAmount,
      orderDate: orderDate ?? this.orderDate,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}