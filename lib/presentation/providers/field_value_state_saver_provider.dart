import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:print_manager/core/providers/isar_provider.dart';
import 'package:print_manager/core/data/models/order_field_value_state.dart';
import 'package:print_manager/core/data/models/order_field_value_metadata.dart';
import 'package:print_manager/core/data/models/order_printer_count.dart';
import 'package:print_manager/core/data/models/printer_last_order.dart';
import 'package:print_manager/core/services/logger_service.dart';

/// FieldValueStateSaver Provider
/// Isar가 준비될 때까지 기다린 후 FieldValueStateSaver를 반환합니다
final fieldValueStateSaverProvider = FutureProvider<FieldValueStateSaver>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return FieldValueStateSaver(isar);
});

/// 필드 값 상태 저장 관리자 (Isar 기반)
class FieldValueStateSaver {
  final Isar _isar;
  final Map<String, Future<void>> _pendingSaves = {}; // 중복 저장 방지

  FieldValueStateSaver(this._isar);

  /// 즉시 저장 (비동기, 블로킹 없음)
  void saveImmediately(OrderFieldValueState state) {
    final key = '${state.orderId}_${state.fieldValue}';

    // 이미 저장 중인 경우 스킵 (중복 저장 방지)
    if (_pendingSaves.containsKey(key)) {
      return;
    }

    // Future를 시작하되 await하지 않음 (fire-and-forget)
    _pendingSaves[key] = _saveToDatabase(state).then((_) {
      _pendingSaves.remove(key);
    }).catchError((e) {
      _pendingSaves.remove(key);
      logger.e('필드 값 상태 저장 실패: $e');
      // 재시도
      Future.delayed(const Duration(seconds: 1), () {
        saveImmediately(state);
      });
    });
  }

  /// 데이터베이스에 저장
  Future<void> _saveToDatabase(OrderFieldValueState state) async {
    await _isar.writeTxn(() async {
      await _isar.orderFieldValueStates.put(state);
    });
  }

  /// await로 완료 보장 (중요 데이터)
  Future<void> saveWithAwait(OrderFieldValueState state) async {
    await _isar.writeTxn(() async {
      await _isar.orderFieldValueStates.put(state);
    });
  }

  /// 여러 상태를 한 번에 저장 (트랜잭션)
  Future<void> saveBatch(List<OrderFieldValueState> states) async {
    await _isar.writeTxn(() async {
      for (final state in states) {
        await _isar.orderFieldValueStates.put(state);
      }
    });
  }

  /// 발주별 미완료 필드 값 상태 조회
  Future<List<OrderFieldValueState>> getIncompleteStates(int orderId) async {
    final allStates = await _isar.orderFieldValueStates.filter().orderIdEqualTo(orderId).sortByFieldValue().findAll();
    return allStates.where((state) => state.status != 'completed').toList();
  }

  /// 특정 필드 값 상태 조회
  Future<OrderFieldValueState?> getState(int orderId, int fieldValue) async {
    return await _isar.orderFieldValueStates.filter().orderIdEqualTo(orderId).fieldValueEqualTo(fieldValue).findFirst();
  }

  /// 발주별 모든 필드 값 상태 조회
  Future<List<OrderFieldValueState>> getAllStates(int orderId) async {
    return await _isar.orderFieldValueStates.filter().orderIdEqualTo(orderId).sortByFieldValue().findAll();
  }

  /// 오류 상태인 필드 값 조회 (재사용 가능)
  Future<List<OrderFieldValueState>> getErrorStates(int orderId) async {
    return await _isar.orderFieldValueStates
        .filter()
        .orderIdEqualTo(orderId)
        .statusEqualTo('error')
        .sortByFieldValue()
        .findAll();
  }

  /// 상태 업데이트
  Future<void> updateState(OrderFieldValueState state) async {
    await _isar.writeTxn(() async {
      await _isar.orderFieldValueStates.put(state);
    });
  }

  /// 앱 종료 시 모든 저장 완료 대기
  Future<void> flush() async {
    // 모든 pending 저장 완료 대기
    await Future.wait(_pendingSaves.values);
    _pendingSaves.clear();
  }

