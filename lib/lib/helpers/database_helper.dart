import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('smc_trading_journal.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE trades (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dateTime TEXT NOT NULL,
        pair TEXT NOT NULL,
        position TEXT NOT NULL,
        entryPrice REAL NOT NULL,
        stopLoss REAL NOT NULL,
        takeProfit REAL NOT NULL,
        lot REAL NOT NULL,
        result TEXT NOT NULL,
        profitOrLoss REAL NOT NULL,
        reason TEXT,
        smcSetup TEXT,
        imageBefore TEXT,
        imageAfter TEXT,
        emotion TEXT,
        isPlanFollowed TEXT,
        isSlFollowed TEXT
      )
    ''');
  }

  Future<int> insertTrade(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('trades', row);
  }

  Future<List<Map<String, dynamic>>> queryAllTrades() async {
    final db = await instance.database;
    return await db.query('trades', orderBy: 'dateTime DESC');
  }

  Future<int> updateTrade(Map<String, dynamic> row) async {
    final db = await instance.database;
    int id = row['id'];
    return await db.update('trades', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTrade(int id) async {
    final db = await instance.database;
    return await db.delete('trades', where: 'id = ?', whereArgs: [id]);
  }

  Future<close> closeDB() async {
    final db = await _database;
    if (db != null) {
      await db.close();
    }
  }
}
