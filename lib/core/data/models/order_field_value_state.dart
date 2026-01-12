import 'package:isar/isar.dart';

part 'order_field_value_state.g.dart';

/// 발주별 필드 값 상태 모델 (Isar Collection)
@collection
class OrderFieldValueState {
  /// 자동 증가 ID
  Id id = Isar.autoIncrement;

  /// 유저 ID (인덱스, 유저별 데이터 구분)
  @Index()
  late String userId;

  /// 발주 ID (인덱스)
  @Index()
  late int orderId;

  /// 필드 값 (숫자) - 유저별 발주별 복합 인덱스
  @Index(composite: [CompositeIndex('userId'), CompositeIndex('orderId')])
  late int fieldValue;

  /// 할당된 프린터 ID (NULL 가능)
  int? printerId;

  /// 상태: 'assigned', 'inUse', 'completed', 'error'
  @Index()
  late String status;

  /// 고유 코드 (발주별)
  late String uniqueCode;

  /// 할당 시간
  late DateTime assignedAt;

  /// 사용 시작 시간 (NULL 가능)
  DateTime? inUseAt;

  /// 완료 시간 (NULL 가능)
  DateTime? completedAt;

  /// 오류 발생 시간 (NULL 가능)
  DateTime? errorAt;

  /// 오류 사유 (NULL 가능)
  String? errorReason;

  /// 생성 시간
  late DateTime createdAt;

  /// 업데이트 시간
  late DateTime updatedAt;

  OrderFieldValueState();

  /// JSON 직렬화 (필요 시)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'fieldValue': fieldValue,
      'printerId': printerId,
      'status': status,
      'uniqueCode': uniqueCode,
      'assignedAt': assignedAt.toIso8601String(),
      'inUseAt': inUseAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'errorAt': errorAt?.toIso8601String(),
      'errorReason': errorReason,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// JSON 역직렬화 (필요 시)
  factory OrderFieldValueState.fromJson(Map<String, dynamic> json) {
    final state = OrderFieldValueState();
    state.id = json['id'] as int? ?? Isar.autoIncrement;
    state.orderId = json['orderId'] as int;
    state.fieldValue = json['fieldValue'] as int;
    state.printerId = json['printerId'] as int?;
    state.status = json['status'] as String;
    state.uniqueCode = json['uniqueCode'] as String;
    state.assignedAt = DateTime.parse(json['assignedAt'] as String);
    state.inUseAt = json['inUseAt'] != null ? DateTime.parse(json['inUseAt'] as String) : null;
    state.completedAt = json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null;
    state.errorAt = json['errorAt'] != null ? DateTime.parse(json['errorAt'] as String) : null;
    state.errorReason = json['errorReason'] as String?;
    state.createdAt = DateTime.parse(json['createdAt'] as String);
    state.updatedAt = DateTime.parse(json['updatedAt'] as String);
    return state;
  }
}
