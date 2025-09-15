import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_manager/core/providers/database_provider.dart';
import '../providers/user_provider.dart';
import '../../core/providers/database_provider.dart';
import 'package:print_manager/domain/entities/user.dart';
import 'package:print_manager/data/models/request/user_request.dart';
import 'package:print_manager/data/repositories/user_repository_provider.dart';


class CompanyRegisterPage extends ConsumerStatefulWidget {
  const CompanyRegisterPage({super.key});

  @override
  ConsumerState<CompanyRegisterPage> createState() => _CompanyRegisterPageState();
}

class _CompanyRegisterPageState extends ConsumerState<CompanyRegisterPage> {
  final _pwController = TextEditingController();
  final _pwConfirmController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _managerController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _pwMismatch = false;
  bool _registerSuccess = false;
  late String _businessNumber;
  // void _onRegister() {
  //   final pw = _pwController.text.trim();
  //   final pwConfirm = _pwConfirmController.text.trim();
  //
  //   if (pw != pwConfirm) {
  //     setState(() {
  //       _pwMismatch = true;
  //     });
  //     return;
  //   }
  //
  //   setState(() {
  //     _pwMismatch = false;
  //   });
  //
  //   ref.read(userProvider.notifier).updateFields(
  //     pw: _pwController.text,
  //     name: _managerController.text,
  //     location: _locationController.text,
  //     phoneNum: _phoneController.text,
  //   );
  //
  //   context.go('/home');
  //
  //   // TODO: 서버로 업체 등록 요청 보내기
  //   final db = ref.read(databaseProvider);
  //   final user = ref.read(userProvider)?.id?? "";
  //
  //   final data = {
  //     'id': user,
  //     'pw': pw,
  //     'name': _managerController.text,
  //     'location': _locationController.text,
  //     'phoneNum': _phoneController.text,
  //   };
  //
  //   db.insertUser(data);
  //
  //   print('업체 등록 완료');
  //   print('위치: ${_locationController.text}');
  //   print('담당자명: ${_managerController.text}');
  //   print('연락처: ${_phoneController.text}');
  // }
  void _onRegister() async {
    final pw = _pwController.text.trim();
    final pwConfirm = _pwConfirmController.text.trim();

    if (pw != pwConfirm) {
      setState(() {
        _pwMismatch = true;
      });
      return;
    }

    setState(() {
      _pwMismatch = false;
    });

    // TODO: 서버로 업체 등록 요청 보내기
    final db = ref.read(databaseProvider);
    final user = ref.read(userProvider)?.id?? "";

    final request = UserRequest(
      companyName: _companyNameController.text,
      address: _locationController.text,
      username: _managerController.text,
      password: _pwController.text,
      phone: _phoneController.text,
      status: "사용중",
    );

    final userRepository = ref.read(userRepositoryProvider);
    final response = await userRepository.updateUser(request);

    setState(() {
      _registerSuccess = response.status == 'success';
    });

    print("response :$response");
    if (_registerSuccess){
      print('업체 등록 완료');
      print('위치: ${_locationController.text}');
      print('담당자명: ${_managerController.text}');
      print('연락처: ${_phoneController.text}');

      ref.read(userProvider.notifier).updateFields(
        pw: _pwController.text,
        company: _companyNameController.text,
        name: _managerController.text,
        location: _locationController.text,
        phoneNum: _phoneController.text,
      );
      context.go('/home');
    } else {
      print('_registerSuccess = false');
    }

  }
  bool _agreed_personal = false;
  bool _agreed_use = false;

