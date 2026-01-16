/// 프린터 상태 (가동 상태)
enum PrinterPrintStatus {
  ///
  shut_down(0),

  ///
  starting_up(1),

  ///
  shutting_down(2),

  /// 가동중중
  running(3),

  /// 인쇄 중
  offline(4);

  final int code;

  const PrinterPrintStatus(this.code);

  /// 문자열로부터 enum 찾기
  static PrinterPrintStatus? fromCode(int? code) {
    if (code == null) return null;
    for (final status in PrinterPrintStatus.values) {
      if (code == status.code) {
        return status;
      }
    }
    return null;
  }
}
