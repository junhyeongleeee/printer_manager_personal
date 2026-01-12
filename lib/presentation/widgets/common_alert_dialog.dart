import 'package:flutter/material.dart';

/// UI 상수 (Windows UI 스타일)
class _AlertUIConstants {
  static const double borderRadius = 2.0; // Windows 스타일: 약간 둥근 모서리
  static const String fontFamily = 'Pretendard';
  static const Color borderColor = Color(0xFFADADAD);
  static const Color cardBg = Color(0xFFFFFFFF);

  // Windows 색상 (발주 선택 다이얼로그와 동일)
  static const Color windowTitleBarStart = Color(0xFF0078D4);
  static const Color windowTitleBarEnd = Color(0xFF005A9E);

  // 텍스트 스타일 헬퍼 메서드
  static TextStyle textStyle({double? fontSize, FontWeight? fontWeight, Color? color}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: fontFamily,
    );
  }
}

/// 공통 알럿 다이얼로그 (Windows UI 스타일)
class CommonAlertDialog extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? customContent;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final Color? cancelColor;
  final bool barrierDismissible;

  const CommonAlertDialog({
    Key? key,
    required this.title,
    this.content,
    this.customContent,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.cancelColor,
    this.barrierDismissible = true,
  })  : assert(
          content != null || customContent != null,
          'content 또는 customContent 중 하나는 필수입니다.',
        ),
        assert(
          !(content != null && customContent != null),
          'content와 customContent는 동시에 사용할 수 없습니다.',
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => barrierDismissible,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: _AlertUIConstants.cardBg,
            border: Border.all(color: _AlertUIConstants.borderColor, width: 1),
            borderRadius: BorderRadius.circular(_AlertUIConstants.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Windows 스타일 헤더 (그라데이션) - 발주 선택 다이얼로그와 동일
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _AlertUIConstants.windowTitleBarStart,
                      _AlertUIConstants.windowTitleBarEnd,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_AlertUIConstants.borderRadius),
                    topRight: Radius.circular(_AlertUIConstants.borderRadius),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: _AlertUIConstants.textStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white, size: 18),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),
              // 컨텐츠 영역
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: content != null
                      ? Text(
                          content!,
                          style: _AlertUIConstants.textStyle(fontSize: 14),
                        )
                      : customContent!,
                ),
              ),
              // 버튼 영역
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFE8E8E8),
                  border: Border(
                    top: BorderSide(color: _AlertUIConstants.borderColor, width: 1),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(_AlertUIConstants.borderRadius),
                    bottomRight: Radius.circular(_AlertUIConstants.borderRadius),
                  ),
                ),
                child: _buildActions(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final hasCancel = cancelText != null && onCancel != null;
    final hasConfirm = confirmText != null && onConfirm != null;

    if (!hasCancel && !hasConfirm) {
      // 버튼이 없으면 확인 버튼만 표시 (ElevatedButton)
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildButton(
            context: context,
            text: '확인',
            onPressed: () => Navigator.pop(context),
            color: _AlertUIConstants.windowTitleBarStart,
            isPrimary: true, // ElevatedButton
          ),
        ],
      );
    }

    if (hasCancel && hasConfirm) {
      // 두 개 버튼 (발주 선택 다이얼로그 스타일: 취소는 OutlinedButton, 확인은 ElevatedButton)
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildButton(
            context: context,
            text: cancelText!,
            onPressed: () {
              onCancel?.call();
              Navigator.pop(context);
            },
            color: cancelColor ?? Colors.grey[700]!,
            isPrimary: false, // OutlinedButton
          ),
          SizedBox(width: 8),
          _buildButton(
            context: context,
            text: confirmText!,
            onPressed: () {
              onConfirm?.call();
              Navigator.pop(context);
            },
            color: confirmColor ?? _AlertUIConstants.windowTitleBarStart,
            isPrimary: true, // ElevatedButton
          ),
        ],
      );
    }

    // 한 개 버튼
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (hasCancel)
          _buildButton(
            context: context,
            text: cancelText!,
            onPressed: () {
              onCancel?.call();
              Navigator.pop(context);
            },
            color: cancelColor ?? Colors.grey[700]!,
            isPrimary: false, // OutlinedButton
          ),
        if (hasConfirm)
          _buildButton(
            context: context,
            text: confirmText!,
            onPressed: () {
              onConfirm?.call();
              Navigator.pop(context);
            },
            color: confirmColor ?? _AlertUIConstants.windowTitleBarStart,
            isPrimary: true, // ElevatedButton
          ),
      ],
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    required Color color,
    bool isPrimary = false, // 주요 버튼인지 여부 (ElevatedButton 사용)
  }) {
    if (isPrimary) {
      // 주요 버튼: ElevatedButton (발주 선택 다이얼로그의 "선택" 버튼 스타일)
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_AlertUIConstants.borderRadius),
          ),
          elevation: 1,
        ),
        child: Text(
          text,
          style: _AlertUIConstants.textStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else {
      // 보조 버튼: OutlinedButton (발주 선택 다이얼로그의 "취소" 버튼 스타일)
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          side: BorderSide(color: _AlertUIConstants.borderColor, width: 1),
          foregroundColor: Colors.grey[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_AlertUIConstants.borderRadius),
          ),
        ),
        child: Text(
          text,
          style: _AlertUIConstants.textStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      );
    }
  }
}

/// 공통 알럿 다이얼로그 헬퍼 클래스
class CommonAlert {
  /// 텍스트 기반 알럿 (버튼 2개)
  static Future<bool?> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = '확인',
    String cancelText = '취소',
    Color? confirmColor,
    Color? cancelColor,
    bool barrierDismissible = true,
  }) async {
    bool? result;
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CommonAlertDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
        cancelColor: cancelColor,
        onConfirm: () => result = true,
        onCancel: () => result = false,
        barrierDismissible: barrierDismissible,
      ),
    );
    return result;
  }

  /// 텍스트 기반 알럿 (버튼 1개)
  static Future<void> showInfoDialog({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = '확인',
    Color? confirmColor,
    bool barrierDismissible = true,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CommonAlertDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        confirmColor: confirmColor ?? Colors.blue,
        onConfirm: () {},
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  /// 커스텀 컨텐츠 알럿 (버튼 2개)
  static Future<bool?> showCustomConfirmDialog({
    required BuildContext context,
    required String title,
    required Widget customContent,
    String confirmText = '확인',
    String cancelText = '취소',
    Color? confirmColor,
    Color? cancelColor,
    bool barrierDismissible = true,
  }) async {
    bool? result;
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CommonAlertDialog(
        title: title,
        customContent: customContent,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
        cancelColor: cancelColor,
        onConfirm: () => result = true,
        onCancel: () => result = false,
        barrierDismissible: barrierDismissible,
      ),
    );
    return result;
  }

  /// 커스텀 컨텐츠 알럿 (버튼 1개)
  static Future<void> showCustomInfoDialog({
    required BuildContext context,
    required String title,
    required Widget customContent,
    String confirmText = '확인',
    Color? confirmColor,
    bool barrierDismissible = true,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CommonAlertDialog(
        title: title,
        customContent: customContent,
        confirmText: confirmText,
        confirmColor: confirmColor ?? Colors.blue,
        onConfirm: () {},
        barrierDismissible: barrierDismissible,
      ),
    );
  }
}
