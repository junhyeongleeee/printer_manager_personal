import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_manager/core/data/models/request/warehouse_request.dart';
import '../../core/domain/entities/managed_printer.dart';
import '../providers/order_list_provider.dart';
import '../providers/printer_list_provider.dart';
import 'package:print_manager/core/data/repositories/order_repository_provider.dart';
import 'package:print_manager/core/data/models/request/patch_order_request.dart';
import 'package:print_manager/core/data/models/request/print_event_request.dart';
import 'package:print_manager/presentation/providers/prototype_printer_provider.dart';
import 'package:print_manager/core/services/logger_service.dart';
import '../widgets/common_alert_dialog.dart';
import '../providers/field_value_state_saver_provider.dart';
import 'package:print_manager/core/data/models/response/order_history_response.dart';
import 'package:print_manager/core/data/models/response/order_shipment_response.dart';

class OrderManagePage extends ConsumerStatefulWidget {
  const OrderManagePage({super.key});

  @override
  ConsumerState<OrderManagePage> createState() => _OrderManagePageState();
}

/// 주문 상태 상수
class OrderStatus {
  static const String waiting = '1';
  static const String inProgress = '2';
  static const String shipping = '3';
  static const String printing = '4';
  static const String printingComplete = '5';
  static const String shipped = '6';

  static String getStatusText(String status) {
    switch (status) {
      case waiting:
        return '제작 대기';
      case inProgress:
        return '제작 중';
      case shipping:
        return '배송 중';
      case printing:
        return '인쇄/가공 중';
      case printingComplete:
        return '인쇄/가공 완료';
      case shipped:
        return '출고 완료';
      default:
        return '제작 대기';
    }
  }
}

/// UI 상수 (Windows UI 스타일)
class _UIConstants {
  static const double headerHeight = 84.0;
  static const double horizontalPadding = 16.0;
  static const double buttonMinWidth = 94.0;
  static const double buttonHeight = 32.0;
  static const double borderRadius = 2.0; // Windows 스타일
  static const double cellMinWidth = 100.0;
  static const double buttonCellWidth = 150.0; // 작업 처리 버튼을 위한 더 넓은 너비
  static const double refreshDelaySeconds = 1.0;

  // 폰트 패밀리
  static const String fontFamily = 'Pretendard';

  // 텍스트 스타일 헬퍼 메서드
  static TextStyle textStyle({double? fontSize, FontWeight? fontWeight, Color? color, String? fontFamily}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: fontFamily ?? _UIConstants.fontFamily,
    );
  }

  // Windows 색상
  static const Color headerBackgroundColor = Color(0xFFE8E8E8); // Windows 스타일
  static const Color rowBackgroundColor = Color(0xFFFFFFFF);
  static const Color primaryBlue = Color(0xFF0078D4); // Windows Blue
  static const Color darkBlue = Color(0xFF005A9E);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color textGray = Color(0xFF3A3A3C);
  static const Color borderGray = Color(0xFFADADAD); // Windows border color
  static const Color backgroundColor = Color(0xFFF0F0F0); // Windows background
  static const Color toolbarBg = Color(0xFFE8E8E8);
  static const Color borderColor = Color(0xFFADADAD);
  static const double cardBorderRadius = 2.0;
  static const double buttonBorderRadius = 2.0;
}

class _OrderManagePageState extends ConsumerState<OrderManagePage> {
  String? _selectedStatusFilter; // null이면 전체, 아니면 특정 상태
  final Map<int, int> _completedCountsCache = {}; // 발주별 완료 수량 캐시 (key: orderId, value: 완료 수량)

  @override
  void initState() {
    super.initState();
    _refreshOrderList();
  }

  /// 주문 목록 새로고침
  Future<void> _refreshOrderList() async {
    final orderRepository = ref.read(orderRepositoryProvider);
    final response = await orderRepository.orderList();
    ref.read(orderListProvider.notifier).replaceOrderListInProvider(ref, response);

    // 완료 수량 최신화 (비동기로 조회하여 캐시 업데이트)
    await _refreshCompletedCounts(response.data.orderList.map((dto) => dto.orderId).toList());

    if (mounted) {
      setState(() {});
    }
  }

