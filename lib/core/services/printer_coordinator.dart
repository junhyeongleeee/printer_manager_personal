import 'package:print_manager/domain/entities/managed_printer.dart';
import 'package:print_manager/core/services/logger_service.dart';

/// 여러 프린터를 동시에 제어하는 코디네이터
/// 여러 프린터에 동시에 작업을 할당하고 관리합니다.
class PrinterCoordinator {
  final List<ManagedPrinter> _printers = [];
  
  /// 프린터 추가
  void addPrinter(ManagedPrinter printer) {
    if (!_printers.contains(printer)) {
      _printers.add(printer);
    }
  }
  
  /// 프린터 제거
  void removePrinter(ManagedPrinter printer) {
    _printers.remove(printer);
  }
  
  /// 모든 프린터 연결
  Future<Map<ManagedPrinter, bool>> connectAll() async {
    final results = <ManagedPrinter, bool>{};
    
    // 모든 프린터를 동시에 연결 시도
    final futures = _printers.map((printer) async {
      try {
        final result = await printer.connect();
        return MapEntry(printer, result);
      } catch (e) {
        logger.i('프린터 ${printer.name} 연결 실패: $e');
        return MapEntry(printer, false);
      }
    });
    
    final connectionResults = await Future.wait(futures);
    for (final entry in connectionResults) {
      results[entry.key] = entry.value;
    }
    
    return results;
  }
  
  /// 여러 프린터에 동시에 인쇄 작업 할당
  Future<Map<ManagedPrinter, bool>> assignPrintJobsConcurrently({
    required List<PrintJobAssignment> assignments,
  }) async {
    final results = <ManagedPrinter, bool>{};
    
    // 각 프린터에 작업을 동시에 할당
    final futures = assignments.map((assignment) async {
      try {
        final printer = _printers.firstWhere(
          (p) => p.id == assignment.printerId,
          orElse: () => throw Exception('프린터 ${assignment.printerId}를 찾을 수 없습니다.'),
        );
        
        await printer.printJobRepeatedly(
          jobName: assignment.jobName,
          uniqueCode: assignment.uniqueCode,
          start: assignment.start,
          end: assignment.end,
        );
        
        return MapEntry(printer, true);
      } catch (e) {
        logger.i('프린터 ${assignment.printerId} 작업 할당 실패: $e');
        return MapEntry(
          _printers.firstWhere((p) => p.id == assignment.printerId),
          false,
        );
      }
    });
    
    final jobResults = await Future.wait(futures);
    for (final entry in jobResults) {
      results[entry.key] = entry.value;
    }
    
    return results;
  }
  
  /// 모든 프린터 상태 조회
  Future<Map<ManagedPrinter, String>> getAllStatuses() async {
    final statuses = <ManagedPrinter, String>{};
    
    // 모든 프린터의 상태를 동시에 조회
    final futures = _printers.map((printer) async {
      try {
        await printer.getPrinterStatus();
        return MapEntry(printer, printer.connectStatus);
      } catch (e) {
        logger.i('프린터 ${printer.name} 상태 조회 실패: $e');
        return MapEntry(printer, '오류');
      }
    });
    
    final statusResults = await Future.wait(futures);
    for (final entry in statusResults) {
      statuses[entry.key] = entry.value;
    }
    
    return statuses;
  }
  
  /// 모든 프린터 연결 해제
  Future<void> disconnectAll() async {
    final futures = _printers.map((printer) => printer.dispose());
    await Future.wait(futures);
  }
  
  /// 특정 프린터 찾기
  ManagedPrinter? findPrinter(int printerId) {
    try {
      return _printers.firstWhere((p) => p.id == printerId);
    } catch (e) {
      return null;
    }
  }
  
  /// 모든 프린터 목록
  List<ManagedPrinter> get printers => List.unmodifiable(_printers);
}

/// 인쇄 작업 할당 정보
class PrintJobAssignment {
  final int printerId;
  final String jobName;
  final String uniqueCode;
  final int start;
  final int end;
  
  PrintJobAssignment({
    required this.printerId,
    required this.jobName,
    required this.uniqueCode,
    required this.start,
    required this.end,
  });
}

