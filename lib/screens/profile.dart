import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pemmob2/screens/ubahprofile.dart';
import 'package:pemmob2/db/db.dart';

class ProfilePage extends StatefulWidget {
  final int userId;
  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _Datalengkap();
  }

  Future<void> _Datalengkap() async {
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
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Kondisi untuk menampilkan foto profil atau default jika foto kosong
              userData!['foto'] != null && userData!['foto'].isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        File(userData!['foto']),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/default_avatar.jpeg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
              const SizedBox(height: 10),
              Text(userData!['username'], style: const TextStyle(fontSize: 20)),
              Text('Nama: ${userData!['nama']}'),
              Text('Email: ${userData!['email']}'),
              Text('Alamat: ${userData!['alamat']}'),
              Text('No. Telp: ${userData!['notlp']}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UbahProfile(userId: widget.userId),
                    ),
                  );
                },
                child: const Text('Ubah Profil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
