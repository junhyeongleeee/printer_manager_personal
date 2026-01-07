import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:print_manager/core/services/logger_service.dart';

/// 필드 값 상태
enum FieldValueStatus {
  available, // 사용 가능 (free 리스트에 있을 때)
  assigned, // 프린터에 할당됐지만 아직 사용 안 됨
  inUse, // 실제 인쇄에 사용 중/사용 완료
}

/// 할당된 필드 값 정보
class AssignedFieldValue {
  final int value; // 실제 필드 값 (숫자)
  final int printerId; // 할당된 프린터 ID
  final DateTime assignedAt; // 할당 시간
  FieldValueStatus status;

  AssignedFieldValue({
    required this.value,
    required this.printerId,
    required this.assignedAt,
    this.status = FieldValueStatus.assigned,
  });
}

/// 필드 값 관리자 상태
/// - nextAvailableValue: 아직 한 번도 쓰지 않은 값 포인터
/// - freeValues: 오류/타임아웃 등으로 인해 재사용 가능한 값들
class FieldValueManagerState {
  final int startCode; // 시작 코드
  final int endCode; // 끝 코드
  final String uniqueCode; // 고유 코드 (필드 값 앞에 붙는 접두사)
  final Map<int, AssignedFieldValue> assignedValues; // 프린터 ID -> 현재 할당된 필드 값
  final Set<int> freeValues; // 재사용 가능한 필드 값 모음
  final int nextAvailableValue; // 다음 사용 가능한 "새로운" 필드 값

  FieldValueManagerState({
    required this.startCode,
    required this.endCode,
    required this.uniqueCode,
    Map<int, AssignedFieldValue>? assignedValues,
    Set<int>? freeValues,
    int? nextAvailableValue,
  }) : assignedValues = assignedValues ?? {},
       freeValues = freeValues ?? {},
       nextAvailableValue = nextAvailableValue ?? startCode;

  /// 사용 가능한 필드 값 개수 (freeValues + 아직 쓰지 않은 값)
  int get availableCount {
    final fresh = nextAvailableValue > endCode ? 0 : (endCode - nextAvailableValue + 1);
    return fresh + freeValues.length;
  }

  /// 할당된 필드 값 개수
  int get assignedCount => assignedValues.length;

  FieldValueManagerState copyWith({
    int? startCode,
    int? endCode,
    String? uniqueCode,
    Map<int, AssignedFieldValue>? assignedValues,
    Set<int>? freeValues,
    int? nextAvailableValue,
  }) {
    return FieldValueManagerState(
      startCode: startCode ?? this.startCode,
      endCode: endCode ?? this.endCode,
      uniqueCode: uniqueCode ?? this.uniqueCode,
      assignedValues: assignedValues ?? Map.from(this.assignedValues),
      freeValues: freeValues ?? Set.from(this.freeValues),
      nextAvailableValue: nextAvailableValue ?? this.nextAvailableValue,
    );
  }
}

/// 필드 값 관리자 Provider
final fieldValueManagerProvider = StateNotifierProvider<FieldValueManagerNotifier, FieldValueManagerState?>((ref) {
  return FieldValueManagerNotifier();
});

class FieldValueManagerNotifier extends StateNotifier<FieldValueManagerState?> {
  FieldValueManagerNotifier() : super(null);

  Timer? _timeoutTimer;
  // 할당만 된 상태(assigned)로 이 시간 이상 유지되면 오류로 간주하고 재사용 풀에 되돌림
  static const Duration _assignmentTimeout = Duration(seconds: 30); // 필요 시 조정 가능

  /// 필드 값 범위 초기화
  /// 주문 정보를 기반으로 필드 값 범위를 설정
  void initialize({required int startCode, required int endCode, required String uniqueCode}) {
    logger.i('필드 값 관리자 초기화: startCode=$startCode, endCode=$endCode, uniqueCode=$uniqueCode');
    state = FieldValueManagerState(startCode: startCode, endCode: endCode, uniqueCode: uniqueCode);
    _startTimeoutCheck();
  }

