/// Zipher 프로토콜 명령어 Enum
/// Zipher Text Communications Protocol v1.37 기반
enum ZipherCommandEnum {
  // ========== 상태 관련 ==========
  /// Get State Request (GST)
  gst,

  /// Set State Command (SST)
  sst,

  // ========== Job 관련 ==========
  /// Job Select (SEL)
  sel,

  /// Job Select with Line Assignment (SLA)
  sla,

  /// Job Select with Line Index (SLI)
  sli,

  /// Interactive Job Selection (IJS)
  ijs,

  // ========== Job Data 관련 ==========
  /// Get Job Data (GJD)
  gjd,

  /// Job Data Update (JDU)
  jdu,

  /// Job Data Assignment (JDA)
  jda,

  /// Job Data Insert (JDI)
  jdi,

  /// Job Data Update with Save (JDUS)
  jdus,

  /// Job Data Assignment with Save (JDAS)
  jdas,

  /// Job Data Insert with Save (JDIS)
  jdis,

  // ========== Line 관련 ==========
  /// Line Assignment (LAS)
  las,

  /// Clear Line (CLN)
  cln,

  /// Stop Line (SLN)
  sln,

  /// Line Data Update (LDU)
  ldu,

  /// Line Select (LSL)
  lsl,

  // ========== 인쇄 관련 ==========
  /// Print Command (PRN)
  prn,

  /// Test Print (TPR)
  tpr,

  /// Part Pallet (PPT)
  ppt,

  /// Pallet Print (PPR)
  ppr,

  /// Pallet Abort (PAB)
  pab,

  // ========== 카운트 관련 ==========
  /// Get Counts Command (GPC)
  gpc,

  /// Set Counts Command (SPC)
  spc,

  /// Return Counts Command (PCS)
  pcs,

  // ========== 오류 관련 ==========
  /// Get All Faults (GFT)
  gft,

  /// Clear All Faults (CAF)
  caf,

  /// Get All Warnings (GWN)
  gwn,

  /// Clear All Warnings (CAW)
  caw,

  /// Clear Single Error (CEM)
  cem,

  // ========== 큐 관련 ==========
  /// Queue Size (QSZ)
  qsz,

  /// Queue Length (QLN)
  qln,

  /// Clear Queue Item (CQI)
  cqi,

  // ========== Job 정보 관련 ==========
  /// Get Job Name (GJN)
  gjn,

  /// Get Job List (GJL)
  gjl,

  /// Get Job Fields (GJF)
  gjf,

  // ========== 시간 관련 ==========
  /// Get Time and Date (GTD)
  gtd,

  /// Set Date and Time (TAD)
  tad,

  // ========== 기타 ==========
  /// Force Micro Purge (FMP)
  fmp,

  /// Version (VER)
  ver,

  /// Delete (DEL)
  del,

  /// Get Line Select (GLS)
  gls,

  // ========== Serialisation 관련 ==========
  /// Serialisation Header and Data (SHD)
  shd,

  /// Serialisation Header Only (SHO)
  sho,

  /// Serialisation Data Only (SDO)
  sdo,

  /// Serialisation Change Field Data (SCF)
  scf,

  /// Serialisation Record Count (SRC)
  src,

  /// Serialisation Clear Buffer (SCB)
  scb,

  /// Serialisation Indexed Data (SID)
  sid,

  /// Serialisation Free Space (SFS)
  sfs,

  /// Serialisation Next Record Index (SNI)
  sni,

  /// Serialisation Last Record Index (SLR)
  slr,

  /// Serialisation Set Maximum Records (SMR)
  smr,

  /// Serialisation Get Maximum Records (SGM)
  sgm,

  // ========== 설정 관련 ==========
  /// Set Print Density (SPD)
  spd,

  /// Get Print Density (GPD)
  gpd,

  // ========== 검증 관련 ==========
  /// Enable Textfield Validation (ETV)
  etv,

  /// Disable Textfield Validation (DTV)
  dtv,

  // ========== 기타 명령어 ==========
  /// Device Specific Commands (CMD)
  cmd,

  /// Get Cartridge Status (GCS)
  gcs,
}

