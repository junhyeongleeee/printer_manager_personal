import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/printer_list_provider.dart';
import '../../domain/entities/managed_printer.dart';
import 'package:print_manager/data/models/request/printers_request.dart';
import 'package:print_manager/data/repositories/printer_repository_provider.dart';
import 'package:print_manager/core/services/logger_service.dart';
import 'package:print_manager/core/enums/printer_protocol.dart';

class PrinterStatusPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<PrinterStatusPage> createState() => _PrinterStatusPageState();
}

/// UI 상수
class _PrinterStatusUIConstants {
  static const double headerHeight = 80.0;
  static const double horizontalPadding = 24.0;
  static const double cardSpacing = 16.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonHeight = 36.0;
  static const double buttonBorderRadius = 8.0;

  // 색상
  static const Color primaryBlue = Color(0xFF1A66EB);
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x1A000000);
  static const Color connectedColor = Color(0xFF4CAF50);
  static const Color disconnectedColor = Color(0xFF9E9E9E);
  static const Color printingColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
}

class _PrinterStatusPageState extends ConsumerState<PrinterStatusPage> {
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
      _setupCountUpdateCallback(printer);
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
    };
  }

  @override
  Widget build(BuildContext context) {
    final printers = ref.watch(printerListProvider);

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(children: [_buildHeader(), Expanded(child: _buildPrinterGrid(printers))]),
    );
  }

  /// 헤더 빌드
  Widget _buildHeader() {
    return Container(
      height: _PrinterStatusUIConstants.headerHeight,
      padding: EdgeInsets.symmetric(horizontal: _PrinterStatusUIConstants.horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: _PrinterStatusUIConstants.cardShadow, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Text('프린터 관리', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
          Spacer(),
          _buildExampleDataButton(),
          SizedBox(width: 12),
          _buildAddButton(),
        ],
      ),
    );
  }

  /// 예시 데이터 버튼
  Widget _buildExampleDataButton() {
    return OutlinedButton.icon(
      onPressed: _addExamplePrinters,
      icon: Icon(Icons.auto_awesome, size: 18),
      label: Text('예시 데이터'),
      style: OutlinedButton.styleFrom(
        foregroundColor: _PrinterStatusUIConstants.primaryBlue,
        side: BorderSide(color: _PrinterStatusUIConstants.primaryBlue),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.buttonBorderRadius),
        ),
      ),
    );
  }

  /// 프린터 추가 버튼
  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: () => _showAddPrinterDialog(context, ref),
      icon: Icon(Icons.add, size: 20),
      label: Text('프린터 추가'),
      style: ElevatedButton.styleFrom(
        backgroundColor: _PrinterStatusUIConstants.primaryBlue,
        foregroundColor: _PrinterStatusUIConstants.primaryText,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.buttonBorderRadius),
        ),
      ),
    );
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

  /// 프린터 그리드 빌드
  Widget _buildPrinterGrid(List<ManagedPrinter> printers) {
    if (printers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.print_disabled, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text('등록된 프린터가 없습니다', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            SizedBox(height: 8),
            Text('프린터 추가 버튼을 눌러 프린터를 등록하세요', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(_PrinterStatusUIConstants.cardSpacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        crossAxisSpacing: _PrinterStatusUIConstants.cardSpacing,
        mainAxisSpacing: _PrinterStatusUIConstants.cardSpacing,
        childAspectRatio: 0.9, // 카드 비율 조정 (약간 더 세로로)
      ),
      itemCount: printers.length,
      itemBuilder: (context, index) => _buildPrinterCard(printers[index]),
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

  /// 프린터 카드 빌드
  Widget _buildPrinterCard(ManagedPrinter printer) {
    // ListenableBuilder로 감싸서 상태 변경 시 자동 UI 업데이트
    return ListenableBuilder(
      listenable: printer,
      builder: (context, child) {
        final isConnected = printer.connectionStatus == '연결됨';
        final isPrinting = printer.printStatus == '인쇄 중';
        final hasOrder = printer.totalPrintWork != null && printer.totalPrintWork! > 0;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.cardBorderRadius),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더: 프린터명 + 상태 배지
                _buildCardHeader(printer, isConnected, isPrinting),
                SizedBox(height: 16),

                // 기본 정보
                _buildBasicInfo(printer),
                SizedBox(height: 16),

                // 통계 정보
                _buildStatistics(printer),
                Spacer(),

                // 액션 버튼들
                _buildActionButtons(printer, hasOrder, isConnected),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 카드 헤더 (프린터명 + 상태 + 제거)
  Widget _buildCardHeader(ManagedPrinter printer, bool isConnected, bool isPrinting) {
    return Row(
      children: [
        Expanded(
          child: Text(
            printer.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // SizedBox(width: 8),
        // _buildStatusBadge(printer.connectStatus, isConnected),
        SizedBox(width: 8),
        _buildRemoveBadge(printer),
      ],
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
    final isPrinterOn = printer.isPrinterOn;
    String printerStateText;
    if (printer.connectionStatus != '연결됨') {
      printerStateText = '미연결';
    } else if (isPrinterOn == true) {
      printerStateText = '작동 중 (ON)';
    } else if (isPrinterOn == false) {
      printerStateText = '준비 상태 (OFF)';
    } else {
      printerStateText = '상태 확인 중';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(Icons.computer, 'IP 주소', '${printer.ip}:${printer.port}'),
        SizedBox(height: 8),
        _buildInfoRow(Icons.inventory_2, '품목명', printer.item ?? '-'),
        SizedBox(height: 8),
        _buildInfoRow(Icons.info, '프린터 상태', printerStateText),
      ],
    );
  }

  /// 정보 행
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

  /// 통계 정보 섹션
  Widget _buildStatistics(ManagedPrinter printer) {
    final totalOrder = printer.totalPrintWork ?? 0;
    final completed = printer.completePrintWork ?? 0;
    final currentCount = printer.protocol == PrinterProtocol.zipher ? printer.currentPrintCount : 0;
    final progress = totalOrder > 0 ? (completed / totalOrder).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('인쇄 현황', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[700])),
          SizedBox(height: 12),
          _buildStatRow('총 발주 수량', '$totalOrder', Colors.grey[800]!),
          SizedBox(height: 8),
          _buildStatRow('완료 수량', '$completed', Color(0xFF4CAF50)),
          if (printer.protocol == PrinterProtocol.zipher) ...[
            SizedBox(height: 8),
            _buildStatRow('실시간 카운트', '$currentCount', _PrinterStatusUIConstants.primaryBlue),
          ],
          if (totalOrder > 0) ...[SizedBox(height: 12), _buildProgressBar(progress)],
        ],
      ),
    );
  }

  /// 통계 행
  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text('$value장', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: valueColor)),
      ],
    );
  }

  /// 진행률 바
  Widget _buildProgressBar(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('진행률', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            Text(
              '${(progress * 100).toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[700]),
            ),
          ],
        ),
        SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(_PrinterStatusUIConstants.primaryBlue),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  /// 액션 버튼들
  Widget _buildActionButtons(ManagedPrinter printer, bool hasOrder, bool isConnected) {
    final isPrinterOn = printer.isPrinterOn;

    return Column(
      children: [
        // 발주/출고 버튼
        if (hasOrder)
          _buildActionButton(
            label: '출고하기',
            icon: Icons.local_shipping,
            color: Color(0xFF4CAF50),
            onPressed: () => _handleShipment(printer),
          )
        else
          _buildActionButton(
            label: '발주하기',
            icon: Icons.add_shopping_cart,
            color: _PrinterStatusUIConstants.primaryBlue,
            onPressed: () => _handleOrder(printer),
          ),
        SizedBox(height: 8),

        // 하단 버튼 (On/Off)
        if (isConnected)
          _buildIconButton(
            icon: isPrinterOn == true ? Icons.pause : Icons.play_arrow,
            label: isPrinterOn == true ? '중지' : (isPrinterOn == false ? '시작' : '상태 확인 중'),
            color:
                isPrinterOn == true
                    ? _PrinterStatusUIConstants.printingColor
                    : _PrinterStatusUIConstants.connectedColor,
            onPressed: () => _handleTogglePrinter(printer, isConnected),
          )
        else
          _buildIconButton(
            icon: Icons.play_arrow,
            label: '연결 필요',
            color: _PrinterStatusUIConstants.disconnectedColor,
            onPressed: null,
          ),
      ],
    );
  }

  /// 액션 버튼
  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: _PrinterStatusUIConstants.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_PrinterStatusUIConstants.buttonBorderRadius),
          ),
        ),
      ),
    );
  }

  /// 아이콘 버튼
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
        label: Text(label, style: TextStyle(fontSize: 12)),
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
    // TODO: 발주 다이얼로그 표시
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('발주 기능은 구현 예정입니다')));
  }

  /// 출고하기 처리
  Future<void> _handleShipment(ManagedPrinter printer) async {
    // TODO: 출고 다이얼로그 표시
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('출고 기능은 구현 예정입니다')));
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
        // 프린터 ON으로 변경
        await printer.setPrinterState(true);
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('프린터 제거'),
            content: Text('${printer.name} 프린터를 제거하시겠습니까?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: Text('취소')),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: _PrinterStatusUIConstants.errorColor),
                child: Text('제거'),
              ),
            ],
          ),
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
          builder:
              (context, setState) => Stack(
                children: [
                  AlertDialog(
                    title: Text('프린터 추가하기'),
                    content: _buildAddPrinterForm(nameController, ipController, portController),
                    actions: [
                      TextButton(onPressed: isLoading ? null : () => Navigator.pop(context), child: Text('취소')),
                      ElevatedButton(
                        onPressed:
                            isLoading
                                ? null
                                : () => _handleAddPrinter(
                                  context,
                                  ref,
                                  nameController,
                                  ipController,
                                  portController,
                                  (loading) => setState(() => isLoading = loading),
                                ),
                        child: Text('추가하기'),
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
}
