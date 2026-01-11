import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_manager/core/infra/zipher_socket.dart';
import 'package:print_manager/core/domain/usecases/print_job_usecase.dart';


class TcpChatPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<TcpChatPage> createState() => _TcpChatPageState();
}

class _TcpChatPageState extends ConsumerState<TcpChatPage> {
  final _logBuffer = <String>[];

  final _ipController = TextEditingController(text: '169.254.2.1');
  final _portController = TextEditingController(text: '5000');
  final _jobNameController = TextEditingController(text: 'test');
  final _startController = TextEditingController(text: '1');
  final _endController = TextEditingController(text: '10');
  final _manualController = TextEditingController();
  final _logScrollController = ScrollController();

  late ZipherSocket _socket;
  late PrintJobUseCase _useCase;

  bool _connected = false;
  bool isTestStart = false;

  @override
  void initState() {
    super.initState();
    _socket = ref.read(zipherSocketProvider);
    _useCase = ref.read(printJobUseCaseProvider);

    _socket.onData = _log;
    _socket.onDone = () => _updateConnection(false, 'Server closed connection');
    _socket.onError = (e) => _updateConnection(false, 'Error: $e');
  }

  void _updateConnection(bool state, String message) {
    setState(() => _connected = state);
    _log(message);
  }

  void _log(String msg) {
    setState(() => _logBuffer.add(msg));

    if (msg.contains('QFULL')) {
      isTestStart = false;
    }

    Future.delayed(Duration(milliseconds: 100)).then((_) {
      if (_logScrollController.hasClients) {
        _logScrollController.jumpTo(_logScrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _connect() async {
    final ip = _ipController.text.trim();
    final port = int.tryParse(_portController.text.trim()) ?? 5000;

    try {
      await _socket.connect(ip, port);
      _updateConnection(true, 'Connected to $ip:$port');
    } catch (e) {
      _log('Connection failed: $e');
    }
  }

  void _sendManual() {
    final message = _manualController.text.trim();
    if (_connected && message.isNotEmpty) {
      _socket.send(message);
      _log('Sent: $message');
      _manualController.clear();
    }
  }

  void _runPrintJob() {
    final job = _jobNameController.text.trim();
    final start = int.tryParse(_startController.text.trim()) ?? 0;
    final end = int.tryParse(_endController.text.trim()) ?? 1;

    _useCase.printJobRepeatedly(jobName: job, start: start, end: end);
  }

  Future<void> printQTest() async {
    int count = 0;
    isTestStart = true;
    while (isTestStart) {
      _socket.send('PRN');
      count++;
      await Future.delayed(Duration(milliseconds: 100));
    }
    _log('큐 최대 수용량 = $count');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zipher Printer Manager'),
        backgroundColor: _connected ? Colors.green : Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: TextField(controller: _ipController, decoration: InputDecoration(labelText: 'IP Address'))),
                SizedBox(width: 8),
                Container(
                  width: 100,
                  child: TextField(controller: _portController, decoration: InputDecoration(labelText: 'Port'), keyboardType: TextInputType.number),
                ),
                ElevatedButton(onPressed: _connect, child: Text('Connect')),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: _jobNameController, decoration: InputDecoration(labelText: 'Job Name'))),
                SizedBox(width: 8),
                Container(
                  width: 100,
                  child: TextField(controller: _startController, decoration: InputDecoration(labelText: 'Start'), keyboardType: TextInputType.number),
                ),
                SizedBox(width: 8),
                Container(
                  width: 100,
                  child: TextField(controller: _endController, decoration: InputDecoration(labelText: 'End'), keyboardType: TextInputType.number),
                ),
                ElevatedButton(onPressed: _runPrintJob, child: Text('Print')),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: _manualController, decoration: InputDecoration(labelText: 'Manual Command'))),
                IconButton(icon: Icon(Icons.send), onPressed: _sendManual),
              ],
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                controller: _logScrollController,
                itemCount: _logBuffer.length,
                itemBuilder: (context, index) => Text(_logBuffer[index]),
              ),
            ),
            ElevatedButton.icon(
              onPressed: printQTest,
              icon: Icon(Icons.science_outlined),
              label: Text("counter Test"),
            ),
          ],
        ),
      ),
    );
  }
}

// === Providers ===
final zipherSocketProvider = Provider<ZipherSocket>((ref) {
  final socket = ZipherSocket();
  ref.onDispose(() => socket.dispose());
  return socket;
});

final printJobUseCaseProvider = Provider<PrintJobUseCase>((ref) {
  final socket = ref.read(zipherSocketProvider);
  return PrintJobUseCase(socket);
});