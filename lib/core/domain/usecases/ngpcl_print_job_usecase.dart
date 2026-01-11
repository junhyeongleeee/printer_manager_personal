import 'package:print_manager/core/infra/ngpcl_socket.dart';
import 'package:print_manager/core/data/ngpcl_commands.dart';

/// NGPCL 프로토콜을 사용한 인쇄 작업 UseCase
/// Image While Printing 패턴 구현
class NGPCLPrintJobUseCase {
  final NGPCLSocket socket;

  NGPCLPrintJobUseCase(this.socket);

  /// Image While Printing 패턴으로 인쇄 작업 실행
  /// NGPCL Users Guide v25.pdf의 10.2절 참조
  Future<void> printJobWithImageWhilePrinting({
    required String jobName,
    required Map<String, String> fields,
    required int count,
  }) async {
    if (!socket.isConnected) {
      throw Exception('Not connected to printer');
    }

    // 1. Job 선택
    await socket.selectJob(jobName);

    // 2. 첫 번째 인쇄를 위한 필드 업데이트 (이미징 완료 후 응답)
    await socket.updateFields(
      fields: fields,
      replyTiming: NGPCLCommand.replyWhenJobImaged,
    );

    // 3. 첫 번째 인쇄 실행 (인쇄 시작 후 응답)
    await socket.requestPrint(
      replyTiming: NGPCLCommand.replyWhenPrintStarted,
      count: 1,
    );

    // 4. 나머지 인쇄 작업 (Image While Printing 패턴)
    for (int i = 1; i < count; i++) {
      // 이전 인쇄가 완료될 때까지 대기 (프린트 준비 완료 후 응답)
      await socket.requestPrintStatus(
        replyTiming: NGPCLCommand.replyWhenReadyToPrint,
      );

      // 다음 필드 데이터 업데이트 (이미징 완료 후 응답)
      await socket.updateFields(
        fields: fields,
        replyTiming: NGPCLCommand.replyWhenJobImaged,
      );

      // 다음 인쇄 실행 (인쇄 시작 후 응답)
      await socket.requestPrint(
        replyTiming: NGPCLCommand.replyWhenPrintStarted,
        count: 1,
      );
    }

    // 5. 마지막 인쇄 완료 대기
    await socket.requestPrintStatus(
      replyTiming: NGPCLCommand.replyWhenReadyToPrint,
    );
  }

  /// 자동 감지 모드용 인쇄 작업
  /// 프린터가 자동으로 인쇄를 감지하고 실행하는 경우
  Future<void> printJobAutoDetection({
    required String jobName,
    required Map<String, String> fields,
  }) async {
    if (!socket.isConnected) {
      throw Exception('Not connected to printer');
    }

    // 1. Job 선택
    await socket.selectJob(jobName);

    // 2. 필드 업데이트 (이미징 완료 후 응답)
    await socket.updateFields(
      fields: fields,
      replyTiming: NGPCLCommand.replyWhenJobImaged,
    );

    // 3. 프린터 상태를 PRODUCING으로 변경 (자동 감지 모드 활성화)
    await socket.changeState('PRODUCING');

    // 이후 프린터가 자동으로 인쇄를 감지하고 실행
    // unsolicitedData를 통해 인쇄 완료 이벤트 수신
  }

  /// 필드 값 업데이트 (다음 인쇄 준비)
  Future<void> prepareNextPrint({
    required Map<String, String> fields,
  }) async {
    if (!socket.isConnected) {
      throw Exception('Not connected to printer');
    }

    // 필드 업데이트 (이미징 완료 후 응답)
    await socket.updateFields(
      fields: fields,
      replyTiming: NGPCLCommand.replyWhenJobImaged,
    );
  }

  /// 인쇄 상태 확인
  Future<String> checkPrintStatus() async {
    if (!socket.isConnected) {
      throw Exception('Not connected to printer');
    }

    return await socket.requestPrintStatus(
      replyTiming: NGPCLCommand.replyImmediately,
    );
  }

  /// 카운트 값 조회
  Future<String> getCounts() async {
    if (!socket.isConnected) {
      throw Exception('Not connected to printer');
    }

    return await socket.getCounts();
  }

  /// 디바이스 상태 조회
  Future<String> getDeviceStatus() async {
    if (!socket.isConnected) {
      throw Exception('Not connected to printer');
    }

    return await socket.getDeviceStatus();
  }
}

