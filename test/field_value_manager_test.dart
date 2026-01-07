import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:print_manager/presentation/providers/field_value_manager_provider.dart';

void main() {
  group('FieldValueManager - 기본 동작', () {
    test('단일 프린터가 연속으로 요청할 때 항상 새로운 필드 값이 할당된다', () {
      final manager = FieldValueManagerNotifier();
      manager.initialize(startCode: 1, endCode: 1000, uniqueCode: 'ABC');

      final values = <String>{};

      // 프린터 ID = 1, 100번 연속 요청
      for (int i = 0; i < 100; i++) {
        final v = manager.requestFormattedFieldValue(1);
        expect(v, isNotNull, reason: '요청 $i 에서 null 이 반환되면 안 됨');
        values.add(v!);
      }

      // 모두 유일해야 함
      expect(values.length, 100);
    });

    test('여러 프린터가 동시에 요청해도 필드 값이 전역적으로 유일하다', () {
      final manager = FieldValueManagerNotifier();
      manager.initialize(startCode: 1, endCode: 100000, uniqueCode: 'ZZZ');

      final printerIds = [1, 2, 3, 4, 5];
      const perPrinter = 200;

      final allValues = <String>{};

      for (final id in printerIds) {
        for (int i = 0; i < perPrinter; i++) {
          final v = manager.requestFormattedFieldValue(id);
          expect(v, isNotNull, reason: '프린터 $id 에 대한 요청 $i 에서 null 이 반환되면 안 됨');
          allValues.add(v!);
        }
      }

      // 전체 유일성 검사
      expect(allValues.length, printerIds.length * perPrinter);
    });

    test('범위를 초과하면 null을 반환한다', () {
      final manager = FieldValueManagerNotifier();
      // 1 ~ 3 까지만 허용
      manager.initialize(startCode: 1, endCode: 3, uniqueCode: 'AAA');

      final v1 = manager.requestFormattedFieldValue(1);
      final v2 = manager.requestFormattedFieldValue(2);
      final v3 = manager.requestFormattedFieldValue(3);
      final v4 = manager.requestFormattedFieldValue(4); // 범위 초과

      expect(v1, isNotNull);
      expect(v2, isNotNull);
      expect(v3, isNotNull);
      expect(v4, isNull);
    });
  });

  group('FieldValueManager - 재사용 및 해제 로직', () {
    test('assigned 상태에서 해제하면 freeValues 를 통해 재사용된다', () {
      final manager = FieldValueManagerNotifier();
      // 작은 범위로 테스트
      manager.initialize(startCode: 1, endCode: 3, uniqueCode: 'R1');

      // 프린터 1, 2, 3 에게 하나씩 할당
      final v1 = manager.requestFormattedFieldValue(1);
      final v2 = manager.requestFormattedFieldValue(2);
      final v3 = manager.requestFormattedFieldValue(3);

      expect(v1, isNotNull);
      expect(v2, isNotNull);
      expect(v3, isNotNull);

      // 아직 inUse 로 표시하지 않았으므로 모두 assigned 상태
      // 프린터 1, 2 의 값을 해제 → freeValues 로 들어가야 함
      manager.releaseFieldValue(1);
      manager.releaseFieldValue(2);

      final statusAfterRelease = manager.getStatus();
      expect(statusAfterRelease['freeValuesCount'], 2, reason: '해제된 2개의 값이 freeValues 에 들어가야 함');

      // 이제 새로운 프린터들이 요청하면, freeValues 에서 값을 재사용해야 하므로
      // null 이 아니라 유효한 값이 나와야 한다 (범위는 이미 다 소진된 상태)
      final v4 = manager.requestFormattedFieldValue(4);
      final v5 = manager.requestFormattedFieldValue(5);

      expect(v4, isNotNull, reason: '범위 1~3 이 이미 소진되었지만 freeValues 덕분에 재사용되어야 함');
      expect(v5, isNotNull, reason: '범위 1~3 이 이미 소진되었지만 freeValues 덕분에 재사용되어야 함');
    });

    test('inUse 상태에서 해제하면 재사용되지 않는다', () {
      final manager = FieldValueManagerNotifier();
      manager.initialize(startCode: 1, endCode: 3, uniqueCode: 'U1');

      final v1 = manager.requestFormattedFieldValue(1);
      expect(v1, isNotNull);

      // 인쇄 시작 시점에 inUse 로 표시
      manager.markFieldValueInUse(1);

      // inUse 상태에서 해제 → freeValues 로 가지 않아야 함
      manager.releaseFieldValue(1);

      final status = manager.getStatus();
      expect(status['freeValuesCount'], 0, reason: 'inUse 상태에서 해제된 값은 재사용 대상이 아니어야 함');
    });
  });

  group('FieldValueManager - 범위 리셋 및 초기화', () {
    test('resetRange 후에는 새로운 범위에서 다시 시작한다', () {
      final manager = FieldValueManagerNotifier();
      manager.initialize(startCode: 1, endCode: 10, uniqueCode: 'X1');

      final first = manager.requestFormattedFieldValue(1);
      expect(first, isNotNull);

      // 범위를 100~200 으로 리셋
      manager.resetRange(startCode: 100, endCode: 200, uniqueCode: 'Y1');

      final status = manager.getStatus();
      expect(status['startCode'], 100);
      expect(status['endCode'], 200);
      expect(status['nextAvailableValue'], 100);

      final afterReset = manager.requestFormattedFieldValue(1);
      expect(afterReset, isNotNull);
      expect(afterReset, isNot(equals(first)), reason: 'resetRange 이후에는 이전 범위 값과 달라야 함');
    });

    test('clearAll 은 모든 상태를 초기화하고 다음 값은 startCode 에서 다시 시작한다', () {
      final manager = FieldValueManagerNotifier();
      manager.initialize(startCode: 50, endCode: 60, uniqueCode: 'Z1');

      final v1 = manager.requestFormattedFieldValue(1);
      expect(v1, isNotNull);

      manager.clearAll();

      final status = manager.getStatus();
      expect(status['assignedCount'], 0);
      expect(status['freeValuesCount'], 0);
      expect(status['nextAvailableValue'], 50);

      final v2 = manager.requestFormattedFieldValue(1);
      expect(v2, isNotNull);
    });
  });

  group('FieldValueManager - 실제 프로세스 시뮬레이션', () {
    test('여러 프린터가 동시에 작동하며 200ms 폴링으로 필드 값을 업데이트한다', () async {
      final manager = FieldValueManagerNotifier();
      manager.initialize(startCode: 1, endCode: 10000, uniqueCode: 'TEST');

      const printerCount = 5; // 프린터 5대
      const totalPrintsPerPrinter = 20; // 각 프린터당 20장 인쇄 (700ms × 20 = 최소 14초)
      const pollingInterval = Duration(milliseconds: 200); // 200ms 폴링

      // 각 프린터의 카운트 상태 (프린터 ID -> 현재 카운트)
      final printerCounts = <int, int>{};
      for (int i = 1; i <= printerCount; i++) {
        printerCounts[i] = 0;
      }

      // 각 프린터의 프린트 이벤트 타임스탬프 (센서 트리거 시뮬레이션)
      final printEvents = <int, List<DateTime>>{};
      for (int i = 1; i <= printerCount; i++) {
        printEvents[i] = [];
      }

      // 모든 프린터가 할당한 필드 값 (중복 검사용)
      final allAssignedValues = <String>{};

      // 프린터 시뮬레이션: 각 프린터가 랜덤한 간격으로 프린트 발생
      final printerTasks = <Future<void>>[];
      for (int printerId = 1; printerId <= printerCount; printerId++) {
        printerTasks.add(
          _simulatePrinter(
            printerId: printerId,
            totalPrints: totalPrintsPerPrinter,
            printEvents: printEvents[printerId]!,
          ),
        );
      }

      // 폴링 시뮬레이션: 200ms마다 모든 프린터의 카운트를 확인하고 필드 값 업데이트
      final pollingTask = _simulatePolling(
        manager: manager,
        printerCounts: printerCounts,
        printEvents: printEvents,
        pollingInterval: pollingInterval,
        allAssignedValues: allAssignedValues,
        totalPrintsPerPrinter: totalPrintsPerPrinter,
      );

      // 모든 프린터 시뮬레이션과 폴링이 완료될 때까지 대기 (타임아웃: 2분)
      await Future.wait([...printerTasks, pollingTask]).timeout(
        Duration(minutes: 2),
        onTimeout: () {
          throw TimeoutException('테스트가 2분 내에 완료되지 않았습니다');
        },
      );

      // 검증: 모든 필드 값이 유일해야 함
      expect(allAssignedValues.length, printerCount * totalPrintsPerPrinter, reason: '모든 프린터가 할당한 필드 값은 전역적으로 유일해야 함');

      // 검증: 각 프린터가 예상한 만큼 필드 값을 할당받았는지
      for (int printerId = 1; printerId <= printerCount; printerId++) {
        expect(
          printerCounts[printerId],
          totalPrintsPerPrinter,
          reason: '프린터 $printerId는 $totalPrintsPerPrinter번 필드 값을 할당받아야 함',
        );
      }

      // 참고: 인쇄/해제 타이밍에 따라 남은 할당이 없어도 문제 아님(정상 종료 가능)
    });

    test('동시에 많은 프린터가 빠르게 요청해도 중복이 발생하지 않는다', () async {
      final manager = FieldValueManagerNotifier();
      manager.initialize(startCode: 1, endCode: 50000, uniqueCode: 'STRESS');

      const printerCount = 10; // 프린터 10대
      const requestsPerPrinter = 100; // 각 프린터당 100번 요청

      final allValues = <String>{};
      final futures = <Future<void>>[];

      // 모든 프린터가 거의 동시에 요청 시작
      for (int printerId = 1; printerId <= printerCount; printerId++) {
        futures.add(
          _simulateConcurrentRequests(
            manager: manager,
            printerId: printerId,
            requestCount: requestsPerPrinter,
            allValues: allValues,
          ),
        );
      }

      await Future.wait(futures);

      // 검증: 모든 값이 유일해야 함
      expect(allValues.length, printerCount * requestsPerPrinter, reason: '동시 요청이 많아도 중복이 없어야 함');
    });

    test('할당되었지만 해제되지 않은 값은 타임아웃 후 재사용된다', () {
      final manager = FieldValueManagerNotifier();
      manager.initialize(startCode: 1, endCode: 5, uniqueCode: 'TIMEOUT');

      // 1. 정상적으로 해제된 값은 재사용되지 않음을 확인
      final value1 = manager.requestFormattedFieldValue(1);
      expect(value1, isNotNull);
      manager.markFieldValueInUse(1);
      manager.releaseFieldValue(1); // 정상 해제

      final statusAfterNormalRelease = manager.getStatus();
      expect(statusAfterNormalRelease['freeValuesCount'], 0, reason: '정상적으로 해제된 값은 재사용되지 않아야 함');

      // 2. 프린터 2가 필드 값을 할당받지만, markFieldValueInUse를 호출하지 않음
      //    (프린터 문제로 인쇄가 시작되지 않은 상황 시뮬레이션)
      final value2 = manager.requestFormattedFieldValue(2);
      expect(value2, isNotNull);
      expect(manager.getStatus()['assignedCount'], 1, reason: '프린터 2만 할당되어 있어야 함');

      // 3. assignedAt을 31초 전으로 설정하여 타임아웃 조건 만족
      manager.debugSetAssignedAtToPast(2, Duration(seconds: 31));

      // 4. 타임아웃 체크 실행 (실제로는 5초마다 자동 실행되지만, 테스트를 위해 수동 호출)
      manager.debugCheckTimeoutsNow();

      // 5. 타임아웃된 값이 freeValues에 추가되었는지 확인
      final statusAfterTimeout = manager.getStatus();
      expect(statusAfterTimeout['freeValuesCount'], 1, reason: '타임아웃된 값이 freeValues에 추가되어야 함');
      expect(statusAfterTimeout['assignedCount'], 0, reason: '타임아웃된 값은 assignedValues에서 제거되어야 함');

      // 6. 범위를 다 소진한 후, 타임아웃된 값이 재사용되는지 확인
      //    프린터 3, 4, 5가 값 3, 4, 5를 할당받음
      for (int i = 3; i <= 5; i++) {
        final v = manager.requestFormattedFieldValue(i);
        expect(v, isNotNull, reason: '프린터 $i는 필드 값을 할당받아야 함');
      }

      // 현재 상태:
      // - nextAvailableValue = 6 (범위 초과)
      // - freeValues = {2} (프린터 2가 타임아웃되어 추가됨)
      // - assignedValues = {3: 값3, 4: 값4, 5: 값5}

      // 7. 범위를 초과했지만 freeValues에 값이 있으면 재사용되어야 함
      final value6 = manager.requestFormattedFieldValue(6);
      expect(value6, isNotNull, reason: 'freeValues에 값이 있으면 재사용되어야 함');
      expect(value6, equals('TIMEOUT000005'), reason: '재사용된 값은 프린터 2가 할당받았던 값(타임아웃된 값)과 같아야 함');

      // 8. 이제 freeValues도 비어있고 범위도 초과했으므로 null이어야 함
      final value7 = manager.requestFormattedFieldValue(7);
      expect(value7, isNull, reason: 'freeValues도 비어있고 범위도 초과했으므로 null이어야 함');
    });
  });
}

