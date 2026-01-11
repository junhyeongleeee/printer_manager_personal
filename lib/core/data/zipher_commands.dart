import 'enums/zipher_command_enum.dart';

/// Zipher Text Communications Protocol v1.37 기반 명령어 클래스
/// Zipher Text Communications Protocol v1.37 1.pdf 참조
///
/// 하위 호환성을 위해 유지되며, 내부적으로 ZipherCommandEnum을 사용합니다.
class ZipherCommand {
  // ========== 상태 관련 ==========

  /// Get State Request (GST)
  /// 상태 조회
  /// 응답: STS|상태코드|...|
  /// 상태 코드: 0=Shutdown, 1=Ready, 2=Error, 3=Running, 4=Offline
  static String gst() => ZipherCommandEnum.gst.build();

  /// Set State Command (SST)
  /// 상태 설정
  /// mode: 0=Pause, 1=Ready, 3=Running, 4=Offline
  static String sst(String mode) => ZipherCommandEnum.sst.buildWithParam(mode);

  // ========== Job 관련 ==========

  /// Job Select (SEL)
  /// Job 선택
  static String sel(String jobName) => ZipherCommandEnum.sel.buildWithParam(jobName);

  /// Job Select with Line Assignment (SLA)
  /// Job 선택 및 라인 할당
  /// jobName: Job 이름
  /// fields: {fieldName: fieldValue} 맵
  static String sla(String jobName, Map<String, String> fields) {
    final params = [jobName];
    fields.forEach((name, value) {
      params.add('$name=$value');
    });
    return ZipherCommandEnum.sla.buildWithParams(params);
  }

  /// Job Select with Line Index (SLI)
  /// 라인 인덱스로 Job 선택
  static String sli(int lineIndex) => ZipherCommandEnum.sli.buildWithParam(lineIndex.toString());

  /// Interactive Job Selection (IJS)
  /// 대화형 Job 선택
  static String ijs() => ZipherCommandEnum.ijs.build();

  // ========== Job Data 관련 ==========

  /// Get Job Data (GJD)
  /// 현재 Job의 필드 데이터 조회
  /// field: 필드 이름 (예: "Serial")
  static String gjd(String field) => ZipherCommandEnum.gjd.buildWithParam(field);

  /// Job Data Update (JDU)
  /// Job 데이터 업데이트 (여러 필드)
  /// fields: {fieldName: fieldValue} 맵
  static String jdu(Map<String, String> fields) => ZipherCommandEnum.jdu.buildWithFields(fields);

  /// Job Data Assignment (JDA)
  /// 필드 데이터 할당
  /// field: 필드 이름
  /// value: 필드 값
  static String jda(String field, String value) => ZipherCommandEnum.jda.buildWithParams([field, value]);

  /// Job Data Insert (JDI)
  /// 필드 데이터 삽입
  static String jdi(String field, String value) => 'JDI|$field=$value|';

  /// Job Data Update with Save (JDUS)
  /// 저장과 함께 Job 데이터 업데이트
  static String jdus(Map<String, String> fields) {
    final params = <String>[];
    fields.forEach((name, value) {
      params.add('$name=$value');
    });
    return 'JDUS|${params.join('|')}|';
  }

  /// Job Data Assignment with Save (JDAS)
  /// 저장과 함께 필드 데이터 할당
  static String jdas(String field, String value) => 'JDAS|$field=$value|';

  /// Job Data Insert with Save (JDIS)
  /// 저장과 함께 필드 데이터 삽입
  static String jdis(String field, String value) => 'JDIS|$field=$value|';

  // ========== Line 관련 ==========

  /// Line Assignment (LAS)
  /// 라인 할당
  static String las(int lineNumber) => 'LAS|$lineNumber|';

  /// Clear Line (CLN)
  /// 라인 클리어
  static String cln() => 'CLN';

  /// Stop Line (SLN)
  /// 라인 정지
  static String sln() => 'SLN';

  /// Line Data Update (LDU)
  /// 라인 데이터 업데이트
  static String ldu(int lineNumber, String data) => 'LDU|$lineNumber|$data|';

  /// Line Select (LSL)
  /// 라인 선택
  static String lsl(int lineNumber) => 'LSL|$lineNumber|';

  // ========== 인쇄 관련 ==========

  /// Print Command (PRN)
  /// 인쇄 실행
  /// 응답: PRS (Print Start), PRC (Print Complete), ACK
  static String prn() => ZipherCommandEnum.prn.build();

  /// Test Print (TPR)
  /// 테스트 인쇄
  static String tpr() => 'TPR';

  /// Part Pallet (PPT)
  /// 팔레트 라벨러용 부분 팔레트
  static String ppt() => 'PPT';

  /// Pallet Print (PPR)
  /// 팔레트 라벨러용 팔레트 인쇄
  static String ppr() => 'PPR';

  /// Pallet Abort (PAB)
  /// 팔레트 라벨러용 팔레트 중단
  static String pab() => 'PAB';

  // ========== 카운트 관련 ==========

  /// Get Counts Command (GPC)
  /// 카운트 값 조회
  /// 응답 형식: GPC|total|batch|...
  static String gpc() => ZipherCommandEnum.gpc.build();

  /// Set Counts Command (SPC)
  /// 카운트 값 설정
  /// total: 총 카운트
  /// batch: 배치 카운트
  static String spc({int? total, int? batch}) {
    if (total != null && batch != null) {
      return 'SPC|$total|$batch|';
    } else if (total != null) {
      return 'SPC|$total||';
    } else if (batch != null) {
      return 'SPC||$batch|';
    }
    return 'SPC|||';
  }

  // ========== 오류 관련 ==========

