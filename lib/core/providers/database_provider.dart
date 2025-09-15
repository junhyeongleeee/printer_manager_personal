import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_manager/data/datasources/local/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


final databaseProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});