  /// 모든 발주의 완료 수량을 조회하여 캐시 업데이트
  Future<void> _refreshCompletedCounts(List<int> orderIds) async {
    try {
      final saver = await ref.read(fieldValueStateSaverProvider.future);

      // 각 발주별로 완료 수량 조회
      for (final orderId in orderIds) {
        final printerCounts = await saver.getAllPrinterCountsForOrder(orderId);
        int total = 0;
        for (final count in printerCounts.values) {
          total += count;
        }
        _completedCountsCache[orderId] = total;
      }
    } catch (e) {
      logger.e('완료 수량 조회 실패: error=$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderListProvider);
    final printers = ref.watch(printerListProvider);
    final filteredOrders = _getFilteredOrders(orders);

    return Scaffold(
      backgroundColor: _UIConstants.backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildToolbar(orders),
                  _buildOrderTable(filteredOrders, printers),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Toolbar (Windows 스타일) - 프린터 상태 화면과 동일한 구조
  Widget _buildToolbar(List orders) {
    final counts = _getStatusCounts(orders);

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _UIConstants.toolbarBg,
        border: Border.all(color: _UIConstants.borderColor),
        borderRadius: BorderRadius.circular(_UIConstants.cardBorderRadius),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterButton('전체', null, counts['all']!),
                _buildFilterButton('제작 대기', OrderStatus.waiting, counts['waiting']!),
                _buildFilterButton('제작 중', OrderStatus.inProgress, counts['inProgress']!),
                _buildFilterButton('배송 중', OrderStatus.shipping, counts['shipping']!),
                _buildFilterButton('인쇄/가공 중', OrderStatus.printing, counts['printing']!),
                _buildFilterButton('인쇄/가공 완료', OrderStatus.printingComplete, counts['printingComplete']!),
                _buildFilterButton('출고 완료', OrderStatus.shipped, counts['shipped']!),
              ],
            ),
          ),
          SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: _refreshOrderList,
            icon: Icon(Icons.refresh, size: 16),
            label: Text('새로고침'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_UIConstants.buttonBorderRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 필터 버튼
  Widget _buildFilterButton(String label, String? status, int count) {
    final isSelected = _selectedStatusFilter == status;
    return OutlinedButton(
      onPressed: () => setState(() => _selectedStatusFilter = status),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.transparent,
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        side: BorderSide(color: isSelected ? Colors.blue : _UIConstants.borderColor, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_UIConstants.buttonBorderRadius),
        ),
      ),
      child: Text('$label ($count)', style: _UIConstants.textStyle()),
    );
  }

  /// 상태별 카운트 계산
  Map<String, int> _getStatusCounts(List orders) {
    int waiting = 0;
    int inProgress = 0;
    int shipping = 0;
    int printing = 0;
    int printingComplete = 0;
    int shipped = 0;

    for (final order in orders) {
      switch (order.status) {
        case OrderStatus.waiting:
          waiting++;
          break;
        case OrderStatus.inProgress:
          inProgress++;
          break;
        case OrderStatus.shipping:
          shipping++;
          break;
        case OrderStatus.printing:
          printing++;
          break;
        case OrderStatus.printingComplete:
          printingComplete++;
          break;
        case OrderStatus.shipped:
          shipped++;
          break;
      }
    }

    return {
      'all': orders.length,
      'waiting': waiting,
      'inProgress': inProgress,
      'shipping': shipping,
      'printing': printing,
      'printingComplete': printingComplete,
      'shipped': shipped,
    };
  }

  /// 필터링된 주문 목록
  List _getFilteredOrders(List orders) {
    if (_selectedStatusFilter == null) {
      return orders;
    }

    return orders.where((order) => order.status == _selectedStatusFilter).toList();
  }

  /// 주문 테이블 빌드 (양옆으로 쭉 늘어나는 구조)
  Widget _buildOrderTable(List orders, List<ManagedPrinter> printers) {
    return Container(
      margin: EdgeInsets.all(_UIConstants.horizontalPadding),
      decoration: BoxDecoration(
        color: _UIConstants.rowBackgroundColor,
        border: Border.all(color: _UIConstants.borderGray, width: 1),
        borderRadius: BorderRadius.circular(_UIConstants.borderRadius),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: IntrinsicWidth(
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) => _UIConstants.headerBackgroundColor,
                    ),
                    dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) => _UIConstants.rowBackgroundColor,
                    ),
                    headingRowHeight: 48,
                    dataRowHeight: 56,
                    columns: _buildTableColumns(),
                    rows: _buildTableRows(orders, printers),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 테이블 컬럼 빌드
  List<DataColumn> _buildTableColumns() {
    return [
      _centerCal('번호'),
      _centerCal('기관명'),
      _centerCal('품목명'),
      _centerCal('코드'),
      _centerCal('처리 상태'),
      _centerCal('총 수량'),
      _centerCal('완료 수량'),
      _centerCal('발주 일시', numeric: false),
      _centerCal('작업 처리', numeric: false, minWidth: _UIConstants.buttonCellWidth),
    ];
  }

  /// 중앙 정렬 컬럼 빌드 (폰트 적용)
  DataColumn _centerCal(String text, {double minWidth = _UIConstants.cellMinWidth, bool numeric = true}) {
    return DataColumn(
      numeric: numeric,
      label: SizedBox(
        width: minWidth,
        child: Center(
          child: Text(
            text,
            style: _UIConstants.textStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[900]),
          ),
        ),
      ),
    );
  }

  /// 테이블 행 빌드
  List<DataRow> _buildTableRows(List orders, List<ManagedPrinter> printers) {
    return orders.asMap().entries.map((entry) {
      final index = entry.key;
      final order = entry.value;
      return _buildDataRow(index, order, printers);
    }).toList();
  }

  /// 데이터 행 빌드
  DataRow _buildDataRow(int index, dynamic order, List<ManagedPrinter> printers) {
    final buttonConfig = _getButtonConfig(order);
    final orderStatus = OrderStatus.getStatusText(order.status);

    // 총 9개의 셀 (컬럼과 일치해야 함)
    // 각 셀을 GestureDetector로 감싸서 행 클릭 이벤트 추가
    final cells = <DataCell>[
      _clickableCell('${index + 1}', order), // 1. 번호
      _clickableCell('${order.institutionName}', order), // 2. 기관명
      _clickableCell(order.itemName, order), // 3. 품목명
      _clickableCell(order.uniqueCode, order), // 4. 코드
      _clickableCell(orderStatus, order), // 5. 처리 상태
      _clickableCell('${order.quantity}', order), // 6. 총 수량
      _buildCompletedCountCell(order.orderId), // 7. 완료 수량
      _clickableCell(order.regDate, order), // 8. 발주 일시
      _clickableButtonCell(_buildActionButton(order, buttonConfig, printers), order), // 9. 작업 처리
    ];

    return DataRow(cells: cells);
  }