  // ========== 메타데이터 관련 메서드 ==========

  /// nextAvailableValue 즉시 저장 (비동기, 블로킹 없음)
  /// 주의: Future가 완료되기 전에 함수가 끝날 수 있으므로, 중요한 시점에서는 saveMetadataWithAwait 사용 권장
  void saveMetadataImmediately({
    required int orderId,
    required int nextAvailableValue,
    required int startCode,
    required int endCode,
    required String uniqueCode,
  }) {
    final key = 'metadata_$orderId';

    // 이미 저장 중인 경우 스킵 (중복 저장 방지)
    if (_pendingSaves.containsKey(key)) {
      return;
    }

    // Future를 시작하되 await하지 않음 (fire-and-forget)
    //
    // 동작 방식:
    // 1. Future를 호출하면 이벤트 루프에 등록됨
    // 2. 함수는 즉시 종료되지만, Future는 이벤트 루프에서 계속 실행됨
    // 3. 이벤트 루프는 Future가 완료될 때까지 실행함
    //
    // 예시:
    //   saveMetadataImmediately(...);  // Future 시작
    //   print('함수 종료');              // 즉시 실행
    //   // 하지만 Future는 이벤트 루프에서 계속 실행됨
    //   // → 저장은 진행됨 (대부분의 경우)
    //
    // 주의사항:
    // - 앱이 강제 종료되면 이벤트 루프도 중단됨
    // - 미완료된 Future는 손실될 수 있음
    // - 따라서 앱 종료 시 flush()를 호출하여 모든 저장 완료를 보장해야 함
    _pendingSaves[key] = _saveMetadataToDatabase(
      orderId: orderId,
      nextAvailableValue: nextAvailableValue,
      startCode: startCode,
      endCode: endCode,
      uniqueCode: uniqueCode,
    ).then((_) {
      _pendingSaves.remove(key);
    }).catchError((e) {
      _pendingSaves.remove(key);
      logger.e('메타데이터 저장 실패: $e');
      // 재시도
      Future.delayed(const Duration(seconds: 1), () {
        saveMetadataImmediately(
          orderId: orderId,
          nextAvailableValue: nextAvailableValue,
          startCode: startCode,
          endCode: endCode,
          uniqueCode: uniqueCode,
        );
      });
    });
  }

  /// nextAvailableValue 저장 (await로 완료 보장)
  /// 중요한 시점에서 사용 (예: 앱 종료 전, 중요한 상태 변경 시)
  Future<void> saveMetadataWithAwait({
    required int orderId,
    required int nextAvailableValue,
    required int startCode,
    required int endCode,
    required String uniqueCode,
  }) async {
    await _saveMetadataToDatabase(
      orderId: orderId,
      nextAvailableValue: nextAvailableValue,
      startCode: startCode,
      endCode: endCode,
      uniqueCode: uniqueCode,
    );
  }

  /// 메타데이터를 데이터베이스에 저장
  Future<void> _saveMetadataToDatabase({
    required int orderId,
    required int nextAvailableValue,
    required int startCode,
    required int endCode,
    required String uniqueCode,
  }) async {
    await _isar.writeTxn(() async {
      // 기존 메타데이터 조회 또는 새로 생성
      final existing = await _isar.orderFieldValueMetadatas.filter().orderIdEqualTo(orderId).findFirst();

      final metadata = existing ?? OrderFieldValueMetadata();
      metadata.orderId = orderId;
      metadata.nextAvailableValue = nextAvailableValue;
      metadata.startCode = startCode;
      metadata.endCode = endCode;
      metadata.uniqueCode = uniqueCode;
      metadata.updatedAt = DateTime.now();

      await _isar.orderFieldValueMetadatas.put(metadata);
    });
  }

  /// 발주별 메타데이터 조회
  Future<OrderFieldValueMetadata?> getMetadata(int orderId) async {
    return await _isar.orderFieldValueMetadatas.filter().orderIdEqualTo(orderId).findFirst();
  }

