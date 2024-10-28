import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'users_secure.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        salt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user_profiles (
        idbio INTEGER PRIMARY KEY AUTOINCREMENT,
        iduser INTEGER NOT NULL,
        nama TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        alamat TEXT,
        notlp TEXT,
        foto TEXT,
        FOREIGN KEY (iduser) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  String _generateSalt() {
    final random = Random.secure();
    List<int> values = List<int>.generate(16, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  String _hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    return sha256.convert(bytes).toString();
  }

  Future<int> registerUser(
      String username, String password, String name, String email) async {
    final db = await database;

    var existingUser = await getUserByUsername(username);
    if (existingUser != null) {
      throw Exception('Username sudah terdaftar');
    }

    var emailCheck = await db.query(
      'user_profiles',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (emailCheck.isNotEmpty) {
      throw Exception('Email sudah terdaftar');
    }

    String salt = _generateSalt();
    String hashedPassword = _hashPassword(password, salt);

    try {
      int userId = await db.insert(
        'users',
        {
          'username': username,
          'password': hashedPassword,
          'salt': salt,
        },
      );

      await db.insert(
        'user_profiles',
        {
          'iduser': userId,
          'nama': name,
          'email': email,
          'alamat': '',
          'notlp': '',
          'foto': '',
        },
      );

      return userId;
    } catch (e) {
      throw Exception('Gagal mendaftarkan pengguna: $e');
    }
  }

  Future<Map<String, dynamic>?> authenticateAndFetchUser(
      String username, String password) async {
    final db = await database;

    final user = await getUserByUsername(username);
    if (user == null) return null;

    String salt = user['salt'];
    String hashedPassword = _hashPassword(password, salt);

    final result = await db.rawQuery('''
    SELECT users.id AS userId, users.username, user_profiles.nama AS name, user_profiles.email
    FROM users
    INNER JOIN user_profiles ON users.id = user_profiles.iduser
    WHERE users.username = ? AND users.password = ?
  ''', [username, hashedPassword]);

    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;

    // Query untuk mengambil data dari tabel user_profiles dan username dari tabel users
    final result = await db.rawQuery('''
    SELECT user_profiles.idbio AS id, 
           user_profiles.iduser, 
           user_profiles.nama AS name, 
           user_profiles.email, 
           users.username AS username
    FROM user_profiles
    INNER JOIN users ON users.id = user_profiles.iduser
  ''');

    return result;
  }

  Future<Map<String, dynamic>?> getUserJoinedData(String username) async {
    final db = await instance.database;

    final result = await db.rawQuery('''
    SELECT users.*, user_profiles.*
    FROM users
    JOIN user_profiles ON users.id = user_profiles.iduser
    WHERE users.username = ?
  ''', [username]);

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<int?> getIdUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'user_profiles',
      columns: ['iduser'],
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return result.first['iduser'] as int?;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
