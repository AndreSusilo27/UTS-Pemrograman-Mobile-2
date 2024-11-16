import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pemmob2/db/db.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:pemmob2/screens/login.dart';
import 'package:pemmob2/screens/profile.dart';
import 'package:pemmob2/screens/tambahbarang.dart';
import 'package:pemmob2/screens/ubahprofile.dart';
import 'package:pemmob2/screens/tentang.dart';

import 'dart:math' as math;
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:fl_chart/fl_chart.dart';

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
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  String _nama = '';
  String _email = '';
  String _foto = 'assets/default_avatar.jpeg'; // Set foto default
  int? _userId;

  int _selectedIndex = 0;

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
      debugPrint('Pengguna tidak ditemukan');
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Pindah halaman berdasarkan indeks yang dipilih
    switch (_selectedIndex) {
      case 0:
        // Tidak perlu memuat ulang halaman Dashboard jika sudah di Dashboard
        if (_selectedIndex != 0) {
          _navigateToPage(
              context,
              Dashboard(
                username: widget.username,
                name: widget.name,
                email: widget.email,
                foto: widget.foto,
              ));
        }
        break;
      case 1:
        // Navigasi ke halaman Profile dengan mengambil userId
        _openProfilePage(context);
        break;
      case 2:
        // Navigasi ke halaman Tentang
        _navigateToPage(context, const Tentang());
        break;
      case 3:
        // Navigasi ke halaman Ubah Profile dengan mengambil userId
        _openSettingsPage();
        break;
    }
  }

