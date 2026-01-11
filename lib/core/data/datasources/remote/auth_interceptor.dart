import 'package:dio/dio.dart';
import 'package:print_manager/core/services/logger_service.dart';

class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getToken;

  AuthInterceptor(this.getToken);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await getToken();
    logger.i("token: $token");
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
