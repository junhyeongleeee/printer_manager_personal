import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_manager/app_router.dart';
import 'package:print_manager/data/datasources/local/database_helper.dart';
import 'package:print_manager/data/providers/dio_client_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:print_manager/data/datasources/remote/api_service.dart';
import 'package:print_manager/data/datasources/remote/dio_client.dart';

void main() {
  //sqfliteFfiInit();
  //databaseFactory = databaseFactoryFfi;
  //DatabaseHelper.database;
  runApp(ProviderScope(
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      //home: PrinterManagerHome(),
    );
  }
}