  /// 발주별 모든 데이터 삭제 (인쇄 완료 시)
  Future<void> clearOrderData(int orderId) async {
    await _isar.writeTxn(() async {
      // 메타데이터 삭제
      await _isar.orderFieldValueMetadatas.filter().orderIdEqualTo(orderId).deleteAll();

      // 필드 값 상태 삭제
      await _isar.orderFieldValueStates.filter().orderIdEqualTo(orderId).deleteAll();

      // 프린터 카운트 삭제
      await _isar.orderPrinterCounts.filter().orderIdEqualTo(orderId).deleteAll();
    });
    logger.i('발주별 데이터 삭제 완료: orderId=$orderId');
  }

  // ========== 디버그/조회 메서드 ==========

  /// 모든 메타데이터 조회 (디버그용)
  Future<List<OrderFieldValueMetadata>> getAllMetadata() async {
    return await _isar.orderFieldValueMetadatas.where().findAll();
  }

  /// 모든 발주의 모든 필드 값 상태 조회 (디버그용)
  Future<List<OrderFieldValueState>> getAllStatesDebug() async {
    return await _isar.orderFieldValueStates.where().findAll();
  }

  /// 발주별 통계 출력 (디버그용)
  /// 콘솔에 발주별 데이터 통계를 출력합니다
  Future<void> printOrderStatistics(int orderId) async {
    final metadata = await getMetadata(orderId);
    final states = await getAllStates(orderId);
    final incompleteStates = await getIncompleteStates(orderId);
    final errorStates = await getErrorStates(orderId);

    logger.i('═══════════════════════════════════════');
    logger.i('📊 발주 $orderId 통계');
    logger.i('═══════════════════════════════════════');

    // 메타데이터 정보
    if (metadata != null) {
      logger.i('📋 메타데이터:');
      logger.i('   - nextAvailableValue: ${metadata.nextAvailableValue}');
      logger.i('   - startCode: ${metadata.startCode}');
      logger.i('   - endCode: ${metadata.endCode}');
      logger.i('   - uniqueCode: ${metadata.uniqueCode}');
      logger.i('   - updatedAt: ${metadata.updatedAt}');
    } else {
      logger.i('📋 메타데이터: 없음');
    }

    // 필드 값 상태 통계
    logger.i('');
    logger.i('📦 필드 값 상태:');
    logger.i('   - 전체: ${states.length}개');
    logger.i('   - 미완료: ${incompleteStates.length}개');
    logger.i('   - 오류: ${errorStates.length}개');

    // 상태별 통계
    final statusCounts = <String, int>{};
    for (final state in states) {
      statusCounts[state.status] = (statusCounts[state.status] ?? 0) + 1;
    }
    logger.i('   - 상태별: $statusCounts');

    // 상세 정보 (최대 10개만)
    if (incompleteStates.isNotEmpty) {
      logger.i('');
      logger.i('📝 미완료 필드 값 (최대 10개):');
      final displayCount = incompleteStates.length > 10 ? 10 : incompleteStates.length;
      for (int i = 0; i < displayCount; i++) {
        final state = incompleteStates[i];
        logger.i('   ${i + 1}. 값: ${state.fieldValue}, 상태: ${state.status}, 프린터: ${state.printerId ?? "없음"}');
      }
      if (incompleteStates.length > 10) {
        logger.i('   ... 외 ${incompleteStates.length - 10}개');
      }
    }

    logger.i('═══════════════════════════════════════');
  }

  /// 모든 발주 통계 출력 (디버그용)
  /// 콘솔에 모든 발주의 데이터 통계를 출력합니다
  Future<void> printAllStatistics() async {
    final allMetadata = await getAllMetadata();
    final allStates = await getAllStatesDebug();

    logger.i('═══════════════════════════════════════');
    logger.i('📊 전체 Isar 데이터 통계');
    logger.i('═══════════════════════════════════════');
    logger.i('📋 메타데이터: ${allMetadata.length}개 발주');
    logger.i('📦 필드 값 상태: ${allStates.length}개');

    // 발주별 통계
    final orderStats = <int, Map<String, dynamic>>{};
    for (final state in allStates) {
      if (!orderStats.containsKey(state.orderId)) {
        orderStats[state.orderId] = {
          'total': 0,
          'assigned': 0,
          'inUse': 0,
          'completed': 0,
          'error': 0,
        };
      }
      final stats = orderStats[state.orderId]!;
      stats['total'] = (stats['total'] as int) + 1;
      stats[state.status] = (stats[state.status] as int) + 1;
    }

    logger.i('');
    logger.i('📊 발주별 통계:');
    for (final entry in orderStats.entries) {
      final orderId = entry.key;
      final stats = entry.value;
      logger.i(
          '   발주 $orderId: 전체 ${stats['total']}개 (assigned: ${stats['assigned']}, inUse: ${stats['inUse']}, completed: ${stats['completed']}, error: ${stats['error']})');
    }

    logger.i('═══════════════════════════════════════');
  }

