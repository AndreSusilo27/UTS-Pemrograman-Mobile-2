import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pemmob2/db/db.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:pemmob2/model/notifications_widget.dart';
import 'package:pemmob2/screens/barangkeluar.dart';
import 'package:pemmob2/screens/barangmasuk.dart';
import 'package:pemmob2/screens/penjadwalan.dart';
import 'package:pemmob2/screens/laporan.dart';
import 'package:pemmob2/screens/login.dart';
import 'package:pemmob2/screens/profile.dart';
import 'package:pemmob2/screens/tambahbarang.dart';
import 'package:pemmob2/screens/ubahprofile.dart';
import 'package:pemmob2/screens/tentang.dart';

import 'package:pemmob2/model/costumcontainer.dart';
import 'package:pemmob2/model/grid.dart';
import 'package:pemmob2/model/listview.dart';
import 'package:pemmob2/model/modelcolor.dart';

import 'dart:math' as math;
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';

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

  List<Map<String, dynamic>> schedules = [
    {
      'title': 'Restock Barang',
      'item': 'Keyboard Mechanical',
      'date': DateTime.now().toIso8601String(),
      'quantity': 10,
      'completed': false,
    },
    {
      'title': 'Restock Barang',
      'item': 'Mouse Wireless',
      'date': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
      'quantity': 5,
      'completed': false,
    },
    {
      'title': 'Pengiriman Barang',
      'item': 'Mouse Logitech Wireless',
      'date': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
      'quantity': 20,
      'completed': false,
    },
    {
      'title': 'Pengambilan Barang',
      'item': 'Keyboard Mechanical Custume',
      'date': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
      'quantity': 15,
      'completed': false,
    },
    {
      'title': 'Restock Barang',
      'item': 'Laptop Acer Nitro 5',
      'date': DateTime.now().toIso8601String(),
      'quantity': 10,
      'completed': false,
    },
    {
      'title': 'Restock Barang',
      'item': 'Laptop Acer Special Edition',
      'date':
          DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'quantity': 50,
      'completed': true,
    },
  ];

  // Fungsi untuk menandai tugas selesai
  void completeSchedule(Map<String, dynamic> schedule) {
    setState(() {
      final index = schedules.indexOf(schedule);
      if (index != -1) {
        schedules[index]['completed'] = true;
      }
    });
  }

  // Fungsi untuk menghapus notifikasi
  void deleteSchedule(Map<String, dynamic> schedule) {
    setState(() {
      schedules.remove(schedule);
    });
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
            Color.fromARGB(255, 216, 164, 8), // 1
            Color.fromARGB(255, 255, 196, 19), // 2
            Colors.amber, // 3
            Colors.deepOrange,
          ],
          duration: Duration(seconds: 7),
          transform:
              GradientRotation(math.pi / 4), // Menambahkan transformasi rotasi
        ),
        backgroundColor: Modelcolor.primaryDark,
        actions: [
          notificationsIcon(
            context: context,
            schedules: schedules,
            onComplete: completeSchedule,
            onDelete: deleteSchedule,
          ),
          const SizedBox(width: 10),
          // Foto di pojok kanan AppBar
          Padding(
            padding: const EdgeInsets.only(right: 22.0),
            child: CircleAvatar(
              radius: 18, // Ukuran lingkaran
              backgroundImage: (_foto.isNotEmpty && File(_foto).existsSync())
                  ? FileImage(File(_foto))
                  : const AssetImage('assets/default_avatar.jpeg')
                      as ImageProvider<Object>,
              backgroundColor: Modelcolor.backgroundDark,
            ),
          ),
        ],
        elevation: 5,
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.52,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bghome2.jpg'),
              fit: BoxFit.cover,
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
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.4), // Shadow cerah
                      blurRadius: 8, // Radius blur shadow
                      spreadRadius: 2, // Sebarannya
                      offset: const Offset(0, 4), // Posisi shadow
                    ),
                  ],
                  image: const DecorationImage(
                    image: AssetImage('assets/avatar.jpg'),
                    fit: BoxFit.cover,
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
                icon: Icons.calendar_month_outlined,
                title: "Jadwal Restok",
                context: context,
                destinationPage: const JadwalRestokPage(),
                iconColor: Colors.white,
                textColor: Colors.white,
                tileColor: Colors.deepPurple.shade600,
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
                icon: Icons.local_shipping_rounded,
                title: "Barang Masuk",
                context: context,
                destinationPage: const BarangMasukPage(),
                iconColor: Colors.white,
                textColor: Colors.white,
                tileColor: Colors.deepPurple.shade600,
              ),
              customListTile(
                icon: Icons.move_to_inbox_sharp,
                title: "Barang Keluar",
                context: context,
                destinationPage: const BarangKeluarPage(),
                iconColor: Colors.white,
                textColor: Colors.white,
                tileColor: Colors.deepPurple.shade600,
              ),
              customListTile(
                icon: Icons.assignment_rounded,
                title: "Laporan",
                context: context,
                destinationPage: const LaporanPage(),
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
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bghome2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ListView(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Dashboard",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                            shadows: [
                              Shadow(
                                blurRadius: 3.0,
                                color: Colors.black26,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Inventory Summary Section
                        Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepPurpleAccent.shade100,
                                Colors.deepPurpleAccent.shade200,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurpleAccent.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "Ringkasan Inventory",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildSummaryCard(
                                    title: "Pendapatan",
                                    value: "108500000",
                                    icon: Icons.account_balance_wallet_rounded,
                                    iconColor: Colors.green,
                                    titleColor: Colors.black,
                                    valueColor: Colors.green,
                                  ),
                                  _buildSummaryCard(
                                    title: "Pengeluaran",
                                    value: "1250000",
                                    icon: Icons.monetization_on_rounded,
                                    iconColor: Colors.red,
                                    titleColor: Colors.black,
                                    valueColor: Colors.redAccent,
                                  ),
                                  _buildSummaryCard(
                                    title: "Stok Rendah",
                                    value: "3",
                                    icon: Icons.warning,
                                    iconColor: Colors.orange,
                                    titleColor: Colors.black,
                                    valueColor: Colors.amber,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const Divider(color: Colors.deepPurple, height: 20),
                        const SizedBox(height: 10),

                        // Statistik Section
                        Customcontainer.widgetContainer(
                          context,
                          Costumlistview.horizontalListView(context),
                          title: "Statistik",
                          height: 255,
                          isCentered: true,
                        ),
                        const Divider(color: Colors.deepPurple, height: 20),
                        const SizedBox(height: 30),

                        // Tab Section
                        const Text(
                          "Grafik Penjualan",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                            shadows: [
                              Shadow(
                                blurRadius: 3.0,
                                color: Colors.black26,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade100,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.deepPurple.withOpacity(0.2),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TabBar(
                                  indicator: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.deepPurple.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  labelColor: Colors.deepPurple.shade700,
                                  unselectedLabelColor:
                                      Colors.deepPurple.shade300,
                                  labelStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                  tabs: const [
                                    Tab(text: "Presentase"),
                                    Tab(text: "Jumlah"),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  border: Border.all(
                                      color: Colors.deepPurple.shade300,
                                      width: 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.deepPurple.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: TabBarView(
                                    children: [
                                      pieChart(context),
                                      barChart(context),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(color: Colors.deepPurple, height: 20),
                        const SizedBox(height: 30),

                        const Text(
                          "Stok & Produk",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                            shadows: [
                              Shadow(
                                blurRadius: 3.0,
                                color: Colors.black26,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        Customcontainer.widgetContainer(
                          height: 370,
                          context,
                          Costumgrid.produkTabel(context),
                          title: "Stok",
                          isCentered: true,
                        ),

                        const SizedBox(height: 10),
                        Customcontainer.widgetContainer(
                          height: 499,
                          context,
                          Costumgrid.verticalGrid(context),
                          title: "Produk",
                          isCentered: true,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Widget for Summary Cards
Widget _buildSummaryCard({
  required String title,
  required String value,
  required IconData icon,
  required Color iconColor,
  required Color titleColor,
  required Color valueColor, // Menambahkan parameter untuk warna value
}) {
  return Container(
    width: 100,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 30, color: iconColor), // Warna ikon
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color:
                valueColor, // Menggunakan warna yang dapat disesuaikan untuk value
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: titleColor
                .withOpacity(0.7), // Warna teks untuk title dengan opasitas
          ),
        ),
      ],
    ),
  );
}

Widget customListTile({
  required IconData icon,
  required String title,
  required BuildContext context,
  Color iconColor = Colors.white,
  Color textColor = Colors.white,
  Color tileColor = Colors.deepPurple,
  VoidCallback? onTap,
  Widget? destinationPage,
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destinationPage),
            );
          }
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
                    'Mouse: Produk dengan penjualan tertinggi (40%).',
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
                    'Laptop: Menyumbang 30% dari total penjualan.',
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
                    'Kabel USB: Menyumbang 20% dari total penjualan.',
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
                    'Keyboard: Menyumbang 10% dari total penjualan.',
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
            'Jumlah Penjualan per Ketegori',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                height: 400,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 50,
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      horizontalInterval: 5,
                      getDrawingHorizontalLine: (value) {
                        return const FlLine(
                          color: Colors.grey,
                          strokeWidth: 0.5,
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
                                return const Text('Mouse',
                                    style: TextStyle(fontSize: 8));
                              case 2:
                                return const Text('Laptop',
                                    style: TextStyle(fontSize: 8));
                              case 3:
                                return const Text('Kabel USB',
                                    style: TextStyle(fontSize: 8));
                              case 4:
                                return const Text('Keyboard',
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
                          toY: 44,
                          color: Colors.blueAccent,
                          width: 15,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                        ),
                      ]),
                      BarChartGroupData(x: 2, barRods: [
                        BarChartRodData(
                          toY: 40,
                          color: Colors.redAccent,
                          width: 15,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                        ),
                      ]),
                      BarChartGroupData(x: 3, barRods: [
                        BarChartRodData(
                          toY: 33,
                          color: Colors.greenAccent.shade700,
                          width: 15,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                        ),
                      ]),
                      BarChartGroupData(x: 4, barRods: [
                        BarChartRodData(
                          toY: 25,
                          color: Colors.amber.shade600,
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
            'Jumlah penjualan produk dalam mencakup berbagai kategori seperti Laptop, Mouse, Keyboard, dan Kabel USB.',
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ],
      ),
    ),
  );
}
