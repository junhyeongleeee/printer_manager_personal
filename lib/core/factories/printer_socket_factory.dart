import 'package:print_manager/core/enums/printer_protocol.dart';
import 'package:print_manager/core/interfaces/printer_socket.dart';
import 'package:print_manager/infra/zipher_socket.dart';
import 'package:print_manager/infra/ngpcl_socket.dart';

/// 프린터 소켓 팩토리
/// 프로토콜 타입에 따라 적절한 소켓 구현체를 생성합니다.
class PrinterSocketFactory {
  /// 프로토콜 타입에 따라 소켓 인스턴스 생성
  static PrinterSocket create(PrinterProtocol protocol) {
    switch (protocol) {
      case PrinterProtocol.zipher:
        return ZipherSocket();
      case PrinterProtocol.ngpcl:
        return NGPCLSocket();
    }
  }
  
  /// 모델명으로부터 소켓 인스턴스 생성
  static PrinterSocket createFromModel(String? model) {
    final protocol = PrinterProtocolExtension.fromModel(model);
    return create(protocol);
  }
}

