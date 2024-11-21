//Andre Susilo
//21552011246
//TIFRM22CID
//Pemrograman Mobile 2
//Aplikasi Sikoin Untuk Inventaris

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:pemmob2/screens/login.dart';
import 'package:pemmob2/model/costumcontainer.dart';

void main() {
  runApp(const Sikoin());
}

class Sikoin extends StatelessWidget {
  const Sikoin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sikoin',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;

  void _handleLogin() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bghome2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Customcontainer.widgetContainerWithGlow(
            context,
            width: 350,
            height: 480,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/home.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // App Name
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.amber, Colors.deepOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    'Sikoin',
                    style: TextStyle(
                      fontSize: 42.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          offset: Offset(0.0, 3.0),
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 15),

                // Welcome Text
                const Text(
                  'Selamat Datang di Aplikasi Sikoin',
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),

                // Animated Text
                AnimatedTextKit(
                  animatedTexts: [
                    _buildTypewriterText('Aplikasi Inventaris Modern'),
                    _buildTypewriterText('Kelola Bisnis Anda dengan Mudah'),
                    _buildTypewriterText('Sikoin: Solusi Bisnis Anda'),
                  ],
                  repeatForever: true,
                  pause: const Duration(seconds: 2),
                  displayFullTextOnTap: true,
                ),
                const SizedBox(height: 40),

                // Login Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    minimumSize: const Size(180, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 15,
                    shadowColor: Colors.black.withOpacity(0.5),
                    side: BorderSide(color: Colors.amber.shade600, width: 0.5),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          'Masuk',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

TypewriterAnimatedText _buildTypewriterText(String text) {
  return TypewriterAnimatedText(
    text,
    textStyle: const TextStyle(
      fontSize: 16.0,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
    speed: const Duration(milliseconds: 100),
  );
}