  /// 타임아웃 체크 시작 (주기적으로 할당만 되고 사용되지 않은 값 확인)
  void _startTimeoutCheck() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkAndReleaseTimeoutValues();
    });
  }

  /// 타임아웃된 할당 값들 자동 해제
  /// - 상태: assigned
  /// - 조건: 할당 후 [_assignmentTimeout] 동안 inUse로 전환되지 않음
  /// - 처리: 프린터와 연결 해제 + freeValues에 값 추가 (재사용 가능)
  ///
  /// 테스트용으로 public으로 노출 (수동 호출 가능)
  void checkAndReleaseTimeoutValues() {
    if (state == null) return;

    final now = DateTime.now();
    final timeoutPrinters = <int>[];

    for (final entry in state!.assignedValues.entries) {
      final printerId = entry.key;
      final assigned = entry.value;

      if (assigned.status == FieldValueStatus.assigned) {
        final elapsed = now.difference(assigned.assignedAt);
        if (elapsed >= _assignmentTimeout) {
          timeoutPrinters.add(printerId);
          logger.w('필드 값 타임아웃: 프린터 $printerId -> 값 ${assigned.value} (할당 후 ${elapsed.inSeconds}초 경과, 사용되지 않음)');
        }
      }
    }

    for (final printerId in timeoutPrinters) {
      // assigned 상태의 값만 free 리스트에 되돌리기 위해
      _releaseForReuseIfNotInUse(printerId);
    }
  }

  @visibleForTesting
  void debugCheckTimeoutsNow() {
    checkAndReleaseTimeoutValues();
  }

  /// 테스트용: 특정 프린터의 assignedAt을 과거로 설정하여 타임아웃 시뮬레이션
  @visibleForTesting
  void debugSetAssignedAtToPast(int printerId, Duration pastDuration) {
    if (state == null) return;
    final assigned = state!.assignedValues[printerId];
    if (assigned == null) return;

    // assignedAt을 과거로 설정한 새로운 AssignedFieldValue 생성
    final pastAssigned = AssignedFieldValue(
      value: assigned.value,
      printerId: assigned.printerId,
      assignedAt: DateTime.now().subtract(pastDuration),
      status: assigned.status,
    );

    final newAssignedValues = Map<int, AssignedFieldValue>.from(state!.assignedValues);
    newAssignedValues[printerId] = pastAssigned;
    state = state!.copyWith(assignedValues: newAssignedValues);
  }

  /// 내부용: 아직 inUse가 아닌 값만 freeValues로 되돌린 후 할당 해제
  void _releaseForReuseIfNotInUse(int printerId) {
    if (state == null) return;
    final assigned = state!.assignedValues[printerId];
    if (assigned == null) return;

    if (assigned.status == FieldValueStatus.assigned) {
      // 실제 인쇄에 사용되지 않은 값으로 간주 → 재사용 가능
      final value = assigned.value;
      final newAssignedValues = Map<int, AssignedFieldValue>.from(state!.assignedValues)..remove(printerId);
      final newFreeValues = Set<int>.from(state!.freeValues)..add(value);

      state = state!.copyWith(assignedValues: newAssignedValues, freeValues: newFreeValues);

      logger.i('필드 값 재사용 가능 상태로 되돌림: 값 $value (프린터 $printerId, inUse 아님)');
    } else {
      // inUse 상태면 재사용하지 않고 단순 해제만 허용
      releaseFieldValue(printerId);
    }
  }

  /// 필드 값 요청 (프린터가 다음 필드 값을 요청)
  /// 반환: 할당된 필드 값 (숫자), null이면 사용 가능한 값이 없음
  ///
  /// 우선순위:
  /// 1) freeValues(재사용 가능 값)이 있으면 거기서 하나 꺼냄
  /// 2) 아니면 nextAvailableValue에서 새 값 할당
  ///
  /// 시간 복잡도: 거의 O(1) (freeValues가 매우 작기 때문)
  int? requestFieldValue(int printerId) {
    if (state == null) {
      logger.w('필드 값 관리자가 초기화되지 않았습니다.');
      return null;
    }

    int? valueToAssign;
    Set<int> newFreeValues = state!.freeValues;

    // 1) freeValues에서 재사용 가능한 값이 있으면 하나 꺼내서 사용
    if (state!.freeValues.isNotEmpty) {
      // Set이므로 임의의 하나를 사용 (동시 프린터 수가 적으므로 괜찮음)
      valueToAssign = state!.freeValues.first;
      newFreeValues = Set<int>.from(state!.freeValues)..remove(valueToAssign);
      logger.d('재사용 가능한 필드 값 사용: $valueToAssign (프린터 $printerId)');
    } else {
      // 2) 새 값 할당
      if (state!.nextAvailableValue > state!.endCode) {
        logger.w('사용 가능한 필드 값이 없습니다. (범위: ${state!.startCode}-${state!.endCode}, 다음 값: ${state!.nextAvailableValue})');
        return null;
      }
      valueToAssign = state!.nextAvailableValue;
    }

    // 필드 값 할당
    final assigned = AssignedFieldValue(
      value: valueToAssign,
      printerId: printerId,
      assignedAt: DateTime.now(),
      status: FieldValueStatus.assigned,
    );

    // 상태 업데이트 (원자적 연산)
    final current = state!;
    state = current.copyWith(
      assignedValues: {...current.assignedValues, printerId: assigned},
      freeValues: newFreeValues,
      nextAvailableValue:
          (valueToAssign == current.nextAvailableValue) ? current.nextAvailableValue + 1 : current.nextAvailableValue,
    );

    logger.i(
      '필드 값 할당: 프린터 $printerId -> 값 $valueToAssign (범위: ${state!.startCode}-${state!.endCode}, 다음 새 값: ${state!.nextAvailableValue}, free=${state!.freeValues.length})',
    );
    return valueToAssign;
  }

  /// 포맷된 필드 값 요청
  /// - 내부적으로 requestFieldValue로 숫자 값을 할당받은 뒤
  /// - uniqueCode + 6자리 HEX 형태의 문자열로 변환하여 반환
  String? requestFormattedFieldValue(int printerId) {
    final value = requestFieldValue(printerId);
    if (value == null) return null;
    return formatFieldValue(value);
  }

  /// 필드 값 사용 중으로 표시 (프린터가 실제로 인쇄 시작)
  /// 이 메서드가 호출되면 타임아웃/재사용 대상에서 제외됨
  void markFieldValueInUse(int printerId) {
    if (state == null) return;

    final assigned = state!.assignedValues[printerId];
    if (assigned != null) {
      assigned.status = FieldValueStatus.inUse;
      state = state!.copyWith(assignedValues: {...state!.assignedValues, printerId: assigned});
      logger.d('필드 값 사용 중 표시: 프린터 $printerId -> 값 ${assigned.value} (재사용 금지)');
    }
  }

  /// 필드 값 해제 (프린터가 인쇄 완료 또는 연결 해제)
  ///
  /// 규칙:
  /// - 명시적으로 해제되는 값은 재사용하지 않음 (assigned, inUse 모두)
  /// - 재사용은 타임아웃 경로(_checkAndReleaseTimeoutValues)에서만 발생
  void releaseFieldValue(int printerId) {
    if (state == null) return;

    final assigned = state!.assignedValues[printerId];
    if (assigned != null) {
      final value = assigned.value;

      final newAssignedValues = Map<int, AssignedFieldValue>.from(state!.assignedValues)..remove(printerId);
      logger.i('필드 값 해제 (재사용 안 함): 프린터 $printerId -> 값 $value (상태: ${assigned.status})');

      state = state!.copyWith(assignedValues: newAssignedValues);
    }
  }

  /// 필드 값을 문자열로 변환 (프린터에 전송할 형식)
  /// 형식: uniqueCode + hex(value)
  String formatFieldValue(int value) {
    if (state == null) {
      logger.w('필드 값 관리자가 초기화되지 않았습니다.');
      return '';
    }

    final hexValue = value.toRadixString(16).padLeft(6, '0').toUpperCase();
    return state!.uniqueCode + hexValue;
  }

  /// 프린터의 현재 할당된 필드 값 조회
  int? getAssignedFieldValue(int printerId) {
    if (state == null) return null;
    return state!.assignedValues[printerId]?.value;
  }

  /// 필드 값 범위 재설정 (새 주문 시작 시)
  void resetRange({required int startCode, required int endCode, required String uniqueCode}) {
    logger.i('필드 값 범위 재설정: startCode=$startCode, endCode=$endCode, uniqueCode=$uniqueCode');
    state = FieldValueManagerState(startCode: startCode, endCode: endCode, uniqueCode: uniqueCode);
    _startTimeoutCheck();
  }

  /// 모든 할당 해제 (테스트/초기화용)
  void clearAll() {
    if (state == null) return;
    logger.i('모든 필드 값 할당 해제');
    state = state!.copyWith(assignedValues: {}, freeValues: {}, nextAvailableValue: state!.startCode);
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  /// 현재 상태 정보 조회 (디버깅/모니터링용)
  Map<String, dynamic> getStatus() {
    if (state == null) {
      return {'initialized': false};
    }

    final s = state!;

    return {
      'initialized': true,
      'startCode': s.startCode,
      'endCode': s.endCode,
      'uniqueCode': s.uniqueCode,
      'nextAvailableValue': s.nextAvailableValue,
      'availableCount': s.availableCount,
      'assignedCount': s.assignedCount,
      'assignedPrinters': s.assignedValues.keys.toList(),
      'freeValuesCount': s.freeValues.length,
      'rangeSize': s.endCode - s.startCode + 1,
    };
  }
}
