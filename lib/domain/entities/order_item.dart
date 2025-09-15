class OrderItem {
  final int orderId;
  final int institutionId;
  final String institutionName;
  final int itemId;
  final String itemName;
  final int quantity;
  final int remainingQuantity;
  final int stock;
  final String uniqueCode;
  final String startCode;
  final String endCode;
  final String embeddingCode;
  final String regDate;
  final String status; //여기서부터 밑에까지 2개
  final int available;

  OrderItem({
    required this.orderId,
    required this.institutionId,
    required this.institutionName,
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.remainingQuantity,
    required this.stock,
    required this.uniqueCode,
    required this.startCode,
    required this.endCode,
    required this.embeddingCode,
    required this.regDate,
    required this.status,
    required this.available,
  });

  OrderItem copyWith({
    int? orderId,
    int? institutionId,
    String? institutionName,
    int? itemId,
    String? itemName,
    int? quantity,
    int? remainingQuantity,
    int? stock,
    String? uniqueCode,
    String? startCode,
    String? endCode,
    String? embeddingCode,
    String? regDate,
    String? status,
    int? available,
  }) {
    return OrderItem(
      orderId: orderId ?? this.orderId,
      institutionId: institutionId ?? this.institutionId,
      institutionName: institutionName ?? this.institutionName,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      remainingQuantity: remainingQuantity ?? this.remainingQuantity,
      stock: stock ?? this.stock,
      uniqueCode: uniqueCode ?? this.uniqueCode,
      startCode: startCode ?? this.startCode,
      endCode: endCode ?? this.endCode,
      embeddingCode: embeddingCode ?? this.embeddingCode,
      regDate: regDate ?? this.regDate,
      status: status ?? this.status,
      available: available ?? this.available,
    );
  }
}
