import 'package:flutter/material.dart';
import 'package:print_manager/data/repositories/user_repository_provider.dart';
import 'package:print_manager/presentation/pages/printer_status_page.dart';
import 'package:print_manager/presentation/pages/order_manage_page.dart';
import 'package:print_manager/presentation/pages/complete_order_page.dart';
import 'package:print_manager/presentation/pages/image_processor_page.dart';
import 'package:print_manager/presentation/pages/tcp_chat_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_list_provider.dart';
import '../providers/order_completion_list_provider.dart';
import '../providers/printer_list_provider.dart';
import '../providers/user_provider.dart';



class PrinterManagerHome extends ConsumerStatefulWidget {
  const PrinterManagerHome({super.key});

  @override
  ConsumerState<PrinterManagerHome> createState() => _PrinterManagerHomeState();
}

class _PrinterManagerHomeState extends ConsumerState<PrinterManagerHome> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    PrinterStatusPage(),
    OrderManagePage(),
    OrderCompletePage(),
    //ImageProcessorPage(),
    TcpChatPage(),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: isSelected ? Color(0xFF1A66EB) : Color(0xFF9D9D9D),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          // Container(
          //   height: 2,
          //   width: 90,
          //   color: isSelected ? Colors.blue : Colors.transparent,
          // ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final businessNumber = ref.read(userProvider)?.id ?? "물음표";
    print("businessNumber: $businessNumber");
    return Scaffold(
      appBar: AppBar(
        //title: Text('프린터 매니저'),
        // title: Row(
        //     //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       TextButton(
        //         onPressed: () => _onTap(0),
        //         child: Text('프린터 상태', style: TextStyle(color: Colors.blue)),
        //       ),
        //       TextButton(
        //         onPressed: () => _onTap(1),
        //         child: Text('주문 상태', style: TextStyle(color: Colors.blue)),
        //       ),
        //       TextButton(
        //         onPressed: () => _onTap(2),
        //         child: Text('인쇄 내역', style: TextStyle(color: Colors.blue)),
        //       ),
        //       // TextButton(
        //       //   onPressed: () => _onTap(3),
        //       //   child: Text('TEST', style: TextStyle(color: Colors.blue)),
        //       // ),
        //       SizedBox(width: 200),
        //       Text(
        //         '사업자번호: $businessNumber',
        //         style: TextStyle(color: Colors.black, fontSize: 14),
        //       ),
        //       OutlinedButton(
        //         onPressed: () {
        //           context.go('/login');
        //           ref.read(printerListProvider.notifier).clear();
        //           ref.read(orderCompletionListProvider.notifier).clear();
        //           ref.read(orderListProvider.notifier).clear();
        //           ref.read(userProvider.notifier).clear();
        //           // 로그아웃 로직
        //         },
        //         style: OutlinedButton.styleFrom(
        //           side: BorderSide(color: Colors.grey),
        //           foregroundColor: Colors.grey,
        //         ),
        //         child: Text('로그아웃', style: TextStyle(color: Colors.grey),),
        //       ),
        //     ]
        // ),
          backgroundColor: Color(0xFFFFFFFF),
          title : Row(
            children: [
              SizedBox(width: 40,),
              _buildTabButton('프린터 상태', 0),
              SizedBox(width: 25,),
              _buildTabButton('주문 상태', 1),
              SizedBox(width: 25,),
              _buildTabButton('인쇄 내역', 2),
              SizedBox(width: 25,),
              _buildTabButton('TEST', 3),
              const Spacer(),
              Text(
                '사업자번호: $businessNumber',
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () {
                  context.go('/login');
                  ref.read(printerListProvider.notifier).clear();
                  ref.read(orderCompletionListProvider.notifier).clear();
                  ref.read(orderListProvider.notifier).clear();
                  ref.read(userProvider.notifier).clear();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  foregroundColor: Colors.grey,
                ),
                child: const Text('로그아웃', style: TextStyle(color: Colors.grey)),
              ),
            ],
          )


        // actions: [
        //   TextButton(onPressed: () => _onTap(0), child: Text('TEST', style: TextStyle(color: Colors.white))),
        //   TextButton(onPressed: () => _onTap(1), child: Text('프린터 상태', style: TextStyle(color: Colors.white))),
        //   TextButton(onPressed: () => _onTap(2), child: Text('설정', style: TextStyle(color: Colors.white))),
        // ],
      ),
      backgroundColor: Color(0xFFF6F7F8),
      body: IndexedStack(index: _selectedIndex, children: _pages),
    );
  }
}