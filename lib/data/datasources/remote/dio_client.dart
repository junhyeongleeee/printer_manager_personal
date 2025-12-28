import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:print_manager/core/services/logger_service.dart';

class DioClient {
  final Dio dio;

  DioClient({required Future<String?> Function() getAccessToken})
    : dio = Dio(
        BaseOptions(
          //baseUrl: kReleaseMode ? 'https://tqm-api.snaptag.co.kr' : 'https://dev-api-tqm.snaptag.co.kr',
          baseUrl: kReleaseMode ? 'https://dev-api-tqm.snaptag.co.kr' : 'https://dev-api-tqm.snaptag.co.kr',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token'; //  헤더 주입
            logger.i("Authorization Header Set: Bearer $token");
          } else {
            logger.i("No token found");
          }
          return handler.next(options);
        },
      ),
    );

    // 에러 인터셉터 추가
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // 연결 오류 상세 정보 로깅
          if (error.type == DioExceptionType.connectionTimeout) {
            logger.i('❌ 연결 타임아웃: 서버에 연결할 수 없습니다 (${dio.options.baseUrl})');
          } else if (error.type == DioExceptionType.receiveTimeout) {
            logger.i('❌ 응답 타임아웃: 서버 응답이 너무 느립니다');
          } else if (error.type == DioExceptionType.connectionError) {
            logger.i('❌ 연결 오류: 네트워크 연결을 확인하세요');
            logger.i('   - 서버 URL: ${dio.options.baseUrl}');
            logger.i('   - 요청 경로: ${error.requestOptions.path}');
            logger.i('   - 오류 메시지: ${error.message}');
          } else if (error.type == DioExceptionType.badResponse) {
            logger.i('❌ 서버 오류: ${error.response?.statusCode}');
          } else {
            logger.i('❌ 알 수 없는 오류: ${error.type}');
            logger.i('   - 메시지: ${error.message}');
          }
          return handler.next(error);
        },
      ),
    );

    dio.interceptors.add(PrettyDioLogger(requestHeader: true, requestBody: true, responseHeader: true));
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
