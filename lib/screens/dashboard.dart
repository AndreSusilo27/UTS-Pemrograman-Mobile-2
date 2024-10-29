import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pemmob2/db/db.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:pemmob2/screens/login.dart';
import 'package:pemmob2/screens/profile.dart';
import 'package:pemmob2/screens/ubahprofile.dart';
import 'package:pemmob2/screens/tentang.dart';

class Dashboard extends StatefulWidget {
  final String username;
  final String name;
  final String email;
  final String? foto; // Buat opsional dengan tipe nullable

  const Dashboard({
    super.key,
    required this.username,
    required this.name,
    required this.email,
    this.foto, // Foto tetap nullable
  });

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  String _nama = '';
  String _email = '';
  String _foto = 'assets/default_avatar.jpeg'; // Set foto default
  int? _userId;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _getUserProfile() async {
    var user = await _databaseHelper.getUserJoinedData(widget.username);
    if (user != null) {
      setState(() {
        _nama = user['nama'] ?? '';
        _email = user['email'] ?? '';
        _userId = user['id'];
        // Mengambil foto, jika ada
        _foto = user['foto'] != null && user['foto']!.isNotEmpty
            ? user['foto'] // Jika ada, gunakan foto dari database
            : 'assets/default_avatar.jpeg'; // Jika tidak ada, gunakan foto default
      });
    } else {
      print('Pengguna tidak ditemukan');
    }
  }

  Future<void> _refresh() async {
    await _getUserProfile();
  }

  Future<void> _openProfilePage(BuildContext context) async {
    _userId = await _databaseHelper.getIdUserByUsername(widget.username);

    if (_userId != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(userId: _userId!),
        ),
      );

      // Periksa jika hasilnya adalah true, maka panggil fungsi _refresh
      if (result != null && result == true) {
        setState(() {
          _refresh();
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID tidak ditemukan')),
      );
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Logout"),
          content: const Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Tidak"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Ya"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _openSettingsPage() async {
    _userId = await _databaseHelper.getIdUserByUsername(widget.username);

    if (_userId != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UbahProfile(userId: _userId!),
        ),
      );

      // Periksa jika hasilnya adalah true, maka panggil fungsi _refresh
      if (result != null && result == true) {
        setState(() {
          _refresh();
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID tidak ditemukan')),
      );
    }
  }

  Future<void> _showUserTableDialog() async {
    List<Map<String, dynamic>> users =
        await DatabaseHelper.instance.getAllUsers();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Daftar Pengguna"),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("ID")),
                DataColumn(label: Text("Username")),
                DataColumn(label: Text("Nama")),
                DataColumn(label: Text("Email")),
              ],
              rows: users.map((user) {
                return DataRow(cells: [
                  DataCell(Text(user['id'].toString())),
                  DataCell(Text(user['username'] ?? 'Tidak ada username')),
                  DataCell(Text(user['name'] ?? 'Tidak ada nama')),
                  DataCell(Text(user['email'] ?? 'Tidak ada email')),
                ]);
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Tutup"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.blueAccent, Colors.cyan],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            "Andre APP",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.deepPurple.shade600,
        actions: [
          IconButton(
            icon:
                const Icon(Icons.manage_accounts_outlined, color: Colors.white),
            onPressed: _openSettingsPage,
          ),
        ],
        elevation: 5,
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.66,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple.shade600,
                Colors.black87,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 37.0),
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade700,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(4, 6),
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple.shade700,
                      Colors.deepPurple.shade900,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundImage:
                          (_foto.isNotEmpty && File(_foto).existsSync())
                              ? FileImage(File(_foto))
                              : const AssetImage('assets/default_avatar.jpeg')
                                  as ImageProvider<Object>,
                      backgroundColor: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '@${widget.username}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        letterSpacing: 1.1,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [Colors.blueAccent, Colors.purpleAccent],
                          ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          _nama.isNotEmpty ? _nama : 'Nama Pengguna',
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                      ],
                      isRepeatingAnimation: false,
                    ),
                    const SizedBox(height: 6),
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          _email.isNotEmpty ? _email : 'Email Pengguna',
                          textStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                      ],
                      isRepeatingAnimation: false,
                    ),
                    const Divider(
                      color: Colors.white38,
                      thickness: 1,
                      height: 30,
                      indent: 50,
                      endIndent: 50,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle_outlined,
                    color: Colors.white),
                title: const Text("Profile",
                    style: TextStyle(color: Colors.white)),
                tileColor: Colors.deepPurple.shade600,
                onTap: () {
                  _openProfilePage(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white),
                title: const Text("Tentang Aplikasi",
                    style: TextStyle(color: Colors.white)),
                tileColor: Colors.deepPurple.shade600,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Tentang()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title:
                    const Text("Logout", style: TextStyle(color: Colors.white)),
                tileColor: Colors.deepPurple.shade600,
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple.shade400,
                Colors.black87,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Selamat Datang di Dashboard!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade700,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 6,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            _nama.isNotEmpty
                                ? "Nama: $_nama"
                                : "Nama: Tidak Ditemukan",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _email.isNotEmpty
                                ? "Email: $_email"
                                : "Email: Tidak Ditemukan",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton.icon(
                            onPressed: _showUserTableDialog,
                            icon: const Icon(Icons.table_chart,
                                color: Colors.white),
                            label: const Text(
                              "Tampilkan Tabel Pengguna",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.deepPurple.shade500,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
