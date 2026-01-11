import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_manager/core/data/models/request/warehouse_request.dart';
import '../../core/domain/entities/managed_printer.dart';
import '../providers/order_list_provider.dart';
import '../providers/printer_list_provider.dart';
import 'package:print_manager/core/data/repositories/order_repository_provider.dart';
import 'package:print_manager/core/data/models/request/patch_order_request.dart';
import 'package:print_manager/core/data/repositories/printer_repository_provider.dart';
import 'package:print_manager/core/data/models/request/printerjob_request.dart';
import 'package:print_manager/presentation/providers/prototype_printer_provider.dart';
import 'package:print_manager/core/services/logger_service.dart';

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
  static const double buttonCellWidth = 120.0;
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
}

class _OrderManagePageState extends ConsumerState<OrderManagePage> {
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
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderListProvider);
    final printers = ref.watch(printerListProvider);

    return Container(
      color: _UIConstants.backgroundColor,
      child: Column(children: [_buildHeader(), Expanded(child: _buildOrderTable(orders, printers))]),
    );
  }

  /// 헤더 영역 빌드
  Widget _buildHeader() {
    return Container(
      height: _UIConstants.headerHeight,
      padding: EdgeInsets.symmetric(horizontal: _UIConstants.horizontalPadding),
      decoration: BoxDecoration(
        color: _UIConstants.headerBackgroundColor,
        border: Border(bottom: BorderSide(color: _UIConstants.borderGray, width: 1)),
      ),
      child: Row(
        children: [
          Text(
            "주문 상태창",
            style: _UIConstants.textStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[900]),
          ),
          Spacer(),
          _buildRefreshButton(),
        ],
      ),
    );
  }

  /// 새로고침 버튼 빌드
  Widget _buildRefreshButton() {
    return OutlinedButton.icon(
      onPressed: _refreshOrderList,
      icon: Icon(Icons.refresh, size: 16),
      label: Text('새로고침', style: _UIConstants.textStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      style: OutlinedButton.styleFrom(
        backgroundColor: _UIConstants.rowBackgroundColor,
        foregroundColor: _UIConstants.textGray,
        side: BorderSide(color: _UIConstants.borderGray),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size(_UIConstants.buttonMinWidth, _UIConstants.buttonHeight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_UIConstants.borderRadius)),
      ),
    );
  }

  /// 주문 테이블 빌드
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
      _centerCal('처리 상태'),
      _centerCal('총 수량'),
      _centerCal('인쇄 가능 수량'),
      _centerCal('발주 일시'),
      _centerCal('작업 처리'),
    ];
  }

  /// 중앙 정렬 컬럼 빌드 (폰트 적용)
  DataColumn _centerCal(String text, {double minWidth = _UIConstants.cellMinWidth}) {
    return DataColumn(
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

    return DataRow(
      cells: [
        _centerCell('${index + 1}'),
        _centerCell('${order.institutionName}'),
        _centerCell(order.itemName),
        _centerCell(orderStatus),
        _centerCell('${order.quantity}'),
        _centerCell('${order.remainingQuantity}'),
        _centerCell(order.regDate),
        _centeredButtonCell(_buildActionButton(order, buttonConfig, printers)),
      ],
    );
  }

  /// 버튼 설정 정보 가져오기
  _ButtonConfig _getButtonConfig(dynamic order) {
    final canConfirm = (order.status == OrderStatus.shipping || order.status == OrderStatus.printingComplete);
    final canAllocate = order.status == OrderStatus.printing;
    final canSendConfirm = order.status == OrderStatus.printingComplete;
    final sendAfterSend = (order.status == OrderStatus.printingComplete || order.status == OrderStatus.shipped);

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
    if (!config.canAllocate) {
      return _buildConfirmButton(order, config);
    } else {
      return _buildAllocateButton(order, config, printers);
    }
  }

  /// 수령완료/출고하기 버튼 빌드
  Widget _buildConfirmButton(dynamic order, _ButtonConfig config) {
    return ElevatedButton(
      onPressed: config.canConfirm ? () => _handleConfirmAction(order) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: config.buttonColor,
        side: BorderSide(color: config.borderColor ?? Colors.white, width: 1.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_UIConstants.borderRadius)),
      ),
      child: Text(
        config.sendAfterSend ? '출고하기' : '수령완료',
        style: _UIConstants.textStyle(color: config.borderColor, fontWeight: FontWeight.w600),
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
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: Text('인쇄하기', style: _UIConstants.textStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<ManagedPrinter>(
                        hint: Text('프린터 선택', style: _UIConstants.textStyle()),
                        items:
                            printers
                                .where(
                                  (printer) =>
                                      (printer.printStatus == "인쇄 대기" || printer.printStatus == "인쇄 완료") &&
                                      (printer.connectStatus == "연결됨"),
                                )
                                .map((printer) => DropdownMenuItem(value: printer, child: Text(printer.name, style: _UIConstants.textStyle())))
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

                        await _processAllocateOrder(
                          index,
                          input,
                          selectedPrinter!,
                          orderId,
                          startCode,
                          itemName,
                          uniqcode,
                          maxAvailable,
                        );

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

  /// 인쇄 작업 할당 처리
  Future<void> _processAllocateOrder(
    int index,
    int input,
    ManagedPrinter selectedPrinter,
    int orderId,
    String startCode,
    String itemName,
    String uniqcode,
    int maxAvailable,
  ) async {
    // 1. 발주 상태 업데이트
    ref.read(orderListProvider.notifier).allocateOrder(index, input);
    selectedPrinter.updateFields(item: ref.read(orderListProvider.notifier).getItemNameByOrderId(orderId));

    // 2. 프린터 작업 생성
    final request = PrinterjobRequest(
      orderId: orderId,
      processingCompanyPrinterId: selectedPrinter.id ?? 0,
      quantity: input,
    );
    logger.i("addPrinterJob request: $request");
    final printerRepository = ref.read(printerRepositoryProvider);
    final response = await printerRepository.addPrinterJob(request);
    final jobId = response.data.jobId;
    logger.i("addPrinterJob response: $response");

    // 3. 인쇄 코드 계산
    final int printingStartCode = int.parse(startCode);
    final int printingEndCode = int.parse(startCode) + (input - 1);
    final printerId = selectedPrinter.id ?? 0;
    final isLastPrint = (maxAvailable == input);

    logger.i(
      "orderManage \n printerId: $printerId, itemName: $itemName, startCode: $startCode, endCode: $printingEndCode",
    );

    // 4. 프린터에 작업 할당
    ref
        .read(printerListProvider.notifier)
        .assignPrintJob(printerId, jobId, itemName, uniqcode, printingStartCode, printingEndCode, isLastPrint);
  }

  /// 출고하기 다이얼로그 표시
  void _showSendToWarehouseDialog(
    BuildContext context,
    WidgetRef ref,
    int index,
    int quantity,
    int stock,
    int orderId,
  ) {
    final warehouseNameController = TextEditingController();
    final warehouseLocationController = TextEditingController();
    final sendAmountController = TextEditingController();
    final maxAvailable = quantity - stock;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: Text('출고하기', style: _UIConstants.textStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: warehouseNameController,
                        decoration: InputDecoration(labelText: '창고 이름'),
                        keyboardType: TextInputType.text,
                      ),
                      TextField(
                        controller: warehouseLocationController,
                        decoration: InputDecoration(labelText: '창고 주소'),
                        keyboardType: TextInputType.text,
                      ),
                      TextField(
                        controller: sendAmountController,
                        decoration: InputDecoration(labelText: '출고 수량 입력'),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 8),
                      Text('출고 가능 수량: $maxAvailable', style: _UIConstants.textStyle()),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('취소', style: _UIConstants.textStyle()),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final input = int.tryParse(sendAmountController.text.trim());
                        if (input == null ||
                            input <= 0 ||
                            input > maxAvailable ||
                            warehouseNameController.text == "" ||
                            warehouseLocationController.text == "") {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('정확한 정보와 유효한 할당량을 입력해주세요.', style: _UIConstants.textStyle())));
                          return;
                        }

                        final request = WarehouseRequest(
                          orderId: orderId,
                          name: warehouseNameController.text,
                          address: warehouseLocationController.text,
                          quantity: input,
                        );
                        logger.i("sendToWarehouse request: $request");
                        final orderRepository = ref.read(orderRepositoryProvider);
                        final response = await orderRepository.sendToWarehouse(request);
                        logger.i("sendToWarehouse response: $response");

                        Navigator.pop(context);
                        await Future.delayed(Duration(seconds: _UIConstants.refreshDelaySeconds.toInt()));
                        _refreshOrderList();
                      },
                      child: SizedBox(width: 80, child: Center(child: Text('출고하기', style: _UIConstants.textStyle()))),
                    ),
                  ],
                ),
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
            style: _UIConstants.textStyle(fontSize: 13, color: Colors.grey[800]),
          ),
        ),
      ),
    );
  }

  /// 중앙 정렬 버튼 셀 빌드
  DataCell _centeredButtonCell(Widget button, {double width = _UIConstants.buttonCellWidth}) {
    return DataCell(SizedBox(width: width, child: Center(child: button)));
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
