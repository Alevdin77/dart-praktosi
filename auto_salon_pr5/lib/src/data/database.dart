import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:sqlite3/sqlite3.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  Database _db;

  DatabaseHelper._internal(this._db);

  static Future<DatabaseHelper> init() async {
    if (_instance != null) return _instance!;
    String homeDir = Platform.environment['HOME'] ?? '.';
    String dbDir = '$homeDir/.local/share/auto_salon';
    await Directory(dbDir).create(recursive: true);
    String dbPath = path.join(dbDir, 'auto_salon.db');
    var db = sqlite3.open(dbPath);
    _instance = DatabaseHelper._internal(db);
    await _instance!._createTables();
    return _instance!;
  }

  Future<void> _createTables() async {
    _db.execute('''
      CREATE TABLE IF NOT EXISTS cars(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        brand TEXT NOT NULL,
        model TEXT NOT NULL,
        year INTEGER NOT NULL,
        price REAL NOT NULL
      )
    ''');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS customers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL
      )
    ''');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS sales(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        carId INTEGER NOT NULL,
        customerId INTEGER NOT NULL,
        saleDate TEXT NOT NULL,
        finalPrice REAL NOT NULL,
        FOREIGN KEY(carId) REFERENCES cars(id),
        FOREIGN KEY(customerId) REFERENCES customers(id)
      )
    ''');
  }

  Database get db => _db;

  void close() {
    _db.dispose();
  }
}