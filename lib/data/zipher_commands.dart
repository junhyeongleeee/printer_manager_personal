
class ZipherCommand {
  //상태 확인
  static String gst() => 'GST'; // STS의 2번째 인자가 2일 시 Error

  //인쇄 관련
  static String sst(String mode) => 'SST|$mode|'; // 0: Pause, 1: Ready
  static String sel(String jobName) => 'SEL|$jobName|';
  static String gjd(String field) => 'GJD|$field|'; // e.g., "Serial"
  static String jda(String field, String value) => 'JDA|$field=$value|';
  static String prn() => 'PRN';

  //오류 관련
  //Fault
  static String gft() => 'GFT'; // Get Fault - FLT의 2번째 인자로 오류 코드 확인, 4번째 인자로 오류 메시지 확인
  static String caf() => 'CAF'; // Clear Fault - 모든 결함 삭제
  //Warning
  static String gwn() => 'GWN'; // Get Warning - 경고 코드 확인
  static String caw() => 'CAW'; // Clear Warning - 모든 경고 삭제
}
