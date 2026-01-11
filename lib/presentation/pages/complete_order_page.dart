import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/printerjob_list_provider.dart';
import 'package:print_manager/core/data/repositories/printer_repository_provider.dart';

/// UI 상수 (Windows UI 스타일)
class _UIConstants {
  static const double headerHeight = 84.0;
  static const double horizontalPadding = 16.0;
  static const double buttonMinWidth = 94.0;
  static const double buttonHeight = 32.0;
  static const double borderRadius = 2.0; // Windows 스타일
  static const double cellMinWidth = 100.0;

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
  static const Color textGray = Color(0xFF3A3A3C);
  static const Color borderGray = Color(0xFFADADAD); // Windows border color
  static const Color backgroundColor = Color(0xFFF0F0F0); // Windows background
}

class OrderCompletePage extends ConsumerStatefulWidget {
  const OrderCompletePage({super.key});

  @override
  ConsumerState<OrderCompletePage> createState() => _OrderCompletePageState();
}

class _OrderCompletePageState extends ConsumerState<OrderCompletePage> {

  void _refreshOrderList() async {
    final printerjobRepository = ref.read(printerRepositoryProvider);
    final response = await printerjobRepository.printerJobList();
    ref.read(printerjobListProvider.notifier).mergeJobs(response.data.printJobList);
  }

  @override
  void initState() {
    super.initState();
    _refreshOrderList();
  }

  @override
  Widget build(BuildContext context) {
    //final completions = ref.watch(orderCompletionListProvider);
    final printerjobs = ref.watch(printerjobListProvider);

    return Container(
      color: _UIConstants.backgroundColor,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildOrderTable(printerjobs)),
        ],
      ),
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
            "완료 내역창",
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
      onPressed: () {
        _refreshOrderList();
      },
      icon: Icon(Icons.refresh, size: 16),
      label: Text('새로고침', style: _UIConstants.textStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      style: OutlinedButton.styleFrom(
        backgroundColor: _UIConstants.rowBackgroundColor,
        foregroundColor: _UIConstants.textGray,
        side: BorderSide(color: _UIConstants.borderGray),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size(_UIConstants.buttonMinWidth, _UIConstants.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_UIConstants.borderRadius),
        ),
      ),
    );
  }

  /// 주문 테이블 빌드
  Widget _buildOrderTable(List printerjobs) {
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
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return _UIConstants.rowBackgroundColor;
                        }
                        return _UIConstants.rowBackgroundColor;
                      },
                    ),
                    headingRowHeight: 48,
                    dataRowHeight: 56,
                    columns: [
                      _centerCal('인덱스'),
                      _centerCal('품목'),
                      _centerCal('총량'),
                      _centerCal('발주 일시'),
                      _centerCal('인쇄 시작'),
                      _centerCal('인쇄 완료'),
                    ],
                    rows: printerjobs.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;

                      return DataRow(
                        cells: [
                          _centerCell('${index + 1}'),
                          _centerCell("${item.itemName}"),
                          _centerCell("${item.quantity}"),
                          _centerCell(item.regDate),
                          _centerCell(item.startedAt ?? "-"),
                          _centerCell(item.completedAt ?? "-"),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
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
            style: _UIConstants.textStyle(fontSize: 13, color: Colors.grey[800]),
          ),
        ),
      ),
    );
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
}
