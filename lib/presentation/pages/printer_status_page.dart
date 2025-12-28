import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/printer_list_provider.dart';
import '../../domain/entities/managed_printer.dart';
import 'package:print_manager/data/models/request/printers_request.dart';
import 'package:print_manager/data/repositories/printer_repository_provider.dart';
import 'package:print_manager/core/services/logger_service.dart';

class PrinterStatusPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<PrinterStatusPage> createState() => _PrinterStatusPageState();
}

/// UI 상수
class _PrinterStatusUIConstants {
  static const double headerHeight = 84.0;
  static const double horizontalPadding = 50.0;
  static const double buttonMinWidth = 94.0;
  static const double buttonHeight = 40.0;
  static const double borderRadius = 4.0;
  static const double cellMinWidth = 100.0;
  static const double spacing = 26.0;
  static const double bottomSpacing = 16.0;
  static const int defaultPort = 5000;

  // 색상
  static const Color headerBackgroundColor = Color(0xFFF9FAFB);
  static const Color rowBackgroundColor = Color(0xFFFFFFFF);
  static const Color primaryBlue = Color(0xFF1A66EB);
  static const Color primaryText = Color(0xFFF3F7FF);
  static const Color loadingOverlay = Color(0x4D000000); // black.withOpacity(0.3)
}

class _PrinterStatusPageState extends ConsumerState<PrinterStatusPage> {
  ManagedPrinter? selectedPrinter;

  @override
  void initState() {
    super.initState();
    _initializePrinters();
  }

  /// 프린터 초기화
  Future<void> _initializePrinters() async {
    try {
      await _refreshPrinterList();
      await _initConnection();
    } catch (e, stack) {
      debugPrint('_initializePrinters error: $e\n$stack');
    }
  }

  /// 프린터 목록 새로고침
  Future<void> _refreshPrinterList() async {
    final printerRepository = ref.read(printerRepositoryProvider);
    final response = await printerRepository.printerList();
    ref.read(printerListProvider.notifier).mergeNewData(ref, response);
  }

  /// 모든 프린터 연결 초기화
  Future<void> _initConnection() async {
    final printerList = ref.read(printerListProvider);
    for (final printer in printerList) {
      final response = await printer.connect();
      logger.i("initConnection- printer: $printer, connection: $response");
    }
  }

  @override
  Widget build(BuildContext context) {
    final printers = ref.watch(printerListProvider);

    return Row(
      children: [
        Expanded(flex: 4, child: _buildPrinterTableSection(printers)),
        VerticalDivider(),
        Expanded(flex: 1, child: _buildPrinterDetailSection()),
      ],
    );
  }

  /// 프린터 테이블 섹션 빌드
  Widget _buildPrinterTableSection(List<ManagedPrinter> printers) {
    return Column(
      children: [
        SizedBox(height: _PrinterStatusUIConstants.headerHeight),
        _buildHeader(),
        SizedBox(height: _PrinterStatusUIConstants.spacing),
        Expanded(child: _buildPrinterTable(printers)),
        SizedBox(height: _PrinterStatusUIConstants.bottomSpacing),
      ],
    );
  }

