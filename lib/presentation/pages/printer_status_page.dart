import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_manager/core/data/models/request/patch_order_request.dart';
import 'package:print_manager/presentation/pages/order_manage_page.dart';
import '../providers/printer_list_provider.dart';
import '../providers/order_list_provider.dart';
import '../providers/field_value_manager_registry_provider.dart';
import '../providers/field_value_state_saver_provider.dart';
import '../widgets/common_alert_dialog.dart';
import '../../core/domain/entities/managed_printer.dart';
import '../../core/domain/entities/order_item.dart';
import '../../core/data/enums/printer_connection_status.dart';
import '../../core/data/enums/printer_print_status.dart';
import 'package:print_manager/core/data/models/request/printers_request.dart';
import 'package:print_manager/core/data/repositories/printer_repository_provider.dart';
import 'package:print_manager/core/data/repositories/order_repository_provider.dart';
import 'package:print_manager/core/data/models/request/print_event_request.dart';
import 'package:print_manager/core/services/logger_service.dart';

class PrinterStatusPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<PrinterStatusPage> createState() => _PrinterStatusPageState();
}

// 프린터 상태 타입 (React 프로젝트와 동일)
enum PrinterStatusType {
  all,
  online, // 대기중
  running, // 가동중
  offline, // 오프라인
}

/// UI 상수 (Windows UI 스타일)
class _PrinterStatusUIConstants {
  static const double horizontalPadding = 16.0;
  static const double cardSpacing = 16.0;
  static const double cardBorderRadius = 2.0; // Windows 스타일: 약간 둥근 모서리
  static const double buttonHeight = 32.0;
  static const double buttonBorderRadius = 2.0;

  // 폰트 패밀리
  static const String fontFamily = 'Pretendard';

  // 텍스트 스타일 헬퍼 메서드
  static TextStyle textStyle({double? fontSize, FontWeight? fontWeight, Color? color, String? fontFamily}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: fontFamily ?? _PrinterStatusUIConstants.fontFamily,
    );
  }

  // Windows 색상
  static const Color windowTitleBarStart = Color(0xFF0078D4);
  static const Color windowTitleBarEnd = Color(0xFF005A9E);
  static const Color toolbarBg = Color(0xFFE8E8E8);
  static const Color borderColor = Color(0xFFADADAD);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color cardHeaderStart = Color(0xFFE8E8E8);
  static const Color cardHeaderEnd = Color(0xFFD0D0D0);
  static const Color statusBarBg = Color(0xFFE8E8E8);

  // 상태 색상
  static const Color onlineColor = Color(0xFF4CAF50);
  static const Color printingColor = Color(0xFF2196F3);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color offlineColor = Color(0xFFF44336);

  // 기존 호환성 색상
  static const Color primaryBlue = Color(0xFF0078D4);
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x1A000000);
  static const Color errorColor = Color(0xFFF44336);

  // 카드 배경색 (상태별)
  static Color getCardBgColor(PrinterStatusType status) {
    switch (status) {
      case PrinterStatusType.online:
        return Color(0xFFF1F8F4); // 연한 녹색
      case PrinterStatusType.running:
        return Color(0xFFE3F2FD); // 연한 파란색
      case PrinterStatusType.offline:
        return Color(0xFFFFEBEE); // 연한 빨간색
      default:
        return cardBg;
    }
  }
}

/// 발주별 print-event 상태 관리
class _PrintEventState {
  final int orderId;
  final int unit; // 단위 (예: 1)
  int lastApiCount; // 마지막 API 호출 시점의 카운트
  DateTime? lastApiTime; // 마지막 API 호출 시간
  Timer? timer; // 5분 타이머

  _PrintEventState({
    required this.orderId,
    this.unit = 1, // 기본값 1
    this.lastApiCount = 0,
  });

  void dispose() {
    timer?.cancel();
    timer = null;
  }
}

class _PrinterStatusPageState extends ConsumerState<PrinterStatusPage> {
  PrinterStatusType _selectedFilter = PrinterStatusType.all;

  // 발주별 완료 수량 (메모리에 저장, 실시간 카운트 증가 시 ++ 연산으로 업데이트)
  // key: orderId, value: 완료 수량
  final Map<int, int> _orderCompletedCounts = {};

  // 발주별 접기/펴기 상태 (key: orderId (null 포함), value: true면 펼침, false면 접힘)
  // 기본값은 true (펼침 상태)
  final Map<int?, bool> _expandedOrders = {};

  // 발주별 print-event 상태 관리
  // key: orderId, value: _PrintEventState
  final Map<int, _PrintEventState> _printEventStates = {};

  @override
  void initState() {
    super.initState();
    _initializePrinters();
  }

  /// 프린터 초기화
  Future<void> _initializePrinters() async {
    try {
      await _refreshPrinterList();

      // 발주 목록이 비어있으면 잠시 대기 (다른 페이지에서 로드될 수 있음)
      final orders = ref.read(orderListProvider);
      if (orders.isEmpty) {
        logger.i('발주 목록이 비어있어 복원을 위해 대기합니다...');
        await Future.delayed(const Duration(milliseconds: 1000));
      }

      await _initConnection();

      // 복원 후 UI 갱신
      if (mounted) {
        setState(() {});
      }
    } catch (e, stack) {
      debugPrint('_initializePrinters error: $e\n$stack');
    }
  }

  /// 프린터 목록 새로고침 (API에서 목록 다시 가져오기)
  Future<void> _refreshPrinterList() async {
    final printerRepository = ref.read(printerRepositoryProvider);
    final response = await printerRepository.printerList();
    ref.read(printerListProvider.notifier).mergeNewData(ref, response);
  }

  /// 프린터 연결 상태 확인 (새로고침 버튼용)
  /// 현재 등록된 프린터들의 연결 상태를 다시 체크
  Future<void> _checkPrinterConnections() async {
    final printerList = ref.read(printerListProvider);
    for (final printer in printerList) {
      try {
        // 발주 완료 체크 콜백 전달
        await printer.checkConnectionStatus(
          onCompletedCountCheck: () {
            final selectedOrder = printer.selectedOrder;
            if (selectedOrder != null) {
              final totalCompleted = _getTotalCompletedCountForOrder(selectedOrder.orderId);
              final totalQuantity = selectedOrder.quantity;
              return totalCompleted >= totalQuantity;
            }
            return false;
          },
        );
      } catch (e) {
        logger.e('프린터 ${printer.name} 연결 상태 확인 실패: $e');
      }
    }
    // Provider 상태 갱신 (statusbar 업데이트를 위해)
    ref.read(printerListProvider.notifier).refreshState();
    // UI 갱신
    if (mounted) {
      setState(() {});
    }
  }

  /// 모든 프린터 연결 초기화
  Future<void> _initConnection() async {
    final printerList = ref.read(printerListProvider);
    for (final printer in printerList) {
      // PrinterListNotifier.connect를 통해 연결해야
      // 필드 값 관리자(FieldValueManager)가 함께 초기화된다.
      // 발주 완료 체크 콜백 전달 (초기 연결 시에는 발주가 아직 복원되지 않았으므로 null)
      await ref.read(printerListProvider.notifier).connect(printer);
      logger.i("initConnection- printer: $printer, connection initialized with FieldValueManager");
      _setupCountUpdateCallback(printer);

      // 프린터별 마지막 선택 발주 복원
      await _restorePrinterLastOrder(printer);

      // 발주 복원 후 완료 수량 초기화
      final selectedOrder = printer.selectedOrder;
      if (selectedOrder != null) {
        await _initializeCompletedCountForOrder(selectedOrder.orderId);

        // 발주 복원 후 프린터 상태 확인 및 발주 완료 여부 체크
        try {
          await printer.checkConnectionStatus(
            onCompletedCountCheck: () {
              final totalCompleted = _getTotalCompletedCountForOrder(selectedOrder.orderId);
              final totalQuantity = selectedOrder.baseQuantity;
              return totalCompleted >= totalQuantity;
            },
          );
        } catch (e) {
          logger.e('프린터 ${printer.name} 상태 확인 실패: $e');
        }
      }
    }
  }

  /// 프린터별 마지막 선택 발주 복원
  Future<void> _restorePrinterLastOrder(ManagedPrinter printer) async {
    if (printer.id == null) return;

    try {
      final saver = await ref.read(fieldValueStateSaverProvider.future);
      final lastOrderId = await saver.getPrinterLastOrder(printer.id!);

      if (lastOrderId != null) {
        logger.i('프린터 ${printer.id} 마지막 선택 발주 복원 시도: orderId=$lastOrderId');

        // 발주 목록에서 해당 발주 찾기
        final orders = ref.read(orderListProvider);

        // 발주 목록이 비어있으면 잠시 대기 후 재시도
        if (orders.isEmpty) {
          logger.w('발주 목록이 비어있어 복원을 지연합니다. 잠시 후 재시도합니다.');
          await Future.delayed(const Duration(milliseconds: 500)); // TODO : 500ms 대기 필요 여부 체크크
          final retryOrders = ref.read(orderListProvider);
          if (retryOrders.isEmpty) {
            logger.w('발주 목록이 여전히 비어있어 복원을 건너뜁니다.');
            return;
          }
        }

        final order = orders.firstWhere(
          (o) => o.orderId == lastOrderId,
          orElse: () {
            logger.w('발주를 찾을 수 없습니다: orderId=$lastOrderId (발주 목록: ${orders.map((o) => o.orderId).toList()})');
            throw Exception('발주를 찾을 수 없습니다: $lastOrderId');
          },
        );

        // 발주 선택 및 초기화
        printer.setSelectedOrder(order);
        await _initializeFieldValueManagerForOrder(printer, order);

        // UI 갱신을 위해 setState 호출
        if (mounted) {
          setState(() {});
        }

        logger.i('프린터 ${printer.id} 마지막 선택 발주 복원 완료: orderId=$lastOrderId, itemName=${order.itemName}');
      } else {
        logger.d('프린터 ${printer.id} 마지막 선택 발주 없음');
      }
    } catch (e, stackTrace) {
      logger.e('프린터 마지막 선택 발주 복원 실패: $e\n$stackTrace');
      // 복원 실패해도 앱은 정상 동작해야 하므로 에러만 로깅
    }
  }