  /// Get All Faults (GFT)
  /// 모든 결함 조회
  /// 응답: FLT|오류코드|...|오류메시지|
  static String gft() => 'GFT';

  /// Clear All Faults (CAF)
  /// 모든 결함 삭제
  static String caf() => 'CAF';

  /// Get All Warnings (GWN)
  /// 모든 경고 조회
  /// 응답: WRN|경고코드|...|
  static String gwn() => 'GWN';

  /// Clear All Warnings (CAW)
  /// 모든 경고 삭제
  static String caw() => 'CAW';

  /// Clear Single Error (CEM)
  /// 단일 오류 삭제
  static String cem(int errorCode) => 'CEM|$errorCode|';

  // ========== 큐 관련 ==========

  /// Queue Size (QSZ)
  /// 큐 크기 조회
  static String qsz() => 'QSZ';

  /// Queue Length (QLN)
  /// 큐 길이 조회 (이미지 업데이트 큐 포함)
  static String qln() => 'QLN';

  /// Clear Queue Item (CQI)
  /// 큐 아이템 클리어
  static String cqi(int itemIndex) => 'CQI|$itemIndex|';

  // ========== Job 정보 관련 ==========

  /// Get Job Name (GJN)
  /// 현재 선택된 Job 이름 조회
  static String gjn() => 'GJN';

  /// Get Job List (GJL)
  /// Job 목록 조회
  static String gjl() => 'GJL';

  /// Get Job Fields (GJF)
  /// Job 필드 목록 조회
  static String gjf() => 'GJF';

  // ========== 시간 관련 ==========

  /// Get Time and Date (GTD)
  /// 시간 및 날짜 조회
  static String gtd() => 'GTD';

  /// Set Date and Time (TAD)
  /// 날짜 및 시간 설정
  /// dateTime: 날짜/시간 문자열
  static String tad(String dateTime) => 'TAD|$dateTime|';

  // ========== 기타 ==========

  /// Force Micro Purge (FMP)
  /// 강제 마이크로 퍼지
  static String fmp() => 'FMP';

  /// Version (VER)
  /// 프로토콜 버전 조회
  static String ver() => 'VER';

  /// Delete (DEL)
  /// 삭제 명령
  static String del(String item) => 'DEL|$item|';

  /// Get Line Select (GLS)
  /// 라인 선택 조회
  static String gls() => 'GLS';

  // ========== Serialisation 관련 ==========

  /// Serialisation Header and Data (SHD)
  /// 시리얼라이제이션 헤더 및 데이터
  static String shd(String header, String data) => 'SHD|$header|$data|';

  /// Serialisation Header Only (SHO)
  /// 시리얼라이제이션 헤더만
  static String sho(String header) => 'SHO|$header|';

  /// Serialisation Data Only (SDO)
  /// 시리얼라이제이션 데이터만
  static String sdo(String data) => 'SDO|$data|';

  /// Serialisation Change Field Data (SCF)
  /// 시리얼라이제이션 필드 데이터 변경
  static String scf(String field, String value) => 'SCF|$field=$value|';

  /// Serialisation Record Count (SRC)
  /// 시리얼라이제이션 레코드 카운트
  static String src() => 'SRC';

  /// Serialisation Clear Buffer (SCB)
  /// 시리얼라이제이션 버퍼 클리어
  static String scb() => 'SCB';

  /// Serialisation Indexed Data (SID)
  /// 시리얼라이제이션 인덱스 데이터
  static String sid(int index, String data) => 'SID|$index|$data|';

  /// Serialisation Free Space (SFS)
  /// 시리얼라이제이션 여유 공간
  static String sfs() => 'SFS';

  /// Serialisation Next Record Index (SNI)
  /// 시리얼라이제이션 다음 레코드 인덱스
  static String sni() => 'SNI';

  /// Serialisation Last Record Index (SLR)
  /// 시리얼라이제이션 마지막 레코드 인덱스
  static String slr() => 'SLR';

  /// Serialisation Set Maximum Records (SMR)
  /// 시리얼라이제이션 최대 레코드 수 설정
  static String smr(int maxRecords) => 'SMR|$maxRecords|';

  /// Serialisation Get Maximum Records (SGM)
  /// 시리얼라이제이션 최대 레코드 수 조회
  static String sgm() => 'SGM';

  /// Serialisation Free Space (SFS)
  /// 시리얼라이제이션 여유 공간 조회
  static String sfsQuery() => 'SFS';

  // ========== 설정 관련 ==========

  /// Set Print Density (SPD)
  /// 인쇄 밀도 설정 (2300 시리즈)
  static String spd(int density) => 'SPD|$density|';

  /// Get Print Density (GPD)
  /// 인쇄 밀도 조회 (2300 시리즈)
  static String gpd() => 'GPD';

  // ========== 검증 관련 ==========

  /// Enable Textfield Validation (ETV)
  /// 텍스트 필드 검증 활성화
  static String etv() => 'ETV';

  /// Disable Textfield Validation (DTV)
  /// 텍스트 필드 검증 비활성화
  static String dtv() => 'DTV';

  // ========== 기타 명령어 ==========

  /// Device Specific Commands (CMD)
  /// 디바이스 특화 명령어
  static String cmd(String command) => 'CMD|$command|';

  /// Get Cartridge Status (GCS)
  /// 카트리지 상태 조회 (8520 프린터)
  static String gcs() => 'GCS';

  /// Event Time Value (ETV)
  /// 이벤트 시간 값
  static String etvEvent(String value) => 'ETV|$value|';

  /// Device Time Value (DTV)
  /// 디바이스 시간 값
  static String dtvDevice(String value) => 'DTV|$value|';
}
