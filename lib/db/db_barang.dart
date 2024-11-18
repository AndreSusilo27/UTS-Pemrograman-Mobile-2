import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'barang.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          // Membuat tabel barang_keluar
          await db.execute('''
          CREATE TABLE barang_keluar (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            kodeBarang TEXT,
            namaBarang TEXT,
            jumlahKeluar INTEGER,
            tanggalKeluar TEXT,
            keterangan TEXT,
            foto TEXT DEFAULT 'assets/default_avatar.jpeg'
          )
          ''');

          // Membuat tabel barang_masuk
          await db.execute('''
          CREATE TABLE barang_masuk (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            kodeBarang TEXT,
            namaBarang TEXT,
            jumlahMasuk INTEGER,
            tanggalMasuk TEXT,
            keterangan TEXT,
            kategori TEXT,
            foto TEXT DEFAULT 'assets/default_avatar.jpeg'
          )
          ''');

          // Menambahkan data awal ke tabel barang_masuk
          await db.rawInsert('''
            INSERT INTO barang_masuk (kodeBarang, namaBarang, jumlahMasuk, tanggalMasuk, keterangan, foto)
            VALUES
            ('BRG001', 'Laptop Dell XPS', 50, '2024-01-15', 'Barang baru dari supplier', 'assets/default_avatar.jpeg'),
            ('BRG002', 'Mouse Logitech', 30, '2024-01-20', 'Stok tambahan', 'assets/default_avatar.jpeg'),
            ('BRG003', 'Keyboard Mechanical', 20, '2024-01-25', 'Barang populer', 'assets/default_avatar.jpeg'),
            ('BRG004', 'Mouse Wireless', 50, '2024-01-20', 'Stok tambahan', 'assets/default_avatar.jpeg'),
            ('BRG005', 'Keyboard Mechanical2', 20, '2024-01-25', 'Barang populer', 'assets/default_avatar.jpeg')
          ''');

          // Menambahkan data awal ke tabel barang_keluar
          await db.rawInsert('''
            INSERT INTO barang_keluar (kodeBarang, namaBarang, jumlahKeluar, tanggalKeluar, keterangan, foto)
            VALUES
            ('BRG001', 'Laptop Dell XPS', 24, '2024-01-18', 'Pengiriman ke cabang', 'assets/default_avatar.jpeg'),
            ('BRG002', 'Mouse Logitech', 12, '2024-01-22', 'Dijual ke pelanggan', 'assets/default_avatar.jpeg'),
            ('BRG003', 'Keyboard Mechanical', 16, '2024-01-25', 'Barang populer', 'assets/default_avatar.jpeg'),
            ('BRG004', 'Mouse Wireless', 50, '2024-01-20', 'Barang populer', 'assets/default_avatar.jpeg'),
            ('BRG005', 'Keyboard Mechanical2', 20, '2024-01-25', 'Barang populer', 'assets/default_avatar.jpeg')
          ''');
        },
      );
    } catch (e) {
      debugPrint("Error opening database: $e");
      rethrow;
    }
  }

  // Fungsi untuk mengambil data barang keluar
  Future<List<Map<String, dynamic>>> getBarangKeluar() async {
    try {
      final db = await database;
      return await db.rawQuery('SELECT * FROM barang_keluar');
    } catch (e) {
      debugPrint("Error fetching barang_keluar: $e");
      return [];
    }
  }

  // Fungsi untuk mengambil data barang masuk
  Future<List<Map<String, dynamic>>> getBarangMasuk() async {
    try {
      final db = await database;
      return await db.rawQuery('SELECT * FROM barang_masuk');
    } catch (e) {
      debugPrint("Error fetching barang_masuk: $e");
      return [];
    }
  }

  // Fungsi untuk menambahkan data baru ke tabel barang
  Future<void> insertData(String table, Map<String, dynamic> data) async {
    try {
      final db = await database;
      final columns = data.keys.join(', ');
      final placeholders = data.keys.map((_) => '?').join(', ');
      final values = data.values.toList();

      await db.rawInsert(
        'INSERT INTO $table ($columns) VALUES ($placeholders)',
        values,
      );
    } catch (e) {
      debugPrint("Error inserting into $table: $e");
    }
  }

  // Fungsi untuk mengupdate data barang keluar
  Future<void> updateBarangKeluar(int id, Map<String, dynamic> data) async {
    try {
      final db = await database;
      final updates = data.keys.map((key) => '$key = ?').join(', ');
      final values = data.values.toList()..add(id);

      await db.rawUpdate(
        'UPDATE barang_keluar SET $updates WHERE id = ?',
        values,
      );
    } catch (e) {
      debugPrint("Error updating barang_keluar: $e");
    }
  }

  // Fungsi untuk mengupdate data barang masuk
  Future<void> updateBarangMasuk(int id, Map<String, dynamic> data) async {
    try {
      final db = await database;
      final updates = data.keys.map((key) => '$key = ?').join(', ');
      final values = data.values.toList()..add(id);

      await db.rawUpdate(
        'UPDATE barang_masuk SET $updates WHERE id = ?',
        values,
      );
    } catch (e) {
      debugPrint("Error updating barang_masuk: $e");
    }
  }
}