/// 프린터 시뮬레이션: 랜덤한 간격으로 프린트 이벤트 발생
Future<void> _simulatePrinter({
  required int printerId,
  required int totalPrints,
  required List<DateTime> printEvents,
}) async {
  final random = DateTime.now().millisecondsSinceEpoch % 1000;

  for (int i = 0; i < totalPrints; i++) {
    // 프린터 실제 딜레이 반영: 최소 700ms 이상 (700ms ~ 1100ms)
    final delay = Duration(milliseconds: 700 + (random % 400));
    await Future.delayed(delay);

    // 프린트 이벤트 기록 (센서 트리거 시뮬레이션)
    printEvents.add(DateTime.now());
  }
}

/// 폴링 시뮬레이션: 200ms마다 모든 프린터의 카운트를 확인하고 필드 값 업데이트
Future<void> _simulatePolling({
  required FieldValueManagerNotifier manager,
  required Map<int, int> printerCounts,
  required Map<int, List<DateTime>> printEvents,
  required Duration pollingInterval,
  required Set<String> allAssignedValues,
  required int totalPrintsPerPrinter,
}) async {
  final startTime = DateTime.now();
  final maxDuration = Duration(seconds: 60); // 최대 60초 동안 폴링

  while (DateTime.now().difference(startTime) < maxDuration) {
    // 모든 프린터의 카운트 확인
    for (final entry in printEvents.entries) {
      final printerId = entry.key;
      final events = entry.value;

      // 현재 시점까지 발생한 프린트 이벤트 수 계산
      final currentCount = events.length;

      // 이전 카운트와 비교하여 변경이 있으면 필드 값 업데이트
      if (currentCount > printerCounts[printerId]!) {
        final fieldValue = manager.requestFormattedFieldValue(printerId);
        if (fieldValue != null) {
          allAssignedValues.add(fieldValue);
          printerCounts[printerId] = currentCount;

          // 인쇄 완료 시뮬레이션: inUse로 표시
          manager.markFieldValueInUse(printerId);
          // 실제 인쇄 완료 후 해제 (짧은 지연 후)
          Future.delayed(Duration(milliseconds: 50), () {
            manager.releaseFieldValue(printerId);
          });
        }
      }
    }

    // 모든 프린터가 완료되었는지 확인
    bool allCompleted = true;
    for (final entry in printerCounts.entries) {
      if (entry.value < totalPrintsPerPrinter) {
        allCompleted = false;
        break;
      }
    }

    if (allCompleted) {
      // 모든 프린터가 완료되었으므로 폴링 종료
      // 마지막으로 한 번 더 확인하여 누락된 이벤트가 없는지 체크
      await Future.delayed(pollingInterval);
      for (final entry in printEvents.entries) {
        final printerId = entry.key;
        final events = entry.value;
        final currentCount = events.length;
        if (currentCount > printerCounts[printerId]!) {
          final fieldValue = manager.requestFormattedFieldValue(printerId);
          if (fieldValue != null) {
            allAssignedValues.add(fieldValue);
            printerCounts[printerId] = currentCount;
            manager.markFieldValueInUse(printerId);
            Future.delayed(Duration(milliseconds: 50), () {
              manager.releaseFieldValue(printerId);
            });
          }
        }
      }
      break;
    }

    // 200ms 대기 (폴링 간격)
    await Future.delayed(pollingInterval);
  }
}

/// 동시 요청 시뮬레이션: 한 프린터가 빠르게 연속 요청
Future<void> _simulateConcurrentRequests({
  required FieldValueManagerNotifier manager,
  required int printerId,
  required int requestCount,
  required Set<String> allValues,
}) async {
  final futures = <Future<void>>[];

  for (int i = 0; i < requestCount; i++) {
    // 거의 동시에 요청 (약간의 랜덤 지연)
    final delay = Duration(milliseconds: (i * 2) % 10);
    futures.add(
      Future.delayed(delay, () {
        final value = manager.requestFormattedFieldValue(printerId);
        if (value != null) {
          allValues.add(value);
        }
      }),
    );
  }

  await Future.wait(futures);
}
