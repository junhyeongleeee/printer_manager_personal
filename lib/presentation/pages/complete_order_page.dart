import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_completion_list_provider.dart';
import '../providers/printerjob_list_provider.dart';
import 'package:print_manager/data/repositories/printer_repository_provider.dart';


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

    return Column(
      children: [
        Row(
            children: [
              SizedBox(height: 84),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "완료 내역창",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // 새로고침 로직 (서버 연동 시점에 구현)
                      _refreshOrderList();
                    },
                    icon: const Icon(Icons.refresh, color: Color(0xFF1A66EB)),
                    label: const Text('새로고침',
    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFFFFF), // 버튼 배경색
                      foregroundColor: Color(0xFF3A3A3C), // 텍스트 + 아이콘 색상
                      minimumSize: Size(94, 40),
                      shape: RoundedRectangleBorder(
                        // 선택: 둥근 테두리 적용
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ]
        ),

        Expanded(
          child: LayoutBuilder(
            builder: (context, constaints) {
              return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0XFFE0E0E0)),
                    borderRadius: BorderRadius.circular(1),
              ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: constaints.maxWidth),
                        child: IntrinsicWidth(
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) => Color(0xFFF9FAFB), // 헤더 배경색
                            ),
                            dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Color(0xFFFFFFFF); // 선택된 row 색상
                                }
                                return Color(0xFFFFFFFF); // 기본 row 색상
                              },
                            ),
                            columns: [
                              // _centerCal('인덱스'),
                              // _centerCal('기관'),
                              // _centerCal('고유코드'),
                              // _centerCal('품목'),
                              // _centerCal('총량'),
                              // _centerCal('할당 인쇄량'),
                              // _centerCal('발주 날짜'),
                              // _centerCal('인쇄 시작'),
                              // _centerCal('인쇄 완료'),
                              _centerCal('인덱스'),
                              //_centerCal('OrdPtJobId'),
                              //_centerCal('PrinterId'),
                              _centerCal('품목'),
                              _centerCal('총량'),
                              //_centerCal('할당 인쇄량'),
                              _centerCal('발주 일시'),
                              _centerCal('인쇄 시작'),
                              _centerCal('인쇄 완료'),
                            ],
                            rows:
                            printerjobs.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;

                              return DataRow(
                                cells: [
                                  // _centerCell('${index + 1}'),
                                  // _centerCell(item.agency),
                                  // _centerCell(item.orderCode),
                                  // _centerCell(item.item),
                                  // _centerCell('${item.total}'),
                                  // _centerCell('${item.assignedAmount}'),
                                  // _centerCell(item.orderDate),
                                  // _centerCell(
                                  //   item.startedAt?.toIso8601String().split('T').first ?? '-'),
                                  // _centerCell(item.completedAt?.toIso8601String().split('T').first ?? '-'),
                                  _centerCell('${index + 1}'),
                                  //_centerCell("${item.orderPrintJobId}"),
                                  //_centerCell("${item.printerId}"),
                                  _centerCell("${item.itemName}"),
                                  _centerCell("${item.quantity}"),
                                  _centerCell(item.regDate),
                                  _centerCell(item.startedAt?? "-"),
                                  _centerCell(item.completedAt ?? "-"),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
              );
            },
          ),
        ),
      ],
    );
  }

  DataCell _centerCell(String text, {double minWidth = 80}) {
    return DataCell(
      SizedBox(width: minWidth, child: Center(child: Text(text))),
    );
  }

  DataColumn _centerCal(String text, {double minWidth = 80}) {
    return DataColumn(
      label: SizedBox(width: minWidth, child: Center(child: Text(text))),
    );
  }
}
