import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Private constructor
  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  // Getter untuk mendapatkan instance database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inisialisasi database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Membuat tabel pengguna dan profil
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user_profiles(
        idbio INTEGER PRIMARY KEY AUTOINCREMENT,
        iduser INTEGER,
        nama TEXT NOT NULL,
        alamat TEXT,
        notlp TEXT,
        foto TEXT,
        FOREIGN KEY (iduser) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  // Menambahkan pengguna baru
  Future<void> insertUser(String username, String password) async {
    final db = await database;
    await db.insert(
      'users',
      {'username': username, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Menambahkan profil pengguna
  Future<void> insertUserProfile(
      int iduser, String nama, String alamat, String notlp, String foto) async {
    final db = await database;
    await db.insert(
      'user_profiles',
      {
        'iduser': iduser,
        'nama': nama,
        'alamat': alamat,
        'notlp': notlp,
        'foto': foto,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Mengambil semua pengguna
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // Mengambil pengguna berdasarkan username
  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return results.isNotEmpty ? results.first : null;
  }

  // Mengambil profil pengguna berdasarkan iduser
  Future<Map<String, dynamic>?> getUserProfile(int iduser) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'user_profiles',
      where: 'iduser = ?',
      whereArgs: [iduser],
    );
    return results.isNotEmpty ? results.first : null;
  }

  // Menghapus pengguna berdasarkan id
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
