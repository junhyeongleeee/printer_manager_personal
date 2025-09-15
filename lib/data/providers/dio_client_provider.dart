import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/remote/dio_client.dart';
import 'token_provider.dart';
import 'package:dio/dio.dart';


final dioProvider = Provider<DioClient>((ref) {
  return DioClient(getAccessToken: () async {
    final token = ref.read(tokenProvider);
    return token?.accessToken;
  });
});
//
// final apiServiceProvider = Provider<ApiService>((ref) {
//   final dio = ref.watch(dioProvider);
//   return ApiService(dio); // baseUrl 생략 가능
// });