// Method untuk melakukan routing ke halaman tertentu
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> _refresh() async {
    await _getUserProfile();
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
        const SnackBar(content: Text('User ID tidak ditemukan')),
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
        title: const GradientAnimationText(
          text: Text(
            'Sikoin',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          colors: [
            Color.fromARGB(255, 207, 155, 1), // 1
            Colors.amber, // 2
            Colors.amber, // 3
            Colors.white,
          ],
          duration: Duration(seconds: 7),
          transform:
              GradientRotation(math.pi / 4), // Menambahkan transformasi rotasi
        ),
        backgroundColor: Colors.deepPurple.shade600,
        actions: [
          // IconButton(
          //   icon:
          //       const Icon(Icons.manage_accounts_outlined, color: Colors.white),
          //   onPressed: _openSettingsPage,
          // ),
          // Foto di pojok kanan AppBar
          Padding(
            padding: const EdgeInsets.only(right: 22.0),
            child: CircleAvatar(
              radius: 18, // Ukuran lingkaran
              backgroundImage: (_foto.isNotEmpty && File(_foto).existsSync())
                  ? FileImage(File(_foto))
                  : const AssetImage('assets/default_avatar.jpeg')
                      as ImageProvider<Object>,
              backgroundColor: Colors.grey[300],
            ),
          ),
        ],
        elevation: 5,
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.52,
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
            padding: const EdgeInsets.symmetric(vertical: 42.0),
            children: [
              Container(
                padding: const EdgeInsets.all(15.0),
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 12.0),
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
                            fontSize: 11,
                            color: Color.fromARGB(223, 255, 255, 255),
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
              customListTile(
                icon: Icons.assignment_add,
                title: "Tambah Barang",
                context: context,
                destinationPage: const TambahBarangPage(),
                iconColor: Colors.white,
                textColor: Colors.white,
                tileColor: Colors.deepPurple.shade600,
              ),
              customListTile(
                icon: Icons.account_circle_outlined,
                title: "Profile",
                context: context,
                onTap: () {
                  _openProfilePage(context);
                },
                iconColor: Colors.white,
                textColor: Colors.white,
                tileColor: Colors.deepPurple.shade600,
              ),
              customListTile(
                icon: Icons.manage_accounts_outlined,
                title: "Setting Profile",
                context: context,
                onTap: () {
                  _openSettingsPage();
                },
                iconColor: Colors.white,
                textColor: Colors.white,
                tileColor: Colors.deepPurple.shade600,
              ),
              customListTile(
                icon: Icons.info_outline_rounded,
                title: "Tentang",
                context: context,
                destinationPage: const Tentang(),
                iconColor: Colors.white,
                textColor: Colors.white,
                tileColor: Colors.deepPurple.shade600,
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
                      "Dashboard",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    widgetContainer(
                      context,
                      horizontalGrid(
                          context), // Memasukkan verticalGrid sebagai konten
                      title: "Statistik", // Judul yang diinginkan
                      height: 255,
                      isCentered: true, // Tinggi yang disesuaikan
                    ),
                    const SizedBox(height: 20),
                    DefaultTabController(
                      length: 5, // Jumlah tab
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade100,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TabBar(
                              indicator: BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.circular(
                                    5), // Sudut membulat pada indikator
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelColor: Colors.deepPurple.shade700,
                              unselectedLabelColor: Colors.deepPurple.shade300,
                              labelStyle: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                              tabs: const [
                                Tab(text: "List Grid"),
                                Tab(text: "List View"),
                                Tab(text: "Tabel Produk"),
                                Tab(text: "Pie Chart"),
                                Tab(text: "Bar Chart"),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              border: Border.all(
                                color: Colors.deepPurple.shade300,
                                width: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: TabBarView(
                                children: [
                                  verticalGrid(context),
                                  verticalListView(context),
                                  produkTabel(context),
                                  pieChart(context),
                                  barChart(context),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    widgetContainer(context, verticalGrid(context),
                        title: "Produk", isCentered: true),
                    const SizedBox(height: 20),
                    widgetContainer(context, verticalListView(context),
                        title: "Laporan", isCentered: true),
                    const SizedBox(height: 20),
                    widgetContainer(context, produkTabel(context),
                        title: "Stok", isCentered: true),
                    const SizedBox(height: 20),
                    horizontalGrid(context),
                    const SizedBox(height: 20),
                    // Informasi Pengguna
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
                                fontSize: 18, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _email.isNotEmpty
                                ? "Email: $_email"
                                : "Email: Tidak Ditemukan",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          TextButton.icon(
                            onPressed: _showUserTableDialog,
                            icon: const Icon(Icons.table_chart,
                                color: Colors.white),
                            label: const Text(
                              "Tampilkan Tabel Pengguna",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
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

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Dashboard"),
            selectedColor: Colors.deepPurple,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.account_circle),
            title: const Text("Profile"),
            selectedColor: Colors.teal,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.info_outline),
            title: const Text("Tentang"),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings),
            title: const Text("Ubah Profile"),
            selectedColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}

Widget customListTile({
  required IconData icon,
  required String title,
  required BuildContext context,
  Color iconColor = Colors.white,
  Color textColor = Colors.white,
  Color tileColor = Colors.deepPurple,
  VoidCallback? onTap, // Callback opsional untuk aksi
  Widget? destinationPage, // Halaman tujuan opsional
}) {
  return ListTile(
    leading: Icon(icon, color: iconColor),
    title: Text(
      title,
      style: TextStyle(color: textColor),
    ),
    tileColor: tileColor,
    onTap: onTap ??
        () {
          if (destinationPage != null) {
            // Navigasi ke halaman jika destinationPage disediakan
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destinationPage),
            );
          }
        },
  );
}

Widget widgetContainer(
  BuildContext context,
  Widget child, {
  String title = "Judul",
  bool isCentered = false,
  double? width, // Lebar yang dapat disesuaikan
  double? height, // Tinggi yang dapat disesuaikan
}) {
  return SizedBox(
    width: width, // Gunakan lebar yang diberikan, jika ada
    height: height ?? 340, // Gunakan tinggi yang diberikan, atau default 340
    child: Container(
      margin:
          const EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Margin luar
      padding: const EdgeInsets.all(10), // Padding dalam
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
            0.6), // Transparansi lebih banyak untuk container utama
        borderRadius: BorderRadius.circular(15), // Sudut membulat lebih besar
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Warna bayangan lebih gelap
            blurRadius: 15, // Tingkat blur bayangan yang lebih besar
            offset: const Offset(0, 6), // Posisi bayangan lebih terlihat
          ),
        ],
        border: Border.all(
          color: Colors.deepPurple
              .withOpacity(0.2), // Border lebih tipis dan transparan
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: isCentered
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start, // Menentukan posisi judul
        children: [
          Container(
            width: double.infinity, // Membuat background judul penuh
            padding: const EdgeInsets.symmetric(
                vertical: 8, horizontal: 12), // Padding dalam judul
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(
                  0.9), // Warna latar belakang judul dengan transparansi
              borderRadius: BorderRadius.circular(12), // Sudut membulat
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3), // Bayangan judul
                  blurRadius: 10, // Tingkat blur bayangan
                  offset: const Offset(0, 4), // Posisi bayangan judul
                ),
              ],
            ),
            child: Text(
              title, // Menggunakan parameter title untuk judul
              textAlign: isCentered
                  ? TextAlign.center
                  : TextAlign
                      .left, // Menentukan apakah teks di tengah atau tidak
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Warna teks judul
              ),
            ),
          ),
          const SizedBox(height: 10), // Spasi antara judul dan konten
          Expanded(child: child), // Konten yang bisa diisi dengan widget lain
        ],
      ),
    ),
  );
}

