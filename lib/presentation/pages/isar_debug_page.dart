import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:print_manager/presentation/providers/field_value_state_saver_provider.dart';
import 'package:print_manager/core/data/models/order_field_value_state.dart';
import 'package:print_manager/core/data/models/order_field_value_metadata.dart';
import 'package:print_manager/core/data/models/order_printer_count.dart';
import 'package:print_manager/core/data/models/printer_last_order.dart';
import 'package:print_manager/core/services/logger_service.dart';

/// Isar 데이터베이스 디버그 화면
class IsarDebugPage extends ConsumerStatefulWidget {
  const IsarDebugPage({super.key});

  @override
  ConsumerState<IsarDebugPage> createState() => _IsarDebugPageState();
}

class _IsarDebugPageState extends ConsumerState<IsarDebugPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _dbPath = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadDbPath();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDbPath() async {
    try {
      // Isar 인스턴스에서 경로 가져오기 (간접적으로)
      final dir = await getApplicationDocumentsDirectory();
      setState(() {
        _dbPath = '${dir.path}/print_manager.isar';
      });
    } catch (e) {
      logger.e('DB 경로 로드 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isar 데이터베이스 디버그'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '필드 값 상태'),
            Tab(text: '메타데이터'),
            Tab(text: '프린터 카운트'),
            Tab(text: '마지막 발주'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
            tooltip: '새로고침',
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('DB 경로 복사'),
                onTap: () {
                  if (_dbPath.isNotEmpty) {
                    // 클립보드에 복사 (실제 구현 필요)
                    logger.i('DB 경로: $_dbPath');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('DB 경로: $_dbPath')),
                    );
                  }
                },
              ),
              PopupMenuItem(
                child: const Text('전체 데이터 삭제'),
                onTap: () => _showClearAllDialog(context),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // DB 경로 표시
          if (_dbPath.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.blue[50],
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'DB 경로: $_dbPath',
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          // 탭 뷰
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFieldValueStateTab(),
                _buildMetadataTab(),
                _buildPrinterCountTab(),
                _buildLastOrderTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldValueStateTab() {
    return FutureBuilder<List<OrderFieldValueState>>(
      future: _loadFieldValueStates(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('오류: ${snapshot.error}'));
        }
        final states = snapshot.data ?? [];
        if (states.isEmpty) {
          return const Center(child: Text('데이터가 없습니다.'));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('총 ${states.length}개 레코드'),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('발주ID')),
                      DataColumn(label: Text('필드값')),
                      DataColumn(label: Text('프린터ID')),
                      DataColumn(label: Text('상태')),
                      DataColumn(label: Text('고유코드')),
                      DataColumn(label: Text('할당시간')),
                      DataColumn(label: Text('완료시간')),
                    ],
                    rows: states.map((state) {
                      return DataRow(
                        cells: [
                          DataCell(Text('${state.id}')),
                          DataCell(Text('${state.orderId}')),
                          DataCell(Text('${state.fieldValue}')),
                          DataCell(Text(state.printerId?.toString() ?? '-')),
                          DataCell(
                            Text(
                              state.status,
                              style: TextStyle(
                                color: _getStatusColor(state.status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataCell(Text(state.uniqueCode)),
                          DataCell(Text(_formatDateTime(state.assignedAt))),
                          DataCell(Text(state.completedAt != null ? _formatDateTime(state.completedAt!) : '-')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetadataTab() {
    return FutureBuilder<List<OrderFieldValueMetadata>>(
      future: _loadMetadata(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('오류: ${snapshot.error}'));
        }
        final metadata = snapshot.data ?? [];
        if (metadata.isEmpty) {
          return const Center(child: Text('데이터가 없습니다.'));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('총 ${metadata.length}개 레코드'),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('발주ID')),
                      DataColumn(label: Text('다음값')),
                      DataColumn(label: Text('시작코드')),
                      DataColumn(label: Text('끝코드')),
                      DataColumn(label: Text('고유코드')),
                      DataColumn(label: Text('업데이트')),
                    ],
                    rows: metadata.map((meta) {
                      return DataRow(
                        cells: [
                          DataCell(Text('${meta.id}')),
                          DataCell(Text('${meta.orderId}')),
                          DataCell(Text('${meta.nextAvailableValue}')),
                          DataCell(Text('${meta.startCode}')),
                          DataCell(Text('${meta.endCode}')),
                          DataCell(Text(meta.uniqueCode)),
                          DataCell(Text(_formatDateTime(meta.updatedAt))),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPrinterCountTab() {
    return FutureBuilder<List<OrderPrinterCount>>(
      future: _loadPrinterCounts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('오류: ${snapshot.error}'));
        }
        final counts = snapshot.data ?? [];
        if (counts.isEmpty) {
          return const Center(child: Text('데이터가 없습니다.'));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('총 ${counts.length}개 레코드'),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('발주ID')),
                      DataColumn(label: Text('프린터ID')),
                      DataColumn(label: Text('카운트')),
                      DataColumn(label: Text('업데이트')),
                      DataColumn(label: Text('생성')),
                    ],
                    rows: counts.map((count) {
                      return DataRow(
                        cells: [
                          DataCell(Text('${count.id}')),
                          DataCell(Text('${count.orderId}')),
                          DataCell(Text('${count.printerId}')),
                          DataCell(Text('${count.count}')),
                          DataCell(Text(_formatDateTime(count.updatedAt))),
                          DataCell(Text(_formatDateTime(count.createdAt))),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLastOrderTab() {
    return FutureBuilder<List<PrinterLastOrder>>(
      future: _loadLastOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('오류: ${snapshot.error}'));
        }
        final lastOrders = snapshot.data ?? [];
        if (lastOrders.isEmpty) {
          return const Center(child: Text('데이터가 없습니다.'));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('총 ${lastOrders.length}개 레코드'),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('프린터ID')),
                      DataColumn(label: Text('발주ID')),
                      DataColumn(label: Text('업데이트')),
                      DataColumn(label: Text('생성')),
                    ],
                    rows: lastOrders.map((lastOrder) {
                      return DataRow(
                        cells: [
                          DataCell(Text('${lastOrder.id}')),
                          DataCell(Text('${lastOrder.printerId}')),
                          DataCell(Text('${lastOrder.orderId}')),
                          DataCell(Text(_formatDateTime(lastOrder.updatedAt))),
                          DataCell(Text(_formatDateTime(lastOrder.createdAt))),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<List<OrderFieldValueState>> _loadFieldValueStates() async {
    try {
      final saver = await ref.read(fieldValueStateSaverProvider.future);
      return await saver.getAllStatesDebug();
    } catch (e) {
      logger.e('필드 값 상태 로드 실패: $e');
      return [];
    }
  }

  Future<List<OrderFieldValueMetadata>> _loadMetadata() async {
    try {
      final saver = await ref.read(fieldValueStateSaverProvider.future);
      return await saver.getAllMetadata();
    } catch (e) {
      logger.e('메타데이터 로드 실패: $e');
      return [];
    }
  }

  Future<List<OrderPrinterCount>> _loadPrinterCounts() async {
    try {
      final saver = await ref.read(fieldValueStateSaverProvider.future);
      return await saver.getAllPrinterCounts();
    } catch (e) {
      logger.e('프린터 카운트 로드 실패: $e');
      return [];
    }
  }

  Future<List<PrinterLastOrder>> _loadLastOrders() async {
    try {
      final saver = await ref.read(fieldValueStateSaverProvider.future);
      return await saver.getAllLastOrders();
    } catch (e) {
      logger.e('마지막 발주 로드 실패: $e');
      return [];
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'assigned':
        return Colors.blue;
      case 'inUse':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'error':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('전체 데이터 삭제'),
        content: const Text('모든 Isar 데이터를 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final saver = await ref.read(fieldValueStateSaverProvider.future);
                await saver.clearAllData();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('모든 데이터가 삭제되었습니다.')),
                  );
                  setState(() {});
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('삭제 실패: $e')),
                  );
                }
              }
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
