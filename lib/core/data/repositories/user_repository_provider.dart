import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_repository_impl.dart';
import 'package:print_manager/core/domain/repositories/user_repository.dart';
import 'package:print_manager/core/data/providers/api_service_provider.dart';


final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiService = ref.read(ApiServiceProvider);
  return UserRepositoryImpl(apiService);
});
