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
          ('BRG001', 'Laptop Dell XPS', 15, '2024-11-13', 'Barang baru dari supplier', 'assets/laptop_dell.jpeg'),
          ('BRG002', 'Mouse Logitech Wireless', 25, '2024-11-12', 'Stok tambahan', 'assets/mouse_logitech_wireless.jpeg'),
          ('BRG003', 'Keyboard Mechanical', 20, '2024-11-15', 'Barang populer', 'assets/keyboard_mechanical.png'),
          ('BRG004', 'Mouse Wireless', 35, '2024-11-10', 'Stok tambahan', 'assets/mouse_wireless.jpeg'),
          ('BRG005', 'Keyboard Mechanical RGB', 17, '2024-11-11', 'Barang populer', 'assets/keyboard_mechanical_rgb.jpeg'),
          ('BRG006', 'Laptop Acer Nitro 5', 12, '2024-11-13', 'Barang baru dari supplier', 'assets/laptop_acer_nitro_5.jpeg'),
          ('BRG007', 'Laptop Acer Special Edition', 50, '2024-11-13', 'Barang baru dari supplier', 'assets/laptop_acer_se.jpeg'),
          ('BRG008', 'Kabel USB Type C', 55, '2024-11-09', 'Barang baru dari supplier', 'assets/usb_type_c.jpeg'),
          ('BRG009', 'Kabel USB Type A', 30, '2024-11-10', 'Barang baru dari supplier', 'assets/usb_type_a.jpeg'),
          ('BRG010', 'Mouse Logitech M100r', 28, '2024-11-12', 'Stok tambahan', 'assets/mouse_logitech.jpeg'),
          ('BRG011', 'Keyboard Mechanical Costume', 18, '2024-11-09', 'Barang populer', 'assets/keyboard_mechanical_costume.jpeg');
        ''');

          // Menambahkan data awal ke tabel barang_keluar
          await db.rawInsert('''
          INSERT INTO barang_keluar (kodeBarang, namaBarang, jumlahKeluar, tanggalKeluar, keterangan, foto)
          VALUES
          ('BRG001', 'Laptop Dell XPS', 8, '2024-11-18', 'Pengiriman ke cabang', 'assets/laptop_dell.jpeg'),
          ('BRG002', 'Mouse Logitech Wireless', 17, '2024-11-17', 'Dijual ke pelanggan', 'assets/mouse_logitech_wireless.jpeg'),
          ('BRG003', 'Keyboard Mechanical', 7, '2024-11-16', 'Barang populer', 'assets/keyboard_mechanical.png'),
          ('BRG004', 'Mouse Wireless', 15, '2024-11-19', 'Barang populer', 'assets/mouse_wireless.jpeg'),
          ('BRG005', 'Keyboard Mechanical RGB', 12, '2024-11-17', 'Barang populer', 'assets/keyboard_mechanical_rgb.jpeg'),
          ('BRG006', 'Laptop Acer Nitro 5', 5, '2024-11-17', 'Dijual ke pelanggan', 'assets/laptop_acer_nitro_5.jpeg'),
          ('BRG007', 'Laptop Acer Special Edition', 27, '2024-11-13', 'Pengiriman ke cabang', 'assets/laptop_acer_se.jpeg'),
          ('BRG008', 'Kabel USB Type C', 22, '2024-11-14', 'Barang populer', 'assets/usb_type_c.jpeg'),
          ('BRG009', 'Kabel USB Type A', 11, '2024-11-12', 'Pengiriman ke cabang', 'assets/usb_type_a.jpeg'),
          ('BRG010', 'Mouse Logitech M100r', 12, '2024-11-14', 'Dijual ke pelanggan', 'assets/mouse_logitech.jpeg'),
          ('BRG011', 'Keyboard Mechanical Costume', 6, '2024-11-12', 'Dijual ke pelanggan', 'assets/keyboard_mechanical_costume.jpeg');
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
