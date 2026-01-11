import 'package:go_router/go_router.dart';
import 'package:print_manager/core/infra/zipher_socket.dart';
import 'package:print_manager/presentation/pages/printer_manager_home_page.dart';
import 'package:print_manager/presentation/pages/login_page.dart';
import 'package:print_manager/presentation/pages/company_register_page.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/register', builder: (context, state) => const CompanyRegisterPage()),
    GoRoute(path: '/home', builder: (context, state) => PrinterManagerHome()),
  ],
);
