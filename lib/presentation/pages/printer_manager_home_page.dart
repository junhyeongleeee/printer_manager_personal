import 'package:flutter/material.dart';
import 'package:print_manager/presentation/pages/printer_status_page.dart';
import 'package:print_manager/presentation/pages/order_manage_page.dart';
import 'package:print_manager/presentation/pages/complete_order_page.dart';
import 'package:print_manager/presentation/pages/tcp_chat_page.dart';
import 'package:print_manager/presentation/pages/isar_debug_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_list_provider.dart';
import '../providers/order_completion_list_provider.dart';
import '../providers/printer_list_provider.dart';
import '../providers/user_provider.dart';
import 'package:print_manager/core/services/logger_service.dart';

class PrinterManagerHome extends ConsumerStatefulWidget {
  const PrinterManagerHome({super.key});

  @override
  ConsumerState<PrinterManagerHome> createState() => _PrinterManagerHomeState();
}

class _PrinterManagerHomeState extends ConsumerState<PrinterManagerHome> {
  int _selectedIndex = 0;
  bool _isInitializing = true;
  final List<Widget> _pages = [
    PrinterStatusPage(),
    OrderManagePage(),
    OrderCompletePage(),
    //ImageProcessorPage(),
    TcpChatPage(),
    IsarDebugPage(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// 프린터 및 발주 데이터 초기화
  Future<void> _initializeData() async {
    try {
      // 두 페이지의 초기화를 병렬로 실행
      await Future.wait([
        _waitForPrinterStatusInitialization(),
        _waitForOrderManageInitialization(),
      ]);
    } catch (e) {
      logger.e('초기화 중 오류 발생: $e');
    } finally {
      // 초기화 완료 후 약간의 딜레이를 주어 자연스럽게 전환
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  /// 프린터 상태 페이지 초기화 대기
  Future<void> _waitForPrinterStatusInitialization() async {
    // PrinterStatusPage의 initState에서 _initializePrinters()가 호출됨
    // 발주 목록이 로드될 때까지 대기
    int retryCount = 0;
    while (retryCount < 20) {
      final orders = ref.read(orderListProvider);
      if (orders.isNotEmpty) {
        break;
      }
      await Future.delayed(const Duration(milliseconds: 100));
      retryCount++;
    }
    // 프린터 초기화가 완료될 때까지 추가 대기
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// 주문 관리 페이지 초기화 대기
  Future<void> _waitForOrderManageInitialization() async {
    // OrderManagePage의 initState에서 _refreshOrderList()가 호출됨
    // 발주 목록이 로드될 때까지 대기
    int retryCount = 0;
    while (retryCount < 20) {
      final orders = ref.read(orderListProvider);
      if (orders.isNotEmpty) {
        break;
      }
      await Future.delayed(const Duration(milliseconds: 100));
      retryCount++;
    }
  }

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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final businessNumber = ref.read(userProvider)?.id ?? "물음표";
    logger.i("businessNumber: $businessNumber");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        title: Row(
          children: [
            SizedBox(width: 40),
            _buildTabButton('프린터 상태', 0),
            SizedBox(width: 25),
            _buildTabButton('주문 내역', 1),
            SizedBox(width: 25),
            _buildTabButton('인쇄 내역', 2),
            SizedBox(width: 25),
            _buildTabButton('TEST', 3),
            SizedBox(width: 25),
            _buildTabButton('DB 디버그', 4),
            const Spacer(),
            Text('사업자번호: $businessNumber', style: const TextStyle(color: Colors.black, fontSize: 14)),
            const SizedBox(width: 16),
            OutlinedButton(
              onPressed: () {
                context.go('/login');
                ref.read(printerListProvider.notifier).clear();
                ref.read(orderCompletionListProvider.notifier).clear();
                ref.read(orderListProvider.notifier).clear();
                ref.read(userProvider.notifier).clear();
              },
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey), foregroundColor: Colors.grey),
              child: const Text('로그아웃', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFFF6F7F8),
      body: Stack(
        children: [
          IndexedStack(index: _selectedIndex, children: _pages),
          if (_isInitializing) _buildSyncOverlay(),
        ],
      ),
    );
  }

  /// 동기화 중 오버레이 빌드
  Widget _buildSyncOverlay() {
    return AnimatedOpacity(
      opacity: _isInitializing ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        color: Colors.white.withOpacity(0.9),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A66EB)),
              ),
              const SizedBox(height: 24),
              Text(
                '동기화 중...',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1A66EB),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '프린터 및 발주 상태를 불러오는 중입니다',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