  /// 버튼 설정 정보 가져오기
  _ButtonConfig _getButtonConfig(dynamic order) {
    final canConfirm = (order.status == OrderStatus.shipping || order.status == OrderStatus.printingComplete);
    final canAllocate = order.status == OrderStatus.printing;
    final canSendConfirm = (order.status == OrderStatus.printingComplete || order.status == OrderStatus.printing);
    final sendAfterSend = (order.status == OrderStatus.printingComplete ||
        order.status == OrderStatus.printing ||
        order.status == OrderStatus.shipped);

    Color buttonColor;
    Color? borderColor;

    switch (order.status) {
      case OrderStatus.shipping:
        buttonColor = _UIConstants.rowBackgroundColor;
        borderColor = _UIConstants.darkBlue;
        break;
      case OrderStatus.printing:
        buttonColor = _UIConstants.darkBlue;
        borderColor = _UIConstants.rowBackgroundColor;
        break;
      case OrderStatus.printingComplete:
        buttonColor = _UIConstants.rowBackgroundColor;
        borderColor = _UIConstants.successGreen;
        break;
      case OrderStatus.shipped:
        buttonColor = _UIConstants.rowBackgroundColor;
        borderColor = _UIConstants.borderGray;
        break;
      default:
        buttonColor = Colors.grey;
        borderColor = null;
    }

    return _ButtonConfig(
      canConfirm: canConfirm,
      canAllocate: canAllocate,
      canSendConfirm: canSendConfirm,
      sendAfterSend: sendAfterSend,
      buttonColor: buttonColor,
      borderColor: borderColor,
    );
  }

  /// 액션 버튼 빌드
  Widget _buildActionButton(dynamic order, _ButtonConfig config, List<ManagedPrinter> printers) {
    // 인쇄/가공 중 상태에서 출고하기 버튼 표시
    if (order.status == OrderStatus.printing && config.canSendConfirm) {
      return _buildConfirmButton(order, config);
    }

    if (!config.canAllocate) {
      return _buildConfirmButton(order, config);
    } else {
      return _buildAllocateButton(order, config, printers);
    }
  }

