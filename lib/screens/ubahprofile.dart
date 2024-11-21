import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pemmob2/db/db.dart';
import 'package:pemmob2/model/modelcolor.dart';

class UbahProfile extends StatefulWidget {
  final int userId;

  const UbahProfile({super.key, required this.userId});

  @override
  State<UbahProfile> createState() => _UbahProfileState();
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
    _loadUserProfile();
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
        photoUrl = pickedImage.path;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final db = DatabaseHelper.instance;

      try {
        await db.database.then((db) => db.update(
              'user_profiles',
              {
                'nama': name,
                'email': email,
                'alamat': address,
                'notlp': phone,
                'foto': photoUrl ?? 'assets/default_avatar.jpeg',
              },
              where: 'iduser = ?',
              whereArgs: [widget.userId],
            ));

        Navigator.pop(context, {
          'nama': name,
          'email': email,
          'alamat': address,
          'notlp': phone,
          'foto': photoUrl ?? 'assets/default_avatar.jpeg',
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui profil: $e')),
        );
      }
    }
  }

  void _confirmUpdate() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content:
              const Text('Apakah Anda yakin ingin mengubah data tersebut?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateProfile();
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
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
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Setting Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Modelcolor.primaryDark,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _confirmUpdate,
          ),
        ],
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bghome2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: (photoUrl != null &&
                                  photoUrl!.isNotEmpty)
                              ? FileImage(File(photoUrl!))
                              : const AssetImage('assets/default_avatar.jpeg')
                                  as ImageProvider,
                          backgroundColor: Colors.grey.shade300,
                          child: photoUrl == null
                              ? const Icon(
                                  Icons.account_circle,
                                  size: 50,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const Positioned(
                          bottom: 0,
                          right: 4,
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.blueAccent,
                            child: Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: name ?? '',
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Nama wajib diisi' : null,
                    onSaved: (value) => name = value,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    initialValue: email ?? '',
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                    validator: _validateEmail,
                    onSaved: (value) => email = value,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    initialValue: address ?? '',
                    decoration: InputDecoration(
                      labelText: 'Alamat',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                    onSaved: (value) => address = value,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    initialValue: phone ?? '',
                    decoration: InputDecoration(
                      labelText: 'No. Telp',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                    onSaved: (value) => phone = value,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
