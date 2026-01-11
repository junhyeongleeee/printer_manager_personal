import 'enums/ngpcl_command_enum.dart';

/// NGPCL 프로토콜 명령어 생성 헬퍼
/// NGPCL Users Guide v25.pdf 기반
/// 
/// 하위 호환성을 위해 유지되며, 내부적으로 NGPCLCommandEnum을 사용합니다.
class NGPCLCommand {
  // 메시지 구분자
  static const String stx = '\x02'; // STX (ASCII: 2) = ^A
  static const String etx = '\x03'; // ETX (ASCII: 3) = ^B
  static const String messageStart = '~'; // 메시지 시작 문자
  static const String fieldDelimiter = '|'; // 필드 구분자

  // Reply Timing 옵션
  static const int replyImmediately = 0;
  static const int replyWhenJobImaged = 1; // Job Update용
  static const int replyWhenReadyToPrint = 1; // Print Status용
  static const int replyWhenPrintStarted = 1; // Print Request용
  static const int replyWhenPrintComplete = 2; // Print Request용

  /// 메시지 포맷팅 (STX ~ [명령어] | [파라미터] | ETX)
  static String _formatMessage(String command, List<String> parameters) {
    final params = parameters.join(fieldDelimiter);
    return '$stx$messageStart$command$fieldDelimiter$params$fieldDelimiter$etx';
  }

  /// 레거시 호환 포맷 (^A ~ [명령어] | [파라미터] | ^Z)
  static String _formatLegacyMessage(String command, List<String> parameters) {
    const String legacyStx = '\x01'; // ^A
    const String legacyEtx = '\x1A'; // ^Z
    const String legacyStart = '^'; // 레거시 메시지 시작
    final params = parameters.join(fieldDelimiter);
    return '$legacyStx$legacyStart$command$fieldDelimiter$params$fieldDelimiter$legacyEtx';
  }

  // ========== 기본 명령어 ==========

  /// NAK (Negative Acknowledgment)
  /// 에러 응답
  static String nak() => NGPCLCommandEnum.nak.build();

  /// Job Select (~JS)
  /// Job 선택
  static String jobSelect(String jobName) => NGPCLCommandEnum.jobSelect.buildWithParam(jobName);

  /// Job Update (~JU)
  /// 필드 데이터 업데이트
  /// replyTiming: 0=즉시 응답, 1=이미징 완료 후 응답
  /// fields: {fieldName: fieldValue} 맵
  static String jobUpdate({int replyTiming = 0, required Map<String, String> fields}) {
    final params = [replyTiming.toString()];
    fields.forEach((name, value) {
      params.add(name);
      params.add(value);
    });
    return NGPCLCommandEnum.jobUpdate.buildWithParams(params);
  }

  /// Print Status Request (~PS)
  /// 프린트 상태 요청
  /// replyTiming: 0=즉시 응답, 1=프린트 준비 완료 후 응답
  static String printStatusRequest({int replyTiming = 0}) {
    return NGPCLCommandEnum.printStatusRequest.buildWithParam(replyTiming.toString());
  }

  /// Print Request (~PG)
  /// 인쇄 실행
  /// replyTiming: 0=즉시, 1=인쇄 시작 후, 2=인쇄 완료 후
  /// count: 인쇄 횟수 (기본 1)
  static String printRequest({int replyTiming = 0, int count = 1}) {
    return NGPCLCommandEnum.printRequest.buildWithParams([replyTiming.toString(), count.toString()]);
  }

  /// Device Status Request (~DS)
  /// 디바이스 상태 요청
  static String deviceStatusRequest() => NGPCLCommandEnum.deviceStatusRequest.build();

  /// Counts Request (~CR)
  /// 카운트 값 요청
  static String countsRequest() => NGPCLCommandEnum.countsRequest.build();

  /// State Change (~SC)
  /// 상태 변경
  /// state: PRODUCING, READY, HELD 등
  static String stateChange(String state) => NGPCLCommandEnum.stateChange.buildWithParam(state);

  // ========== 설정 관련 ==========

