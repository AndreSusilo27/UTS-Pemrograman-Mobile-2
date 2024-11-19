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
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = false;

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
    final bytes = utf8.encode(password + salt);
    return sha256.convert(bytes).toString();
  }

  // Fungsi registrasi user
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

    // Masukkan data ke tabel `user_profiles`
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

    // Validasi input
    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field harus diisi'),
          backgroundColor: Colors.red, // Warna merah untuk notifikasi gagal
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    const emailPattern = r'^[^@]+@[^@]+\.[^@]+';
    if (!RegExp(emailPattern).hasMatch(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Format email tidak valid'),
          backgroundColor: Colors.red, // Warna merah untuk notifikasi gagal
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_usernameController.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username harus lebih dari 3 karakter'),
          backgroundColor: Colors.red, // Warna merah untuk notifikasi gagal
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_passwordController.text.length < 7) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password harus lebih dari 6 karakter'),
          backgroundColor: Colors.red, // Warna merah untuk notifikasi gagal
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password dan konfirmasi tidak cocok'),
          backgroundColor: Colors.red, // Warna merah untuk notifikasi gagal
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      await registerUser(
        _usernameController.text,
        _passwordController.text,
        _nameController.text,
        _emailController.text,
      );

      // Notifikasi keberhasilan registrasi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi berhasil'),
          backgroundColor: Colors.green, // Warna hijau untuk notifikasi sukses
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      // Notifikasi kegagalan registrasi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registrasi gagal: ${e.toString()}'),
          backgroundColor: Colors.red, // Warna merah untuk notifikasi gagal
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bghome2.jpg'),
            fit: BoxFit.cover,
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
                  ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 50.0),
                      backgroundColor: Colors.deepPurple.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Daftar',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                  ),
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
