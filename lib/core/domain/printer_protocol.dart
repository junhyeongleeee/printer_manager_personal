/// 프린터 프로토콜 타입
enum PrinterProtocol {
  /// Zipher 프로토콜 (기존)
  zipher,

  /// NGPCL 프로토콜 (새로운)
  ngpcl,
}

extension PrinterProtocolExtension on PrinterProtocol {
  /// 프로토콜 이름
  String get name {
    switch (this) {
      case PrinterProtocol.zipher:
        return 'Zipher';
      case PrinterProtocol.ngpcl:
        return 'NGPCL';
    }
  }

  /// 모델명으로부터 프로토콜 타입 추론
  static PrinterProtocol fromModel(String? model) {
    if (model == null || model.isEmpty) {
      return PrinterProtocol.zipher; // 기본값
    }

    final modelLower = model.toLowerCase();

    // NGPCL 지원 모델명 패턴 (실제 모델명에 맞게 수정 필요)
    if (modelLower.contains('ngpcl') || modelLower.contains('nextgen') || modelLower.contains('sacheon')) {
      return PrinterProtocol.ngpcl;
    }

    // 기본값은 Zipher
    return PrinterProtocol.zipher;
  }
}
