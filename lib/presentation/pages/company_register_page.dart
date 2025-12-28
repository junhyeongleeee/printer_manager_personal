import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_manager/core/providers/database_provider.dart';
import '../providers/user_provider.dart';
import '../../core/providers/database_provider.dart';
import 'package:print_manager/domain/entities/user.dart';
import 'package:print_manager/data/models/request/user_request.dart';
import 'package:print_manager/data/repositories/user_repository_provider.dart';
import 'package:print_manager/core/services/logger_service.dart';

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
    final user = ref.read(userProvider)?.id ?? "";

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

    logger.i("response :$response");
    if (_registerSuccess) {
      logger.i('업체 등록 완료');
      logger.i('위치: ${_locationController.text}');
      logger.i('담당자명: ${_managerController.text}');
      logger.i('연락처: ${_phoneController.text}');

      ref
          .read(userProvider.notifier)
          .updateFields(
            pw: _pwController.text,
            company: _companyNameController.text,
            name: _managerController.text,
            location: _locationController.text,
            phoneNum: _phoneController.text,
          );
      context.go('/home');
    } else {
      logger.i('_registerSuccess = false');
    }
  }

  bool _agreed_personal = false;
  bool _agreed_use = false;

  @override
  Widget build(BuildContext context) {
    _businessNumber = ref.read(userProvider)?.id ?? "물음표";
    logger.i("_businessNumber: $_businessNumber");
    return Scaffold(
      appBar: AppBar(title: const Text('업체 등록')),
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
                child: Text('비밀번호가 일치하지 않습니다.', style: TextStyle(color: Colors.red, fontSize: 13)),
              ),
            const SizedBox(height: 24),
            _buildTextField(_locationController, '업체 위치', maxLength: 50),
            const SizedBox(height: 16),
            _buildTextField(_managerController, '담당자명', maxLength: 20),
            const SizedBox(height: 16),
            _buildTextField(_phoneController, '담당자 연락처', maxLength: 13, keyboardType: TextInputType.phone),
            const SizedBox(height: 32),
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
      decoration: const InputDecoration(labelText: '새 비밀번호', border: OutlineInputBorder()),
    );
  }

  Widget _buildPasswordConfirmField() {
    return TextField(
      controller: _pwConfirmController,
      obscureText: true,
      maxLength: 20,
      decoration: const InputDecoration(labelText: '새 비밀번호 확인', border: OutlineInputBorder()),
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
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    );
  }
}
