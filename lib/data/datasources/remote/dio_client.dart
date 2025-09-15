import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:print_manager/data/providers/token_provider.dart';
import 'package:print_manager/data/datasources/remote/auth_interceptor.dart';
import 'package:print_manager/core/token.dart';

class DioClient {
  final Dio dio;

  DioClient({required Future<String?> Function() getAccessToken})
      : dio = Dio(
    BaseOptions(
      //baseUrl: kReleaseMode ? 'https://tqm-api.snaptag.co.kr' : 'https://dev-api-tqm.snaptag.co.kr',
      baseUrl: kReleaseMode ? 'https://dev-api-tqm.snaptag.co.kr' : 'https://dev-api-tqm.snaptag.co.kr',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  ) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token'; //  헤더 주입
          print("Authorization Header Set: Bearer $token");
        } else {
          print("No token found");
        }
        return handler.next(options);
      },
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) {
    return dio.put(path, data: data);
  }

  Future<Response> delete(String path, {dynamic data}) {
    return dio.delete(path, data: data);
  }
}