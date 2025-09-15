import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_manager/data/models/request/update_printerjob_request.dart';
import 'package:print_manager/data/models/request/warehouse_request.dart';
import '../../domain/entities/managed_printer.dart';
import '../providers/order_list_provider.dart';
import '../providers/printer_list_provider.dart';
import 'package:print_manager/data/repositories/order_repository_provider.dart';
import 'package:print_manager/data/models/request/patch_order_request.dart';
import 'package:print_manager/data/repositories/printer_repository_provider.dart';
import 'package:print_manager/data/models/request/printerjob_request.dart';
import 'package:print_manager/presentation/providers/prototype_printer_provider.dart';

class OrderManagePage extends ConsumerStatefulWidget {
  const OrderManagePage({super.key});

  @override
  ConsumerState<OrderManagePage> createState() => _OrderManagePageState();
}

class _OrderManagePageState extends ConsumerState<OrderManagePage> {
  @override
  void initState() {
    super.initState();
    _refreshOrderList();
  }

  void _refreshOrderList() async {
    final orderRepository = ref.read(orderRepositoryProvider);
    final response = await orderRepository.orderList();
    //ref.read(orderListProvider.notifier).mergeNewOrdersIntoProvider(ref, response);
    ref
        .read(orderListProvider.notifier)
        .replaceOrderListInProvider(ref, response);
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderListProvider);
    final printers = ref.watch(printerListProvider);

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
                  "주문 상태창",
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
                    // 새로고침 로직
                    _refreshOrderList();
                  },
                  icon: Icon(Icons.refresh, color: Color(0xFF1A66EB)),
                  label: Text(
                    '새로고침',
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
          ],
        ),

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
                        headingRowColor:
                            MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) =>
                                  Color(0xFFF9FAFB), // 헤더 배경색
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
                          _centerCal('번호'),
                          _centerCal('기관명'),
                          _centerCal('품목명'),
                          _centerCal('처리 상태'),
                          _centerCal('총 수량'),
                          _centerCal('인쇄 가능 수량'),
                          _centerCal('발주 일시'),
                          _centerCal('작업 처리'),
                        ],
                        rows:
                            orders.asMap().entries.map((entry) {
                              final i = entry.key;
                              final o = entry.value;
                              final canConfirm =
                                  (o.status == '3' || o.status == '5');
                              final canAllocate = o.status == '4';
                              final canSendConfirm = o.status == '5';
                              final sendAfterSend =
                                  (o.status == '5' || o.status == '6');
                              Color buttonColor;
                              Color? borderColor;
                              if (o.status == '3') {
                                buttonColor = Color(0xFFFFFFFF);
                                borderColor = Color(0xFF0246B0);
                              } else if (o.status == '4') {
                                buttonColor = Color(0xFF0246B0);
                                borderColor = Color(0xFFFFFFFF);
                              } else if (o.status == '5') {
                                buttonColor = Color(0xFFFFFFFF);
                                borderColor = Color(0xFF01BC90);
                              } else if (o.status == "6") {
                                buttonColor = Color(0xFFFFFFFF);
                                borderColor = Color(0xFFD9D9D9);
                              } else {
                                buttonColor = Colors.grey;
                              }
                              String orderStatus;
                              switch (o.status) {
                                case "1":
                                  orderStatus = "제작 대기";
                                  break;
                                case "2":
                                  orderStatus = "제작 중";
                                  break;
                                case "3":
                                  orderStatus = "배송 중";
                                  break;
                                case "4":
                                  orderStatus = "인쇄/가공 중";
                                  break;
                                case "5":
                                  orderStatus = "인쇄/가공 완료";
                                  break;
                                case "6":
                                  orderStatus = "출고 완료";
                                  break;
                                default:
                                  orderStatus = "제작 대기";
                                  break;
                              }

                              return DataRow(
                                cells: [
                                  _centerCell('${i + 1}'),
                                  //_centerCell(o.embeddingCode),
                                  //_centerCell('${o.orderId}'),
                                  _centerCell('${o.institutionName}'),
                                  _centerCell(o.itemName),
                                  //_centerCell(o.status),
                                  _centerCell(orderStatus),
                                  _centerCell('${o.quantity}'),
                                  _centerCell('${o.remainingQuantity}'),
                                  _centerCell(o.regDate),
                                  _centeredButtonCell(
                                    !canAllocate
                                        ? ElevatedButton(
                                          onPressed:
                                              canConfirm
                                                  ? () async {
                                                    if (o.status == "3") {
                                                      ref
                                                          .read(
                                                            orderListProvider
                                                                .notifier,
                                                          )
                                                          .completeOrder(i);

                                                      final request =
                                                          PatchOrderRequest(
                                                            status: "4",
                                                          );

                                                      final orderRepository =
                                                          ref.read(
                                                            orderRepositoryProvider,
                                                          );
                                                      print(
                                                        "updateOrder request: $request, orderId: ${o.orderId}",
                                                      );
                                                      final response =
                                                          await orderRepository
                                                              .updateOrder(
                                                                o.orderId,
                                                                request,
                                                              );
                                                      print(
                                                        "updateOrder response: $response",
                                                      );
                                                      /*await Future.delayed(Duration(seconds: 1), () {
                                        print('1초 후 실행됨');
                                      });*/
                                                      _refreshOrderList();
                                                    } else {
                                                      _showSendToWarehouseDialog(
                                                        context,
                                                        ref,
                                                        i,
                                                        o.quantity,
                                                        o.stock,
                                                        o.orderId,
                                                      );
                                                      // final request = PatchOrderRequest(
                                                      //   status: "6",
                                                      // );
                                                      // print("updateOrder request: $request, orderId: ${o.orderId}");
                                                      // final orderRepository = ref.read(orderRepositoryProvider);
                                                      // final response = await orderRepository.updateOrder(o.orderId, request);
                                                      // print("updateOrder response: $response");
                                                      await Future.delayed(
                                                        Duration(seconds: 1),
                                                        () {
                                                          print('1초 후 실행됨');
                                                        },
                                                      );
                                                      _refreshOrderList();

                                                      print(
                                                        "status 6 상태변경은 서버에서 결정",
                                                      );
                                                    }
                                                  }
                                                  : null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: buttonColor,
                                            side: BorderSide(
                                              color:
                                                  borderColor ?? Colors.white,
                                              width: 1.0,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    4,
                                                  ), // ← 여기가 라운드 효과!
                                            ),
                                          ),
                                          child: Text(
                                            (sendAfterSend) ? '출고하기' : '수령완료',
                                            style: TextStyle(
                                              color: borderColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                        : ElevatedButton(
                                          onPressed: () async {
                                            if (o.status == "4") {
                                              ref
                                                  .read(
                                                    prototypePrinterProvider
                                                        .notifier,
                                                  )
                                                  .setOrder(o);
                                              _showAllocateDialog(
                                                context,
                                                ref,
                                                i,
                                                o.quantity,
                                                o.remainingQuantity,
                                                o.uniqueCode,
                                                o.orderId,
                                                o.startCode,
                                                o.endCode,
                                                o.itemName,
                                                printers,
                                              );
                                              await Future.delayed(
                                                Duration(seconds: 1),
                                                () {
                                                  print('1초 후 실행됨');
                                                },
                                              );
                                              _refreshOrderList();
                                            } else {
                                              _showSendToWarehouseDialog(
                                                context,
                                                ref,
                                                i,
                                                o.quantity,
                                                o.stock,
                                                o.orderId,
                                              );
                                            }
                                            await Future.delayed(
                                              Duration(seconds: 1),
                                              () {
                                                print('1초 후 실행됨');
                                              },
                                            );
                                            _refreshOrderList();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: buttonColor,
                                            side: BorderSide(
                                              color:
                                                  borderColor ?? Colors.white,
                                              width: 1.0,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    4,
                                                  ), // ← 여기가 라운드 효과!
                                            ),
                                          ),
                                          child: Text(
                                            (o.status == "4") ? '인쇄하기' : '출고하기',
                                            style: TextStyle(
                                              color: borderColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                  ),
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
      ],
    );
  }

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
                  title: Text('인쇄하기'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<ManagedPrinter>(
                        hint: Text('프린터 선택'),
                        items:
                            printers
                            .where((printer) =>
                            (printer.printStatus == "인쇄 대기" ||
                              printer.printStatus == "인쇄 완료") &&
                                (printer.connectStatus == "연결됨")
                            )
                                .map(
                                  (printer) => DropdownMenuItem(
                                    value: printer,
                                    child: Text(printer.name),
                                  ),
                                )
                                .toList(),
                        onChanged: (printer) {
                          setState(() => selectedPrinter = printer);
                          ref
                              .read(prototypePrinterProvider.notifier)
                              .setPrinter(selectedPrinter!);
                        },
                      ),
                      TextField(
                        controller: amountController,
                        decoration: InputDecoration(labelText: '인쇄 수량 입력'),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 8),
                      Text('인쇄 가능량: $maxAvailable'),
                      //Text('인쇄 수량: $maxAvailable'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('취소'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        //final input = maxAvailable;

                        //0627프로토타입 이후 사용
                        final input = int.tryParse(
                          amountController.text.trim(),
                        );
                        if (input == null ||
                            input <= 0 ||
                            input > maxAvailable ||
                            selectedPrinter == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('정확한 프린터와 유효한 할당량을 입력해주세요.'),
                            ),
                          );
                          return;
                        }

                        // 1. 발주 상태 업데이트
                        ref
                            .read(orderListProvider.notifier)
                            .allocateOrder(index, input);

                        selectedPrinter?.item = ref
                            .read(orderListProvider.notifier)
                            .getItemNameByOrderId(orderId);
                        //ref.read(orderListProvider.notifier).

                        //

                        final request = PrinterjobRequest(
                          orderId: orderId,
                          processingCompanyPrinterId: selectedPrinter!.id ?? 0,
                          quantity: input,
                        );
                        print("addPrinterJob request: $request");
                        final printerRepository = ref.read(
                          printerRepositoryProvider,
                        );
                        final response = await printerRepository.addPrinterJob(
                          request,
                        );
                        final jobId = response.data.jobId;
                        print("addPrinterJob response: $response");
                        /*final request_complete = UpdatePrinterjobRequest(
                          status: "IN_PROGRESS",
                          message: "인쇄 중",
                        );*/
                        // printerRepository.updatePrinterJob(jobId, request_complete);
                        // await Future.delayed(Duration(seconds: 1), () {
                        //   print('1초 후 실행됨');
                        // });
                        // // 2. 프린터 할당
                        final int printingStartCode = int.parse(startCode);
                        final int printingEndCode =
                            int.parse(startCode) + (input - 1);

                        final printerId = selectedPrinter?.id ?? 0;
                        print(
                          "odermanage \n prinerId: ${selectedPrinter?.id}, itemName: $itemName, startCode: $startCode, endCode: $endCode",
                        );

                        final isLastPrint = (maxAvailable == input);

                        ref
                            .read(printerListProvider.notifier)
                            .assignPrintJob(
                              printerId,
                              jobId,
                              itemName, // 필요 시 o.code나 o.item 등으로 대체 가능
                              uniqcode,
                              printingStartCode,
                              // 시작 번호 (실제 로직 필요시 index나 누적값 기반으로 변경)
                              printingEndCode, // 할당량만큼
                              isLastPrint,
                            );
                        //
                        // final request_complete2 = UpdatePrinterjobRequest(
                        //   status: "COMPLETE",
                        //   message: "인쇄 완료",
                        // );
                        // printerRepository.updatePrinterJob(jobId, request_complete2);
                        // await Future.delayed(Duration(seconds: 1), () {
                        //   print('1초 후 실행됨');
                        // });

                        // ref.read(printerListProvider.notifier).assignPrintJob(
                        //   selectedPrinter!.id ??0,
                        //   itemName, // 필요 시 o.code나 o.item 등으로 대체 가능
                        //   int.parse(startCode), // 시작 번호 (실제 로직 필요시 index나 누적값 기반으로 변경)
                        //   int.parse(endCode), // 할당량만큼
                        // );

                        Navigator.pop(context);
                        await Future.delayed(Duration(seconds: 1), () {
                          print('1초 후 실행됨');
                        });
                        _refreshOrderList();
                      },
                      child: SizedBox(
                        width: 80,
                        child: Center(child: Text('인쇄하기')),
                      ),
                    ),
                  ],
                ),
          ),
    );
  }

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
    ManagedPrinter? selectedPrinter;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: Text('출고하기'),
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
                      Text('출고 가능 수량: $maxAvailable'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('취소'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final input = int.tryParse(
                          sendAmountController.text.trim(),
                        );
                        if (input == null ||
                            input <= 0 ||
                            input > maxAvailable ||
                            warehouseNameController.text == "" ||
                            warehouseLocationController.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('정확한 정보와 유효한 할당량을 입력해주세요.')),
                          );
                          return;
                        }

                        final request = WarehouseRequest(
                          orderId: orderId,
                          name: warehouseNameController.text,
                          address: warehouseLocationController.text,
                          quantity: input,
                        );
                        print("addPrinterJob request: $request");
                        final orderRepository = ref.read(
                          orderRepositoryProvider,
                        );
                        final response = await orderRepository.sendToWarehouse(
                          request,
                        );
                        //final jobId = response.data.jobId;
                        print("addPrinterJob response: $response");

                        Navigator.pop(context);
                        await Future.delayed(Duration(seconds: 1), () {
                          print('1초 후 실행됨');
                        });
                        _refreshOrderList();
                      },
                      child: SizedBox(
                        width: 80,
                        child: Center(child: Text('출고하기')),
                      ),
                    ),
                  ],
                ),
          ),
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
    return DataCell(SizedBox(width: width, child: Center(child: button)));
  }
}
