import 'package:flutter/material.dart';
import 'common_alert_dialog.dart';

/// 공통 알럿 다이얼로그 사용 예시
class CommonAlertDialogExample {
  /// 예시 1: 텍스트 기반 알럿 (버튼 2개)
  static Future<void> example1(BuildContext context) async {
    final result = await CommonAlert.showConfirmDialog(
      context: context,
      title: '인쇄 완료',
      content: '발주 "품목명"의 인쇄를 완료 처리하시겠습니까?\n\n이 작업은 저장된 데이터를 초기화합니다.',
      confirmText: '완료',
      cancelText: '취소',
      confirmColor: Colors.green,
    );

    if (result == true) {
      // 확인 버튼 클릭 시 처리
      print('확인 클릭');
    } else {
      // 취소 버튼 클릭 시 처리
      print('취소 클릭');
    }
  }

  /// 예시 2: 텍스트 기반 알럿 (버튼 1개)
  static Future<void> example2(BuildContext context) async {
    await CommonAlert.showInfoDialog(
      context: context,
      title: '알림',
      content: '작업이 완료되었습니다.',
      confirmText: '확인',
    );
  }

  /// 예시 3: 커스텀 컨텐츠 알럿 (버튼 2개)
  static Future<void> example3(BuildContext context) async {
    final result = await CommonAlert.showCustomConfirmDialog(
      context: context,
      title: '일괄 제어',
      customContent: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('발주 1에 할당된 3개 프린터를 모두 준비하시겠습니까?'),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('프린터 목록:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('• 프린터 1'),
                Text('• 프린터 2'),
                Text('• 프린터 3'),
              ],
            ),
          ),
        ],
      ),
      confirmText: '준비',
      cancelText: '취소',
      confirmColor: Colors.green,
    );

    if (result == true) {
      // 확인 버튼 클릭 시 처리
      print('확인 클릭');
    }
  }

  /// 예시 4: 커스텀 컨텐츠 알럿 (버튼 1개)
  static Future<void> example4(BuildContext context) async {
    await CommonAlert.showCustomInfoDialog(
      context: context,
      title: '상세 정보',
      customContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.info, size: 20, color: Colors.blue),
              SizedBox(width: 8),
              Text('작업이 성공적으로 완료되었습니다.'),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              border: Border.all(color: Colors.green[200]!),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text('완료 수량: 25장'),
          ),
        ],
      ),
      confirmText: '확인',
      confirmColor: Colors.green,
    );
  }

  /// 예시 5: 직접 CommonAlertDialog 사용
  static Future<void> example5(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => CommonAlertDialog(
        title: '커스텀 알럿',
        customContent: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('이것은 커스텀 컨텐츠입니다.'),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: '입력',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        confirmText: '저장',
        cancelText: '취소',
        onConfirm: () {
          // 확인 버튼 클릭 시 처리
          print('저장 클릭');
        },
        onCancel: () {
          // 취소 버튼 클릭 시 처리
          print('취소 클릭');
        },
      ),
    );
  }
}
