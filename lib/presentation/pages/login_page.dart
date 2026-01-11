import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_manager/core/services/logger_service.dart';
import '../providers/user_provider.dart';
import 'package:print_manager/core/data/models/request/login_request.dart';
import 'package:print_manager/core/data/repositories/user_repository_provider.dart';
import 'package:print_manager/core/data/providers/token_provider.dart';
import 'package:print_manager/core/token.dart';
import 'package:print_manager/core/domain/entities/user.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _idController = TextEditingController();
  final _pwController = TextEditingController();

  bool _loginFailed = false;
  bool _isError = false;

  void _attemptLogin() async {
    // context.go('/home');
    try {
      final request = LoginRequest(userId: _idController.text, password: _pwController.text);
      final userRepository = ref.read(userRepositoryProvider);
      final response = await userRepository.login(request);
      ref.read(tokenProvider.notifier).setToken(Token()..accessToken = response.data.accessToken);
      logger.i("accessToken: $response.data.accessToken");

      setState(() {
        _loginFailed = response.status != 'success'; //status = success, loginFail = false
        logger.i("_loginFailed = $_loginFailed");
        //_isError = _loginFailed;
        logger.i("_isError = $_isError");
        ref
            .read(userProvider.notifier)
            .updateUser(
              User(id: _idController.text, pw: _pwController.text, company: '', name: '', location: '', phoneNum: ''),
            );
        logger.i("userId: ${_idController.text}, password: ${_pwController.text}");
        logger.i("ref.read(userProvider).id : ${ref.read(userProvider)?.id ?? "물음표"}");
        if (!_loginFailed) {
          if (response.data.isFirst) {
            context.go('/register');
          } else {
            // context.go('/register');
            context.go('/home');
          }
          // context.go('/home'); // test
        }
      });
    } catch (e) {
      setState(() {
        _isError = true;
      });
      // context.go('/home'); // test
    }
  }

  OutlineInputBorder _getBorder(bool isError) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: isError ? Colors.red : Colors.grey, width: 1.5),
      borderRadius: BorderRadius.circular(8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F7F8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Center(
          //child: ConstrainedBox(
          child: Container(
            color: Color(0xFFFFFFFF),
            constraints: const BoxConstraints(maxWidth: 408, maxHeight: 3140),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  SizedBox(width: 200, height: 80, child: Image.asset('assets/logo.png', fit: BoxFit.contain)),
                  //const SizedBox(height: 20),
                  Text("종량제 봉투 위변조 방지코드\n프린터 관리 시스템", textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _idController,
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: '사업자등록번호',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: _getBorder(_isError),
                      focusedBorder: _getBorder(_isError),
                      enabledBorder: _getBorder(_isError),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _pwController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: _getBorder(_isError),
                      focusedBorder: _getBorder(_isError),
                      enabledBorder: _getBorder(_isError),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 오류 메시지
                  if (_isError)
                    const Text('* 사업자등록번호와 비밀번호가 일치하지 않습니다. \n다시 입력해주세요.', style: TextStyle(color: Colors.red)),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _attemptLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // 원하는 색상
                        foregroundColor: Colors.white, // 텍스트 색상
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          // 버튼 모서리 둥글게 (선택)
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('로그인'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
