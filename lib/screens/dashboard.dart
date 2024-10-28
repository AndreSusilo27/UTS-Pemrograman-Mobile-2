import 'package:flutter/material.dart';
import 'package:pemmob2/db/db.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:pemmob2/screens/profile.dart';
import 'package:pemmob2/screens/ubahprofile.dart';
import 'package:pemmob2/screens/tentang.dart';

class Dashboard extends StatefulWidget {
  final String username;
  final String name;
  final String email;

  Dashboard({required this.username, required this.name, required this.email});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  String _nama = '';
  String _email = '';
  int? _userId;

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  Future<void> _getUserProfile() async {
    var user = await _databaseHelper.getUserJoinedData(widget.username);
    if (user != null) {
      setState(() {
        _nama = user['nama'] ?? '';
        _email = user['email'] ?? '';
        _userId = user['id'];
        // Tambahkan variabel lain sesuai dengan kolom yang ada di join
      });
    } else {
      print('Pengguna tidak ditemukan');
    }
  }

  Future<void> _refresh() async {
    await _getUserProfile();
  }

  void _navigateToProfile(BuildContext context) async {
    final userId = await _databaseHelper.getIdUserByEmail(widget.email);

    if (userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(userId: userId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID tidak ditemukan')),
      );
    }
  }

  void _logout() {
    Navigator.pop(context);
  }

  void _openSettingsPage() {
    if (_userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UbahProfile(userId: _userId!),
        ),
      );
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
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: _openSettingsPage,
          ),
        ],
        elevation: 5,
      ),
      // Tambahkan Future<void> _refresh(); di drawer agar data bisa ikut di refresh
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
            padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                      radius: 40,
                      backgroundImage: AssetImage('assets/default_avatar.jpeg'),
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
                          ..shader = LinearGradient(
                            colors: [Colors.blueAccent, Colors.purpleAccent],
                          ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
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
                tileColor: Colors.deepPurple.shade400.withOpacity(0.3),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToProfile(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.white),
                title:
                    const Text("About", style: TextStyle(color: Colors.white)),
                tileColor: Colors.deepPurple.shade400.withOpacity(0.3),
                onTap: () {
                  Navigator.pop(context);
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
                tileColor: Colors.deepPurple.shade400.withOpacity(0.3),
                onTap: () {
                  Navigator.pop(context);
                  _logout();
                },
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
