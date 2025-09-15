import '../datasources/remote/api_service.dart';
import 'dio_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ApiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider).dio;
  return ApiService(dio);
});