  /// 헤더 영역 빌드
  Widget _buildHeader() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: _PrinterStatusUIConstants.horizontalPadding),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("프린터 상태창", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ),
        Spacer(),
        _buildTestButton(),
        _buildAddButton(),
      ],
    );
  }

  /// 테스트 버튼 빌드
  Widget _buildTestButton() {
    return Container(
      height: _PrinterStatusUIConstants.buttonHeight,
      child: ElevatedButton(
        onPressed: _testPrint,
        style: _getPrimaryButtonStyle(),
        child: Text('프린터 테스트', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }

  /// 추가 버튼 빌드
  Widget _buildAddButton() {
    return Container(
      height: _PrinterStatusUIConstants.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: () => _showAddPrinterDialog(context, ref),
        icon: Icon(Icons.add),
        label: Text('프린터 추가', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        style: _getPrimaryButtonStyle(),
      ),
    );
  }

  /// 기본 버튼 스타일
  ButtonStyle _getPrimaryButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: _PrinterStatusUIConstants.primaryBlue,
      foregroundColor: _PrinterStatusUIConstants.primaryText,
      minimumSize: Size(_PrinterStatusUIConstants.buttonMinWidth, _PrinterStatusUIConstants.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.borderRadius)),
    );
  }

  /// 프린터 테이블 빌드
  Widget _buildPrinterTable(List<ManagedPrinter> printers) {
    return LayoutBuilder(
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
                    (Set<MaterialState> states) => _PrinterStatusUIConstants.headerBackgroundColor,
                  ),
                  dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) => _PrinterStatusUIConstants.rowBackgroundColor,
                  ),
                  showCheckboxColumn: false,
                  columns: _buildTableColumns(),
                  rows: _buildTableRows(printers),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 테이블 컬럼 빌드
  List<DataColumn> _buildTableColumns() {
    return [
      _centerCal('인덱스'),
      _centerCal('프린터명'),
      _centerCal('IP 주소 : 포트'),
      _centerCal('품목명'),
      _centerCal('연결 상태'),
      _centerCal('프린터 상태'),
      _centerCal('인쇄 현황'),
      _centerCal('시작 일시'),
      _centerCal('완료 일시'),
    ];
  }

  /// 테이블 행 빌드
  List<DataRow> _buildTableRows(List<ManagedPrinter> printers) {
    return printers.asMap().entries.map((entry) {
      final index = entry.key;
      final printer = entry.value;
      return _buildDataRow(index, printer);
    }).toList();
  }

  /// 데이터 행 빌드
  DataRow _buildDataRow(int index, ManagedPrinter printer) {
    final isSelected = printer == selectedPrinter;
    return DataRow(
      selected: isSelected,
      onSelectChanged: (_) {
        setState(() => selectedPrinter = printer);
        logger.i("selectedPrinter: ${selectedPrinter?.id ?? 0}");
      },
      cells: [
        DataCell(Center(child: Text('${index + 1}'))),
        DataCell(Center(child: Text(printer.name))),
        DataCell(Center(child: Text('${printer.ip}:${printer.port}'))),
        DataCell(Center(child: Text(printer.item ?? ''))),
        DataCell(Center(child: Text(printer.connectStatus))),
        DataCell(Center(child: Text(printer.status ?? ''))),
        DataCell(Center(child: Text(printer.printStatus ?? ''))),
        DataCell(Center(child: Text(printer.startDate ?? ''))),
        DataCell(Center(child: Text(printer.endDate ?? ''))),
      ],
    );
  }

  /// 프린터 상세 정보 섹션 빌드
  Widget _buildPrinterDetailSection() {
    if (selectedPrinter == null) {
      return Center(child: Text('프린터를 선택하세요'));
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildPrinterInfo(), Spacer(), _buildRemoveButton()],
      ),
    );
  }

  /// 프린터 정보 빌드
  Widget _buildPrinterInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('프린터명: ${selectedPrinter!.name}'),
        Text('상태: ${selectedPrinter!.connectStatus}'),
        Text('품목: ${selectedPrinter!.item ?? "-"}'),
      ],
    );
  }

  /// 제거 버튼 빌드
  Widget _buildRemoveButton() {
    return Center(child: ElevatedButton(onPressed: () => _handleRemovePrinter(), child: Text('프린터 제거')));
  }

  /// 프린터 제거 처리
  Future<void> _handleRemovePrinter() async {
    if (selectedPrinter == null) return;

    _confirmRemovePrinter(context, selectedPrinter!);
    final printerRepository = ref.read(printerRepositoryProvider);
    await selectedPrinter!.dispose();
    logger.i("selectedPrinter!.index: ${selectedPrinter!.id}");
    await printerRepository.deletePrinter(selectedPrinter!.id ?? 0);
    await ref.read(printerListProvider.notifier).removePrinter(selectedPrinter!);
    setState(() => selectedPrinter = null);
    await _refreshPrinterList();
  }

  /// 프린터 제거 확인 다이얼로그
  void _confirmRemovePrinter(BuildContext context, ManagedPrinter printer) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('프린터 제거'),
            content: Text('프린터를 제거하시겠습니까?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('취소')),
              TextButton(onPressed: () => _processRemovePrinter(printer), child: Text('확인')),
            ],
          ),
    );
  }

  /// 프린터 제거 처리
  Future<void> _processRemovePrinter(ManagedPrinter printer) async {
    // 서버에 제거 API
    final printerRepository = ref.read(printerRepositoryProvider);
    if (selectedPrinter != null) {
      await printerRepository.deletePrinter(selectedPrinter!.id ?? 0);
    }

    // 로컬에서 제거
    await ref.read(printerListProvider.notifier).removePrinter(printer);
    setState(() => selectedPrinter = null);

    // 화면 이동
    Navigator.pop(context);
  }

  /// 프린터 테스트 실행
  void _testPrint() {
    ref.read(printerListProvider.notifier).testPrint();
  }

  /// 프린터 추가 다이얼로그 표시
  void _showAddPrinterDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final ipController = TextEditingController();
    final portController = TextEditingController(text: _PrinterStatusUIConstants.defaultPort.toString());
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setState) => Stack(
                children: [
                  AlertDialog(
                    title: Text('프린터 추가하기'),
                    content: _buildAddPrinterForm(nameController, ipController, portController),
                    actions: _buildAddPrinterActions(
                      context,
                      ref,
                      nameController,
                      ipController,
                      portController,
                      isLoading,
                      (loading) => setState(() => isLoading = loading),
                    ),
                  ),
                  if (isLoading) _buildLoadingOverlay(),
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
        TextField(controller: nameController, decoration: InputDecoration(labelText: '프린터 이름')),
        TextField(controller: ipController, decoration: InputDecoration(labelText: 'IP 주소')),
        TextField(
          controller: portController,
          decoration: InputDecoration(labelText: 'Port'),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  /// 프린터 추가 액션 버튼 빌드
  List<Widget> _buildAddPrinterActions(
    BuildContext context,
    WidgetRef ref,
    TextEditingController nameController,
    TextEditingController ipController,
    TextEditingController portController,
    bool isLoading,
    Function(bool) setLoading,
  ) {
    return [
      TextButton(onPressed: isLoading ? null : () => Navigator.pop(context), child: Text('취소')),
      ElevatedButton(
        onPressed:
            isLoading
                ? null
                : () => _handleAddPrinter(context, ref, nameController, ipController, portController, setLoading),
        style: _getLoadingButtonStyle(isLoading),
        child: Text('추가하기'),
      ),
    ];
  }

  /// 로딩 중 버튼 스타일
  ButtonStyle _getLoadingButtonStyle(bool isLoading) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states) => isLoading ? Colors.grey : null),
      foregroundColor: MaterialStateProperty.resolveWith((states) => isLoading ? Colors.black26 : null),
    );
  }

  /// 로딩 오버레이 빌드
  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: Container(
        color: _PrinterStatusUIConstants.loadingOverlay,
        child: Center(child: CircularProgressIndicator()),
      ),
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
      await _savePrinterToServer(ref, printer, name, ip, port);
      Navigator.pop(context);
    } else {
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

  /// 중앙 정렬 컬럼 빌드
  DataColumn _centerCal(String text, {double minWidth = _PrinterStatusUIConstants.cellMinWidth}) {
    return DataColumn(label: SizedBox(width: minWidth, child: Center(child: Text(text))));
  }
}
