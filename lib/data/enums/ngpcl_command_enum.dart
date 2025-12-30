/// NGPCL 프로토콜 명령어 Enum
/// NGPCL Users Guide v25.pdf 기반
enum NGPCLCommandEnum {
  // ========== 기본 명령어 ==========
  /// NAK (Negative Acknowledgment)
  nak,
  /// Job Select (~JS)
  jobSelect,
  /// Job Update (~JU)
  jobUpdate,
  /// Print Status Request (~PS)
  printStatusRequest,
  /// Print Request (~PG)
  printRequest,
  /// Device Status Request (~DS)
  deviceStatusRequest,
  /// Counts Request (~CR)
  countsRequest,
  /// State Change (~SC)
  stateChange,

  // ========== 설정 관련 ==========
  /// Setting Change (~ST)
  settingChange,
  /// Setting Request (~SR)
  settingRequest,

  // ========== 필드 관련 ==========
  /// Field Contents Request (~FC)
  fieldContentsRequest,
  /// Logged Field Contents Request (~LF)
  loggedFieldContentsRequest,

  // ========== 가상 I/O ==========
  /// Virtual Output Request (~VO)
  virtualOutputRequest,
  /// Set Virtual Input (~VI)
  setVirtualInput,

  // ========== 클럭 관련 ==========
  /// Request Clock (~RC)
  requestClock,
  /// Clock Set (~CS)
  clockSet,

  // ========== 버전 관련 ==========
  /// Version Request (~VR)
  versionRequest,
  /// Protocol Version Request (~PV)
  protocolVersionRequest,

  // ========== 기타 ==========
  /// Allocation Clear (~AC)
  allocationClear,
  /// Clear to Send Data Request (~CT)
  clearToSendDataRequest,

  // ========== 5600/5800 특화 명령어 ==========
  /// Remote Purge (~UC RP)
  remotePurge,
  /// Clear Print Queue (~UC CPQ)
  clearPrintQueue,

  // ========== Job Preview (5800 전용) ==========
  /// Job Preview Request (~JP)
  jobPreviewRequest,

  // ========== User Command ==========
  /// User Command (~UC)
  userCommand,
}

/// NGPCLCommandEnum Extension
/// 명령어 문자열 생성 메서드 제공
extension NGPCLCommandEnumExtension on NGPCLCommandEnum {
  // 메시지 구분자
  static const String stx = '\x02'; // STX (ASCII: 2)
  static const String etx = '\x03'; // ETX (ASCII: 3)
  static const String messageStart = '~'; // 메시지 시작 문자
  static const String fieldDelimiter = '|'; // 필드 구분자

  /// 명령어 코드 반환
  String get code {
    switch (this) {
      case NGPCLCommandEnum.nak:
        return 'NAK';
      case NGPCLCommandEnum.jobSelect:
        return 'JS';
      case NGPCLCommandEnum.jobUpdate:
        return 'JU';
      case NGPCLCommandEnum.printStatusRequest:
        return 'PS';
      case NGPCLCommandEnum.printRequest:
        return 'PG';
      case NGPCLCommandEnum.deviceStatusRequest:
        return 'DS';
      case NGPCLCommandEnum.countsRequest:
        return 'CR';
      case NGPCLCommandEnum.stateChange:
        return 'SC';
      case NGPCLCommandEnum.settingChange:
        return 'ST';
      case NGPCLCommandEnum.settingRequest:
        return 'SR';
      case NGPCLCommandEnum.fieldContentsRequest:
        return 'FC';
      case NGPCLCommandEnum.loggedFieldContentsRequest:
        return 'LF';
      case NGPCLCommandEnum.virtualOutputRequest:
        return 'VO';
      case NGPCLCommandEnum.setVirtualInput:
        return 'VI';
      case NGPCLCommandEnum.requestClock:
        return 'RC';
      case NGPCLCommandEnum.clockSet:
        return 'CS';
      case NGPCLCommandEnum.versionRequest:
        return 'VR';
      case NGPCLCommandEnum.protocolVersionRequest:
        return 'PV';
      case NGPCLCommandEnum.allocationClear:
        return 'AC';
      case NGPCLCommandEnum.clearToSendDataRequest:
        return 'CT';
      case NGPCLCommandEnum.remotePurge:
        return 'UC';
      case NGPCLCommandEnum.clearPrintQueue:
        return 'UC';
      case NGPCLCommandEnum.jobPreviewRequest:
        return 'JP';
      case NGPCLCommandEnum.userCommand:
        return 'UC';
    }
  }

  /// 메시지 포맷팅 (STX ~ [명령어] | [파라미터] | ETX)
  String _formatMessage(List<String> parameters) {
    final params = parameters.join(fieldDelimiter);
    return '$stx$messageStart$code$fieldDelimiter$params$fieldDelimiter$etx';
  }

  /// 파라미터 없이 명령어 생성
  String build() {
    if (this == NGPCLCommandEnum.nak) {
      return '$messageStart$code';
    }
    return _formatMessage([]);
  }

  /// 단일 파라미터로 명령어 생성
  String buildWithParam(String param) => _formatMessage([param]);

  /// 여러 파라미터로 명령어 생성
  String buildWithParams(List<String> params) => _formatMessage(params);

  /// 특수 명령어 생성 (User Command 등)
  String buildUserCommand(String subCommand, [List<String>? parameters]) {
    final params = [subCommand];
    if (parameters != null) {
      params.addAll(parameters);
    }
    return _formatMessage(params);
  }
}
