import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:pemmob2/screens/login.dart';
import 'package:pemmob2/db/db.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController(); // Controller untuk nama
  final _emailController = TextEditingController(); // Controller untuk email

  bool _isLoading = false;

  get userId => null;

  // Fungsi untuk mendapatkan user berdasarkan username
  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await DatabaseHelper.instance.database;
    var result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Fungsi untuk membuat salt acak
  String _generateSalt() {
    const length = 16;
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)])
        .join();
  }

  // Fungsi untuk hashing password
  String _hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt); // Kombinasi password dan salt
    return sha256.convert(bytes).toString(); // Menghasilkan hash SHA-256
  }

  Future<Map<String, dynamic>> registerUser(
      String username, String password, String name, String email) async {
    final db = await DatabaseHelper.instance.database;

    // Periksa apakah username sudah terdaftar
    var existingUser = await getUserByUsername(username);
    if (existingUser != null) {
      throw Exception('Username sudah terdaftar');
    }

    // Periksa apakah email sudah terdaftar
    var emailCheck = await db.query(
      'user_profiles',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (emailCheck.isNotEmpty) {
      throw Exception('Email sudah terdaftar');
    }

    // Hash password dengan salt
    String salt = _generateSalt();
    String hashedPassword = _hashPassword(password, salt);

    // Masukkan data user ke tabel `users`
    int userId = await db.insert(
      'users',
      {
        'username': username,
        'password': hashedPassword,
        'salt': salt,
      },
    );

    // Masukkan data ke tabel `user_profiles` yang terhubung dengan `userId`
    await db.insert(
      'user_profiles',
      {
        'iduser': userId,
        'nama': name,
        'email': email,
        'alamat': '', // Optional: tambahkan sesuai kebutuhan
        'notlp': '',
        'foto': '',
      },
    );

    // Ambil data user yang baru saja ditambahkan menggunakan `JOIN`
    var result = await db.rawQuery('''
    SELECT users.id, users.username, user_profiles.nama, user_profiles.email
    FROM users
    INNER JOIN user_profiles ON users.id = user_profiles.iduser
    WHERE users.id = ?
  ''', [userId]);

    return result.first;
  }

  void _register() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print("Mulai proses registrasi..."); // Debug
      var userData = await registerUser(
        _usernameController.text,
        _passwordController.text,
        _nameController.text,
        _emailController.text,
      );

      print('Registrasi berhasil: $userData');

      // Pindah ke halaman login setelah berhasil registrasi
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      print('Registrasi gagal: $e'); // Tampilkan error jika ada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi gagal: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      print("Proses registrasi selesai."); // Debug
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade700,
              Colors.black,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10.0,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Animasi teks dengan efek kursor
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Daftar Akun Baru',
                        textStyle: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade700,
                        ),
                        speed: const Duration(milliseconds: 100),
                        cursor: '|',
                      ),
                    ],
                    totalRepeatCount: 1,
                  ),
                  const SizedBox(height: 20),
                  // Input field Nama
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Input field Email
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Input field Username
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Input field Password
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Input field Confirm Password
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tombol Register dengan animasi loading
                  _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.deepPurple,
                        )
                      : ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            backgroundColor: Colors.deepPurple.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: const Text(
                            'Daftar',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  // Tombol untuk kembali ke halaman login
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Sudah punya akun? Login di sini',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