  /// 수령완료/출고하기 버튼 빌드
  Widget _buildConfirmButton(dynamic order, _ButtonConfig config) {
    // 출고하기 버튼일 때 완료 수량 확인
    bool isDisabled = false;
    if (config.sendAfterSend) {
      final completedCount = _completedCountsCache[order.orderId] ?? 0;
      isDisabled = completedCount == 0;
    }

    final canPress = config.canConfirm || config.canSendConfirm;

    return ElevatedButton(
      onPressed: (canPress && !isDisabled) ? () => _handleConfirmAction(order) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? Colors.grey[300] : config.buttonColor,
        side: BorderSide(
          color: isDisabled ? Colors.grey : (config.borderColor ?? Colors.white),
          width: 1.0,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_UIConstants.borderRadius)),
      ),
      child: Text(
        config.sendAfterSend ? '출고하기' : '수령완료',
        style: _UIConstants.textStyle(
          color: isDisabled ? Colors.grey[600] : config.borderColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 인쇄하기 버튼 빌드
  Widget _buildAllocateButton(dynamic order, _ButtonConfig config, List<ManagedPrinter> printers) {
    return ElevatedButton(
      onPressed: () => _handleAllocateAction(order, printers),
      style: ElevatedButton.styleFrom(
        backgroundColor: config.buttonColor,
        side: BorderSide(color: config.borderColor ?? Colors.white, width: 1.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_UIConstants.borderRadius)),
      ),
      child: Text(
        (order.status == OrderStatus.printing) ? '인쇄하기' : '출고하기',
        style: _UIConstants.textStyle(color: config.borderColor, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// 상세 내역 액션 처리 (행 클릭 시 호출)
  Future<void> _handleDetailAction(dynamic order) async {
    await _showOrderHistoryDialog(order.orderId);
  }

  /// 발주 현황 이력 다이얼로그 표시
  Future<void> _showOrderHistoryDialog(int orderId) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => _OrderHistoryDialog(
        orderId: orderId,
        orderRepository: ref.read(orderRepositoryProvider),
      ),
    );
  }

  /// 수령완료/출고하기 액션 처리
  Future<void> _handleConfirmAction(dynamic order) async {
    if (order.status == OrderStatus.shipping) {
      ref.read(orderListProvider.notifier).completeOrder(ref.read(orderListProvider).indexOf(order));

      final request = PatchOrderRequest(status: OrderStatus.printing);
      final orderRepository = ref.read(orderRepositoryProvider);
      logger.i("updateOrder request: $request, orderId: ${order.orderId}");
      final response = await orderRepository.updateOrder(order.orderId, request);
      logger.i("updateOrder response: $response");
      _refreshOrderList();
    } else {
      _showSendToWarehouseDialog(
        context,
        ref,
        ref.read(orderListProvider).indexOf(order),
        order.quantity,
        order.stock,
        order.orderId,
        order, // order 객체 추가
      );
      await Future.delayed(Duration(seconds: _UIConstants.refreshDelaySeconds.toInt()));
      _refreshOrderList();
      logger.i("status 6 상태변경은 서버에서 결정");
    }
  }

  /// 인쇄하기 액션 처리
  Future<void> _handleAllocateAction(dynamic order, List<ManagedPrinter> printers) async {
    if (order.status == OrderStatus.printing) {
      ref.read(prototypePrinterProvider.notifier).setOrder(order);
      _showAllocateDialog(
        context,
        ref,
        ref.read(orderListProvider).indexOf(order),
        order.quantity,
        order.remainingQuantity,
        order.uniqueCode,
        order.orderId,
        order.startCode,
        order.endCode,
        order.itemName,
        printers,
      );
    } else {
      _showSendToWarehouseDialog(
        context,
        ref,
        ref.read(orderListProvider).indexOf(order),
        order.quantity,
        order.stock,
        order.orderId,
        order, // order 객체 추가
      );
    }
    await Future.delayed(Duration(seconds: _UIConstants.refreshDelaySeconds.toInt()));
    _refreshOrderList();
  }

  /// 인쇄하기 다이얼로그 표시
  void _showAllocateDialog(
    BuildContext context,
    WidgetRef ref,
    int index,
    int maxfixAvailable,
    int maxAvailable,
    String uniqcode,
    int orderId,
    String startCode,
    String endCode,
    String itemName,
    List<ManagedPrinter> printers,
  ) {
    final amountController = TextEditingController();
    ManagedPrinter? selectedPrinter;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('인쇄하기', style: _UIConstants.textStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<ManagedPrinter>(
                hint: Text('프린터 선택', style: _UIConstants.textStyle()),
                items: printers
                    .where(
                      (printer) =>
                          (printer.printStatus == "인쇄 대기" || printer.printStatus == "인쇄 완료") &&
                          (printer.connectStatus == "연결됨"),
                    )
                    .map((printer) =>
                        DropdownMenuItem(value: printer, child: Text(printer.name, style: _UIConstants.textStyle())))
                    .toList(),
                onChanged: (printer) {
                  setState(() => selectedPrinter = printer);
                  ref.read(prototypePrinterProvider.notifier).setPrinter(selectedPrinter!);
                },
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: '인쇄 수량 입력'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8),
              Text('인쇄 가능량: $maxAvailable', style: _UIConstants.textStyle()),
              //Text('인쇄 수량: $maxAvailable'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소', style: _UIConstants.textStyle()),
            ),
            ElevatedButton(
              onPressed: () async {
                //final input = maxAvailable;

                //0627프로토타입 이후 사용
                final input = int.tryParse(amountController.text.trim());
                if (input == null || input <= 0 || input > maxAvailable || selectedPrinter == null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('정확한 프린터와 유효한 할당량을 입력해주세요.', style: _UIConstants.textStyle())));
                  return;
                }

                // await _processAllocateOrder(
                //   index,
                //   input,
                //   selectedPrinter!,
                //   orderId,
                //   startCode,
                //   itemName,
                //   uniqcode,
                //   maxAvailable,
                // );

                Navigator.pop(context);
                await Future.delayed(Duration(seconds: _UIConstants.refreshDelaySeconds.toInt()));
                _refreshOrderList();
              },
              child: SizedBox(width: 80, child: Center(child: Text('인쇄하기', style: _UIConstants.textStyle()))),
            ),
          ],
        ),
      ),
    );
  }

  /// 출고하기 다이얼로그 표시
  Future<void> _showSendToWarehouseDialog(
    BuildContext context,
    WidgetRef ref,
    int index,
    int quantity,
    int stock,
    int orderId,
    dynamic order, // order 객체 추가
  ) async {
    final warehouseNameController = TextEditingController();
    final warehouseLocationController = TextEditingController();
    final sendAmountController = TextEditingController();

    // 완료 수량 조회 (발주별 모든 프린터의 완료 수량 합계)
    int completedCount = 0;
    try {
      final saver = await ref.read(fieldValueStateSaverProvider.future);
      final printerCounts = await saver.getAllPrinterCountsForOrder(orderId);
      completedCount = printerCounts.values.fold(0, (sum, count) => sum + count);
    } catch (e) {
      logger.e('완료 수량 조회 실패: $e');
    }

    // 출고 가능 최대 수량 = 완료 수량 - 이미 인쇄된 수량(printedQuantity) - 이미 출고된 수량(stock)
    final availableShipmentCount = (completedCount - order.printedQuantity - order.stock).clamp(0, completedCount);

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => CommonAlertDialog(
        title: '출고하기',
        customContent: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: warehouseNameController,
                decoration: InputDecoration(
                  labelText: '창고 이름',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                keyboardType: TextInputType.text,
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: 12),
              TextField(
                controller: warehouseLocationController,
                decoration: InputDecoration(
                  labelText: '창고 주소',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                keyboardType: TextInputType.text,
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: 12),
              TextField(
                controller: sendAmountController,
                decoration: InputDecoration(
                  labelText: '출고 수량 입력',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 20, color: Colors.blue[700]),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '출고 가능 최대 수량: $availableShipmentCount',
                        style: _UIConstants.textStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        confirmText: '출고하기',
        cancelText: '취소',
        onConfirm: () async {
          final input = int.tryParse(sendAmountController.text.trim());
          if (input == null ||
              input <= 0 ||
              input > availableShipmentCount ||
              warehouseNameController.text.trim().isEmpty ||
              warehouseLocationController.text.trim().isEmpty) {
            // 검증 실패 시 SnackBar 표시 후 다이얼로그 유지
            // CommonAlertDialog가 자동으로 Navigator.pop을 호출하므로
            // 검증 실패 시에는 다이얼로그가 닫히지만, 사용자가 다시 열 수 있음
            ScaffoldMessenger.of(dialogContext).showSnackBar(
              SnackBar(
                content: Text('정확한 정보와 유효한 할당량을 입력해주세요.'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          // 검증 성공 시에만 진행
          // 출고하기 전에 print-event API 호출
          await _sendPrintEventForShipment(orderId);

          final request = WarehouseRequest(
            orderId: orderId,
            name: warehouseNameController.text.trim(),
            address: warehouseLocationController.text.trim(),
            quantity: input,
          );
          logger.i("sendToWarehouse request: $request");
          final orderRepository = ref.read(orderRepositoryProvider);
          final response = await orderRepository.sendToWarehouse(request);
          logger.i("sendToWarehouse response: $response");

          // CommonAlertDialog가 자동으로 Navigator.pop을 호출
          await Future.delayed(Duration(seconds: _UIConstants.refreshDelaySeconds.toInt()));
          _refreshOrderList();
        },
      ),
    );
  }

  /// 중앙 정렬 셀 빌드 (폰트 적용)
  DataCell _centerCell(String text, {double minWidth = _UIConstants.cellMinWidth}) {
    return DataCell(
      SizedBox(
        width: minWidth,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _UIConstants.textStyle(fontSize: 13, color: Colors.grey[800]),
          ),
        ),
      ),
    );
  }

  /// 클릭 가능한 셀 빌드 (행 클릭 이벤트 포함)
  DataCell _clickableCell(String text, dynamic order, {double minWidth = _UIConstants.cellMinWidth}) {
    return DataCell(
      GestureDetector(
        onTap: () => _handleDetailAction(order),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: minWidth,
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: _UIConstants.textStyle(fontSize: 13, color: Colors.grey[800]),
            ),
          ),
        ),
      ),
    );
  }

  /// 중앙 정렬 버튼 셀 빌드
  DataCell _centeredButtonCell(Widget button, {double width = _UIConstants.buttonCellWidth}) {
    return DataCell(
      Container(
        width: width,
        alignment: Alignment.center,
        child: button,
      ),
    );
  }

  /// 클릭 가능한 버튼 셀 빌드 (행 클릭 이벤트 포함, 버튼 클릭은 별도 처리)
  DataCell _clickableButtonCell(Widget button, dynamic order, {double width = _UIConstants.buttonCellWidth}) {
    return DataCell(
      GestureDetector(
        onTap: () => _handleDetailAction(order),
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: width,
          alignment: Alignment.center,
          child: button,
        ),
      ),
    );
  }

  /// 완료 수량 셀 빌드 (캐시된 값 사용)
  DataCell _buildCompletedCountCell(int orderId) {
    final completedCount = _completedCountsCache[orderId] ?? 0;

    return DataCell(
      GestureDetector(
        onTap: () {
          // 행 클릭 이벤트는 DataRow에서 처리되므로 여기서는 빈 함수
        },
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Text(
            '$completedCount',
            textAlign: TextAlign.center,
            style: _UIConstants.textStyle(
              fontSize: 13,
              color: Colors.grey[800],
            ),
          ),
        ),
      ),
    );
  }

  /// Print-event용 eventKey 생성 (UUID v4 형식)
  String _generateEventKey() {
    final random = Random();
    final chars = '0123456789abcdef';
    final parts = <String>[];
    parts.add(List.generate(8, (_) => chars[random.nextInt(chars.length)]).join());
    parts.add(List.generate(4, (_) => chars[random.nextInt(chars.length)]).join());
    parts.add('4' + List.generate(3, (_) => chars[random.nextInt(chars.length)]).join());
    final variantChars = '89ab';
    parts.add(variantChars[random.nextInt(variantChars.length)] +
        List.generate(3, (_) => chars[random.nextInt(chars.length)]).join());
    parts.add(List.generate(12, (_) => chars[random.nextInt(chars.length)]).join());
    return parts.join('-');
  }

  /// Print-event API 호출 (출고하기 시점)
  /// 현재 완료 수량을 조회하여 전송합니다.
  Future<void> _sendPrintEventForShipment(int orderId) async {
    try {
      // 현재 완료 수량 조회
      final saver = await ref.read(fieldValueStateSaverProvider.future);
      final printerCounts = await saver.getAllPrinterCountsForOrder(orderId);
      final currentCount = printerCounts.values.fold(0, (sum, count) => sum + count);

      if (currentCount <= 0) {
        logger.d('📦 Print-event (출고): orderId=$orderId, 완료 수량이 0이므로 API 호출 생략');
        return;
      }

      // 각 API 호출마다 고유한 난수 eventKey 생성 (멱등성 보장)
      final eventKey = _generateEventKey();

      final orderRepository = ref.read(orderRepositoryProvider);
      final request = PrintEventRequest(
        orderId: orderId,
        quantity: currentCount,
        eventKey: eventKey,
      );

      logger.i('📤 Print-event API 호출 (출고): orderId=$orderId, quantity=$currentCount, eventKey=$eventKey');

      final response = await orderRepository.sendPrintEvent(request);

      if (response.status == "success") {
        logger.i('✅ Print-event API 성공 (출고): orderId=$orderId, quantity=$currentCount');
      } else {
        logger.w('⚠️ Print-event API 실패 (출고, value=false): orderId=$orderId');
      }
    } catch (e, stackTrace) {
      logger.e('❌ Print-event API 호출 실패 (출고): orderId=$orderId, error=$e\n$stackTrace');
    }
  }
}

