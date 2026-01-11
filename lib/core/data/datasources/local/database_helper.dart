import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:print_manager/core/services/logger_service.dart';

class DatabaseHelper {
  static Database? _db;

  static Future<Database> get database async {
    _db ??= await _initDb();
    logger.i('await _initDb();');
    return _db!;
  }

  static Future<Database> _initDb() async {
    final db = await databaseFactoryFfi.openDatabase('app.db');
    await db.execute('''
       CREATE TABLE IF NOT EXISTS user (
        id TEXT PRIMARY KEY,
        pw TEXT NOT NULL,
        name TEXT NOT NULL,
        location TEXT NOT NULL,
        phoneNum TEXT NOT NULL
      )
    ''');

    // 프린터 테이블 생성
    await db.execute('''
      CREATE TABLE IF NOT EXISTS printer (
        name TEXT PRIMARY KEY,
        ip TEXT NOT NULL,
        port INTEGER NOT NULL,
        order_code TEXT NOT NULL,
        item TEXT NOT NULL,
        completed_count INTEGER,
        total_count INTEGER,
        started_at TEXT,
        completed_at TEXT
      )
    ''');

    // 발주 테이블 생성
    await db.execute('''
      CREATE TABLE IF NOT EXISTS order_item (
        code TEXT PRIMARY KEY,
        agency TEXT NOT NULL,
        item TEXT NOT NULL,
        available INTEGER NOT NULL,
        total INTEGER NOT NULL,
        order_date TEXT NOT NULL,
        is_allocatable INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // 완료 발주 내역 테이블 생성
    await db.execute('''
      CREATE TABLE IF NOT EXISTS order_completion (
        id INTEGER PRIMARY KEY,
        agency TEXT NOT NULL,
        order_code TEXT NOT NULL,
        item TEXT NOT NULL,
        total INTEGER NOT NULL,
        assigned_amount INTEGER NOT NULL,
        order_date TEXT NOT NULL,
        started_at TEXT,
        completed_at TEXT
      )
    ''');

    return db;
  }

  //user
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    logger.i('insert data : $user');
    return await db.insert('user', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUserByBusinessNumber(String businessNumber) async {
    final db = await database;
    final result = await db.query(
      'user',
      where: 'id = ?',
      whereArgs: [businessNumber],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUser(String businessNumber, Map<String, dynamic> user) async {
    final db = await database;
    return await db.update(
      'user',
      user,
      where: 'id = ?',
      whereArgs: [businessNumber],
    );
  }

// DELETE
  Future<int> deleteUser(String businessNumber) async {
    final db = await database;
    return await db.delete(
      'user',
      where: 'id = ?',
      whereArgs: [businessNumber],
    );
  }


  //printer
  Future<int> insertPrinter(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('printer', data);
  }

  Future<List<Map<String, dynamic>>> getPrinters() async {
    final db = await database;
    return await db.query('printer');
  }

  Future<int> updatePrinter(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update('printer', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deletePrinter(int id) async {
    final db = await database;
    return await db.delete('printer', where: 'id = ?', whereArgs: [id]);
  }

  //order_item
  Future<int> insertOrder(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('order_item', data);
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await database;
    return await db.query('order_item');
  }

  Future<int> updateOrder(String code, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update('order_item', data, where: 'code = ?', whereArgs: [code]);
  }

  Future<int> deleteOrder(String code) async {
    final db = await database;
    return await db.delete('order_item', where: 'code = ?', whereArgs: [code]);
  }
  //order_completion
  Future<int> insertCompletion(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('order_completion', data);
  }

  Future<List<Map<String, dynamic>>> getCompletions() async {
    final db = await database;
    return await db.query('order_completion');
  }

  Future<int> updateCompletion(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update('order_completion', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCompletion(int id) async {
    final db = await database;
    return await db.delete('order_completion', where: 'id = ?', whereArgs: [id]);
  }
}
