import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:pemmob2/screens/dashboard.dart';
import 'package:pemmob2/screens/main.dart';
import 'package:pemmob2/screens/register.dart';
import 'package:pemmob2/db/db.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  int _loginAttempts = 0;
  final int _maxAttempts = 3;
  bool _isLocked = false;

  void _login() async {
    if (_isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Akun Anda terkunci sementara. Coba lagi nanti."),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset pesan error
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Validasi input
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Username dan password tidak boleh kosong.";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!)),
      );
      return;
    }

    try {
      // Mengotentikasi pengguna dan mengambil profil pengguna
      Map<String, dynamic>? userProfile = await DatabaseHelper.instance
          .authenticateAndFetchUser(username, password);

      // Reset loading state sebelum memeriksa hasil
      setState(() {
        _isLoading = false;
      });

      // Memeriksa apakah profil pengguna berhasil didapat
      if (userProfile != null) {
        _loginAttempts = 0; // Reset percobaan login jika berhasil

        // Check if the photo URL is empty or null, assign default if so
        String userPhoto = userProfile['foto']?.isNotEmpty == true
            ? userProfile['foto']
            : 'assets/default_avatar.jpeg'; // Default avatar path

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(
              username: userProfile['username'],
              name: userProfile['name'],
              email: userProfile['email'],
              foto: userPhoto, // Pass the correct photo
            ),
          ),
        );
      } else {
        // Jika pengguna tidak ada, tingkatkan percobaan login
        _loginAttempts++;
        if (_loginAttempts >= _maxAttempts) {
          setState(() {
            _isLocked = true; // Kunci akun
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "Akun terkunci sementara karena terlalu banyak percobaan gagal."),
              duration: Duration(seconds: 5),
            ),
          );

          // Reset kunci setelah 10 detik
          Future.delayed(const Duration(seconds: 10), () {
            setState(() {
              _isLocked = false;
              _loginAttempts = 0; // Reset percobaan
            });
          });
        } else {
          setState(() {
            _errorMessage =
                "Username atau password salah. Percobaan $_loginAttempts dari $_maxAttempts.";
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_errorMessage!)),
          );
        }
      }
    } catch (e) {
      // Menangani kesalahan yang mungkin terjadi
      setState(() {
        _isLoading = false; // Reset loading state
        _errorMessage = "Terjadi kesalahan, silakan coba lagi.";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan, silakan coba lagi.")),
      );
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
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Selamat Datang',
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
                  const SizedBox(height: 20),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 10),
                  _isLoading
                      ? const SpinKitCircle(
                          color: Colors.deepPurple,
                          size: 50.0,
                        )
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            backgroundColor: Colors.deepPurple.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      'Belum punya akun? Daftar di sini',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                    child: const Text(
                      'Beranda',
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
