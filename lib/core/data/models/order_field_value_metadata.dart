import 'package:isar/isar.dart';

part 'order_field_value_metadata.g.dart';

/// 발주별 필드 값 관리 메타데이터 (발주당 1개 레코드)
@collection
class OrderFieldValueMetadata {
  /// 자동 증가 ID
  Id id = Isar.autoIncrement;

  /// 유저 ID (인덱스, 유저별 데이터 구분)
  @Index()
  late String userId;

  /// 발주 ID (인덱스, 유저별로 유니크)
  @Index(composite: [CompositeIndex('userId')])
  late int orderId;

  /// 다음 사용 가능한 필드 값 (새 값 할당 시 사용)
  late int nextAvailableValue;

  /// 시작 코드
  late int startCode;

  /// 끝 코드
  late int endCode;

  /// 고유 코드 (필드 값 앞에 붙는 접두사)
  late String uniqueCode;

  /// 업데이트 시간
  late DateTime updatedAt;

  OrderFieldValueMetadata();
}
