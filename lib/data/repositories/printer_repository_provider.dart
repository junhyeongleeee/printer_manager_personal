import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'printer_repository_impl.dart';
import 'package:print_manager/domain/repositories/printer_repository.dart';
import 'package:print_manager/data/providers/api_service_provider.dart';


final printerRepositoryProvider = Provider<PrinterRepository>((ref) {
  final apiService = ref.read(ApiServiceProvider);
  return PrinterRepositoryImpl(apiService);
});
