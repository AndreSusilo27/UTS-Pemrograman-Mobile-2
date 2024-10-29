import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pemmob2/db/db.dart';

class UbahProfile extends StatefulWidget {
  final int userId;
  const UbahProfile({super.key, required this.userId});

  @override
  _UbahProfileState createState() => _UbahProfileState();
}

class _UbahProfileState extends State<UbahProfile> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? email;
  String? address;
  String? phone;
  String? photoUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Load data profil pengguna saat halaman dibuka
  }

  Future<void> _loadUserProfile() async {
    final db = DatabaseHelper.instance;
    final profile = await db.database.then((db) => db.query(
          'user_profiles',
          where: 'iduser = ?',
          whereArgs: [widget.userId],
        ));

    if (profile.isNotEmpty) {
      setState(() {
        name = profile[0]['nama'] as String?;
        email = profile[0]['email'] as String?;
        address = profile[0]['alamat'] as String?;
        phone = profile[0]['notlp'] as String?;
        photoUrl = profile[0]['foto'] as String?;
      });
    }
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        photoUrl = pickedImage.path; // Simpan path foto yang dipilih
      });
    }
  }

  Future<void> _updateProfile() async {
    // Validasi form terlebih dahulu
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final db = DatabaseHelper.instance;

      try {
        // Simpan data ke database
        await db.database.then((db) => db.update(
              'user_profiles',
              {
                'nama': name,
                'email': email,
                'alamat': address,
                'notlp': phone,
                'foto': photoUrl, // Path foto baru jika ada
              },
              where: 'iduser = ?',
              whereArgs: [widget.userId],
            ));

        // Ambil data terbaru dari tabel setelah pembaruan
        final updatedProfile = await db.database.then((db) => db.query(
              'user_profiles',
              where: 'iduser = ?',
              whereArgs: [widget.userId],
            ));

        if (updatedProfile.isNotEmpty) {
          // Mengambil data dari hasil query
          final userId = updatedProfile[0]['iduser'];

          // Navigasi kembali ke Dashboard dan memicu refresh
          Navigator.pop(context, {'userId': userId, 'success': true});
        } else {
          throw Exception('Profil tidak ditemukan');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui profil: $e')),
        );
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email wajib diisi';
    }
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubah Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                          ? FileImage(File(photoUrl!))
                          : null,
                      backgroundColor: Colors.grey.shade300,
                      child: photoUrl == null
                          ? const Icon(Icons.manage_accounts_sharp,
                              size: 50, color: Colors.white)
                          : null,
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 4,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama wajib diisi' : null,
                onSaved: (value) => name = value,
              ),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: _validateEmail,
                onSaved: (value) => email = value,
              ),
              TextFormField(
                initialValue: address,
                decoration: const InputDecoration(labelText: 'Alamat'),
                onSaved: (value) => address = value,
              ),
              TextFormField(
                initialValue: phone,
                decoration: const InputDecoration(labelText: 'No. Telp'),
                onSaved: (value) => phone = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
