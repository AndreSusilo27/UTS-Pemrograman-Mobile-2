import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:pemmob2/db/db.dart';

class ProfilePage extends StatefulWidget {
  final int userId;

  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _datalengkap();
  }

  Future<void> _datalengkap() async {
    final db = DatabaseHelper.instance;
    final result = await db.database.then((db) => db.rawQuery('''
      SELECT users.username, user_profiles.nama, user_profiles.email, 
             user_profiles.alamat, user_profiles.notlp, user_profiles.foto
      FROM users
      INNER JOIN user_profiles ON users.id = user_profiles.iduser
      WHERE users.id = ?
    ''', [widget.userId]));

    if (result.isNotEmpty) {
      setState(() {
        userData = result.first;
      });
    } else {
      setState(() {
        userData = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Ubah Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple[900],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade600, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Kotak foto profil dengan efek
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
                // Foto profil
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white54, width: 3),
                    image: DecorationImage(
                      image: userData!['foto'] != null &&
                              userData!['foto'].isNotEmpty
                          ? FileImage(File(userData!['foto']))
                          : const AssetImage('assets/default_avatar.jpeg')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Username dengan efek animasi dan '@' di depan
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  '@${userData!['username']}',
                  textStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Colors.blueAccent, Colors.lightBlueAccent],
                      ).createShader(
                          const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  ),
                  speed: const Duration(milliseconds: 170),
                ),
              ],
              isRepeatingAnimation: false,
            ),
            const SizedBox(height: 20),

            // Informasi profil dalam card
            Card(
              color: Colors.white.withOpacity(0.17),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileInfo('Nama', userData!['nama']),
                    _buildProfileInfo('Email', userData!['email']),
                    _buildProfileInfo('Alamat', userData!['alamat']),
                    _buildProfileInfo('No. Telp', userData!['notlp']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              title,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value ?? 'Tidak ada data',
              style: GoogleFonts.roboto(
                color: const Color.fromARGB(214, 255, 255, 255),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