  /// 카운트 업데이트 콜백 설정
  /// ChangeNotifier를 사용하므로 콜백은 선택적 (하위 호환성 유지)
  void _setupCountUpdateCallback(ManagedPrinter printer) {
    // ChangeNotifier의 notifyListeners()가 자동으로 UI를 업데이트하므로
    // 콜백은 필요 없지만, 기존 코드와의 호환성을 위해 유지
    printer.onCountUpdate = (updatedPrinter) {
      // ListenableBuilder가 자동으로 처리하므로 여기서는 아무것도 하지 않아도 됨
      // 하지만 필요시 추가 로직을 넣을 수 있음

      // 발주 전체 완료 감지 및 데이터 초기화
      // _checkAndClearOrderDataIfCompleted(updatedPrinter);
    };

    // 카운트 저장 콜백 설정 (Isar에 저장, 발주별 각 프린터의 완료 수량 저장)
    printer.onCountSave = (orderId, printerId, totalCount) async {
      try {
        final saver = await ref.read(fieldValueStateSaverProvider.future);

        // 각 프린터의 완료 수량을 DB에 저장 (발주별 프린터별로 저장)
        saver.savePrinterCountImmediately(
          orderId: orderId,
          printerId: printerId,
          totalCount: totalCount, // 파라미터명은 totalCount지만 실제로는 각 프린터의 완료 수량
        );

        // 완료 수량 ++ (모든 프린터의 완료 수량 합계)
        _orderCompletedCounts[orderId] = (_orderCompletedCounts[orderId] ?? 0) + 1;
        setState(() {}); // UI 업데이트

        logger.i(
            '💾 발주별 프린터 완료 수량 저장: orderId=$orderId, printerId=$printerId, completedCount=${_orderCompletedCounts[orderId]}');

        // print-event API 단위 체크 (카운트 증가 시)
        await _checkAndSendPrintEventIfNeeded(orderId);

        // quantity(여유 수량) 도달 시 모든 프린터 중단
        await _checkAndStopPrintersIfQuantityReached(orderId);
      } catch (e) {
        logger.e('프린터 카운트 저장 실패: $e');
      }
    };
  }

  /// 완료 수량 조회 (메모리에서 관리)
  /// 처음 복원 시 각 프린터의 완료 수량을 합산하여 초기화하고,
  /// 이후 실시간 카운트 증가 시 ++ 연산으로 업데이트
  int _getTotalCompletedCountForOrder(int orderId) {
    return _orderCompletedCounts[orderId] ?? 0;
  }

  /// 발주별 완료 수량 초기화 (복원 시 호출)
  /// 각 프린터의 완료 수량을 합산하여 완료 수량 초기화
  /// 완료 수량 = 모든 프린터의 완료 수량 합계
  Future<void> _initializeCompletedCountForOrder(int orderId) async {
    try {
      final saver = await ref.read(fieldValueStateSaverProvider.future);
      final printerCounts = await saver.getAllPrinterCountsForOrder(orderId);

      // 각 프린터의 완료 수량을 합산하여 완료 수량 초기화
      int totalCompletedCount = 0;
      for (final count in printerCounts.values) {
        totalCompletedCount += count; // 각 프린터의 완료 수량 합계
      }

      _orderCompletedCounts[orderId] = totalCompletedCount;
      logger.i('발주 $orderId 완료 수량 초기화: $totalCompletedCount장 (각 프린터의 완료 수량 합계)');
    } catch (e) {
      logger.e('완료 수량 초기화 실패: $e');
      _orderCompletedCounts[orderId] = 0;
    }
  }

  /// quantity(여유 수량) 도달 시 모든 프린터 중단
  /// 발주의 quantity(여유 수량)와 현재 인쇄된 수량을 비교하여 도달 여부 확인
  Future<void> _checkAndStopPrintersIfQuantityReached(int orderId) async {
    final printers = ref.read(printerListProvider);
    final selectedPrinters = printers.where((p) => p.selectedOrder?.orderId == orderId).toList();

    if (selectedPrinters.isEmpty) return;

    // 첫 번째 프린터의 발주 정보 사용 (모든 프린터가 같은 발주를 선택했으므로)
    final order = selectedPrinters.first.selectedOrder;
    if (order == null) return;

    final orderQuantity = order.quantity; // quantity는 여유 수량
    if (orderQuantity <= 0) return; // 여유 수량이 없으면 체크하지 않음

    // 완료 수량 조회 (메모리에서 관리)
    final totalCompleted = _getTotalCompletedCountForOrder(orderId);

    // quantity(여유 수량) 도달 여부 확인
    if (totalCompleted >= orderQuantity) {
      logger.i('여유 수량 도달 감지: orderId=$orderId, quantity=$orderQuantity, totalCompleted=$totalCompleted');

      // 같은 발주를 선택한 모든 프린터를 중지
      for (final printer in selectedPrinters) {
        if (printer.isPrinterOn == true) {
          try {
            await printer.setPrinterState(false);
            logger.i('프린터 ${printer.id} 자동 중지: 여유 수량 도달');
          } catch (e) {
            logger.e('프린터 ${printer.id} 자동 중지 실패: $e');
          }
        }
      }

      setState(() {}); // UI 업데이트

      // 완료 알림
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('발주 "${order.itemName}" 여유 수량 도달: $totalCompleted/$orderQuantity'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  /// 발주 전체 완료 감지 및 자동 중지
  /// 발주의 quantity와 현재 인쇄된 수량을 비교하여 완료 여부 확인
  @Deprecated('Use _checkAndStopPrintersIfQuantityReached instead')
  Future<void> _checkAndStopPrintersIfCompleted(int orderId) async {
    final printers = ref.read(printerListProvider);
    final selectedPrinters = printers.where((p) => p.selectedOrder?.orderId == orderId).toList();

    if (selectedPrinters.isEmpty) return;

    // 첫 번째 프린터의 발주 정보 사용 (모든 프린터가 같은 발주를 선택했으므로)
    final order = selectedPrinters.first.selectedOrder;
    if (order == null) return;

    final orderQuantity = order.quantity;
    if (orderQuantity <= 0) return; // 발주 수량이 없으면 체크하지 않음

    // 완료 수량 조회 (메모리에서 관리)
    final totalCompleted = _getTotalCompletedCountForOrder(orderId);

    // 완료 여부 확인
    if (totalCompleted >= orderQuantity) {
      logger.i('발주 전체 완료 감지: orderId=$orderId, quantity=$orderQuantity, totalCompleted=$totalCompleted');

      // 같은 발주를 선택한 모든 프린터를 중지
      for (final printer in selectedPrinters) {
        if (printer.isPrinterOn == true) {
          try {
            await printer.setPrinterState(false);
            logger.i('프린터 ${printer.id} 자동 중지: 발주 완료');
          } catch (e) {
            logger.e('프린터 ${printer.id} 자동 중지 실패: $e');
          }
        }
      }

      // 완료 알림
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('발주 "${order.itemName}" 완료: $totalCompleted/$orderQuantity'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );
      }

      // Isar에서 발주별 데이터 초기화
      try {
        final registry = ref.read(fieldValueManagerRegistryProvider);
        await registry.clearOrderData(orderId);
        logger.i('발주별 Isar 데이터 초기화 완료: orderId=$orderId');
      } catch (e) {
        logger.e('발주별 Isar 데이터 초기화 실패: $e');
      }
    }
  }

  /// 발주 전체 완료 감지 및 데이터 초기화
  /// 발주의 quantity와 현재 인쇄된 수량을 비교하여 완료 여부 확인
  @Deprecated('Use _checkAndStopPrintersIfCompleted instead')
  Future<void> _checkAndClearOrderDataIfCompleted(ManagedPrinter printer) async {
    final selectedOrder = printer.selectedOrder;
    if (selectedOrder == null) return;

    try {
      // 발주의 quantity와 현재 인쇄된 수량 비교
      final orderQuantity = selectedOrder.quantity;
      final currentCount = printer.currentPrintCount;
      final completedWork = printer.completePrintWork ?? 0;

      // 완료 여부 확인 (현재 카운트 또는 완료 수량이 발주 수량과 같거나 초과)
      final isCompleted = (currentCount >= orderQuantity) || (completedWork >= orderQuantity);

      if (isCompleted) {
        logger.i(
            '발주 전체 완료 감지: orderId=${selectedOrder.orderId}, quantity=$orderQuantity, currentCount=$currentCount, completedWork=$completedWork');

        // Isar에서 발주별 데이터 초기화
        final registry = ref.read(fieldValueManagerRegistryProvider);
        await registry.clearOrderData(selectedOrder.orderId);

        logger.i('발주별 데이터 초기화 완료: orderId=${selectedOrder.orderId}');
      }
    } catch (e, stackTrace) {
      logger.e('발주 완료 감지 및 데이터 초기화 실패: $e\n$stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    final printers = ref.watch(printerListProvider);
    final filteredPrinters = _getFilteredPrinters(printers);

    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0), // Windows 배경색
      body: Column(
        children: [
          // _buildWindowTitleBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildToolbar(printers),
                  _buildStatusBar(printers),
                  _buildPrinterGrid(filteredPrinters),
                  _buildBottomStatusBar(filteredPrinters.length),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Window Title Bar (Windows 스타일)
  Widget _buildWindowTitleBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_PrinterStatusUIConstants.windowTitleBarStart, _PrinterStatusUIConstants.windowTitleBarEnd],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Icon(Icons.print, size: 20, color: Colors.white),
          SizedBox(width: 8),
          Text(
            '프린터 상태 모니터 시스템',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: _PrinterStatusUIConstants.fontFamily,
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.settings, size: 16, color: Colors.white),
            onPressed: () {},
            padding: EdgeInsets.all(4),
            constraints: BoxConstraints(),
            style: IconButton.styleFrom(backgroundColor: Colors.transparent, shape: RoundedRectangleBorder()),
          ),
          SizedBox(width: 4),
          IconButton(
            icon: Icon(Icons.power_settings_new, size: 16, color: Colors.white),
            onPressed: () {},
            padding: EdgeInsets.all(4),
            constraints: BoxConstraints(),
            style: IconButton.styleFrom(backgroundColor: Colors.transparent, shape: RoundedRectangleBorder()),
          ),
        ],
      ),
    );
  }

