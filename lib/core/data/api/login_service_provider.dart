import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:print_manager/core/data/datasources/remote/api_service.dart';
import '../datasources/remote/dio_client.dart';
import '../providers/dio_client_provider.dart';

final loginServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.read(dioProvider).dio;
  return ApiService(dio);
});
