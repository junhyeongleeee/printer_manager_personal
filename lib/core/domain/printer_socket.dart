abstract class PrinterSocket {
  Future<void> connect(String host, int port);
  bool get isConnected;

  Future<String> send(String message);
  void sendUtf16LE(String message);
  void dispose();

  Future<String> setPrinterRunning();
  Future<String> setPrinterOffline();
  Future<String> setPrintState(int state);
  Future<String> selectJob(String jobName);
  Future<String> requestJobData(String field);
  Future<String> updateField(String field, String value);
  Future<String> printOnce();
  Future<String> getPrinterStatus();

  void setOnData(Function(String message));
  void setOnDone(Function());
  void setOnError(Function(Object error));
}