  @override
  Widget build(BuildContext context) {
    _businessNumber = ref.read(userProvider)?.id ?? "물음표";
    print("_businessNumber: $_businessNumber");
    return Scaffold(
      appBar: AppBar(
        title: const Text('업체 등록'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(_companyNameController, '업체 이름', maxLength: 50),
            const SizedBox(height: 16), //24
            _buildPasswordField(),
            const SizedBox(height: 16),
            _buildPasswordConfirmField(),
            if (_pwMismatch)
              const Padding(
                padding: EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  '비밀번호가 일치하지 않습니다.',
                  style: TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),
            const SizedBox(height: 24),
            _buildTextField(_locationController, '업체 위치', maxLength: 50),
            const SizedBox(height: 16),
            _buildTextField(_managerController, '담당자명', maxLength: 20),
            const SizedBox(height: 16),
            _buildTextField(
              _phoneController,
              '담당자 연락처',
              maxLength: 13,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 32),
//             Text("개인정보처리방침", style: TextStyle(color: Colors.black, fontSize: 32)),
//             SingleChildScrollView(
//             child: Text(
//                 '''종량제 봉투 총량 관리 서비스 이용약관
// 제1조 (목적)
// 스냅태그 주식회사(이하 '회사'라 함)는 개인정보 보호법, 정보통신망 이용촉진 및 정보보호 등에 관한 법률(이하 ‘정보통신망법’라 함) 등 회사가 준수하여야 할 국내 개인정보 보호 법령을 준수하며, 관련 법령에 의거한 개인정보 처리방침을 정하여 이용자 권익 보호에 최선을 다하고 있습니다. 본 개인정보 처리방침은 회사가 운영하는 ‘위변조방지코드 인식 기반 종량제 봉투 시스템’(이하 서비스)에 적용되며 다음과 같은 내용을 담고 있습니다. 이 개인정보 처리방침에서 사용하는 용어의 의미는 관련 법령 및 회사의 이용약관에서 정한 바에 따르며, 그 밖의 사항은 일반적인 상관례에 따릅니다.
//
// 1. 수집하는 개인정보의 항목 및 수집 방법
//
// 2. 개인정보의 수집 및 이용목적
//
// 3. 개인정보의 제공 및 위탁
//
// 4. 개인정보 보유 및 이용기간
//
// 5. 개인정보 파기
//
// 6. 개인정보 열람∙정정∙삭제
//
// 7. 쿠키의 운영
//
// 8. 행태정보의 수집∙이용∙제공 및 거부
//
// 9. 마케팅 정보 처리방침
//
// 10. 회원의 권리와 의무
//
// 11. 개인정보의 기술적·관리적 보호대책
//
// 12. 개인정보 보호책임자 및 개인정보 열람청구 담당자
//
// 13. 기타
//
// 14. 고지의 의무
//
// 1. 수집하는 개인정보의 항목 및 수집 방법
// 가. 수집하는 개인정보의 항목
// 회사는 원활한 서비스의 제공을 위해 기관 회원 가입 시 및 서비스 이용 시 아래와 같은 개인정보를 수집하고 있습니다.
// o필수항목 : 소속기관, 소속 부처, 이름, 전화번호, 이메일
//
// 기관 회원 가입 이후 담당자는 종량제 봉투 제작 업체 담당자를 직접 기입하는 방식으로 다음의 항목이 선택항목으로 수집될 수 있습니다.
// o수집내용 : 소속, 이름, 전화번호, 이메일
//
// 워터마크 가공 업체 등록은 현장 프린터 설치 시 직접 등록하는 방식으로 다음의 항목이 선택항목으로 수집될 수 있습니다.
// o수집내용 : 사업자등록번호, 소속, 이름, 전화번호, 이메일,
//
// 서비스 이용과정이나 처리 과정에서 아래와 같은 정보들이 자동으로 생성되어 수집될 수 있습니다.
// o수집내용 : 방문 및 서비스 이용 기록, 로그(Log)기록, 쿠키(Cookie), 아이피 주소(IP Address), 이용정지 기록, 이용해지 기록
//
// 서비스 이용과정에서 OS버전, 단말기 정보 등의 환경정보와 이용형태와 빈도가 이용 과정에서 생성된 정보가 수집됩니다.
// 이벤트 및 경품 신청 과정에서 추가로 개인정보 수집이 발생할 수 있습니다. 추가로 개인정보를 수집하는 시점에 회원에게 ‘수집하는 개인정보 항목, 개인정보의 수집 및 이용목적, 개인정보의 보유 및 이용기간, 동의를 거부할 권리 및 동의 거부에 따른 불이익’에 대해 별도로 안내를 드리고 동의를 받습니다.
// 나. 개인정보의 수집방법
// 회사는 다음과 같은 방법으로 개인정보를 수집합니다.
// 회원가입 및 서비스 이용 과정에서 회원이 개인정보 수집에 대해 동의한 정보와 직접 정보를 입력하는 경우, 해당 개인정보를 수집합니다.
// 기기정보 등과 같은 생성정보는 PC 웹, 모바일 웹/앱 이용 과정에서 자동으로 생성되어 수집될 수 있습니다.
// 회사와 제휴한 외부 기업이나 단체로부터 개인정보를 제공받을 수 있으며, 이러한 경우 개인정보보호법에 따라 제휴한 외부 기업 또는 단체에서 회원의 개인정보 제공 동의 등을 받은 후 회사에 제공합니다.
// 서비스 이용과정의 로그가 수집될 수 있습니다.
// 2. 개인정보의 수집 및 이용목적
// 회사는 서비스(PC웹, 모바일 앱/웹 포함)의 회원 관리, 서비스 제공과 개발 및 개선의 목적으로만 개인정보를 이용합니다.
// 서비스 이용에 따른 가입의사 확인, 회원 식별, 원활한 의사소통 경로의 확보, 새로운 정보의 소개 및 고지사항 전달, 서비스 방문 및 이용기록 분석을 위해 이용합니다.
// 서비스 및 콘텐츠 제공을 위한 본인 인증 목적으로 개인정보를 처리합니다.
// 신규 서비스 개발 및 맞춤 서비스 제공을 위해 이용자의 서비스 이용에 대한 통계 목적으로 개인정보를 처리합니다.
// 기타 서비스, 신규 정보 안내 및 이벤트 정보 안내를 위해 개인정보를 수집합니다.
// 서비스 제공, 콘텐츠 제공, 본인인증 목적으로 개인정보를 처리합니다.
// 신규 서비스 발굴 및 기존 서비스 개선을 위해 이용합니다.
// 서비스 이용과 접속 빈도 분석, 서비스 이용에 대한 통계, 서비스 분석 및 통계에 따른 맞춤 서비스 제공 및 광고 게재를 위해 이용합니다.
// 서비스 제공(광고 포함)에 더하여, 인구통계학적 분석, 맞춤형 서비스 제공 등 신규 서비스 요소의 발굴 및 기존 서비스 개선을 위해 이용합니다.
// 법령 및 이용약관을 위반하는 회원에 대한 이용 제한 조치, 부정 이용 행위를 포함하여 서비스의 원활한 운영에 지장을 주는 행위에 대한 방지 및 제재, 계정도용 방지, 약관 개정 등의 고지사항 전달, 분쟁조정을 위한 기록 보존, 고객 문의 처리 등 회원 보호 및 서비스 운영을 위해 이용합니다.
// 이벤트 정보 및 참여기회 제공과 경품 배송, 광고성 정보 제공 등 마케팅 및 프로모션 목적을 위해 이용합니다.
// 3. 개인정보의 제공 및 위탁
// 회사는 회원의 사전 동의 없이 개인정보를 제3자 혹은 외부에 제공하지 않습니다. 단, 회원이 서비스 이용 중 개인정보 제공에 직접 동의를 한 경우, 관련 법령에 의거해 회사에 개인정보 제출 의무가 발생한 경우에 한하여 개인정보를 제공하고 있습니다.
// 가. 개인정보의 제3자 제공
// 회원이 사전에 동의한 경우
// 법률에 특별한 규정이 있거나, 수사 목적으로 법률에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우
// 나. 개인정보의 처리 위탁
// 회사는 서비스 향상 등을 위하여 아래와 같이 개인정보의 처리를 위탁하고 있으며, 위탁 받은 업체가 개인정보 보호법 등 관계 법령에 따라 개인정보를 안전하게 처리하도록 필요한 사항을 규정하고 관리와 감독을 실시하고 있습니다.
// 4. 개인정보 보유 및 이용기간
// 회사는 원칙적으로 회원의 개인정보를 담당자 변경 시 지체없이 파기하고 있습니다. 단, 기관 회원에게 개인정보 보관기간에 대해 별도의 동의를 얻은 경우, 또는 법령에서 일정 기간 정보보관 의무를 부과하는 경우에는 해당 기간 동안 개인정보를 안전하게 보관합니다.
// 내부 방침에 의한 보관
// 부정이용기록은 부정 이용 방지를 위해 1년간 보관됩니다.
// 관련 법령에 의한 보관
// 계약 또는 청약철회 등에 관한 기록 보유 : 5년 (전자상거래 등에서의 소비자보호에 관한 법률)
// 대금결제 및 재화 등의 공급에 관한 기록 보유 : 5년 (전자상거래 등에서의 소비자보호에 관한 법률)
// 소비자 불만 또는 분쟁처리에 관한 기록 보유 : 3년 (전자상거래 등에서의 소비자보호에 관한 법률)
// 방문에 관한 기록 보유 : 3개월 (통신비밀보호법)
// 5. 개인정보 파기
// 개인정보 파기 시에는 재생이 불가능한 방법으로 파기하고 있습니다. 또한 법령에서 보존의무를 부과한 정보에 대해서도 해당 기간 경과 후 지체없이 재생이 불가능한 방법으로 파기합니다. 전자적 파일 형태의 경우 복구 및 재생이 되지 않도록 기술적인 방법을 이용하여 안전하게 삭제하며, 출력물 등은 분쇄하거나 소각하는 방식 등으로 파기합니다. 회사는 ‘개인정보 유효기간제’에 따라 1년간 서비스를 이용하지 않은 회원의 개인정보를 별도로 분리 보관하여 관리하고 있습니다. 단, 개인정보 유효기간을 회원 탈퇴 시 까지로 설정한 경우에는 해당되지 않습니다.
//
// 6. 개인정보 열람∙정정∙삭제
// 기관 회원은 언제든지 서비스 로그인 후, 설정 메뉴 선택 후 자신의 개인정보를 조회하거나 수정할 수 있습니다.
// 기관 회원은 언제든지 ‘담당자 변경’ 등을 통해 개인정보의 수집 및 이용 동의를 철회할 수 있습니다.
// 회원이 개인정보의 오류에 대한 정정을 요청한 경우, 정정을 완료하기 전까지 해당 개인정보를 이용 또는 제공하지 않습니다. 또한 잘못된 개인정보를 제3자에게 이미 제공한 경우에는 정정 처리결과를 제3자에게 지체없이 통지하여 정정이 이루어지도록 하겠습니다.
// 7. 쿠키의 운영
// 쿠키란? 사이트 접속시 회원의 저장장치에 전송하는 특별한 텍스트 파일(text file)을 말합니다. 쿠키는 웹사이트의 서버(server)에서만 읽어 들일 수 있는 형태로 전송되며 개인이 사용하는 브라우저(browser)의 디렉터리(directory) 하위에 저장됩니다. 모바일 애플리케이션과 같이 쿠키 기술을 사용할 수 없는 경우에는 쿠키와 유사한 기능을 수행하는 기술(광고식별자 등)을 사용할 수도 있습니다.
//
// 가. 쿠키의 사용 목적
// 쿠키를 통해 수집하는 정보는 '수집하는 개인정보의 항목'과 같으며 '개인정보의 수집 및 이용목적' 외의 용도로는 이용되지 않습니다.
// 나. 쿠키 설정 거부
// 이용자는 쿠키에 대한 선택권을 가지고 있습니다. 웹 브라우저 옵션(option)을 선택함으로써 모든 쿠키의 허용, 동의를 통한 쿠키의 허용, 모든 쿠키의 차단을 스스로 결정할 수 있습니다. 단, 쿠키 저장을 거부할 경우에는 로그인이 필요한 일부 서비스를 이용하지 못할 수도 있습니다.
// 8. 행태정보의 수집∙이용∙제공 및 거부
// 구글 애널리틱스(Google Analytics)는 Google Inc.에서 제공하는 로그 분석 서비스입니다. 이 도구는 쿠키를 이용해 웹사이트 이용 현황을 분석하며, IP 주소 등 일부 정보는 익명화 과정을 거칩니다. 관련 정보는 다음과 같습니다:
//
// 브라우저 유형/버전
// 사용된 운영 체제
// 추천 URL (이전에 방문한 페이지)
// 접속한 컴퓨터의 호스트 이름 (IP주소)
// 서버 요청 시간
// 구글 애널리틱스 차단을 위한 브라우저 플러그인은 여기에서 다운로드할 수 있습니다.
//
// 9. 마케팅 정보 처리방침
// 회사는 이벤트 및 홍보를 위해 다음과 같은 정보를 수집·이용할 수 있습니다.
//
// 수집/이용 목적: 스냅태그 소식, 이벤트 안내, 경품 제공 등
// 수집 항목: 성함, 소속/부서/직위, 휴대폰, 전화번호, 이메일
// 보유/이용 기간: 수집일로부터 2년
// 10. 회원의 권리와 의무
// 회원은 자신의 개인정보를 보호할 권리와 함께, 타인의 정보를 침해하지 않을 의무를 가집니다. 부정확한 정보 제공에 따른 책임은 회원 본인에게 있으며, 위반 시 법적 처벌을 받을 수 있습니다.
//
// 11. 개인정보의 안전성 확보조치
// 관리적 조치: 내부관리계획 수립·시행, 전담조직 운영, 직원 교육
// 기술적 조치: 접근 권한 관리, 접근통제 시스템, 암호화, 보안프로그램 설치
// 물리적 조치: 전산실, 자료보관실 등 접근통제
// 12. 개인정보 보호책임자 및 개인정보 열람청구 담당자
// 서비스 이용 중 개인정보 관련 문의는 아래 책임자에게 가능합니다.
//
// 이름: 한윤
// 소속: 스냅태그(주)
// 전화: 031-781-4350
// 이메일: official@snaptag.co.kr
// 기타 외부 기관:
//
// 개인정보분쟁조정위원회: 1833-6972 / www.kopico.go.kr
// 개인정보침해신고센터: 118 / privacy.kisa.or.kr
// 대검찰청 사이버수사과: 1301 / www.spo.go.kr
// 경찰청 사이버안전지킴이: 182 / www.police.go.kr/www/security/cyber.jsp
// 13. 기타
// 서비스 내에 링크된 외부 웹사이트에 대해서는 본 개인정보 처리방침이 적용되지 않습니다.
//
// 14. 고지의 의무
// 본 개인정보 처리방침의 내용 추가, 삭제 또는 수정이 있을 경우 최소 7일 전 서비스 내 공지를 통해 고지합니다. 이용자의 권리에 중대한 변경이 발생할 경우 최소 30일 전에 공지하며, 필요시 동의를 다시 받을 수 있습니다.
//
// 부칙
//
// 공고일자: 2025. 06. 24.
// 시행일자: 2025. 06. 24.'''
//             ),
//             ),
//             CheckboxListTile(
//               contentPadding: EdgeInsets.zero,
//               title: const Text(
//                 '[필수] 개인정보처리방침에 동의합니다.',
//                 style: TextStyle(fontSize: 14),
//               ),
//               value: _agreed_personal,
//               onChanged: (value) {
//                 setState(() {
//                   _agreed_personal = value ?? false;
//                 });
//               },
//             ),
//             Text("이용약관", style: TextStyle(color: Colors.black, fontSize: 32)),
//             SingleChildScrollView(
//               child: Text(
//                   '''종량제 봉투 총량 관리 서비스 이용약관
// 제1조 (목적)
// 본 약관은 스냅태그 주식회사(이하 “회사”)가 제공하는 위변조방지코드 인식 기반 종량제 봉투 총량 관리 시스템(이하 “서비스”)의 이용 조건 및 절차, 회사와 이용자 간의 권리·의무 및 책임사항을 규정함을 목적으로 합니다.
//
// 제2조 (정의)
// “이용자”란 본 서비스에 접속하여 본 약관에 따라 회사가 제공하는 서비스를 이용하는 자를 의미합니다.
// “종량제 봉투 총량 관리 서비스”란 종 위변조방지코드 이미지 등을 포함하여 회사가 위변조방지코드 인식을 통해 정보 연동을 제공하는 대상을 말합니다.
// “위변조방지코드”란 인위적으로 위조 및 변조가 어려운 방식으로 종량제 봉투에 삽입된 정보를 의미합니다.
// “연동 정보”란 종량제 봉투 발주 정보, 제작 업체 등 종량제 봉투에 삽입된 위변조방지코드를 인식함으로써 제공되는 메타데이터(정보, 이력, 진위 여부 등)를 말합니다.
// 제3조 (약관의 게시 및 변경)
// 본 약관은 서비스 초기 화면 또는 별도 연결 화면을 통해 게시됩니다.
// 회사는 필요 시 「전자상거래법」, 「정보통신망법」, 「개인정보보호법」 등 관계 법령을 위반하지 않는 범위에서 본 약관을 변경할 수 있습니다.
// 변경된 약관은 적용일자 및 변경 사유와 함께 공지되며, 적용일 이후에도 이용자가 서비스를 계속 사용할 경우 변경 약관에 동의한 것으로 간주됩니다.
// 제4조 (서비스의 제공 및 변경)
// 본 서비스는 다음과 같은 기능을 포함합니다.
// 종량제 봉투 품목 관리, 제작 업체 관리, 발주 관리, 인쇄 현황 모니터링
// 모바일 카메라를 통한 위변조방지코드 스캔
// 인식 결과에 기반한 진위 확인 및 종량제 봉투 제작 정보 제공
// 회사는 기술적 사유 또는 운영 정책에 따라 서비스의 일부 또는 전부를 변경하거나 중단할 수 있습니다.
// 제5조 (이용자의 의무)
// 이용자는 다음 행위를 하여서는 안 됩니다.
// 제공하는 서비스 화면을 허가 없이 촬영하거나 무단 사용
// 위변조방지코드를 위조하거나 무단 해제하는 행위
// 서비스 운영을 방해하거나 시스템에 악영향을 미치는 행위
// 이용자는 서비스 이용 시 관계 법령 및 본 약관의 규정을 준수해야 합니다.
// 제6조 (지적재산권 및 데이터 권리)
// 본 서비스 내 제공되는 모든 콘텐츠(이미지, 설명, 데이터 등)는 해당 작가 또는 제공자의 저작권 및 지식재산권에 따라 보호됩니다.
// 이용자는 회사 또는 정당한 권리자로부터 명시적 사전 허락 없이 해당 콘텐츠를 무단 복제·유포·전송할 수 없습니다.
// 이용자가 서비스 이용을 통해 제공한 의견, 질문, 기타 콘텐츠에 대한 저작권은 이용자에게 있으며, 회사는 이에 대한 비독점적 사용권을 가집니다.
// 제7조 (개인정보의 수집 및 이용)
// 회사는 서비스 제공을 위해 최소한의 개인정보(예: 디바이스 ID, 카메라 접근 등)를 수집할 수 있으며, 수집 시 별도의 개인정보처리방침에 따릅니다.
// 이용자의 사전 동의 없이 개인정보를 제3자에게 제공하지 않습니다.
// 이용자는 언제든지 개인정보의 열람, 수정, 삭제를 요청할 수 있습니다.
// 제8조 (서비스의 제한 및 해지)
// 회사는 다음 사유가 발생할 경우 사전 통보 없이 서비스 이용을 제한 또는 해지할 수 있습니다.
// 타인의 권리를 침해한 경우
// 허위 정보 등록, 자동화된 수단을 이용한 접근
// 회사의 명예를 훼손하거나 서비스 운영을 방해한 경우
// 이용자는 언제든지 앱 내 설정 또는 고객센터를 통해 서비스 이용을 해지할 수 있습니다.
// 제9조 (면책조항)
// 회사는 다음에 해당하는 경우 책임을 지지 않습니다.
// 이용자의 귀책사유로 인한 서비스 이용 장애
// 종량제 봉투의 실제 정보와 위변조방지코드 데이터 간의 차이
// 외부 시스템 오류 또는 통신 장애
// 회사는 위변조방지코드의 진위 여부 판단에 대한 법적 보증을 하지 않으며, 사용자는 참고용으로만 활용해야 합니다.
// 제10조 (분쟁해결 및 관할)
// 본 약관 및 서비스 이용과 관련하여 분쟁이 발생할 경우, 회사와 이용자는 성실히 협의하여 해결합니다.
// 분쟁이 해결되지 않을 경우 민사소송법상 관할법원에 제소할 수 있습니다.
// 부칙
//
// 본 약관은 2025년 6월 24일부터 시행됩니다.'''
//               ),
//             ),
//             const SizedBox(height: 8),
//             CheckboxListTile(
//               contentPadding: EdgeInsets.zero,
//               title: const Text(
//                 '[필수] 이용약관에 동의합니다.',
//                 style: TextStyle(fontSize: 14),
//               ),
//               value: _agreed_use,
//               onChanged: (value) {
//                 setState(() {
//                   _agreed_use = value ?? false;
//                 });
//               },
//             ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // onPressed: _agreed_use && _agreed_personal ? _onRegister : null,
                onPressed: _onRegister,
                child: const Text('등록하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _pwController,
      obscureText: true,
      maxLength: 20,
      decoration: const InputDecoration(
        labelText: '새 비밀번호',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPasswordConfirmField() {
    return TextField(
      controller: _pwConfirmController,
      obscureText: true,
      maxLength: 20,
      decoration: const InputDecoration(
        labelText: '새 비밀번호 확인',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        int? maxLength,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
