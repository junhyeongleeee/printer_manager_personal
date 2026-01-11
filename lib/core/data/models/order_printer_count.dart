import 'package:isar/isar.dart';

part 'order_printer_count.g.dart';

/// 발주별 프린터 카운트 모델 (발주-프린터 조합당 1개 레코드)
@collection
class OrderPrinterCount {
  /// 자동 증가 ID
  Id id = Isar.autoIncrement;

  /// 발주 ID (인덱스)
  @Index()
  late int orderId;

  /// 프린터 ID (인덱스)
  @Index()
  late int printerId;

  /// 카운트 값
  late int count;

  /// 업데이트 시간
  late DateTime updatedAt;

  /// 생성 시간
  late DateTime createdAt;

  OrderPrinterCount();

  /// 복합 인덱스: (orderId, printerId) 조합이 유니크해야 함
  /// Isar에서는 복합 인덱스로 유니크 제약을 직접 지원하지 않으므로,
  /// 애플리케이션 레벨에서 중복 체크 필요
}
