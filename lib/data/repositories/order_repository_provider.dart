import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'order_repository_impl.dart';
import 'package:print_manager/domain/repositories/order_repository.dart';
import 'package:print_manager/data/providers/api_service_provider.dart';


final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final apiService = ref.read(ApiServiceProvider);
  return OrderRepositoryImpl(apiService);
});
