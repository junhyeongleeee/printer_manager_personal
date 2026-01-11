import 'package:isar/isar.dart';

part 'printer_last_order.g.dart';

/// 프린터별 마지막 선택 발주 모델 (프린터당 1개 레코드)
@collection
class PrinterLastOrder {
  /// 자동 증가 ID
  Id id = Isar.autoIncrement;

  /// 프린터 ID (인덱스, 유니크)
  @Index(unique: true)
  late int printerId;

  /// 마지막으로 선택한 발주 ID
  late int orderId;

  /// 업데이트 시간
  late DateTime updatedAt;

  /// 생성 시간
  late DateTime createdAt;

  PrinterLastOrder();
}
