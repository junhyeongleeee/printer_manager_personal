import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_manager/presentation/providers/field_value_manager_provider.dart';
import 'package:print_manager/presentation/providers/field_value_state_saver_provider.dart';
import 'package:print_manager/core/services/logger_service.dart';

/// 발주별 FieldValueManager를 관리하는 Registry
class FieldValueManagerRegistry {
  final Map<int, FieldValueManagerNotifier> _managers = {};
  final Ref _ref;

  FieldValueManagerRegistry(this._ref);

  /// 발주별 FieldValueManager 가져오기 또는 생성
  /// Isar에서 데이터 복원을 시도하고, 없으면 새로 초기화
  /// [currentTotalCount]: 현재까지 인쇄된 총 카운트 (필드 값과 동기화하기 위해 필요)
  Future<FieldValueManagerNotifier> getOrCreateManager(
    int orderId, {
    required int startCode,
    required int endCode,
    required String uniqueCode,
    int? currentTotalCount,
  }) async {
    if (!_managers.containsKey(orderId)) {
      // Isar가 준비될 때까지 기다림
      final saver = await _ref.read(fieldValueStateSaverProvider.future);
      final manager = FieldValueManagerNotifier(orderId: orderId, saver: saver);
      // Isar에서 데이터 복원 시도 (저장된 데이터가 있으면 복원, 없으면 새로 초기화)
      await manager.initializeAndRestore(
        startCode: startCode,
        endCode: endCode,
        uniqueCode: uniqueCode,
        currentTotalCount: currentTotalCount,
      );
      _managers[orderId] = manager;
      logger.i('발주별 FieldValueManager 생성 및 복원 완료: orderId=$orderId, currentTotalCount=$currentTotalCount');
    }
    return _managers[orderId]!;
  }

  /// 발주별 FieldValueManager 가져오기
  FieldValueManagerNotifier? getManager(int orderId) {
    return _managers[orderId];
  }

  /// 발주별 FieldValueManager 제거
  void removeManager(int orderId) {
    _managers[orderId]?.dispose();
    _managers.remove(orderId);
    logger.i('발주별 FieldValueManager 제거: orderId=$orderId');
  }

  /// 발주별 데이터 초기화 (인쇄 완료 시)
  Future<void> clearOrderData(int orderId) async {
    final manager = _managers[orderId];
    if (manager != null) {
      await manager.clearOrderData();
      logger.i('발주별 데이터 초기화 완료: orderId=$orderId');
    } else {
      logger.w('발주별 FieldValueManager를 찾을 수 없음: orderId=$orderId');
    }
  }

  /// 모든 관리자 정리
  void dispose() {
    for (final manager in _managers.values) {
      manager.dispose();
    }
    _managers.clear();
    logger.i('모든 FieldValueManager 정리 완료');
  }
}

/// 발주별 FieldValueManager Registry Provider
final fieldValueManagerRegistryProvider = Provider<FieldValueManagerRegistry>((ref) {
  return FieldValueManagerRegistry(ref);
});

/// 발주별 FieldValueManager Provider (Family)
/// 주의: 이 Provider는 FutureProvider를 사용하므로 직접 사용 시 await가 필요합니다.
/// 대신 fieldValueManagerRegistryProvider를 사용하는 것을 권장합니다.
@Deprecated('Use fieldValueManagerRegistryProvider.getOrCreateManager() instead')
final fieldValueManagerByOrderProvider =
    StateNotifierProvider.family<FieldValueManagerNotifier, FieldValueManagerState?, int>((ref, orderId) {
  // 이 Provider는 FutureProvider를 직접 사용할 수 없으므로 사용하지 않는 것을 권장합니다.
  // 대신 fieldValueManagerRegistryProvider.getOrCreateManager()를 사용하세요.
  throw UnimplementedError('Use fieldValueManagerRegistryProvider.getOrCreateManager() instead');
});
