import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'sensor_data.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sensor_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        value REAL,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<void> insertData(String type, double value) async {
    Database db = await database;
    await db.insert(
      'sensor_data',
      {'type': type, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchData(String type) async {
    Database db = await database;
    return await db.query(
      'sensor_data',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'timestamp DESC',
    );
  }
}


