import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_manager/presentation/providers/order_list_provider.dart';
import 'dart:io';
import '../providers/printer_list_provider.dart';
import '../../domain/entities/managed_printer.dart';
import 'package:print_manager/data/models/request/printers_request.dart';
import 'package:print_manager/data/repositories/printer_repository_provider.dart';

import 'package:print_manager/data/repositories/order_repository_provider.dart';
import 'package:print_manager/presentation/providers/printerjob_list_provider.dart';


class PrinterStatusPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<PrinterStatusPage> createState() => _PrinterStatusPageState();
}

class _PrinterStatusPageState extends ConsumerState<PrinterStatusPage> {
  ManagedPrinter? selectedPrinter;

  @override
  void initState() {
    super.initState();
    _initializePrinters();
  }

  void _initializePrinters() async {
    try {
      await _refreshPrinterList();
      await _initConnection();
    } catch (e, stack) {
      debugPrint('_initializePrinters error: $e\n$stack');
    }

    //await _refreshPrinterList();
  }

  Future<void> _refreshPrinterList() async {
    final printerRepository = ref.read(printerRepositoryProvider);
    final response = await printerRepository.printerList();
    ref.read(printerListProvider.notifier).mergeNewData(ref, response);
  }

  Future<void> _initConnection() async {

    final printerList = ref.read(printerListProvider);
    for (final printer in printerList) {
      final response = await printer.connect();
      print("initConnection- printer: $printer, connection: $response");

    }
  }

