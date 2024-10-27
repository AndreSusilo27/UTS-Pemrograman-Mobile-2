import 'package:flutter/material.dart';
import 'package:pemmob2/db/db.dart';

class Dashboard extends StatefulWidget {
  final String username;

  const Dashboard({super.key, required this.username});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  String _nama = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  Future<void> _getUserProfile() async {
    var user = await _databaseHelper.getUserByUsername(widget.username);
    if (user != null) {
      setState(() {
        _nama = user['nama'] ?? '';
        _email = user['email'] ?? '';
      });
    }
  }

  void _logout() {
    Navigator.pop(context); // Logika logout kembali ke halaman login
  }

  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Dashboard(username: widget.username)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _goToProfile,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: const AssetImage('assets/default_avatar.png'),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _nama.isNotEmpty ? _nama : 'Nama Pengguna',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _email.isNotEmpty ? _email : 'Email Anda',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