Widget produkTabel(BuildContext context) {
  final List<Map<String, dynamic>> productData = [
    {
      "name": "Laptop",
      "stock": "50",
      "category": "Elektronik",
      "price": "15,000,000"
    },
    {
      "name": "Meja Kantor",
      "stock": "20",
      "category": "Furniture",
      "price": "1,200,000"
    },
    {
      "name": "Printer",
      "stock": "10",
      "category": "Elektronik",
      "price": "2,300,000"
    },
    {
      "name": "Monitor",
      "stock": "25",
      "category": "Elektronik",
      "price": "3,500,000"
    },
    {
      "name": "Laptop",
      "stock": "50",
      "category": "Elektronik",
      "price": "15,000,000"
    },
    {
      "name": "Meja Kantor",
      "stock": "20",
      "category": "Furniture",
      "price": "1,200,000"
    },
    {
      "name": "Printer",
      "stock": "10",
      "category": "Elektronik",
      "price": "2,300,000"
    },
    {
      "name": "Monitor",
      "stock": "25",
      "category": "Elektronik",
      "price": "3,500,000"
    },
  ];

  return Container(
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    ),
    child: SingleChildScrollView(
      // Add horizontal scrolling
      scrollDirection: Axis.vertical, // Enable vertical scrolling
      child: SingleChildScrollView(
        // Add horizontal scrolling
        scrollDirection: Axis.horizontal, // Enable horizontal scrolling
        child: DataTable(
          columnSpacing: 20,
          columns: const [
            DataColumn(
              label: Text(
                "Nama",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "Stok",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "Kategori",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "Harga",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
          rows: productData.map((product) {
            return DataRow(cells: [
              DataCell(Text(product["name"])),
              DataCell(Text(product["stock"])),
              DataCell(Text(product["category"])),
              DataCell(Text(product["price"])),
            ]);
          }).toList(),
        ),
      ),
    ),
  );
}

// Fungsi untuk membuat Card statistik
Widget listViewStat(String title, String count, IconData icon, double d) {
  return Container(
    width: 100,
    padding: const EdgeInsets.all(15.0),
    decoration: BoxDecoration(
      color: Colors.deepPurple.shade500,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 6,
          offset: const Offset(2, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: const Color.fromARGB(255, 255, 255, 255)),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
              fontSize: 16, color: Color.fromARGB(255, 255, 255, 255)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        Text(
          count,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 41, 237, 6)),
        ),
      ],
    ),
  );
}

// Fungsi untuk membuat Card statistik
Widget gridStat(String title, String count, IconData icon) {
  return Container(
    padding: const EdgeInsets.all(15.0),
    decoration: BoxDecoration(
      color: Colors.deepPurple.shade500,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 6,
          offset: const Offset(2, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: const Color.fromARGB(255, 255, 255, 255)),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
              fontSize: 16, color: Color.fromARGB(255, 255, 255, 255)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        Text(
          count,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 41, 237, 6)),
        ),
      ],
    ),
  );
}

// Widget untuk GridView Horizontal dalam SizedBox
Widget horizontalGrid(BuildContext context) {
  List<Map<String, dynamic>> statData = [
    {
      "title": "Total Barang",
      "count": "150",
      "icon": Icons.inventory_2_outlined
    },
    {
      "title": "Barang Masuk",
      "count": "50",
      "icon": Icons.add_shopping_cart_outlined
    },
    {
      "title": "Barang Keluar",
      "count": "30",
      "icon": Icons.remove_shopping_cart_outlined
    },
    {"title": "Jumlah Produk", "count": "80", "icon": Icons.widgets_outlined},
    {
      "title": "Jumlah Kategori",
      "count": "20",
      "icon": Icons.category_outlined
    },
  ];

  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.2,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(statData.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: gridStat(
                statData[index]["title"],
                statData[index]["count"],
                statData[index]["icon"],
              ),
            ),
          );
        }),
      ),
    ),
  );
}

Widget verticalGrid(BuildContext context) {
  final items = List.generate(10, (index) => "Item ${index + 1}");

  return Padding(
    padding: const EdgeInsets.all(10),
    child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Dua kolom dalam grid
        crossAxisSpacing: 13,
        mainAxisSpacing: 13,
        childAspectRatio: 3 / 2, // Rasio lebar:tinggi
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              items[index],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    ),
  );
}