  /// Toolbar (Windows 스타일)
  Widget _buildToolbar(List<ManagedPrinter> printers) {
    final counts = _getStatusCounts(printers);

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _PrinterStatusUIConstants.toolbarBg,
        border: Border.all(color: _PrinterStatusUIConstants.borderColor),
        borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.cardBorderRadius),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterButton('전체', PrinterStatusType.all, counts['all']!),
                _buildFilterButton('대기중', PrinterStatusType.online, counts['online']!),
                _buildFilterButton('인쇄중', PrinterStatusType.running, counts['running']!),
                _buildFilterButton('오프라인', PrinterStatusType.offline, counts['offline']!),
              ],
            ),
          ),
          SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: _addExamplePrinters,
            icon: Icon(Icons.auto_awesome, size: 16),
            label: Text('예시 데이터'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.buttonBorderRadius),
              ),
            ),
          ),
          SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () => _clearIsarData(context, ref),
            icon: Icon(Icons.delete_sweep, size: 16),
            label: Text('Isar 초기화'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.cardBorderRadius),
              ),
              foregroundColor: Colors.red,
            ),
          ),
          SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () => _showAddPrinterDialog(context, ref),
            icon: Icon(Icons.add, size: 16),
            label: Text('프린터 추가'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.buttonBorderRadius),
              ),
            ),
          ),
          SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () => _checkPrinterConnections(),
            icon: Icon(Icons.refresh, size: 16),
            label: Text('새로고침'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.buttonBorderRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 필터 버튼
  Widget _buildFilterButton(String label, PrinterStatusType type, int count) {
    final isSelected = _selectedFilter == type;
    return OutlinedButton(
      onPressed: () => setState(() => _selectedFilter = type),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.transparent,
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        side: BorderSide(color: isSelected ? Colors.blue : _PrinterStatusUIConstants.borderColor, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.buttonBorderRadius),
        ),
      ),
      child: Text('$label ($count)', style: _PrinterStatusUIConstants.textStyle()),
    );
  }

  /// Status Bar (Windows 스타일)
  /// Consumer로 감싸서 프린터 상태 변경 시 자동 업데이트
  Widget _buildStatusBar(List<ManagedPrinter> printers) {
    // Consumer로 감싸서 프린터 목록 변경 및 각 프린터의 상태 변경 감지
    return Consumer(
      builder: (context, ref, child) {
        // 프린터 목록을 watch하여 변경 감지
        final latestPrinters = ref.watch(printerListProvider);
        final counts = _getStatusCounts(latestPrinters);

        return Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
          decoration: BoxDecoration(
            color: _PrinterStatusUIConstants.cardBg,
            border: Border.all(color: _PrinterStatusUIConstants.borderColor),
            borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.cardBorderRadius),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
          ),
          child: Row(
            children: [
              Expanded(child: _buildStatusBarItem('전체', counts['all']!, Colors.grey[800]!)),
              Container(width: 1, height: 40, color: Colors.grey[300]),
              Expanded(child: _buildStatusBarItem('대기중', counts['online']!, _PrinterStatusUIConstants.onlineColor)),
              Container(width: 1, height: 40, color: Colors.grey[300]),
              Expanded(child: _buildStatusBarItem('인쇄중', counts['running']!, _PrinterStatusUIConstants.printingColor)),
              Container(width: 1, height: 40, color: Colors.grey[300]),
              Expanded(child: _buildStatusBarItem('오프라인', counts['offline']!, _PrinterStatusUIConstants.offlineColor)),
            ],
          ),
        );
      },
    );
  }

  /// Status Bar Item
  Widget _buildStatusBarItem(String label, int count, Color color) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600], fontFamily: _PrinterStatusUIConstants.fontFamily),
          ),
          SizedBox(height: 4),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: _PrinterStatusUIConstants.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  /// Bottom Status Bar
  Widget _buildBottomStatusBar(int printerCount) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _PrinterStatusUIConstants.statusBarBg,
        border: Border.all(color: _PrinterStatusUIConstants.borderColor),
        borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.cardBorderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '총 $printerCount개의 프린터',
            style: TextStyle(fontSize: 12, color: Colors.grey[700], fontFamily: _PrinterStatusUIConstants.fontFamily),
          ),
          Text(
            '마지막 업데이트: ${DateTime.now().toString().substring(11, 19)}',
            style: TextStyle(fontSize: 12, color: Colors.grey[700], fontFamily: _PrinterStatusUIConstants.fontFamily),
          ),
        ],
      ),
    );
  }

  /// 상태 개요 카드들 (React 프로젝트 스타일)
  @Deprecated('Use _buildStatusBar instead')
  Widget _buildStatusOverview(List<ManagedPrinter> printers) {
    final counts = _getStatusCounts(printers);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: _PrinterStatusUIConstants.horizontalPadding, vertical: 16),
      child: Row(
        children: [
          Expanded(child: _buildStatusCard('전체', counts['all']!, Colors.grey[700]!, Icons.timeline)),
          SizedBox(width: 12),
          Expanded(child: _buildStatusCard('대기중', counts['online']!, Color(0xFF4CAF50), null)),
          SizedBox(width: 12),
          Expanded(child: _buildStatusCard('인쇄중', counts['running']!, Color(0xFF2196F3), null)),
          SizedBox(width: 12),
          Expanded(child: _buildStatusCard('오프라인', counts['offline']!, Color(0xFFF44336), null)),
        ],
      ),
    );
  }

  /// 상태 카드
  Widget _buildStatusCard(String label, int count, Color color, IconData? icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null)
                Icon(icon, size: 16, color: Colors.grey[600])
              else
                Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              SizedBox(width: 8),
              Text(label, style: _PrinterStatusUIConstants.textStyle(fontSize: 14, color: Colors.grey[600])),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '$count',
            style: _PrinterStatusUIConstants.textStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  /// 상태별 카운트 계산
  Map<String, int> _getStatusCounts(List<ManagedPrinter> printers) {
    int online = 0;
    int running = 0;
    int offline = 0;

    for (final printer in printers) {
      final status = _getPrinterStatusType(printer);
      switch (status) {
        case PrinterStatusType.online:
          online++;
          break;
        case PrinterStatusType.running:
          running++;
          break;
        case PrinterStatusType.offline:
          offline++;
          break;
        default:
          break;
      }
    }

    return {'all': printers.length, 'online': online, 'running': running, 'offline': offline};
  }

  /// 프린터 상태 타입 결정
  PrinterStatusType _getPrinterStatusType(ManagedPrinter printer) {
    // 오프라인: 연결되지 않음
    if (printer.connectionStatus != PrinterConnectionStatus.connected) {
      return PrinterStatusType.offline;
    }

    // 가동중
    if (printer.printStatus == PrinterPrintStatus.running) {
      return PrinterStatusType.running;
    }

    // 대기중
    if (printer.connectionStatus == PrinterConnectionStatus.connected &&
        printer.printStatus == PrinterPrintStatus.offline) {
      return PrinterStatusType.online;
    }

    // 오프라인
    return PrinterStatusType.offline;
  }

  /// 필터링된 프린터 목록
  List<ManagedPrinter> _getFilteredPrinters(List<ManagedPrinter> printers) {
    if (_selectedFilter == PrinterStatusType.all) {
      return printers;
    }

    return printers.where((printer) {
      return _getPrinterStatusType(printer) == _selectedFilter;
    }).toList();
  }

  /// 예시 프린터 데이터 추가
  Future<void> _addExamplePrinters() async {
    final examplePrinters = [
      {
        'name': '프린터 1호기',
        'ip': '192.168.1.101',
        'port': 5000,
        'item': '라벨지 A4',
        'connectStatus': '연결됨',
        'printStatus': '인쇄 중',
        'totalPrintWork': 100,
        'completePrintWork': 75,
        'currentCount': 75,
      },
      {
        'name': '프린터 2호기',
        'ip': '192.168.1.102',
        'port': 5000,
        'item': '라벨지 B5',
        'connectStatus': '연결됨',
        'printStatus': '인쇄 대기',
        'totalPrintWork': 50,
        'completePrintWork': 50,
        'currentCount': 50,
      },
      {
        'name': '프린터 3호기',
        'ip': '192.168.1.103',
        'port': 5000,
        'item': '라벨지 A5',
        'connectStatus': '미연결',
        'printStatus': '인쇄 대기',
        'totalPrintWork': null,
        'completePrintWork': null,
        'currentCount': 0,
      },
      {
        'name': '프린터 4호기',
        'ip': '192.168.1.104',
        'port': 5000,
        'item': '라벨지 A3',
        'connectStatus': '연결됨',
        'printStatus': '인쇄 완료',
        'totalPrintWork': 200,
        'completePrintWork': 200,
        'currentCount': 200,
      },
      {
        'name': '프린터 5호기',
        'ip': '192.168.1.105',
        'port': 5000,
        'item': '라벨지 B4',
        'connectStatus': '연결됨',
        'printStatus': '인쇄 중',
        'totalPrintWork': 80,
        'completePrintWork': 30,
        'currentCount': 30,
      },
      {
        'name': '프린터 6호기',
        'ip': '192.168.1.106',
        'port': 5000,
        'item': '라벨지 A4',
        'connectStatus': '연결됨',
        'printStatus': '인쇄 대기',
        'totalPrintWork': null,
        'completePrintWork': null,
        'currentCount': 0,
      },
      {
        'name': '프린터 7호기',
        'ip': '192.168.1.107',
        'port': 5000,
        'item': '라벨지 C5',
        'connectStatus': '연결됨',
        'printStatus': '인쇄 중',
        'totalPrintWork': 150,
        'completePrintWork': 120,
        'currentCount': 120,
      },
      {
        'name': '프린터 8호기',
        'ip': '192.168.1.108',
        'port': 5000,
        'item': '라벨지 A4',
        'connectStatus': '미연결',
        'printStatus': '인쇄 대기',
        'totalPrintWork': 60,
        'completePrintWork': 45,
        'currentCount': 0,
      },
    ];

    final printerListNotifier = ref.read(printerListProvider.notifier);
    final currentPrinters = ref.read(printerListProvider);

    for (final example in examplePrinters) {
      // 이미 존재하는 프린터는 스킵
      if (currentPrinters.any((p) => p.ip == example['ip'] && p.port == example['port'])) {
        continue;
      }

      final printer = ManagedPrinter(
        index: currentPrinters.length + 1,
        id: null,
        name: example['name'] as String,
        ip: example['ip'] as String,
        port: example['port'] as int,
        regDate: DateTime.now().toString(),
      );

      // 상태 설정 (실제 연결은 하지 않고 상태만 설정)
      printer.updateFields(
        connectionStatus: example['connectStatus'] as String, // connectionStatus로 명확하게 구분
        item: example['item'] as String,
        printStatus: example['printStatus'] as String,
        totalPrintWork: example['totalPrintWork'] as int?,
        completePrintWork: example['completePrintWork'] as int?,
      );

      // 예시 데이터이므로 실제 연결은 하지 않음
      // currentPrintCount는 카운터가 시작될 때 자동으로 설정됨

      printerListNotifier.addPrinter(printer);
      _setupCountUpdateCallback(printer);
    }

    // 상태 갱신
    printerListNotifier.refreshState();
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${examplePrinters.length}개의 예시 프린터가 추가되었습니다'), duration: Duration(seconds: 2)),
    );
  }

  /// Isar 데이터 초기화
  Future<void> _clearIsarData(BuildContext context, WidgetRef ref) async {
    // 확인 다이얼로그 표시
    final confirmed = await CommonAlert.showConfirmDialog(
      context: context,
      title: 'Isar 데이터 초기화',
      content: '모든 Isar 데이터를 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없습니다.',
      confirmText: '삭제',
      cancelText: '취소',
      confirmColor: Colors.red,
    );

    if (confirmed != true) return;

    try {
      final saver = await ref.read(fieldValueStateSaverProvider.future);
      await saver.clearAllData();

      // 삭제 확인: 특정 발주/프린터의 카운트가 정말 0인지 확인
      final printers = ref.read(printerListProvider);
      for (final printer in printers) {
        if (printer.id != null && printer.selectedOrder != null) {
          final testCount = await saver.getPrinterCount(printer.selectedOrder!.orderId, printer.id!);
          if (testCount > 0) {
            logger.w('⚠️ 프린터 ${printer.id} 발주 ${printer.selectedOrder!.orderId} 카운트가 여전히 $testCount입니다. 재삭제 시도...');
            // 재삭제
            await saver.clearPrinterCountsForOrder(printer.selectedOrder!.orderId);
            final retryCount = await saver.getPrinterCount(printer.selectedOrder!.orderId, printer.id!);
            logger.i('재삭제 후 카운트: $retryCount');
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('모든 Isar 데이터가 초기화되었습니다'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      logger.e('Isar 데이터 초기화 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Isar 데이터 초기화 실패: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// 프린터 그리드 빌드 (발주별로 그룹화)
  Widget _buildPrinterGrid(List<ManagedPrinter> printers) {
    if (printers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.print, size: 64, color: Colors.grey[300]),
            SizedBox(height: 16),
            Text('해당 상태의 프린터가 없습니다', style: _PrinterStatusUIConstants.textStyle(fontSize: 16, color: Colors.grey[500])),
          ],
        ),
      );
    }

    // 발주별로 프린터 그룹화
    final printersByOrder = <int?, List<ManagedPrinter>>{};
    for (final printer in printers) {
      final orderId = printer.selectedOrder?.orderId;
      if (!printersByOrder.containsKey(orderId)) {
        printersByOrder[orderId] = [];
      }
      printersByOrder[orderId]!.add(printer);
    }

    // 발주 ID로 정렬 (null은 마지막에)
    final sortedOrders = printersByOrder.keys.toList()
      ..sort((a, b) {
        if (a == null) return 1;
        if (b == null) return -1;
        return a.compareTo(b);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final orderId in sortedOrders) ...[
          _buildOrderSection(orderId, printersByOrder[orderId]!),
          SizedBox(height: 16),
        ],
      ],
    );
  }

  /// 발주별 섹션 빌드
  Widget _buildOrderSection(int? orderId, List<ManagedPrinter> printers) {
    final orders = ref.read(orderListProvider);
    final order = orderId != null ? orders.firstWhere((o) => o.orderId == orderId, orElse: () => orders.first) : null;

    // 접기/펴기 상태 확인 (기본값은 true - 펼침)
    final isExpanded = _expandedOrders[orderId] ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 발주 헤더
        Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: orderId != null ? Colors.blue[50] : Colors.grey[200],
            border: Border.all(
              color: orderId != null ? Colors.blue[300]! : Colors.grey[400]!,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.cardBorderRadius),
          ),
          child: Row(
            children: [
              // 접기/펴기 버튼
              IconButton(
                icon: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                  color: orderId != null ? Colors.blue[700] : Colors.grey[600],
                ),
                onPressed: () {
                  setState(() {
                    _expandedOrders[orderId] = !isExpanded;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              SizedBox(width: 4),
              Icon(
                orderId != null ? Icons.shopping_cart : Icons.print_disabled,
                size: 18,
                color: orderId != null ? Colors.blue[700] : Colors.grey[600],
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  orderId != null
                      ? '발주 ${orderId}: ${order?.itemName ?? "알 수 없음"} (${printers.length}개 프린터)'
                      : '발주 미선택 (${printers.length}개 프린터)',
                  style: _PrinterStatusUIConstants.textStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: orderId != null ? Colors.blue[900] : Colors.grey[700],
                  ),
                ),
              ),
              if (orderId != null) ...[
                Consumer(
                  builder: (context, ref, child) {
                    final completedCount = _getTotalCompletedCountForOrder(orderId);
                    final orderQuantity = order?.quantity ?? 0;
                    return Text(
                      '완료: $completedCount${orderQuantity > 0 ? '/$orderQuantity' : ''}장',
                      style: _PrinterStatusUIConstants.textStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    );
                  },
                ),
                SizedBox(width: 12),
                // 일괄 중지/준비 버튼
                _buildBatchControlButtons(orderId, printers),
                SizedBox(width: 6),
                // 인쇄 완료 버튼
                _buildCompletePrintButton(orderId, printers),
              ],
            ],
          ),
        ),
        // 프린터 그리드 (접기/펴기 상태에 따라 표시/숨김)
        if (isExpanded)
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: _PrinterStatusUIConstants.cardSpacing),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(context),
              crossAxisSpacing: _PrinterStatusUIConstants.cardSpacing,
              mainAxisSpacing: _PrinterStatusUIConstants.cardSpacing,
              childAspectRatio: 0.75,
            ),
            itemCount: printers.length,
            itemBuilder: (context, index) => _buildPrinterCard(printers[index]),
          ),
      ],
    );
  }

  /// 반응형 그리드 컬럼 수 계산
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // 더 넓은 화면에서도 최대 4개로 제한하여 카드 크기 유지
    if (width > 1600) return 4;
    if (width > 1200) return 3;
    if (width > 800) return 2;
    return 1;
  }

  /// 프린터 카드 빌드 (Windows UI 스타일)
  Widget _buildPrinterCard(ManagedPrinter printer) {
    // ListenableBuilder로 감싸서 상태 변경 시 자동 UI 업데이트
    return ListenableBuilder(
      listenable: printer,
      builder: (context, child) {
        final statusType = _getPrinterStatusType(printer);
        // 발주가 선택되어 있거나 기존 작업이 있으면 hasOrder = true
        final hasOrder =
            (printer.selectedOrder != null) || (printer.totalPrintWork != null && printer.totalPrintWork! > 0);

        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: _PrinterStatusUIConstants.cardBg, // 상태별 배경색
            border: Border.all(color: _PrinterStatusUIConstants.borderColor, width: 2),
            borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.cardBorderRadius),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 카드 헤더 (Windows 스타일 그라데이션)
              _buildCardHeader(printer, statusType),

              // 카드 본문
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 기본 정보
                      _buildBasicInfo(printer),
                      SizedBox(height: 12),

                      // 품목명 및 선택된 발주 정보
                      _buildItemName(printer),
                      if (printer.selectedOrder != null) ...[
                        SizedBox(height: 6),
                        _buildSelectedOrderInfo(printer.selectedOrder!),
                      ],
                      SizedBox(height: 10),

                      // 통계 정보
                      _buildStatistics(printer),

                      // Spacer로 액션 버튼을 바닥에 붙이기
                      Spacer(),

                      // 액션 버튼들 (같은 행에 배치)
                      _buildActionButtons(printer, hasOrder),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 카드 헤더 (Windows 스타일 그라데이션)
  Widget _buildCardHeader(ManagedPrinter printer, PrinterStatusType statusType) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_PrinterStatusUIConstants.cardHeaderStart, _PrinterStatusUIConstants.cardHeaderEnd],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        border: Border(bottom: BorderSide(color: _PrinterStatusUIConstants.borderColor, width: 2)),
      ),
      child: Row(
        children: [
          Icon(Icons.print, size: 24, color: Colors.grey[700]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  printer.name,
                  style: _PrinterStatusUIConstants.textStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  'VJ 6330', // 모델명
                  style: _PrinterStatusUIConstants.textStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [_buildStatusBadge(statusType)]),
          SizedBox(width: 8),
          _buildRemoveBadge(printer),
        ],
      ),
    );
  }

  /// 상태 아이콘
  Widget _buildStatusIcon(PrinterStatusType statusType) {
    switch (statusType) {
      case PrinterStatusType.online:
        return Icon(Icons.check_circle, size: 20, color: Color(0xFF4CAF50));
      case PrinterStatusType.offline:
        return Icon(Icons.error, size: 20, color: Color(0xFFF44336));
      case PrinterStatusType.running:
        return Icon(Icons.access_time, size: 20, color: Color(0xFF2196F3));
      default:
        return Icon(Icons.help_outline, size: 20, color: Colors.grey);
    }
  }

  /// 상태 배지 (Windows 스타일)
  Widget _buildStatusBadge(PrinterStatusType statusType) {
    String label;
    Color color;

    switch (statusType) {
      case PrinterStatusType.online:
        label = '대기중';
        color = _PrinterStatusUIConstants.onlineColor;
        break;
      case PrinterStatusType.offline:
        label = '오프라인';
        color = _PrinterStatusUIConstants.offlineColor;
        break;
      case PrinterStatusType.running:
        label = '가동중';
        color = _PrinterStatusUIConstants.printingColor;
        break;
      default:
        label = '알 수 없음';
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.cardBorderRadius),
      ),
      child: Text(
        label,
        style: _PrinterStatusUIConstants.textStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }

  /// 제거 배지 (X 버튼)
  Widget _buildRemoveBadge(ManagedPrinter printer) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleRemovePrinter(printer),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: _PrinterStatusUIConstants.errorColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _PrinterStatusUIConstants.errorColor.withOpacity(0.3), width: 1),
          ),
          child: Icon(Icons.close, size: 16, color: _PrinterStatusUIConstants.errorColor),
        ),
      ),
    );
  }

  /// 기본 정보 섹션
  Widget _buildBasicInfo(ManagedPrinter printer) {
    return Container(
      padding: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('IP 주소', style: _PrinterStatusUIConstants.textStyle(fontSize: 11, color: Colors.grey[600])),
                SizedBox(height: 2),
                Text(
                  printer.ip,
                  style: _PrinterStatusUIConstants.textStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                    fontFamily: 'monospace', // IP 주소는 monospace 유지
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('위치', style: _PrinterStatusUIConstants.textStyle(fontSize: 11, color: Colors.grey[600])),
                SizedBox(height: 2),
                Text(
                  '1층 - 영업부', // 실제 위치 정보가 있다면 사용
                  style: _PrinterStatusUIConstants.textStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 선택된 발주 정보 표시 (Windows 스타일 - 컴팩트 버전)
  Widget _buildSelectedOrderInfo(OrderItem order) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFE3F2FD), // Windows Blue 배경
        border: Border.all(color: _PrinterStatusUIConstants.primaryBlue, width: 1),
        borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.cardBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 헤더와 발주명을 한 줄에
          Row(
            children: [
              Icon(Icons.shopping_cart, size: 16, color: _PrinterStatusUIConstants.primaryBlue),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  order.itemName,
                  style: _PrinterStatusUIConstants.textStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          // 상세 정보를 더 컴팩트하게 (작은 폰트, 한 줄에 여러 정보)
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _buildCompactOrderInfo('ID', '${order.orderId}'),
              _buildCompactOrderInfo('수량', '${order.quantity}'),
              if (order.uniqueCode.isNotEmpty) _buildCompactOrderInfo('코드', order.uniqueCode),
            ],
          ),
        ],
      ),
    );
  }

  /// 컴팩트한 발주 정보 아이템
  Widget _buildCompactOrderInfo(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(2)),
      child: Text(
        '$label: $value',
        style: _PrinterStatusUIConstants.textStyle(fontSize: 10, color: Colors.grey[700], fontWeight: FontWeight.w500),
      ),
    );
  }

  /// 품목명 섹션
  Widget _buildItemName(ManagedPrinter printer) {
    return Container(
      padding: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('품목명', style: _PrinterStatusUIConstants.textStyle(fontSize: 11, color: Colors.grey[600])),
          SizedBox(height: 2),
          Text(
            printer.item ?? '-',
            style: _PrinterStatusUIConstants.textStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }

  /// 정보 행
  @Deprecated('Not used in Windows UI style')
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              children: [
                TextSpan(text: '$label: ', style: TextStyle(fontWeight: FontWeight.w500)),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 통계 정보 섹션 (Windows 스타일)
  /// Consumer를 사용하여 같은 발주를 선택한 다른 프린터들의 카운트 변경도 감지
  Widget _buildStatistics(ManagedPrinter printer) {
    // 발주가 선택되어 있으면 선택된 발주의 수량을 사용, 없으면 기존 totalPrintWork 사용
    final totalOrder = printer.selectedOrder?.quantity ?? printer.totalPrintWork ?? 0;

    // Consumer로 감싸서 같은 발주를 선택한 다른 프린터들의 카운트 변경도 감지
    return Consumer(
      builder: (context, ref, child) {
        // printerListProvider를 watch하여 같은 발주를 선택한 다른 프린터들의 변경도 감지
        ref.watch(printerListProvider);

        // 발주가 선택된 경우: 메모리에서 완료 수량 조회
        // 발주가 선택되지 않은 경우: 기존 completePrintWork 사용
        final completed = printer.selectedOrder != null
            ? _getTotalCompletedCountForOrder(printer.selectedOrder!.orderId)
            : (printer.completePrintWork ?? 0);

        return Builder(
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border.all(color: Colors.grey[200]!),
                borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.cardBorderRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '인쇄 현황',
                    style: _PrinterStatusUIConstants.textStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 12),
                  // 3열 그리드: 발주 수량, 실시간 카운트, 완료 수량
                  // ListenableBuilder로 프린터의 실시간 카운트 변경 감지
                  ListenableBuilder(
                    listenable: printer,
                    builder: (context, child) {
                      // 각 프린터가 몇 장을 인쇄하고 있는지 표시 (발주 선택 시 0부터 시작)
                      final realtimeCount = printer.currentPrintCount;
                      return Row(
                        children: [
                          Expanded(child: _buildStatBox('발주 수량', '$totalOrder', Colors.grey[900]!)),
                          SizedBox(width: 8),
                          Expanded(
                              child: _buildStatBox('완료 수량', '$completed', _PrinterStatusUIConstants.printingColor)),
                          SizedBox(width: 8),
                          Expanded(child: _buildStatBox('실시간 카운트', '$realtimeCount', Color(0xFF9C27B0))),
                        ],
                      );
                    },
                  ),
                  if (totalOrder > 0 && printer.selectedOrder != null) ...[
                    SizedBox(height: 12),
                    _buildProgressBar(
                      completed: completed,
                      baseQuantity: printer.selectedOrder!.baseQuantity,
                      quantity: printer.selectedOrder!.quantity,
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// 통계 박스 (Windows 스타일)
  Widget _buildStatBox(String label, String value, Color valueColor) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.cardBorderRadius),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: _PrinterStatusUIConstants.textStyle(fontSize: 11, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            '${value}장',
            style: _PrinterStatusUIConstants.textStyle(fontSize: 16, fontWeight: FontWeight.bold, color: valueColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 통계 컬럼 (React 프로젝트 스타일)
  @Deprecated('Use _buildStatBox instead')
  Widget _buildStatColumn(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          label,
          style: _PrinterStatusUIConstants.textStyle(fontSize: 12, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          '${value}장',
          style: _PrinterStatusUIConstants.textStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 진행률 바 (baseQuantity와 quantity 구간별 색상 표시)
  Widget _buildProgressBar({
    required int completed,
    required int baseQuantity,
    required int quantity,
  }) {
    if (quantity <= 0) return SizedBox.shrink();

    // 전체 진행률 (completed / quantity)
    final totalProgress = (completed / quantity).clamp(0.0, 1.0);

    // baseQuantity까지의 진행률
    final baseProgress = baseQuantity > 0 ? (completed.clamp(0, baseQuantity) / baseQuantity).clamp(0.0, 1.0) : 0.0;

    // baseQuantity부터 quantity까지의 진행률
    final remainingProgress = (quantity > baseQuantity && completed > baseQuantity)
        ? ((completed - baseQuantity) / (quantity - baseQuantity)).clamp(0.0, 1.0)
        : 0.0;

    // 색상 정의 (톤은 비슷하게)
    final baseColor = _PrinterStatusUIConstants.primaryBlue; // baseQuantity까지 색상 (0xFF0078D4)
    final remainingColor = Color(0xFF4A90E2); // baseQuantity부터 quantity까지 색상 (약간 밝은 파란색)

    // baseQuantity와 quantity가 같으면 구분할 필요 없음
    final showDivision = quantity > baseQuantity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('진행률', style: _PrinterStatusUIConstants.textStyle(fontSize: 11, color: Colors.grey[600])),
            Row(
              children: [
                Text(
                  '${(totalProgress * 100).toStringAsFixed(1)}%',
                  style: _PrinterStatusUIConstants.textStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                if (showDivision) ...[
                  SizedBox(width: 8),
                  Text(
                    '(발주: $baseQuantity / 여유: $quantity)',
                    style: _PrinterStatusUIConstants.textStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        SizedBox(height: 4),
        LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final baseWidth = totalWidth * (baseQuantity / quantity).clamp(0.0, 1.0);
            // 첫 번째 구간의 실제 진행률에 따른 너비 계산
            final firstSectionProgressWidth = completed < baseQuantity
                ? baseWidth * baseProgress // baseQuantity 미만일 때 진행률에 비례한 너비
                : baseWidth; // baseQuantity 이상일 때 전체 너비

            return Stack(
              children: [
                // 진행률 바 배경
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    height: 6,
                    color: Colors.grey[200],
                    child: Row(
                      children: [
                        // baseQuantity까지 구간 (첫 번째 색상)
                        if (baseQuantity > 0 && firstSectionProgressWidth > 0)
                          Container(
                            width: firstSectionProgressWidth,
                            decoration: BoxDecoration(
                              color: completed >= baseQuantity
                                  ? baseColor
                                  : (completed > 0 ? baseColor : Colors.transparent),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                                topRight: (showDivision && completed < baseQuantity) ? Radius.zero : Radius.circular(4),
                                bottomRight:
                                    (showDivision && completed < baseQuantity) ? Radius.zero : Radius.circular(4),
                              ),
                            ),
                          ),
                        // baseQuantity부터 quantity까지 구간 (두 번째 색상)
                        if (showDivision)
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: completed > baseQuantity
                                    ? (remainingProgress > 0 ? remainingColor : Colors.transparent)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.only(
                                  topLeft: (baseQuantity > 0 && completed >= baseQuantity)
                                      ? Radius.zero
                                      : Radius.circular(4),
                                  bottomLeft: (baseQuantity > 0 && completed >= baseQuantity)
                                      ? Radius.zero
                                      : Radius.circular(4),
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // baseQuantity 위치 구분선
                if (showDivision && baseQuantity > 0)
                  Positioned(
                    left: baseWidth - 1,
                    child: Container(
                      width: 2,
                      height: 6,
                      color: Colors.white,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// 액션 버튼들 (Windows 스타일 - 같은 행에 배치)
  Widget _buildActionButtons(ManagedPrinter printer, bool hasOrder) {
    final isConnected = printer.connectionStatus == PrinterConnectionStatus.connected;
    final isPrinterOn = printer.isPrinterOn;

    // 발주 선택은 프린터가 준비 상태(isPrinterOn == true)가 아니면 가능 (오프라인이어도 상관없음)
    final canSelectOrder = isPrinterOn != true;

    return Row(
      children: [
        // 발주 선택 버튼 (항상 표시, 중지 상태일 때만 활성화)
        Expanded(
          child: _buildActionButton(
            label: printer.selectedOrder != null ? '발주 변경' : '발주선택',
            icon: Icons.add_shopping_cart,
            color: Colors.blue,
            onPressed: canSelectOrder ? () => _handleOrder(printer) : null,
          ),
        ),
        SizedBox(width: 8),

        // 준비/정지 버튼
        Expanded(
          child: isConnected
              ? (isPrinterOn == true
                  ? _buildActionButton(
                      label: '정지',
                      icon: Icons.pause,
                      color: _PrinterStatusUIConstants.offlineColor,
                      onPressed: () => _handleTogglePrinter(printer, isConnected),
                    )
                  : _buildActionButton(
                      label: '준비',
                      icon: Icons.play_arrow,
                      color: _PrinterStatusUIConstants.onlineColor,
                      onPressed: () => _handleTogglePrinter(printer, isConnected),
                    ))
              : _buildActionButton(label: '연결 필요', icon: Icons.play_arrow, color: Colors.grey, onPressed: null),
        ),
      ],
    );
  }

  /// 액션 버튼 (Windows 스타일)
  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: _PrinterStatusUIConstants.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null ? color : Colors.grey[400],
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.buttonBorderRadius),
          ),
          elevation: onPressed != null ? 1 : 0,
        ),
        child: Text(label, style: _PrinterStatusUIConstants.textStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ),
    );
  }

  /// 아이콘 버튼
  @Deprecated('Not used in Windows UI style')
  Widget _buildIconButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: _PrinterStatusUIConstants.buttonHeight,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label, style: _PrinterStatusUIConstants.textStyle(fontSize: 12)),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.buttonBorderRadius),
          ),
        ),
      ),
    );
  }

  /// 발주하기 처리
  Future<void> _handleOrder(ManagedPrinter printer) async {
    await _showOrderSelectionDialog(printer);
  }

  /// 발주 선택 시 FieldValueManager 초기화 및 복원
  Future<void> _initializeFieldValueManagerForOrder(ManagedPrinter printer, OrderItem order) async {
    try {
      final registry = ref.read(fieldValueManagerRegistryProvider);
      final startCode = int.tryParse(order.startCode) ?? 1;
      final endCode = int.tryParse(order.endCode) ?? 1000000;

      // 완료 수량 조회 (메모리에서 관리)
      final currentTotalCount = _getTotalCompletedCountForOrder(order.orderId);

      // 발주별 FieldValueManager 가져오기 또는 생성 (Isar에서 데이터 복원 포함)
      // 카운트를 전달하여 nextAvailableValue를 동기화
      final manager = await registry.getOrCreateManager(
        order.orderId,
        startCode: startCode,
        endCode: endCode,
        uniqueCode: order.uniqueCode,
        currentTotalCount: currentTotalCount,
      );

      // 프린터에 필드 값 요청 콜백 설정
      if (printer.id != null) {
        final printerId = printer.id!;
        printer.setFieldValueRequestCallback(() async {
          return manager.requestFormattedFieldValue(printerId);
        });

        // 각 프린터의 완료 수량 복원 및 완료 수량 초기화
        try {
          final saver = await ref.read(fieldValueStateSaverProvider.future);
          final savedCompletedCount = await saver.getPrinterCount(order.orderId, printerId);

          // 각 프린터의 복원된 완료 수량 저장
          printer.setOrderRestoredTotalCount(order.orderId, savedCompletedCount);

          if (savedCompletedCount > 0) {
            logger.i(
                '🔍 발주별 프린터 완료 수량 복원: orderId=${order.orderId}, printerId=$printerId, completedCount=$savedCompletedCount');
          } else {
            logger.d('발주별 프린터 완료 수량 없음: orderId=${order.orderId}, printerId=$printerId');
          }

          // 완료 수량 초기화 (처음 한 번만, 모든 프린터의 완료 수량을 합산)
          if (!_orderCompletedCounts.containsKey(order.orderId)) {
            await _initializeCompletedCountForOrder(order.orderId);
            // print-event 상태 초기화 및 타이머 시작
            _initializePrintEventState(order);
          }
        } catch (e) {
          logger.e('발주별 프린터 완료 수량 복원 실패: $e');
        }
      }

      logger.i('발주별 FieldValueManager 초기화 및 복원 완료: orderId=${order.orderId}, printerId=${printer.id}');
    } catch (e, stackTrace) {
      logger.e('발주별 FieldValueManager 초기화 실패: $e\n$stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('발주 데이터 복원 실패: $e'), backgroundColor: Colors.red),
      );
    }
  }

  /// 발주 선택 다이얼로그 표시
  Future<void> _showOrderSelectionDialog(ManagedPrinter printer) async {
    // 프린터가 준비 상태가 아닌지 확인 (오프라인이어도 상관없음)
    final isPrinterOn = printer.isPrinterOn;

    if (isPrinterOn == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('프린터가 실행 중입니다. 발주를 선택하려면 먼저 프린터를 정지하세요.'), backgroundColor: Colors.orange));
      return;
    }

    final orders = ref.read(orderListProvider);

    // 수령완료 상태인 주문만 필터링 (상태 코드 '4': 인쇄/가공 중)
    final availableOrders = orders.where((order) => order.status == '4').toList();

    if (availableOrders.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('선택 가능한 발주가 없습니다. 수령완료된 주문이 필요합니다.'), backgroundColor: Colors.orange));
      return;
    }

    final selectedOrder = await showDialog<OrderItem>(
      context: context,
      builder: (context) => _OrderSelectionDialog(orders: availableOrders, currentSelectedOrder: printer.selectedOrder),
    );

    if (selectedOrder != null) {
      final wasAlreadySelected = printer.selectedOrder?.orderId == selectedOrder.orderId;

      // 기존 발주를 선택한 프린터가 있는지 확인 (현재 프린터 제외)
      final printers = ref.read(printerListProvider);
      final otherPrintersWithSameOrder =
          printers.where((p) => p != printer && p.selectedOrder?.orderId == selectedOrder.orderId).toList();
      final hasOtherPrintersWithSameOrder = otherPrintersWithSameOrder.isNotEmpty;

      // 발주 선택 시 먼저 발주를 설정 (카운트 초기화)
      printer.setSelectedOrder(selectedOrder);

      // 발주 선택 시 Isar에 마지막 선택 발주 저장
      if (printer.id != null) {
        try {
          final saver = await ref.read(fieldValueStateSaverProvider.future);
          saver.savePrinterLastOrderImmediately(
            printerId: printer.id!,
            orderId: selectedOrder.orderId,
          );
        } catch (e) {
          logger.e('프린터 마지막 발주 저장 실패: $e');
        }
      }

      // 발주 선택 시 Isar에서 데이터 복원 및 FieldValueManager 초기화
      // setSelectedOrder가 먼저 호출되어 카운트가 0으로 초기화된 후 복원
      await _initializeFieldValueManagerForOrder(printer, selectedOrder);

      // print-event 상태 초기화 (처음 한 번만)
      final isFirstTimeForOrder = !_printEventStates.containsKey(selectedOrder.orderId);
      if (isFirstTimeForOrder) {
        _initializePrintEventState(selectedOrder);
      }

      // 기존 발주를 선택한 프린터가 없는 경우 (이 프린터가 첫 번째로 선택하는 경우)
      // 마지막 API 호출 이후 증가한 카운트 전송
      if (!hasOtherPrintersWithSameOrder) {
        final state = _printEventStates[selectedOrder.orderId];
        if (state != null) {
          final currentCount = _getTotalCompletedCountForOrder(selectedOrder.orderId);
          final incrementCount = currentCount - state.lastApiCount;
          if (incrementCount > 0) {
            logger.i(
                '📋 발주 선택 시 print-event 호출 (기존 프린터 없음): orderId=${selectedOrder.orderId}, incrementCount=$incrementCount');
            await _sendPrintEvent(selectedOrder.orderId, incrementCount);
          }
        }
      }

      // UI 업데이트 (발주별 그룹화를 위해 필요)
      setState(() {});

      if (wasAlreadySelected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('발주가 선택되었습니다: ${selectedOrder.itemName}'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('발주가 변경되었습니다: ${selectedOrder.itemName}'), backgroundColor: Colors.green),
        );
      }
    }
  }

  /// 인쇄 완료 처리
  Future<void> _handleCompletePrint(ManagedPrinter printer) async {
    final selectedOrder = printer.selectedOrder;
    if (selectedOrder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('발주가 선택되지 않았습니다.'), backgroundColor: Colors.orange),
      );
      return;
    }

    // 확인 다이얼로그 표시
    final confirmed = await CommonAlert.showConfirmDialog(
      context: context,
      title: '인쇄 완료',
      content:
          '발주 "${selectedOrder.itemName}"의 인쇄를 완료 처리하시겠습니까?\n\n완료 수량: ${_getTotalCompletedCountForOrder(selectedOrder.orderId)}장\n\n이 작업은 저장된 데이터를 초기화합니다.',
      confirmText: '완료',
      cancelText: '취소',
      confirmColor: Colors.green,
    );

    if (confirmed != true) return;

    try {
      final orderId = selectedOrder.orderId;
      final totalCompleted = _getTotalCompletedCountForOrder(orderId);

      final request = PatchOrderRequest(status: OrderStatus.printingComplete);
      final orderRepository = ref.read(orderRepositoryProvider);
      final response = await orderRepository.updateOrder(orderId, request);

      // response 확인, 실패 시 아래 작업 취소 해야함.
      logger.i("updateOrder response: $response");

      // Isar에서 발주별 데이터 초기화
      final registry = ref.read(fieldValueManagerRegistryProvider);
      await registry.clearOrderData(orderId);
      logger.i('발주별 Isar 데이터 초기화 완료: orderId=$orderId');

      // 완료 수량 초기화
      _orderCompletedCounts.remove(orderId);

      // 발주 선택 해제
      printer.setSelectedOrder(null);

      // 완료 알림
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('발주 "${selectedOrder.itemName}" 인쇄 완료 처리 완료 (완료 수량: $totalCompleted장)'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }

      setState(() {}); // UI 업데이트
    } catch (e) {
      logger.e('인쇄 완료 처리 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('인쇄 완료 처리 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 발주별 인쇄 완료 버튼 빌드
  Widget _buildCompletePrintButton(int orderId, List<ManagedPrinter> printers) {
    // Consumer로 감싸서 완료 수량 변경 시 버튼 업데이트
    return Consumer(
      builder: (context, ref, child) {
        // 연결된 프린터만 필터링
        final connectedPrinters =
            printers.where((p) => p.connectionStatus == PrinterConnectionStatus.connected).toList();

        // 모든 연결된 프린터가 중지 상태인지 확인
        final allStopped = connectedPrinters.isEmpty || connectedPrinters.every((p) => p.isPrinterOn != true);

        // 발주 정보 가져오기
        final orders = ref.read(orderListProvider);
        final order = orders.firstWhere((o) => o.orderId == orderId, orElse: () => orders.first);

        // 완료 수량 조회 (printerListProvider를 watch하여 완료 수량 변경 감지)
        ref.watch(printerListProvider);
        final totalCompleted = _getTotalCompletedCountForOrder(orderId);

        // 발주량(baseQuantity) 이상 프린팅했는지 확인
        final baseQuantityReached = totalCompleted >= order.baseQuantity;

        // 모든 프린터가 중지 상태이고, 발주량 이상 프린팅했을 때만 버튼 활성화
        if (!allStopped || !baseQuantityReached) {
          return SizedBox.shrink(); // 조건을 만족하지 않으면 버튼 숨김
        }

        return OutlinedButton.icon(
          onPressed: () => _handleCompletePrintForOrder(orderId, printers),
          icon: Icon(Icons.check_circle, size: 14),
          label: Text('인쇄 완료'),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            minimumSize: Size(0, 28),
            side: BorderSide(color: Colors.green),
            foregroundColor: Colors.green[700],
          ),
        );
      },
    );
  }

  /// 발주별 인쇄 완료 처리
  Future<void> _handleCompletePrintForOrder(int orderId, List<ManagedPrinter> printers) async {
    final orders = ref.read(orderListProvider);
    final order = orders.firstWhere((o) => o.orderId == orderId, orElse: () => orders.first);

    // 확인 다이얼로그 표시
    final totalCompleted = _getTotalCompletedCountForOrder(orderId);
    final confirmed = await CommonAlert.showConfirmDialog(
      context: context,
      title: '인쇄 완료',
      content:
          '발주 ${orderId}: "${order.itemName}"의 인쇄를 완료 처리하시겠습니까?\n\n완료 수량: $totalCompleted장\n프린터 수: ${printers.length}개\n\n이 작업은 저장된 데이터를 초기화합니다.',
      confirmText: '완료',
      cancelText: '취소',
      confirmColor: Colors.green,
    );

    if (confirmed != true) return;

    try {
      // 인쇄 완료 전에 마지막 API 호출 이후 증가한 카운트 전송
      final state = _printEventStates[orderId];
      if (state != null) {
        final currentCount = _getTotalCompletedCountForOrder(orderId);
        final incrementCount = currentCount - state.lastApiCount;
        if (incrementCount > 0) {
          logger.i('🏁 인쇄 완료 전 print-event 호출: orderId=$orderId, incrementCount=$incrementCount');
          await _sendPrintEvent(orderId, incrementCount);
        }
      }

      // Isar에서 발주별 데이터 초기화
      final registry = ref.read(fieldValueManagerRegistryProvider);
      await registry.clearOrderData(orderId);
      logger.i('발주별 Isar 데이터 초기화 완료: orderId=$orderId');

      // 완료 수량 초기화
      _orderCompletedCounts.remove(orderId);

      // print-event 상태 정리
      _printEventStates[orderId]?.dispose();
      _printEventStates.remove(orderId);

      // 해당 발주에 할당된 모든 프린터의 발주 선택 해제
      for (final printer in printers) {
        if (printer.selectedOrder?.orderId == orderId) {
          printer.setSelectedOrder(null);
        }
      }

      // 완료 알림
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('발주 ${orderId}: "${order.itemName}" 인쇄 완료 처리 완료 (완료 수량: $totalCompleted장)'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }

      setState(() {}); // UI 업데이트
    } catch (e) {
      logger.e('인쇄 완료 처리 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('인쇄 완료 처리 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 발주별 일괄 제어 버튼 빌드
  Widget _buildBatchControlButtons(int orderId, List<ManagedPrinter> printers) {
    // 연결된 프린터만 필터링
    final connectedPrinters = printers.where((p) => p.connectionStatus == '연결됨').toList();
    if (connectedPrinters.isEmpty) {
      return SizedBox.shrink();
    }

    // 모든 프린터가 준비 상태인지 확인
    final allReady = connectedPrinters.every((p) => p.isPrinterOn != true);
    final allRunning = connectedPrinters.every((p) => p.isPrinterOn == true);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 일괄 준비 버튼 (모든 프린터가 중지 상태일 때만 표시)
        if (allReady)
          OutlinedButton.icon(
            onPressed: () => _handleBatchTogglePrinters(orderId, printers, start: true),
            icon: Icon(Icons.play_arrow, size: 14),
            label: Text('일괄 준비'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size(0, 28),
              side: BorderSide(color: Colors.green),
              foregroundColor: Colors.green[700],
            ),
          ),
        // 일괄 중지 버튼 (모든 프린터가 준비 상태일 때만 표시)
        if (allRunning)
          OutlinedButton.icon(
            onPressed: () => _handleBatchTogglePrinters(orderId, printers, start: false),
            icon: Icon(Icons.pause, size: 14),
            label: Text('일괄 중지'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size(0, 28),
              side: BorderSide(color: Colors.orange),
              foregroundColor: Colors.orange[700],
            ),
          ),
        // 혼합 상태일 때는 두 버튼 모두 표시
        if (!allReady && !allRunning) ...[
          OutlinedButton.icon(
            onPressed: () => _handleBatchTogglePrinters(orderId, printers, start: true),
            icon: Icon(Icons.play_arrow, size: 14),
            label: Text('일괄 준비'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size(0, 28),
              side: BorderSide(color: Colors.green),
              foregroundColor: Colors.green[700],
            ),
          ),
          SizedBox(width: 6),
          OutlinedButton.icon(
            onPressed: () => _handleBatchTogglePrinters(orderId, printers, start: false),
            icon: Icon(Icons.pause, size: 14),
            label: Text('일괄 중지'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size(0, 28),
              side: BorderSide(color: Colors.orange),
              foregroundColor: Colors.orange[700],
            ),
          ),
        ],
      ],
    );
  }

  /// 발주별 일괄 프린터 제어 (준비/중지)
  Future<void> _handleBatchTogglePrinters(int orderId, List<ManagedPrinter> printers, {required bool start}) async {
    // 연결된 프린터만 필터링
    final connectedPrinters = printers.where((p) => p.connectionStatus == '연결됨').toList();

    if (connectedPrinters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('연결된 프린터가 없습니다.'), backgroundColor: Colors.orange),
      );
      return;
    }

    // 확인 다이얼로그 표시
    final action = start ? '준비' : '중지';
    final confirmed = await CommonAlert.showConfirmDialog(
      context: context,
      title: '일괄 $action',
      content: '발주 $orderId에 할당된 ${connectedPrinters.length}개 프린터를 모두 $action하시겠습니까?',
      confirmText: action,
      cancelText: '취소',
      confirmColor: start ? Colors.green : Colors.orange,
    );

    if (confirmed != true) return;

    try {
      int successCount = 0;
      int failCount = 0;

      // 모든 프린터를 동시에 제어
      await Future.wait(
        connectedPrinters.map((printer) async {
          try {
            // Running 상태로 변경하려는 경우 발주 완료 여부 체크
            await printer.setPrinterState(
              start,
              onCompletedCountCheck: start
                  ? () {
                      final selectedOrder = printer.selectedOrder;
                      if (selectedOrder != null) {
                        final totalCompleted = _getTotalCompletedCountForOrder(selectedOrder.orderId);
                        final totalQuantity = selectedOrder.baseQuantity; // 총 발주 수량

                        // 총 발주 수량과 완료 수량이 같으면 Running 상태로 변경 불가
                        if (totalCompleted >= totalQuantity) {
                          logger.w('프린터 ${printer.id} 일괄 $action 실패: 발주 완료됨 (완료: $totalCompleted/$totalQuantity)');
                          return true; // 완료됨
                        }
                      }
                      return false; // 완료되지 않음
                    }
                  : null,
            );
            successCount++;
            logger.i('프린터 ${printer.id} 일괄 $action 성공');
          } catch (e) {
            failCount++;
            logger.e('프린터 ${printer.id} 일괄 $action 실패: $e');
          }
        }),
      );

      // 상태 새로고침
      ref.read(printerListProvider.notifier).refreshState();
      setState(() {});

      // 결과 알림
      if (mounted) {
        if (failCount == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('발주 $orderId: ${connectedPrinters.length}개 프린터 모두 $action 완료'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('발주 $orderId: $successCount개 성공, $failCount개 실패'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      logger.e('일괄 $action 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('일괄 $action 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 프린터 On/Off 토글
  Future<void> _handleTogglePrinter(ManagedPrinter printer, bool isConnected) async {
    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('프린터가 연결되지 않았습니다')));
      return;
    }

    try {
      final currentState = printer.isPrinterOn;

      if (currentState == true) {
        // 프린터 OFF로 변경
        await printer.setPrinterState(false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${printer.name} 프린터가 중지되었습니다')));
      } else {
        // 프린터 ON으로 변경 전에 발주 완료 여부 체크
        final selectedOrder = printer.selectedOrder;
        bool isOrderCompleted = false;
        if (selectedOrder != null) {
          final totalCompleted = _getTotalCompletedCountForOrder(selectedOrder.orderId);
          final totalQuantity = selectedOrder.baseQuantity; // 총 발주 수량

          // 총 발주 수량과 완료 수량이 같으면 Running 상태로 변경 불가
          isOrderCompleted = totalCompleted >= totalQuantity;
          if (isOrderCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('발주 "${selectedOrder.itemName}"는 이미 완료되었습니다. (완료: $totalCompleted/$totalQuantity)'),
                backgroundColor: Colors.orange,
              ),
            );
            return;
          }
        }

        // 프린터 ON으로 변경 (발주 완료 체크 콜백 전달)
        await printer.setPrinterState(
          true,
          onCompletedCountCheck: () {
            if (selectedOrder != null) {
              final totalCompleted = _getTotalCompletedCountForOrder(selectedOrder.orderId);
              final totalQuantity = selectedOrder.baseQuantity;
              return totalCompleted >= totalQuantity;
            }
            return false;
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${printer.name} 프린터가 시작되었습니다')));
      }

      ref.read(printerListProvider.notifier).refreshState();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('프린터 상태 변경 실패: $e')));
    }
  }

  /// 프린터 제거 처리
  Future<void> _handleRemovePrinter(ManagedPrinter printer) async {
    final confirmed = await CommonAlert.showConfirmDialog(
      context: context,
      title: '프린터 제거',
      content: '${printer.name} 프린터를 제거하시겠습니까?',
      confirmText: '제거',
      cancelText: '취소',
      confirmColor: _PrinterStatusUIConstants.errorColor,
    );

    if (confirmed == true) {
      try {
        final printerRepository = ref.read(printerRepositoryProvider);
        if (printer.id != null) {
          await printerRepository.deletePrinter(printer.id!);
        }
        await printer.stopPrintMonitoring();
        await ref.read(printerListProvider.notifier).removePrinter(printer);
        await _refreshPrinterList();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('프린터가 제거되었습니다')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('프린터 제거 실패: $e')));
      }
    }
  }

  /// 프린터 추가 다이얼로그 표시
  void _showAddPrinterDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final ipController = TextEditingController();
    final portController = TextEditingController(text: '5000');
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Stack(
            children: [
              AlertDialog(
                title: Text(
                  '프린터 추가하기',
                  style: _PrinterStatusUIConstants.textStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                content: _buildAddPrinterForm(nameController, ipController, portController),
                actions: [
                  TextButton(
                    onPressed: isLoading ? null : () => Navigator.pop(context),
                    child: Text('취소', style: _PrinterStatusUIConstants.textStyle()),
                  ),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => _handleAddPrinter(
                              context,
                              ref,
                              nameController,
                              ipController,
                              portController,
                              (loading) => setState(() => isLoading = loading),
                            ),
                    child: Text('추가하기', style: _PrinterStatusUIConstants.textStyle()),
                  ),
                ],
              ),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: _PrinterStatusUIConstants.cardShadow,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// 프린터 추가 폼 빌드
  Widget _buildAddPrinterForm(
    TextEditingController nameController,
    TextEditingController ipController,
    TextEditingController portController,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: '프린터 이름', border: OutlineInputBorder()),
        ),
        SizedBox(height: 12),
        TextField(
          controller: ipController,
          decoration: InputDecoration(labelText: 'IP 주소', border: OutlineInputBorder()),
        ),
        SizedBox(height: 12),
        TextField(
          controller: portController,
          decoration: InputDecoration(labelText: 'Port', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  /// 프린터 추가 처리
  Future<void> _handleAddPrinter(
    BuildContext context,
    WidgetRef ref,
    TextEditingController nameController,
    TextEditingController ipController,
    TextEditingController portController,
    Function(bool) setLoading,
  ) async {
    setLoading(true);

    final name = nameController.text.trim();
    final ip = ipController.text.trim();
    final port = int.tryParse(portController.text.trim()) ?? 0;

    if (ref.read(printerListProvider.notifier).exists(ip, port)) {
      setLoading(false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('이미 추가된 프린터입니다')));
      return;
    }

    final printer = ManagedPrinter(
      index: ref.read(printerListProvider).length + 1,
      id: null,
      name: name,
      ip: ip,
      port: port,
      regDate: DateTime.now().toString(),
    );

    final connected = await printer.connect();
    logger.i("connected: $connected");

    if (connected) {
      _setupCountUpdateCallback(printer);
      await _savePrinterToServer(ref, printer, name, ip, port);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('프린터가 추가되었습니다')));
    } else {
      await printer.stopPrintMonitoring();
      printer.dispose();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('연결할 수 없습니다')));
    }

    setLoading(false);
  }

  /// 서버에 프린터 저장
  Future<void> _savePrinterToServer(WidgetRef ref, ManagedPrinter printer, String name, String ip, int port) async {
    ref.read(printerListProvider.notifier).addPrinter(printer);

    final request = PrintersRequest(name: name, model: "VJ 6330", ip: ip, port: port.toString(), status: "인쇄 대기");

    final printerRepository = ref.read(printerRepositoryProvider);
    final response = await printerRepository.addPrinter(request);
    logger.i("response: $response");
    printer.updateFields(id: response.data.processingCompanyPrinterIndex);
  }

  // ========== Print Event API 관련 메서드 ==========

  /// UUID 형식의 난수 eventKey 생성 (멱등성 보장)
  /// 서버가 같은 eventKey로 여러 번 호출된 경우 중복 카운트를 방지하기 위해
  /// 각 API 호출마다 고유한 난수 eventKey를 생성합니다.
  String _generateEventKey() {
    final random = Random();
    // UUID v4 형식: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
    // 4는 버전, y는 8, 9, a, b 중 하나
    final chars = '0123456789abcdef';
    final parts = <String>[];

    // 8자리
    parts.add(List.generate(8, (_) => chars[random.nextInt(chars.length)]).join());
    // 4자리
    parts.add(List.generate(4, (_) => chars[random.nextInt(chars.length)]).join());
    // 4자리 (버전 4)
    parts.add('4' + List.generate(3, (_) => chars[random.nextInt(chars.length)]).join());
    // 4자리 (variant)
    final variantChars = '89ab';
    parts.add(variantChars[random.nextInt(variantChars.length)] +
        List.generate(3, (_) => chars[random.nextInt(chars.length)]).join());
    // 12자리
    parts.add(List.generate(12, (_) => chars[random.nextInt(chars.length)]).join());

    return parts.join('-');
  }

  /// 발주별 print-event 상태 초기화 및 타이머 시작
  void _initializePrintEventState(OrderItem order) {
    final orderId = order.orderId;

    // 기존 상태가 있으면 정리
    _printEventStates[orderId]?.dispose();

    // 새 상태 생성 (eventKey는 각 API 호출 시마다 생성)
    final state = _PrintEventState(
      orderId: orderId,
      lastApiCount: 0,
    );

    _printEventStates[orderId] = state;

    // 5분 타이머 시작
    _startPrintEventTimer(orderId);

    logger.i('📊 Print-event 상태 초기화: orderId=$orderId, unit=${state.unit}');
  }

  /// 5분 타이머 시작
  void _startPrintEventTimer(int orderId) {
    final state = _printEventStates[orderId];
    if (state == null) return;

    // 기존 타이머가 있으면 취소
    state.timer?.cancel();

    // 5분마다 실행되는 타이머 시작
    state.timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _onPrintEventTimerTick(orderId);
    });

    logger.i('⏰ Print-event 타이머 시작: orderId=$orderId');
  }

  /// 타이머 틱 처리 (5분마다 실행)
  Future<void> _onPrintEventTimerTick(int orderId) async {
    final state = _printEventStates[orderId];
    if (state == null) return;

    // 현재 완료 수량 조회
    final currentCount = _getTotalCompletedCountForOrder(orderId);

    // 마지막 API 호출 이후 증가한 카운트 계산
    final incrementCount = currentCount - state.lastApiCount;

    logger.i('⏰ Print-event 타이머 틱: orderId=$orderId, currentCount=$currentCount lastApiCount=${state.lastApiCount}');

    // 증가한 카운트가 있으면 API 호출
    if (incrementCount > 0) {
      logger.i('⏰ Print-event incrementCount > 0 타이머 틱: orderId=$orderId, incrementCount=$incrementCount');
      await _sendPrintEvent(orderId, incrementCount);
    } else {
      logger.d('⏰ Print-event 타이머 틱: orderId=$orderId, 증가한 카운트 없음');
    }
  }

  /// 카운트 증가 시 단위 체크 및 API 호출
  /// 단위 배수에 도달했을 때, 마지막 API 호출 이후 실제 증가한 카운트만큼 전송합니다.
  /// 예: unit=100, lastApiCount=60, currentCount=200인 경우
  ///     실제로는 140만큼 더 프린트했으므로 quantity=140으로 전송
  Future<void> _checkAndSendPrintEventIfNeeded(int orderId) async {
    final state = _printEventStates[orderId];
    if (state == null) return;

    // 현재 완료 수량 조회
    final currentCount = _getTotalCompletedCountForOrder(orderId);

    // 단위 체크: 현재 카운트가 단위의 배수인지 확인
    // 예: 단위가 30이면 30, 60, 90, ... 마다 실행
    final shouldSendByUnit = (currentCount > 0) && (currentCount % state.unit == 0);

    logger.i(
        '📊 Print-event 단위 도달: orderId=$orderId, currentCount=$currentCount, lastApiCount=${state.lastApiCount}, shouldSendByUnit=$shouldSendByUnit, unit=${state.unit}');

    if (shouldSendByUnit) {
      // 마지막 API 호출 이후 실제 증가한 카운트 계산
      final incrementCount = currentCount - state.lastApiCount;

      // 증가한 카운트가 있으면 전송 (타이머에서 이미 일부를 호출했을 수 있으므로)
      if (incrementCount > 0) {
        logger.i(
            '📊 Print-event 단위 도달: orderId=$orderId, currentCount=$currentCount, lastApiCount=${state.lastApiCount}, incrementCount=$incrementCount, unit=${state.unit}');
        await _sendPrintEvent(orderId, incrementCount);
      }
    }
  }

  /// Print-event API 호출
  /// 각 호출마다 고유한 난수 eventKey를 생성하여 멱등성을 보장합니다.
  Future<void> _sendPrintEvent(int orderId, int quantity) async {
    final state = _printEventStates[orderId];
    if (state == null) {
      logger.w('Print-event 상태 없음: orderId=$orderId');
      return;
    }

    // 각 API 호출마다 고유한 난수 eventKey 생성 (멱등성 보장)
    final eventKey = _generateEventKey();

    try {
      final orderRepository = ref.read(orderRepositoryProvider);
      final request = PrintEventRequest(
        orderId: orderId,
        quantity: quantity,
        eventKey: eventKey,
      );

      logger.i('📤 Print-event API 호출: orderId=$orderId, quantity=$quantity, eventKey=$eventKey');

      final response = await orderRepository.sendPrintEvent(request);

      if (response.status == "success") {
        // 성공 시 마지막 API 호출 시점 업데이트
        final currentCount = _getTotalCompletedCountForOrder(orderId);
        state.lastApiCount = currentCount;
        state.lastApiTime = DateTime.now();

        logger.i(
            '✅ Print-event API 성공: orderId=$orderId, quantity=$quantity, lastApiCount=${state.lastApiCount}, totalPrintedQuantity=${response.data.totalPrintedQuantity}');
      } else {
        logger.w('⚠️ Print-event API 실패 (status=${response.status}): orderId=$orderId, message=${response.message}');
      }
    } catch (e, stackTrace) {
      logger.e('❌ Print-event API 호출 실패: orderId=$orderId, error=$e\n$stackTrace');
    }
  }

  @override
  void dispose() {
    // 모든 타이머 정리
    for (final state in _printEventStates.values) {
      state.dispose();
    }
    _printEventStates.clear();
    super.dispose();
  }
}

/// 발주 선택 다이얼로그
class _OrderSelectionDialog extends StatefulWidget {
  final List<OrderItem> orders;
  final OrderItem? currentSelectedOrder;

  const _OrderSelectionDialog({required this.orders, this.currentSelectedOrder});

  @override
  State<_OrderSelectionDialog> createState() => _OrderSelectionDialogState();
}

class _OrderSelectionDialogState extends State<_OrderSelectionDialog> {
  OrderItem? _selectedOrder;

  @override
  void initState() {
    super.initState();
    _selectedOrder = widget.currentSelectedOrder;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 600,
        constraints: BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          color: _PrinterStatusUIConstants.cardBg,
          border: Border.all(color: _PrinterStatusUIConstants.borderColor, width: 1),
          borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.cardBorderRadius),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Windows 스타일 헤더 (그라데이션)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_PrinterStatusUIConstants.windowTitleBarStart, _PrinterStatusUIConstants.windowTitleBarEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_PrinterStatusUIConstants.cardBorderRadius),
                  topRight: Radius.circular(_PrinterStatusUIConstants.cardBorderRadius),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.shopping_cart, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '발주 선택',
                    style: _PrinterStatusUIConstants.textStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 18),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
            ),
            // 본문
            Flexible(
              child: Container(
                padding: EdgeInsets.all(16),
                child: widget.orders.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
                              SizedBox(height: 16),
                              Text(
                                '선택 가능한 발주가 없습니다.',
                                style: _PrinterStatusUIConstants.textStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.orders.length,
                        itemBuilder: (context, index) {
                          final order = widget.orders[index];
                          final isSelected = _selectedOrder?.orderId == order.orderId;

                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedOrder = order;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 8),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Color(0xFFE3F2FD) // Windows Blue 배경
                                    : _PrinterStatusUIConstants.toolbarBg,
                                border: Border.all(
                                  color: isSelected
                                      ? _PrinterStatusUIConstants.primaryBlue
                                      : _PrinterStatusUIConstants.borderColor,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.cardBorderRadius),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle,
                                          color: _PrinterStatusUIConstants.primaryBlue,
                                          size: 20,
                                        )
                                      else
                                        Icon(Icons.radio_button_unchecked, color: Colors.grey[600], size: 20),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          order.itemName,
                                          style: _PrinterStatusUIConstants.textStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                isSelected ? _PrinterStatusUIConstants.primaryBlue : Colors.grey[900],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(child: _buildOrderInfoRow('주문 ID', '${order.orderId}')),
                                      Expanded(child: _buildOrderInfoRow('수량', '${order.quantity}')),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Expanded(child: _buildOrderInfoRow('기관명', order.institutionName)),
                                      Expanded(child: _buildOrderInfoRow('등록일', order.regDate)),
                                    ],
                                  ),
                                  if (order.uniqueCode.isNotEmpty) ...[
                                    SizedBox(height: 4),
                                    _buildOrderInfoRow('고유 코드', order.uniqueCode),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
            // Windows 스타일 푸터 (버튼 영역)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _PrinterStatusUIConstants.toolbarBg,
                border: Border(top: BorderSide(color: _PrinterStatusUIConstants.borderColor, width: 1)),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(_PrinterStatusUIConstants.cardBorderRadius),
                  bottomRight: Radius.circular(_PrinterStatusUIConstants.cardBorderRadius),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      side: BorderSide(color: _PrinterStatusUIConstants.borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.buttonBorderRadius),
                      ),
                    ),
                    child: Text(
                      '취소',
                      style: _PrinterStatusUIConstants.textStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _selectedOrder != null ? () => Navigator.pop(context, _selectedOrder) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _selectedOrder != null ? _PrinterStatusUIConstants.primaryBlue : Colors.grey[400],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.buttonBorderRadius),
                      ),
                      elevation: _selectedOrder != null ? 1 : 0,
                    ),
                    child: Text(
                      '선택',
                      style: _PrinterStatusUIConstants.textStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: _PrinterStatusUIConstants.textStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(value, style: _PrinterStatusUIConstants.textStyle(fontSize: 12, color: Colors.grey[900])),
          ),
        ],
      ),
    );
  }
}
