import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:pemmob2/db/db.dart';
import 'package:pemmob2/model/modelcolor.dart';

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
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Modelcolor.primaryDark,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bghome2.jpg'),
            fit: BoxFit.cover,
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
                  height: 340,
                  width: 340,
                  padding: const EdgeInsets.all(15.0),
                  margin: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color:
                        Colors.white.withOpacity(0.1), // Warna cerah transparan
                    borderRadius:
                        BorderRadius.circular(20), // Sudut tidak lancip
                    border: Border.all(
                      color:
                          Colors.blueAccent.withOpacity(0.6), // Border menyala
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent
                            .withOpacity(0.4), // Shadow menyala lembut
                        blurRadius: 15, // Radius blur shadow
                        offset: const Offset(0, 5), // Posisi shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Foto Profil
                      Container(
                        width: 230,
                        height: 230,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white
                                .withOpacity(0.8), // Border putih untuk foto
                            width: 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.white.withOpacity(0.4), // Shadow putih
                              blurRadius: 8, // Blur shadow
                              offset: const Offset(0, 4), // Posisi shadow
                            ),
                          ],
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
                      const SizedBox(height: 20),

                      // Username dengan animasi
                      AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            '@${userData!['username']}',
                            textStyle: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Teks putih agar kontras
                              letterSpacing: 1.2,
                            ),
                            speed: const Duration(
                                milliseconds: 150), // Kecepatan animasi
                          ),
                        ],
                        isRepeatingAnimation: false, // Tidak berulang
                      ),
                    ],
                  ),
                ),
              ],
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
