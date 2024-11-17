import 'package:flutter/material.dart';
import 'package:pemmob2/db/db_barang.dart';
import 'package:pemmob2/model/modelcolor.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> barangMasuk = [];
  List<Map<String, dynamic>> barangKeluar = [];
  List<Map<String, dynamic>> filteredBarang = [];
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String selectedFilter = 'A-Z'; // Default filter

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();
    _searchController.addListener(_filterData);

    _tabController.addListener(() {
      // Update `filteredBarang` when tab changes
      if (_tabController.index == 0) {
        setState(() {
          filteredBarang = barangMasuk;
        });
      } else {
        setState(() {
          filteredBarang = barangKeluar;
        });
      }
    });
  }

  // Pastikan data yang diterima bisa dimodifikasi
  Future<void> _fetchData() async {
    try {
      var resultBarangMasuk = await DatabaseHelper().getBarangMasuk();
      var resultBarangKeluar = await DatabaseHelper().getBarangKeluar();
      setState(() {
        barangMasuk = List<Map<String, dynamic>>.from(
            resultBarangMasuk); // Membuat salinan dari data
        barangKeluar = List<Map<String, dynamic>>.from(
            resultBarangKeluar); // Membuat salinan dari data
        filteredBarang = List<Map<String, dynamic>>.from(barangMasuk);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  void _filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (_tabController.index == 0) {
        filteredBarang = barangMasuk
            .where((item) =>
                item['kodeBarang']?.toLowerCase().contains(query) ??
                false || item['namaBarang']?.toLowerCase().contains(query) ??
                false)
            .toList();
      } else {
        filteredBarang = barangKeluar
            .where((item) =>
                item['kodeBarang']?.toLowerCase().contains(query) ??
                false || item['namaBarang']?.toLowerCase().contains(query) ??
                false)
            .toList();
      }
    });
    _applyFilter();
  }

  void _applyFilter() {
    switch (selectedFilter) {
      case 'A-Z':
        filteredBarang.sort(
            (a, b) => (a['namaBarang'] ?? '').compareTo(b['namaBarang'] ?? ''));
        break;
      case 'Z-A':
        filteredBarang.sort(
            (a, b) => (b['namaBarang'] ?? '').compareTo(a['namaBarang'] ?? ''));
        break;
      case 'Tanggal':
        filteredBarang.sort((a, b) =>
            (a['tanggalMasuk'] ?? '').compareTo(b['tanggalMasuk'] ?? ''));
        break;
    }
  }

  Widget _buildDataList() {
    if (filteredBarang.isEmpty) {
      return const Center(child: Text('Tidak ada data yang ditemukan.'));
    }
    return ListView.builder(
      itemCount: filteredBarang.length,
      itemBuilder: (context, index) {
        final item = filteredBarang[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Modelcolor.cardBackground.withOpacity(0.88),
            border: Border.all(color: Modelcolor.primary),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kode Barang: ${item['kodeBarang'] ?? '-'}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Modelcolor.primary),
              ),
              Text('Nama Barang: ${item['namaBarang'] ?? '-'}'),
              Text(
                'Jumlah: ${_tabController.index == 0 ? item['jumlahMasuk'] ?? '-' : item['jumlahKeluar'] ?? '-'}',
              ),
              Text(
                'Tanggal: ${_tabController.index == 0 ? item['tanggalMasuk'] ?? '-' : item['tanggalKeluar'] ?? '-'}',
              ),
              Text('Keterangan: ${item['keterangan'] ?? '-'}'),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Laporan Barang', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Modelcolor.primaryDark,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Barang Masuk'),
            Tab(text: 'Barang Keluar'),
          ],
          indicatorColor: Colors.white, // Warna indikator TabBar
          labelColor: Colors.white, // Warna label tab yang aktif
          unselectedLabelColor: Colors.grey, // Warna label tab yang tidak aktif
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Modelcolor.primaryDark2, // Warna pertama gradasi
              Modelcolor.backgroundDark, // Warna kedua gradasi
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Modelcolor.cardBackground,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Modelcolor.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Cari barang...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list,
                          color: Modelcolor.primary),
                      onPressed: () {
                        _showFilterDialog();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: _buildDataList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: _buildDataList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showFilterDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Filter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('A-Z'),
                leading: Radio<String>(
                  value: 'A-Z',
                  groupValue: selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                      _applyFilter();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Z-A'),
                leading: Radio<String>(
                  value: 'Z-A',
                  groupValue: selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                      _applyFilter();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Tanggal'),
                leading: Radio<String>(
                  value: 'Tanggal',
                  groupValue: selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                      _applyFilter();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