  // ========== 발주별 프린터 카운트 관련 메서드 ==========

  /// 발주별 프린터 카운트 저장 (즉시, 비동기)
  void savePrinterCountImmediately({
    required int orderId,
    required int printerId,
    required int count,
  }) {
    final key = 'count_${orderId}_$printerId';

    // 이미 저장 중인 경우 스킵 (중복 저장 방지)
    if (_pendingSaves.containsKey(key)) {
      return;
    }

    // Future를 시작하되 await하지 않음 (fire-and-forget)
    _pendingSaves[key] = _savePrinterCountToDatabase(
      orderId: orderId,
      printerId: printerId,
      count: count,
    ).then((_) {
      _pendingSaves.remove(key);
    }).catchError((e) {
      _pendingSaves.remove(key);
      logger.e('프린터 카운트 저장 실패: $e');
      // 재시도
      Future.delayed(const Duration(seconds: 1), () {
        savePrinterCountImmediately(
          orderId: orderId,
          printerId: printerId,
          count: count,
        );
      });
    });
  }

  /// 프린터 카운트를 데이터베이스에 저장
  Future<void> _savePrinterCountToDatabase({
    required int orderId,
    required int printerId,
    required int count,
  }) async {
    await _isar.writeTxn(() async {
      // 기존 카운트 조회
      final existing =
          await _isar.orderPrinterCounts.filter().orderIdEqualTo(orderId).printerIdEqualTo(printerId).findFirst();

      final countRecord = existing ?? OrderPrinterCount();
      countRecord.orderId = orderId;
      countRecord.printerId = printerId;
      countRecord.count = count;
      countRecord.updatedAt = DateTime.now();
      if (existing == null) {
        countRecord.createdAt = DateTime.now();
      }

      await _isar.orderPrinterCounts.put(countRecord);
    });
  }

  /// 발주별 프린터 카운트 조회
  Future<int> getPrinterCount(int orderId, int printerId) async {
    final countRecord =
        await _isar.orderPrinterCounts.filter().orderIdEqualTo(orderId).printerIdEqualTo(printerId).findFirst();

    final count = countRecord?.count ?? 0;
    if (count > 0) {
      logger.d('📊 Isar에서 카운트 조회: orderId=$orderId, printerId=$printerId, count=$count');
    }
    return count;
  }

  /// 발주별 모든 프린터 카운트 조회
  Future<Map<int, int>> getAllPrinterCountsForOrder(int orderId) async {
    final counts = await _isar.orderPrinterCounts.filter().orderIdEqualTo(orderId).findAll();

    final result = <int, int>{};
    for (final countRecord in counts) {
      result[countRecord.printerId] = countRecord.count;
    }

    return result;
  }

  /// 발주별 모든 프린터 카운트 삭제 (인쇄 완료 시)
  Future<void> clearPrinterCountsForOrder(int orderId) async {
    await _isar.writeTxn(() async {
      await _isar.orderPrinterCounts.filter().orderIdEqualTo(orderId).deleteAll();
    });
    logger.i('발주별 프린터 카운트 삭제 완료: orderId=$orderId');
  }

  // ========== 프린터별 마지막 선택 발주 관련 메서드 ==========

