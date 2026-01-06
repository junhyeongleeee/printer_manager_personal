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

// 프린터 상태 타입 (React 프로젝트와 동일)
enum PrinterStatusType {
  all,
  online, // 대기중
  printing, // 인쇄중
  warning, // 경고
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
      case PrinterStatusType.printing:
        return Color(0xFFE3F2FD); // 연한 파란색
      case PrinterStatusType.warning:
        return Color(0xFFFFF8E1); // 연한 노란색
      case PrinterStatusType.offline:
        return Color(0xFFFFEBEE); // 연한 빨간색
      default:
        return cardBg;
    }
  }
}

class _PrinterStatusPageState extends ConsumerState<PrinterStatusPage> {
  PrinterStatusType _selectedFilter = PrinterStatusType.all;

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
                _buildFilterButton('인쇄중', PrinterStatusType.printing, counts['printing']!),
                _buildFilterButton('경고', PrinterStatusType.warning, counts['warning']!),
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
            onPressed: () => _refreshPrinterList(),
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
  Widget _buildStatusBar(List<ManagedPrinter> printers) {
    final counts = _getStatusCounts(printers);

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
          Expanded(child: _buildStatusBarItem('인쇄중', counts['printing']!, _PrinterStatusUIConstants.printingColor)),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          Expanded(child: _buildStatusBarItem('경고', counts['warning']!, _PrinterStatusUIConstants.warningColor)),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          Expanded(child: _buildStatusBarItem('오프라인', counts['offline']!, _PrinterStatusUIConstants.offlineColor)),
        ],
      ),
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
          Expanded(child: _buildStatusCard('인쇄중', counts['printing']!, Color(0xFF2196F3), null)),
          SizedBox(width: 12),
          Expanded(child: _buildStatusCard('경고', counts['warning']!, Color(0xFFFFC107), null)),
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
    int printing = 0;
    int warning = 0;
    int offline = 0;

    for (final printer in printers) {
      final status = _getPrinterStatusType(printer);
      switch (status) {
        case PrinterStatusType.online:
          online++;
          break;
        case PrinterStatusType.printing:
          printing++;
          break;
        case PrinterStatusType.warning:
          warning++;
          break;
        case PrinterStatusType.offline:
          offline++;
          break;
        default:
          break;
      }
    }

    return {'all': printers.length, 'online': online, 'printing': printing, 'warning': warning, 'offline': offline};
  }

  /// 프린터 상태 타입 결정
  PrinterStatusType _getPrinterStatusType(ManagedPrinter printer) {
    // 오프라인: 연결되지 않음
    if (printer.connectionStatus != '연결됨') {
      return PrinterStatusType.offline;
    }

    // 인쇄중: printStatus에 '인쇄 중' 포함
    if (printer.printStatus.contains('인쇄 중')) {
      return PrinterStatusType.printing;
    }

    // 경고: 연결되었지만 이상 상태
    if (printer.printStatus != '인쇄 대기' && printer.printStatus != '인쇄 완료') {
      return PrinterStatusType.warning;
    }

    // 대기중: 연결되었고 대기 상태
    return PrinterStatusType.online;
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

  /// 프린터 그리드 빌드
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

    return GridView.builder(
      shrinkWrap: true, // SingleChildScrollView 안에서 사용하기 위해 필요
      physics: NeverScrollableScrollPhysics(), // 부모의 스크롤을 사용
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

  /// 프린터 카드 빌드 (Windows UI 스타일)
  Widget _buildPrinterCard(ManagedPrinter printer) {
    // ListenableBuilder로 감싸서 상태 변경 시 자동 UI 업데이트
    return ListenableBuilder(
      listenable: printer,
      builder: (context, child) {
        final statusType = _getPrinterStatusType(printer);
        final hasOrder = printer.totalPrintWork != null && printer.totalPrintWork! > 0;

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

                      // 품목명
                      _buildItemName(printer),
                      SizedBox(height: 12),

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
      case PrinterStatusType.printing:
        return Icon(Icons.access_time, size: 20, color: Color(0xFF2196F3));
      case PrinterStatusType.warning:
        return Icon(Icons.warning, size: 20, color: Color(0xFFFFC107));
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
      case PrinterStatusType.printing:
        label = '인쇄중';
        color = _PrinterStatusUIConstants.printingColor;
        break;
      case PrinterStatusType.warning:
        label = '경고';
        color = _PrinterStatusUIConstants.warningColor;
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
  Widget _buildStatistics(ManagedPrinter printer) {
    final totalOrder = printer.totalPrintWork ?? 0;
    final completed = printer.completePrintWork ?? 0;
    final currentCount = printer.protocol == PrinterProtocol.zipher ? printer.currentPrintCount : 0;
    final progress = totalOrder > 0 ? (completed / totalOrder).clamp(0.0, 1.0) : 0.0;

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
          // 3열 그리드
          Row(
            children: [
              Expanded(child: _buildStatBox('총 발주 수량', '$totalOrder', Colors.grey[900]!)),
              SizedBox(width: 8),
              Expanded(child: _buildStatBox('완료 수량', '$completed', _PrinterStatusUIConstants.printingColor)),
              if (printer.protocol == PrinterProtocol.zipher) ...[
                SizedBox(width: 8),
                Expanded(child: _buildStatBox('실시간 카운트', '$currentCount', _PrinterStatusUIConstants.onlineColor)),
              ],
            ],
          ),
          if (totalOrder > 0) ...[SizedBox(height: 12), _buildProgressBar(progress)],
        ],
      ),
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

  /// 진행률 바
  Widget _buildProgressBar(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('진행률', style: _PrinterStatusUIConstants.textStyle(fontSize: 11, color: Colors.grey[600])),
            Text(
              '${(progress * 100).toStringAsFixed(1)}%',
              style: _PrinterStatusUIConstants.textStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
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

  /// 액션 버튼들 (Windows 스타일 - 같은 행에 배치)
  Widget _buildActionButtons(ManagedPrinter printer, bool hasOrder) {
    final isConnected = printer.connectionStatus == '연결됨';
    final isPrinterOn = printer.isPrinterOn;

    return Row(
      children: [
        // 발주/출고 버튼
        Expanded(
          child:
              hasOrder
                  ? _buildActionButton(
                    label: '출고하기',
                    icon: Icons.local_shipping,
                    color: _PrinterStatusUIConstants.onlineColor,
                    onPressed: () => _handleShipment(printer),
                  )
                  : _buildActionButton(
                    label: '발주선택',
                    icon: Icons.add_shopping_cart,
                    color: Colors.blue,
                    onPressed: () => _handleOrder(printer),
                  ),
        ),
        SizedBox(width: 8),

        // 준비/정지 버튼
        Expanded(
          child:
              isConnected
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
            title: Text(
              '프린터 제거',
              style: _PrinterStatusUIConstants.textStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: Text('${printer.name} 프린터를 제거하시겠습니까?', style: _PrinterStatusUIConstants.textStyle()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('취소', style: _PrinterStatusUIConstants.textStyle()),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: _PrinterStatusUIConstants.errorColor),
                child: Text('제거', style: _PrinterStatusUIConstants.textStyle()),
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
}