// Widget untuk GridView Horizontal dalam SizedBox
Widget horizontalListView(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.2,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      itemBuilder: (context, index) {
        List<Map<String, dynamic>> statData = [
          {
            "title": "Total Barang",
            "count": "150",
            "icon": Icons.inventory_2_outlined
          },
          {
            "title": "Barang Masuk",
            "count": "50",
            "icon": Icons.add_shopping_cart_outlined
          },
          {
            "title": "Barang Keluar",
            "count": "30",
            "icon": Icons.remove_shopping_cart_outlined
          },
          {
            "title": "Jumlah Produk",
            "count": "80",
            "icon": Icons.widgets_outlined
          },
          {
            "title": "Jumlah Kategori",
            "count": "20",
            "icon": Icons.category_outlined
          },
        ];
        return Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: listViewStat(
            statData[index]["title"],
            statData[index]["count"],
            statData[index]["icon"],
            MediaQuery.of(context).size.width * 0.21,
          ),
        );
      },
    ),
  );
}

Widget verticalListView(BuildContext context) {
  final items = List.generate(10, (index) => "Item ${index + 1}");

  return ListView.separated(
    padding: const EdgeInsets.all(16),
    itemCount: items.length,
    separatorBuilder: (context, index) => const SizedBox(height: 10),
    itemBuilder: (context, index) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              items[index],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Icon(Icons.arrow_forward, color: Colors.deepPurple),
          ],
        ),
      );
    },
  );
}

Widget pieChart(BuildContext context) {
  return SingleChildScrollView(
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Persentase Penjualan per Kategori',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 200, // Mengatur tinggi Pie Chart
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.blueAccent,
                      value: 40,
                      title: '40%',
                      titleStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.redAccent,
                      value: 30,
                      title: '30%',
                      titleStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.greenAccent.shade700,
                      value: 20,
                      title: '20%',
                      titleStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.amber.shade600,
                      value: 10,
                      title: '10%',
                      titleStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                  sectionsSpace: 3,
                  centerSpaceRadius: 60,
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Deskripsi Pie Chart
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  color: Colors.blueAccent,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Laptop: Produk dengan penjualan tertinggi (40%).',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  color: Colors.redAccent,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Smartphone: Menyumbang 30% dari total penjualan.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  color: Colors.greenAccent.shade700,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Televisi: Menyumbang 20% dari total penjualan.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  color: Colors.amber.shade600,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Aksesoris: Menyumbang 10% dari total penjualan.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget barChart(BuildContext context) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jumlah Penjualan per Produk',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 10),
          // Tambahkan SingleChildScrollView
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                height: 400, // Menyesuaikan tinggi sesuai kebutuhan
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 20, // Menyesuaikan skala untuk data lebih besar
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      horizontalInterval: 5,
                      getDrawingHorizontalLine: (value) {
                        return const FlLine(
                          color: Colors.grey, // Warna garis horizontal
                          strokeWidth: 0.5, // Ketebalan garis
                        );
                      },
                    ),
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 5,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.deepPurple,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 1:
                                return const Text('Laptop',
                                    style: TextStyle(fontSize: 8));
                              case 2:
                                return const Text('Smartphone',
                                    style: TextStyle(fontSize: 8));
                              case 3:
                                return const Text('Televisi',
                                    style: TextStyle(fontSize: 8));
                              case 4:
                                return const Text('Aksesoris',
                                    style: TextStyle(fontSize: 8));
                              case 5:
                                return const Text('Tablet',
                                    style: TextStyle(fontSize: 8));
                              case 6:
                                return const Text('Headphone',
                                    style: TextStyle(fontSize: 8));
                              default:
                                return const Text('');
                            }
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(
                          toY: 18,
                          color: Colors.blueAccent,
                          width: 15,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                        ),
                      ]),
                      BarChartGroupData(x: 2, barRods: [
                        BarChartRodData(
                          toY: 15,
                          color: Colors.redAccent,
                          width: 15,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                        ),
                      ]),
                      BarChartGroupData(x: 3, barRods: [
                        BarChartRodData(
                          toY: 12,
                          color: Colors.greenAccent.shade700,
                          width: 15,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                        ),
                      ]),
                      BarChartGroupData(x: 4, barRods: [
                        BarChartRodData(
                          toY: 10,
                          color: Colors.amber.shade600,
                          width: 15,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                        ),
                      ]),
                      BarChartGroupData(x: 5, barRods: [
                        BarChartRodData(
                          toY: 8,
                          color: Colors.cyan,
                          width: 15,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                        ),
                      ]),
                      BarChartGroupData(x: 6, barRods: [
                        BarChartRodData(
                          toY: 6,
                          color: Colors.pinkAccent,
                          width: 15,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Jumlah penjualan produk dalam kategori elektronik mencakup berbagai produk seperti Laptop, Smartphone, Televisi, dan lainnya.',
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ],
      ),
    ),
  );
}