  /// 프린터별 마지막 선택 발주 저장 (즉시, 비동기)
  void savePrinterLastOrderImmediately({
    required int printerId,
    required int orderId,
  }) {
    final key = 'lastOrder_$printerId';

    // 이미 저장 중인 경우 스킵 (중복 저장 방지)
    if (_pendingSaves.containsKey(key)) {
      return;
    }

    // Future를 시작하되 await하지 않음 (fire-and-forget)
    _pendingSaves[key] = _savePrinterLastOrderToDatabase(
      printerId: printerId,
      orderId: orderId,
    ).then((_) {
      _pendingSaves.remove(key);
    }).catchError((e) {
      _pendingSaves.remove(key);
      logger.e('프린터 마지막 발주 저장 실패: $e');
      // 재시도
      Future.delayed(const Duration(seconds: 1), () {
        savePrinterLastOrderImmediately(
          printerId: printerId,
          orderId: orderId,
        );
      });
    });
  }

  /// 프린터별 마지막 선택 발주를 데이터베이스에 저장
  Future<void> _savePrinterLastOrderToDatabase({
    required int printerId,
    required int orderId,
  }) async {
    await _isar.writeTxn(() async {
      // 기존 레코드 조회
      final existing = await _isar.printerLastOrders.filter().printerIdEqualTo(printerId).findFirst();

      final lastOrder = existing ?? PrinterLastOrder();
      lastOrder.printerId = printerId;
      lastOrder.orderId = orderId;
      lastOrder.updatedAt = DateTime.now();
      if (existing == null) {
        lastOrder.createdAt = DateTime.now();
      }

      await _isar.printerLastOrders.put(lastOrder);
    });
  }

  /// 프린터별 마지막 선택 발주 조회
  Future<int?> getPrinterLastOrder(int printerId) async {
    final lastOrder = await _isar.printerLastOrders.filter().printerIdEqualTo(printerId).findFirst();
    return lastOrder?.orderId;
  }

  /// 프린터별 마지막 선택 발주 삭제
  Future<void> clearPrinterLastOrder(int printerId) async {
    await _isar.writeTxn(() async {
      await _isar.printerLastOrders.filter().printerIdEqualTo(printerId).deleteAll();
    });
    logger.i('프린터 마지막 발주 삭제 완료: printerId=$printerId');
  }

  /// 모든 Isar 데이터 초기화 (모든 컬렉션 삭제)
  /// 주의: 이 메서드는 모든 데이터를 영구적으로 삭제합니다.
  Future<void> clearAllData() async {
    await _isar.writeTxn(() async {
      // 모든 컬렉션 데이터 삭제
      await _isar.orderFieldValueStates.clear();
      await _isar.orderFieldValueMetadatas.clear();
      await _isar.orderPrinterCounts.clear();
      await _isar.printerLastOrders.clear();
    });

    // 삭제 확인
    final remainingStates = await _isar.orderFieldValueStates.count();
    final remainingMetadata = await _isar.orderFieldValueMetadatas.count();
    final remainingCounts = await _isar.orderPrinterCounts.count();
    final remainingLastOrders = await _isar.printerLastOrders.count();

    logger.i('모든 Isar 데이터 초기화 완료');
    logger.i(
        '삭제 확인: states=$remainingStates, metadata=$remainingMetadata, counts=$remainingCounts, lastOrders=$remainingLastOrders');

    if (remainingStates > 0 || remainingMetadata > 0 || remainingCounts > 0 || remainingLastOrders > 0) {
      logger.w('⚠️ 일부 데이터가 남아있습니다! 수동으로 다시 삭제를 시도합니다.');
      // 재시도
      await _isar.writeTxn(() async {
        await _isar.orderFieldValueStates.clear();
        await _isar.orderFieldValueMetadatas.clear();
        await _isar.orderPrinterCounts.clear();
        await _isar.printerLastOrders.clear();
      });

      final retryStates = await _isar.orderFieldValueStates.count();
      final retryMetadata = await _isar.orderFieldValueMetadatas.count();
      final retryCounts = await _isar.orderPrinterCounts.count();
      final retryLastOrders = await _isar.printerLastOrders.count();

      logger.i(
          '재시도 후 삭제 확인: states=$retryStates, metadata=$retryMetadata, counts=$retryCounts, lastOrders=$retryLastOrders');
    }
  }
}
