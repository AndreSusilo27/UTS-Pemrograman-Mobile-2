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
            keterangan TEXT
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
            keterangan TEXT
          )
        ''');

        // Menambahkan data awal ke tabel barang_masuk
        await db.insert('barang_masuk', {
          'kodeBarang': 'BRG001',
          'namaBarang': 'Laptop Dell XPS',
          'jumlahMasuk': 5,
          'tanggalMasuk': '2024-01-15',
          'keterangan': 'Barang baru dari supplier'
        });
        await db.insert('barang_masuk', {
          'kodeBarang': 'BRG002',
          'namaBarang': 'Mouse Logitech',
          'jumlahMasuk': 20,
          'tanggalMasuk': '2024-01-20',
          'keterangan': 'Stok tambahan'
        });
        await db.insert('barang_masuk', {
          'kodeBarang': 'BRG003',
          'namaBarang': 'Keyboard Mechanical',
          'jumlahMasuk': 10,
          'tanggalMasuk': '2024-01-25',
          'keterangan': 'Barang populer'
        });
        await db.insert('barang_masuk', {
          'kodeBarang': 'BRG004',
          'namaBarang': 'Monitor LG 24"',
          'jumlahMasuk': 7,
          'tanggalMasuk': '2024-02-01',
          'keterangan': 'Barang baru'
        });
        await db.insert('barang_masuk', {
          'kodeBarang': 'BRG005',
          'namaBarang': 'Printer Epson L360',
          'jumlahMasuk': 3,
          'tanggalMasuk': '2024-02-05',
          'keterangan': 'Penggantian stok lama'
        });

        // Menambahkan data awal ke tabel barang_keluar
        await db.insert('barang_keluar', {
          'kodeBarang': 'BRG001',
          'namaBarang': 'Laptop Dell XPS',
          'jumlahKeluar': 2,
          'tanggalKeluar': '2024-01-18',
          'keterangan': 'Pengiriman ke cabang'
        });
        await db.insert('barang_keluar', {
          'kodeBarang': 'BRG002',
          'namaBarang': 'Mouse Logitech',
          'jumlahKeluar': 15,
          'tanggalKeluar': '2024-01-22',
          'keterangan': 'Dijual ke pelanggan'
        });
        await db.insert('barang_keluar', {
          'kodeBarang': 'BRG003',
          'namaBarang': 'Keyboard Mechanical',
          'jumlahKeluar': 5,
          'tanggalKeluar': '2024-01-28',
          'keterangan': 'Pesanan online'
        });
        await db.insert('barang_keluar', {
          'kodeBarang': 'BRG004',
          'namaBarang': 'Monitor LG 24"',
          'jumlahKeluar': 3,
          'tanggalKeluar': '2024-02-03',
          'keterangan': 'Permintaan pelanggan tetap'
        });
        await db.insert('barang_keluar', {
          'kodeBarang': 'BRG005',
          'namaBarang': 'Printer Epson L360',
          'jumlahKeluar': 1,
          'tanggalKeluar': '2024-02-07',
          'keterangan': 'Penggantian barang rusak'
        });
      },
    );
  }

  // Fungsi untuk mengambil data barang keluar
  Future<List<Map<String, dynamic>>> getBarangKeluar() async {
    final db = await database;
    return await db.query('barang_keluar');
  }

  // Fungsi untuk mengambil data barang masuk
  Future<List<Map<String, dynamic>>> getBarangMasuk() async {
    final db = await database;
    return await db.query('barang_masuk');
  }

  // Fungsi untuk menambahkan data barang keluar
  Future<void> insertData(String table, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(table, data);
  }

  // Fungsi untuk mengupdate data barang keluar
  Future<void> updateBarangKeluar(int id, Map<String, dynamic> data) async {
    final db = await database;
    await db.update(
      'barang_keluar',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Fungsi untuk mengupdate data barang masuk
  Future<void> updateBarangMasuk(int id, Map<String, dynamic> data) async {
    final db = await database;
    await db.update(
      'barang_masuk',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