  @override
  Widget build(BuildContext context) {
    final printers = ref.watch(printerListProvider);

    return Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: [
                SizedBox(height: 84),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "프린터 상태창",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: 40,
                      child: ElevatedButton(
                        //onPressed: () => _showAddPrinterDialog(context, ref),
                        onPressed: () => _testPrint(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1A66EB),       // 버튼 배경색
                          foregroundColor: Color(0xFFF3F7FF),
                          minimumSize: Size(94, 40),
                          shape: RoundedRectangleBorder(
                            // 선택: 둥근 테두리 적용
                            borderRadius: BorderRadius.circular(4),
                          ),// 텍스트 + 아이콘 색상
                        ),
                        child: Text('프린터 테스트',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () => _showAddPrinterDialog(context, ref),
                        icon: Icon(Icons.add),
                        label: Text('프린터 추가',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1A66EB),       // 버튼 배경색
                          foregroundColor: Color(0xFFF3F7FF),
                          minimumSize: Size(94, 40),
                          shape: RoundedRectangleBorder(
                            // 선택: 둥근 테두리 적용
                            borderRadius: BorderRadius.circular(4),
                          ),// 텍스트 + 아이콘 색상
                        ),
                      ),
                    ),
                  ]
                ),
                SizedBox(height: 26),
                Expanded(
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
                                showCheckboxColumn: false,
                                // columns: const [
                                //   DataColumn(label: Center(child: Text('인덱스'))),
                                //   DataColumn(label: Center(child: Text('프린터명'))),
                                //   DataColumn(label: Center(child: Text('IP 주소 : 포트'))),
                                //   //DataColumn(label: Center(child: Text('고유코드'))),
                                //   DataColumn(label: Center(child: Text('품목'))),
                                //   DataColumn(label: Center(child: Text('상태'))),
                                //   DataColumn(label: Center(child: Text('인쇄 현황'))),
                                //   DataColumn(label: Center(child: Text('시작 일시'))),
                                //   DataColumn(label: Center(child: Text('완료 일시'))),
                                // ],
                                columns: [
                                  _centerCal('인덱스'),
                                  _centerCal('프린터명'),
                                  _centerCal('IP 주소 : 포트'),
                                  //_centerCalxt('고유코드'),
                                  _centerCal('품목명'),
                                  _centerCal('연결 상태'),
                                  _centerCal('프린터 상태'),
                                  _centerCal('인쇄 현황'),
                                  _centerCal('시작 일시'),
                                  _centerCal('완료 일시'),
                                ],
                                rows: printers.asMap().entries.map((entry) {
                                  final i = entry.key;
                                  final p = entry.value;
                                  final isSelected = p == selectedPrinter;
                                  return DataRow(
                                    selected: isSelected,
                                    onSelectChanged: (_) {
                                      setState(() => selectedPrinter = p);
                                      print("selectedPrinter: ${selectedPrinter?.id ?? 0}");
                                     // final printjobList = ref.read(printerjobListProvider);
                                      //p.updateFields(startDate: printjobList.getStratAtByOrderId(p.id??0), endDate: orderList.getEndAtByOrderId(p.id??0), code: orderList.code, item: orderList.startDate, endDate: orderList.endDate, code: orderList.code);
                                    },
                                    cells: [
                                      DataCell(Center(child: Text('${i + 1}'))),
                                      DataCell(Center(child: Text(p.name))),
                                      DataCell(Center(child: Text('${p.ip}:${p.port}'))),
                                      //DataCell(Center(child: Text(p.code ?? ''))),
                                      DataCell(Center(child: Text(p.item ?? ''))),
                                      DataCell(Center(child: Text(p.connectStatus))),
                                      DataCell(Center(child: Text(p.status ?? ''))),
                                      DataCell(Center(child: Text(p.printStatus ?? ''))),
                                      DataCell(Center(child: Text(p.startDate ?? ''))),
                                      DataCell(Center(child: Text(p.endDate ?? ''))),
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
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          VerticalDivider(),
          Expanded(
            flex: 1,
            child:
                selectedPrinter == null
                    ? Center(child: Text('프린터를 선택하세요'))
                    : Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('프린터명: ${selectedPrinter!.name}'),
                          Text('상태: ${selectedPrinter!.connectStatus}'),
                          //Text('고유코드: ${selectedPrinter!.code ?? "-"}'),
                          Text('품목: ${selectedPrinter!.item ?? "-"}'),
                          // Text(
                          //   '인쇄 범위: ${selectedPrinter!.startDate ?? "-"} ~ ${selectedPrinter!.endDate ?? "-"}',
                          // ),
                          // Text(
                          //   '현재 인쇄 번호: ${selectedPrinter!.printStatus ?? "-"}',
                          // ),
                          Spacer(),
                          Center(
                            child: ElevatedButton(
                              onPressed:
                                  () async { _confirmRemovePrinter(
                                context,
                                selectedPrinter!,
                              );
                              final printerRepository = ref.read(printerRepositoryProvider);
                              await selectedPrinter!.dispose();
                              print("selectedPrinter!.index: ${selectedPrinter!.id}");
                              await printerRepository.deletePrinter(selectedPrinter!.id?? 0);
                              await ref.read(printerListProvider.notifier).removePrinter(selectedPrinter!);
                              setState(() => selectedPrinter = null);
                              await _refreshPrinterList();
                              },
                              child: Text('프린터 제거'),
                            ),
                          ),
                        ],
                      ),
                ),
          ),
        ],
    );
  }

  void _confirmRemovePrinter(BuildContext context, ManagedPrinter printer) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('프린터 제거'),
            content: Text('프린터를 제거하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('취소'),
              ),
              TextButton(
                onPressed: () async {
                  //서버에 제거 API
                  final printerRepository = ref.read(printerRepositoryProvider);
                  selectedPrinter != null
                      ? await printerRepository.deletePrinter(selectedPrinter!.id??0)
                      : null;

                  //로컬에서 제거
                  await ref.read(printerListProvider.notifier).removePrinter(printer);
                  setState(() => selectedPrinter = null);

                  //화면 이동
                  Navigator.pop(context);
                },
                child: Text('확인'),
              ),
            ],
          ),
    );
  }


  void _testPrint(){
    ref.read(printerListProvider.notifier).testPrint();
  }

  void _showAddPrinterDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final ipController = TextEditingController();
    final portController = TextEditingController(text: 5000.toString());
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
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: '프린터 이름'),
                        ),
                        TextField(
                          controller: ipController,
                          decoration: InputDecoration(labelText: 'IP 주소'),
                        ),
                        TextField(
                          controller: portController,
                          decoration: InputDecoration(labelText: 'Port'),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed:
                            isLoading ? null : () => Navigator.pop(context),
                        child: Text('취소'),
                      ),
                      ElevatedButton(
                        onPressed:
                            isLoading
                                ? null
                                : () async {
                                      setState(() => isLoading = true);

                                      final name = nameController.text.trim();
                                      final ip = ipController.text.trim();
                                      final port =
                                          int.tryParse(
                                            portController.text.trim(),
                                          ) ??
                                          0;

                                      if (ref
                                          .read(printerListProvider.notifier)
                                          .exists(ip, port)) {
                                        setState(() => isLoading = false);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('이미 추가된 프린터입니다')),
                                        );
                                        return;
                                      }

                                      final printer = ManagedPrinter(
                                        index: ref.read(printerListProvider.notifier).state.length + 1,
                                        id: null,
                                        name: name,
                                        ip: ip,
                                        port: port,
                                        regDate: DateTime.now().toString(),
                                        //repository: printerRepository,
                                      );
                                      final connected = await printer.connect();
                                      print("connected: $connected");
                                      if (connected) {
                                        print("connected: $connected");
                                        ref
                                            .read(printerListProvider.notifier)
                                            .addPrinter(printer);

                                        final request = PrintersRequest(
                                          name: name,
                                          model: "VJ 6330",
                                          ip: ip,
                                          port: port.toString(),
                                          status: "인쇄 대기",
                                        );

                                        final printerRepository = ref.read(printerRepositoryProvider);
                                        final response = await printerRepository.addPrinter(request);
                                        print("response :$response");
                                        printer.updateFields(id: response.data.processingCompanyPrinterIndex);
                                        Navigator.pop(context);
                                      } else {
                                        print("connected: $connected");
                                        printer.dispose();
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('연결할 수 없습니다')),
                                        );
                                      }

                                      setState(() => isLoading = false);
                                },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => isLoading ? Colors.grey : null,
                          ),
                          foregroundColor: MaterialStateProperty.resolveWith(
                            (states) => isLoading ? Colors.black26 : null,
                          ),
                        ),
                        child: Text('추가하기'),
                      ),
                    ],
                  ),
                  if (isLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              ),
        );
      },
    );
  }
  DataCell _centerCell(String text, {double minWidth = 100}) {
    return DataCell(
      SizedBox(width: minWidth, child: Center(child: Text(text))),
    );
  }

  DataColumn _centerCal(String text, {double minWidth = 100}) {
    return DataColumn(
      label: SizedBox(width: minWidth, child: Center(child: Text(text))),
    );
  }

  DataCell _centeredButtonCell(Widget button, {double width = 120}) {
    return DataCell(
      SizedBox(
        width: width,
        child: Center(
          child: button,
        ),
      ),
    );
  }
}
