/// 프린터 연결 상태 (네트워크 연결 상태)
enum PrinterConnectionStatus {
  /// 미연결 (초기 상태)
  disconnected('미연결'),

  /// 연결됨
  connected('연결됨'),

  /// 연결 실패
  connectionFailed('연결 실패'),

  /// 연결 종료
  connectionClosed('연결 종료'),

  /// 에러 발생
  error('에러');

  final String displayText;

  const PrinterConnectionStatus(this.displayText);

  /// 문자열로부터 enum 찾기
  static PrinterConnectionStatus? fromString(String? text) {
    if (text == null) return null;
    for (final status in PrinterConnectionStatus.values) {
      if (status.displayText == text || text.startsWith(status.displayText)) {
        return status;
      }
    }
    // 에러 메시지인 경우
    if (text.startsWith('에러')) {
      return PrinterConnectionStatus.error;
    }
    return null;
  }
}
