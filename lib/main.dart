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

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Pretendard',
        textTheme: TextTheme(
          displayLarge: TextStyle(fontFamily: 'Pretendard'),
          displayMedium: TextStyle(fontFamily: 'Pretendard'),
          displaySmall: TextStyle(fontFamily: 'Pretendard'),
          headlineLarge: TextStyle(fontFamily: 'Pretendard'),
          headlineMedium: TextStyle(fontFamily: 'Pretendard'),
          headlineSmall: TextStyle(fontFamily: 'Pretendard'),
          titleLarge: TextStyle(fontFamily: 'Pretendard'),
          titleMedium: TextStyle(fontFamily: 'Pretendard'),
          titleSmall: TextStyle(fontFamily: 'Pretendard'),
          bodyLarge: TextStyle(fontFamily: 'Pretendard'),
          bodyMedium: TextStyle(fontFamily: 'Pretendard'),
          bodySmall: TextStyle(fontFamily: 'Pretendard'),
          labelLarge: TextStyle(fontFamily: 'Pretendard'),
          labelMedium: TextStyle(fontFamily: 'Pretendard'),
          labelSmall: TextStyle(fontFamily: 'Pretendard'),
        ),
      ),
      //home: PrinterManagerHome(),
    );
  }
}