/// 버튼 설정 정보 클래스
class _ButtonConfig {
  final bool canConfirm;
  final bool canAllocate;
  final bool canSendConfirm;
  final bool sendAfterSend;
  final Color buttonColor;
  final Color? borderColor;

  _ButtonConfig({
    required this.canConfirm,
    required this.canAllocate,
    required this.canSendConfirm,
    required this.sendAfterSend,
    required this.buttonColor,
    this.borderColor,
  });
}

/// 발주 현황 이력 다이얼로그
class _OrderHistoryDialog extends StatefulWidget {
  final int orderId;
  final dynamic orderRepository;

  const _OrderHistoryDialog({
    required this.orderId,
    required this.orderRepository,
  });

  @override
  State<_OrderHistoryDialog> createState() => _OrderHistoryDialogState();
}

class _OrderHistoryDialogState extends State<_OrderHistoryDialog> with SingleTickerProviderStateMixin {
  final int _pageSize = 10;

  // 발주 현황 이력 관련
  int _historyCurrentPage = 1;
  OrderHistoryListResponse? _historyResponse;
  bool _isHistoryLoading = false;

  // 출고 이력 관련
  int _shipmentCurrentPage = 1;
  OrderShipmentListResponse? _shipmentResponse;
  bool _isShipmentLoading = false;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadHistory();
    _loadShipment();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isHistoryLoading = true;
    });

    try {
      final response = await widget.orderRepository.getOrderHistoryList(
        widget.orderId,
        _pageSize,
        _historyCurrentPage,
      );
      // 날짜 내림차순 정렬 (최신순)
      final sortedHistoryList = List<OrderHistoryItem>.from(response.data.historyList)
        ..sort((a, b) {
          // regDate를 DateTime으로 변환하여 비교
          final dateA = DateTime.tryParse(a.regDate.replaceAll(' ', 'T')) ?? DateTime(1970);
          final dateB = DateTime.tryParse(b.regDate.replaceAll(' ', 'T')) ?? DateTime(1970);
          return dateB.compareTo(dateA); // 내림차순
        });

      setState(() {
        _historyResponse = response.copyWith(
          data: response.data.copyWith(
            historyList: sortedHistoryList,
          ),
        );
        _isHistoryLoading = false;
      });
      logger.i("발주 현황 이력 조회: orderId=${widget.orderId}, pageSize=$_pageSize, currentPage=$_historyCurrentPage");
    } catch (e) {
      logger.e('발주 현황 이력 조회 실패: $e');
      setState(() {
        _isHistoryLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('발주 현황 이력을 불러오는데 실패했습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadHistoryPage(int page) async {
    setState(() {
      _historyCurrentPage = page;
      _isHistoryLoading = true;
    });

    try {
      final response = await widget.orderRepository.getOrderHistoryList(
        widget.orderId,
        _pageSize,
        _historyCurrentPage,
      );
      // 날짜 내림차순 정렬 (최신순)
      final sortedHistoryList = List<OrderHistoryItem>.from(response.data.historyList)
        ..sort((a, b) {
          final dateA = DateTime.tryParse(a.regDate.replaceAll(' ', 'T')) ?? DateTime(1970);
          final dateB = DateTime.tryParse(b.regDate.replaceAll(' ', 'T')) ?? DateTime(1970);
          return dateB.compareTo(dateA); // 내림차순
        });

      setState(() {
        _historyResponse = response.copyWith(
          data: response.data.copyWith(
            historyList: sortedHistoryList,
          ),
        );
        _isHistoryLoading = false;
      });
    } catch (e) {
      logger.e('발주 현황 이력 조회 실패: $e');
      setState(() {
        _isHistoryLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('발주 현황 이력을 불러오는데 실패했습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadShipment() async {
    setState(() {
      _isShipmentLoading = true;
    });

    try {
      final response = await widget.orderRepository.getOrderShipmentList(
        widget.orderId,
        _pageSize,
        _shipmentCurrentPage,
      );
      // 날짜 내림차순 정렬 (최신순)
      final sortedShipmentList = List<OrderShipmentItem>.from(response.data.shipmentList)
        ..sort((a, b) {
          final dateA = DateTime.tryParse(a.regDate.replaceAll(' ', 'T')) ?? DateTime(1970);
          final dateB = DateTime.tryParse(b.regDate.replaceAll(' ', 'T')) ?? DateTime(1970);
          return dateB.compareTo(dateA); // 내림차순
        });

      setState(() {
        _shipmentResponse = response.copyWith(
          data: response.data.copyWith(
            shipmentList: sortedShipmentList,
          ),
        );
        _isShipmentLoading = false;
      });
      logger.i("출고 이력 조회: orderId=${widget.orderId}, pageSize=$_pageSize, currentPage=$_shipmentCurrentPage");
    } catch (e) {
      logger.e('출고 이력 조회 실패: $e');
      setState(() {
        _isShipmentLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('출고 이력을 불러오는데 실패했습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadShipmentPage(int page) async {
    setState(() {
      _shipmentCurrentPage = page;
      _isShipmentLoading = true;
    });

    try {
      final response = await widget.orderRepository.getOrderShipmentList(
        widget.orderId,
        _pageSize,
        _shipmentCurrentPage,
      );
      // 날짜 내림차순 정렬 (최신순)
      final sortedShipmentList = List<OrderShipmentItem>.from(response.data.shipmentList)
        ..sort((a, b) {
          final dateA = DateTime.tryParse(a.regDate.replaceAll(' ', 'T')) ?? DateTime(1970);
          final dateB = DateTime.tryParse(b.regDate.replaceAll(' ', 'T')) ?? DateTime(1970);
          return dateB.compareTo(dateA); // 내림차순
        });

      setState(() {
        _shipmentResponse = response.copyWith(
          data: response.data.copyWith(
            shipmentList: sortedShipmentList,
          ),
        );
        _isShipmentLoading = false;
      });
    } catch (e) {
      logger.e('출고 이력 조회 실패: $e');
      setState(() {
        _isShipmentLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('출고 이력을 불러오는데 실패했습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 표시할 페이지 번호 리스트 계산 (최대 5개) - 발주 현황 이력
  List<int> _getHistoryPageNumbers() {
    if (_historyResponse == null) return [];

    final totalPage = _historyResponse!.data.paging.totalPage;
    final currentPage = _historyResponse!.data.paging.currentPage;

    // 현재 페이지를 중심으로 앞뒤 2페이지씩 (최대 5개)
    int startPage = (currentPage - 2).clamp(1, totalPage);
    int endPage = (startPage + 4).clamp(startPage, totalPage);

    // 끝 페이지가 totalPage에 가까우면 시작 페이지 조정
    if (endPage - startPage < 4 && startPage > 1) {
      startPage = (endPage - 4).clamp(1, totalPage);
    }

    return List.generate(endPage - startPage + 1, (index) => startPage + index);
  }

  /// 표시할 페이지 번호 리스트 계산 (최대 5개) - 출고 이력
  List<int> _getShipmentPageNumbers() {
    if (_shipmentResponse == null) return [];

    final totalPage = _shipmentResponse!.data.paging.totalPage;
    final currentPage = _shipmentResponse!.data.paging.currentPage;

    // 현재 페이지를 중심으로 앞뒤 2페이지씩 (최대 5개)
    int startPage = (currentPage - 2).clamp(1, totalPage);
    int endPage = (startPage + 4).clamp(startPage, totalPage);

    // 끝 페이지가 totalPage에 가까우면 시작 페이지 조정
    if (endPage - startPage < 4 && startPage > 1) {
      startPage = (endPage - 4).clamp(1, totalPage);
    }

    return List.generate(endPage - startPage + 1, (index) => startPage + index);
  }

  @override
  Widget build(BuildContext context) {
    return CommonAlertDialog(
      title: '발주 이력',
      customContent: Container(
        constraints: BoxConstraints(maxHeight: 500, minWidth: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 탭 바
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: '발주 현황 이력'),
                Tab(text: '출고 이력'),
              ],
            ),
            // 탭 뷰
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // 발주 현황 이력 탭
                  _buildHistoryTab(),
                  // 출고 이력 탭
                  _buildShipmentTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      confirmText: '닫기',
      cancelText: null,
      onConfirm: () {},
    );
  }

  /// 발주 현황 이력 탭 빌드
  Widget _buildHistoryTab() {
    if (_isHistoryLoading || _historyResponse == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_historyResponse!.data.historyList.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            '발주 현황 이력이 없습니다.',
            style: _UIConstants.textStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 내역 리스트
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _historyResponse!.data.historyList.length,
            itemBuilder: (context, index) {
              final item = _historyResponse!.data.historyList[index];
              return Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '수량: ${item.quantity}',
                            style: _UIConstants.textStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '상태: ${item.status}',
                            style: _UIConstants.textStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      item.regDate,
                      style: _UIConstants.textStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12),
        // 페이징 정보 및 버튼
        _buildHistoryPagination(),
      ],
    );
  }

  /// 출고 이력 탭 빌드
  Widget _buildShipmentTab() {
    if (_isShipmentLoading || _shipmentResponse == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_shipmentResponse!.data.shipmentList.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            '출고 이력이 없습니다.',
            style: _UIConstants.textStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 내역 리스트
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _shipmentResponse!.data.shipmentList.length,
            itemBuilder: (context, index) {
              final item = _shipmentResponse!.data.shipmentList[index];
              return Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '재고: ${item.stock}',
                            style: _UIConstants.textStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '창고명: ${item.warehouseName}',
                            style: _UIConstants.textStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '주소: ${item.address}',
                            style: _UIConstants.textStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      item.regDate,
                      style: _UIConstants.textStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12),
        // 페이징 정보 및 버튼
        _buildShipmentPagination(),
      ],
    );
  }

  /// 발주 현황 이력 페이징 빌드
  Widget _buildHistoryPagination() {
    if (_historyResponse == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          // 페이지 정보
          Text(
            '총 ${_historyResponse!.data.paging.totalCount}건 (${_historyResponse!.data.paging.currentPage}/${_historyResponse!.data.paging.totalPage}페이지)',
            style: _UIConstants.textStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          // 페이징 컨트롤
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 첫 페이지로 이동 (<<)
              IconButton(
                onPressed: _historyCurrentPage > 1 && !_isHistoryLoading ? () => _loadHistoryPage(1) : null,
                icon: Icon(Icons.first_page, size: 20),
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(),
                color: _historyCurrentPage > 1 ? Colors.grey[700] : Colors.grey[300],
              ),
              SizedBox(width: 4),
              // 이전 페이지로 이동 (<)
              IconButton(
                onPressed: _historyResponse!.data.paging.canPrev && !_isHistoryLoading
                    ? () => _loadHistoryPage(_historyCurrentPage - 1)
                    : null,
                icon: Icon(Icons.chevron_left, size: 20),
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(),
                color: _historyResponse!.data.paging.canPrev ? Colors.grey[700] : Colors.grey[300],
              ),
              SizedBox(width: 8),
              // 페이지 번호들 (최대 5개)
              ..._getHistoryPageNumbers().map((pageNum) {
                final isCurrentPage = pageNum == _historyCurrentPage;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: GestureDetector(
                    onTap: !_isHistoryLoading && !isCurrentPage ? () => _loadHistoryPage(pageNum) : null,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCurrentPage ? _UIConstants.primaryBlue : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isCurrentPage ? _UIConstants.primaryBlue : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        '$pageNum',
                        style: _UIConstants.textStyle(
                          fontSize: 12,
                          fontWeight: isCurrentPage ? FontWeight.w600 : FontWeight.normal,
                          color: isCurrentPage ? Colors.white : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(width: 8),
              // 다음 페이지로 이동 (>)
              IconButton(
                onPressed: _historyResponse!.data.paging.canNext && !_isHistoryLoading
                    ? () => _loadHistoryPage(_historyCurrentPage + 1)
                    : null,
                icon: Icon(Icons.chevron_right, size: 20),
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(),
                color: _historyResponse!.data.paging.canNext ? Colors.grey[700] : Colors.grey[300],
              ),
              SizedBox(width: 4),
              // 마지막 페이지로 이동 (>>)
              IconButton(
                onPressed: _historyCurrentPage < _historyResponse!.data.paging.totalPage && !_isHistoryLoading
                    ? () => _loadHistoryPage(_historyResponse!.data.paging.totalPage)
                    : null,
                icon: Icon(Icons.last_page, size: 20),
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(),
                color:
                    _historyCurrentPage < _historyResponse!.data.paging.totalPage ? Colors.grey[700] : Colors.grey[300],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 출고 이력 페이징 빌드
  Widget _buildShipmentPagination() {
    if (_shipmentResponse == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          // 페이지 정보
          Text(
            '총 ${_shipmentResponse!.data.paging.totalCount}건 (${_shipmentResponse!.data.paging.currentPage}/${_shipmentResponse!.data.paging.totalPage}페이지)',
            style: _UIConstants.textStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          // 페이징 컨트롤
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 첫 페이지로 이동 (<<)
              IconButton(
                onPressed: _shipmentCurrentPage > 1 && !_isShipmentLoading ? () => _loadShipmentPage(1) : null,
                icon: Icon(Icons.first_page, size: 20),
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(),
                color: _shipmentCurrentPage > 1 ? Colors.grey[700] : Colors.grey[300],
              ),
              SizedBox(width: 4),
              // 이전 페이지로 이동 (<)
              IconButton(
                onPressed: _shipmentResponse!.data.paging.canPrev && !_isShipmentLoading
                    ? () => _loadShipmentPage(_shipmentCurrentPage - 1)
                    : null,
                icon: Icon(Icons.chevron_left, size: 20),
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(),
                color: _shipmentResponse!.data.paging.canPrev ? Colors.grey[700] : Colors.grey[300],
              ),
              SizedBox(width: 8),
              // 페이지 번호들 (최대 5개)
              ..._getShipmentPageNumbers().map((pageNum) {
                final isCurrentPage = pageNum == _shipmentCurrentPage;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: GestureDetector(
                    onTap: !_isShipmentLoading && !isCurrentPage ? () => _loadShipmentPage(pageNum) : null,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCurrentPage ? _UIConstants.primaryBlue : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isCurrentPage ? _UIConstants.primaryBlue : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        '$pageNum',
                        style: _UIConstants.textStyle(
                          fontSize: 12,
                          fontWeight: isCurrentPage ? FontWeight.w600 : FontWeight.normal,
                          color: isCurrentPage ? Colors.white : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(width: 8),
              // 다음 페이지로 이동 (>)
              IconButton(
                onPressed: _shipmentResponse!.data.paging.canNext && !_isShipmentLoading
                    ? () => _loadShipmentPage(_shipmentCurrentPage + 1)
                    : null,
                icon: Icon(Icons.chevron_right, size: 20),
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(),
                color: _shipmentResponse!.data.paging.canNext ? Colors.grey[700] : Colors.grey[300],
              ),
              SizedBox(width: 4),
              // 마지막 페이지로 이동 (>>)
              IconButton(
                onPressed: _shipmentCurrentPage < _shipmentResponse!.data.paging.totalPage && !_isShipmentLoading
                    ? () => _loadShipmentPage(_shipmentResponse!.data.paging.totalPage)
                    : null,
                icon: Icon(Icons.last_page, size: 20),
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(),
                color: _shipmentCurrentPage < _shipmentResponse!.data.paging.totalPage
                    ? Colors.grey[700]
                    : Colors.grey[300],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