  /// Setting Change (~ST)
  /// 설정 변경
  static String settingChange(String settingName, String value) {
    return NGPCLCommandEnum.settingChange.buildWithParams([settingName, value]);
  }

  /// Setting Request (~SR)
  /// 설정 요청
  static String settingRequest(String settingName) {
    return NGPCLCommandEnum.settingRequest.buildWithParam(settingName);
  }

  // ========== 필드 관련 ==========

  /// Field Contents Request (~FC)
  /// 필드 내용 요청
  static String fieldContentsRequest(String fieldName) {
    return NGPCLCommandEnum.fieldContentsRequest.buildWithParam(fieldName);
  }

  /// Logged Field Contents Request (~LF)
  /// 로그된 필드 내용 요청
  static String loggedFieldContentsRequest(String fieldName) {
    return _formatMessage('LF', [fieldName]);
  }

  // ========== 가상 I/O ==========

  /// Virtual Output Request (~VO)
  /// 가상 출력 요청
  static String virtualOutputRequest() {
    return _formatMessage('VO', []);
  }

  /// Set Virtual Input (~VI)
  /// 가상 입력 설정
  static String setVirtualInput(int inputNumber, bool value) {
    return _formatMessage('VI', [inputNumber.toString(), value ? '1' : '0']);
  }

  // ========== 클럭 관련 ==========

  /// Request Clock (~RC)
  /// 클럭 요청
  static String requestClock() {
    return _formatMessage('RC', []);
  }

  /// Clock Set (~CS)
  /// 클럭 설정
  static String clockSet(String dateTime) {
    return _formatMessage('CS', [dateTime]);
  }

  // ========== 버전 관련 ==========

  /// Version Request (~VR)
  /// 버전 요청
  static String versionRequest() {
    return _formatMessage('VR', []);
  }

  /// Protocol Version Request (~PV)
  /// 프로토콜 버전 요청
  static String protocolVersionRequest() {
    return _formatMessage('PV', []);
  }

  // ========== 기타 ==========

  /// Allocation Clear (~AC)
  /// 할당 클리어
  static String allocationClear() {
    return _formatMessage('AC', []);
  }

  /// Clear to Send Data Request (~CT)
  /// 데이터 전송 가능 여부 요청
  static String clearToSendDataRequest() {
    return _formatMessage('CT', []);
  }

  // ========== 5600/5800 특화 명령어 ==========

  /// Remote Purge (~UC RP)
  /// 원격 퍼지 (5600/5800 전용)
  /// printhead: "PH1" 또는 "PH2"
  static String remotePurge(String printhead) {
    return NGPCLCommandEnum.remotePurge.buildUserCommand('RP', [printhead]);
  }

  /// Clear Print Queue (~UC CPQ)
  /// 프린트 큐 클리어 (5600/5800 전용)
  static String clearPrintQueue() {
    return NGPCLCommandEnum.clearPrintQueue.buildUserCommand('CPQ');
  }

  // ========== Job Preview (5800 전용) ==========

  /// Job Preview Request (~JP)
  /// Job 미리보기 요청 (5800 전용)
  static String jobPreviewRequest() {
    return _formatMessage('JP', []);
  }

  // ========== User Command ==========

  /// User Command (~UC)
  /// 사용자 정의 명령어
  static String userCommand(String command, [List<String>? parameters]) {
    final params = [command];
    if (parameters != null) {
      params.addAll(parameters);
    }
    return _formatMessage('UC', params);
  }

  // ========== 레거시 호환 ==========

  /// 레거시 Update Variable Fields (호환성)
  /// 필드 번호 기반 업데이트 (NGPCL Job Update로 변환)
  static String legacyUpdateVariableFields({
    required int replyTiming,
    required Map<int, String> fields, // fieldNumber: value
  }) {
    // 레거시 명령어는 필드 번호를 사용하지만 NGPCL은 필드 이름을 사용
    // 실제 구현에서는 필드 번호를 필드 이름으로 매핑해야 함
    final params = [replyTiming.toString()];
    fields.forEach((number, value) {
      params.add(number.toString());
      params.add(value);
    });
    return _formatLegacyMessage('UV', params);
  }
}