/// ZipherCommandEnum Extension
/// 명령어 문자열 생성 메서드 제공
extension ZipherCommandEnumExtension on ZipherCommandEnum {
  /// 명령어 코드 반환
  String get code {
    switch (this) {
      case ZipherCommandEnum.gst:
        return 'GST';
      case ZipherCommandEnum.sst:
        return 'SST';
      case ZipherCommandEnum.sel:
        return 'SEL';
      case ZipherCommandEnum.sla:
        return 'SLA';
      case ZipherCommandEnum.sli:
        return 'SLI';
      case ZipherCommandEnum.ijs:
        return 'IJS';
      case ZipherCommandEnum.gjd:
        return 'GJD';
      case ZipherCommandEnum.jdu:
        return 'JDU';
      case ZipherCommandEnum.jda:
        return 'JDA';
      case ZipherCommandEnum.jdi:
        return 'JDI';
      case ZipherCommandEnum.jdus:
        return 'JDUS';
      case ZipherCommandEnum.jdas:
        return 'JDAS';
      case ZipherCommandEnum.jdis:
        return 'JDIS';
      case ZipherCommandEnum.las:
        return 'LAS';
      case ZipherCommandEnum.cln:
        return 'CLN';
      case ZipherCommandEnum.sln:
        return 'SLN';
      case ZipherCommandEnum.ldu:
        return 'LDU';
      case ZipherCommandEnum.lsl:
        return 'LSL';
      case ZipherCommandEnum.prn:
        return 'PRN';
      case ZipherCommandEnum.tpr:
        return 'TPR';
      case ZipherCommandEnum.ppt:
        return 'PPT';
      case ZipherCommandEnum.ppr:
        return 'PPR';
      case ZipherCommandEnum.pab:
        return 'PAB';
      case ZipherCommandEnum.gpc:
        return 'GPC';
      case ZipherCommandEnum.spc:
        return 'SPC';
      case ZipherCommandEnum.pcs:
        return 'PCS';
      case ZipherCommandEnum.gft:
        return 'GFT';
      case ZipherCommandEnum.caf:
        return 'CAF';
      case ZipherCommandEnum.gwn:
        return 'GWN';
      case ZipherCommandEnum.caw:
        return 'CAW';
      case ZipherCommandEnum.cem:
        return 'CEM';
      case ZipherCommandEnum.qsz:
        return 'QSZ';
      case ZipherCommandEnum.qln:
        return 'QLN';
      case ZipherCommandEnum.cqi:
        return 'CQI';
      case ZipherCommandEnum.gjn:
        return 'GJN';
      case ZipherCommandEnum.gjl:
        return 'GJL';
      case ZipherCommandEnum.gjf:
        return 'GJF';
      case ZipherCommandEnum.gtd:
        return 'GTD';
      case ZipherCommandEnum.tad:
        return 'TAD';
      case ZipherCommandEnum.fmp:
        return 'FMP';
      case ZipherCommandEnum.ver:
        return 'VER';
      case ZipherCommandEnum.del:
        return 'DEL';
      case ZipherCommandEnum.gls:
        return 'GLS';
      case ZipherCommandEnum.shd:
        return 'SHD';
      case ZipherCommandEnum.sho:
        return 'SHO';
      case ZipherCommandEnum.sdo:
        return 'SDO';
      case ZipherCommandEnum.scf:
        return 'SCF';
      case ZipherCommandEnum.src:
        return 'SRC';
      case ZipherCommandEnum.scb:
        return 'SCB';
      case ZipherCommandEnum.sid:
        return 'SID';
      case ZipherCommandEnum.sfs:
        return 'SFS';
      case ZipherCommandEnum.sni:
        return 'SNI';
      case ZipherCommandEnum.slr:
        return 'SLR';
      case ZipherCommandEnum.smr:
        return 'SMR';
      case ZipherCommandEnum.sgm:
        return 'SGM';
      case ZipherCommandEnum.spd:
        return 'SPD';
      case ZipherCommandEnum.gpd:
        return 'GPD';
      case ZipherCommandEnum.etv:
        return 'ETV';
      case ZipherCommandEnum.dtv:
        return 'DTV';
      case ZipherCommandEnum.cmd:
        return 'CMD';
      case ZipherCommandEnum.gcs:
        return 'GCS';
    }
  }

  /// 파라미터 없이 명령어 생성
  String build() => code;

  /// 단일 파라미터로 명령어 생성
  String buildWithParam(String param) => '$code|$param|';

  /// 여러 파라미터로 명령어 생성
  String buildWithParams(List<String> params) => '$code|${params.join('=')}|';

  /// 필드 맵으로 명령어 생성 (JDU, SLA 등)
  String buildWithFields(Map<String, String> fields) {
    final params = <String>[];
    fields.forEach((name, value) {
      params.add('$name=$value');
    });
    return '$code|${params.join('|')}|';
  }
}
