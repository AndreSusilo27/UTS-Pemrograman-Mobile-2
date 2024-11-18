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
      // Update filteredBarang based on tab selection
      _updateFilteredBarang();
    });
  }

  void _fetchData() async {
    try {
      var resultBarangMasuk = await DatabaseHelper().getBarangMasuk();
      var resultBarangKeluar = await DatabaseHelper().getBarangKeluar();
      setState(() {
        barangMasuk = List<Map<String, dynamic>>.from(resultBarangMasuk);
        barangKeluar = List<Map<String, dynamic>>.from(resultBarangKeluar);
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
                (item['kodeBarang']?.toLowerCase().contains(query) ?? false) ||
                (item['namaBarang']?.toLowerCase().contains(query) ?? false) ||
                (item['jumlahMasuk']
                        ?.toString()
                        .toLowerCase()
                        .contains(query) ??
                    false))
            .toList();
      } else {
        filteredBarang = barangKeluar
            .where((item) =>
                (item['kodeBarang']?.toLowerCase().contains(query) ?? false) ||
                (item['namaBarang']?.toLowerCase().contains(query) ?? false) ||
                (item['jumlahKeluar']
                        ?.toString()
                        .toLowerCase()
                        .contains(query) ??
                    false))
            .toList();
      }
    });
    _applyFilter();
  }

  void _updateFilteredBarang() {
    setState(() {
      if (_tabController.index == 0) {
        filteredBarang = List<Map<String, dynamic>>.from(barangMasuk);
      } else {
        filteredBarang = List<Map<String, dynamic>>.from(barangKeluar);
      }
      _applyFilter();
    });
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
        filteredBarang.sort((a, b) {
          DateTime? dateA = _tabController.index == 0
              ? DateTime.tryParse(a['tanggalMasuk'] ?? '')
              : DateTime.tryParse(a['tanggalKeluar'] ?? '');
          DateTime? dateB = _tabController.index == 0
              ? DateTime.tryParse(b['tanggalMasuk'] ?? '')
              : DateTime.tryParse(b['tanggalKeluar'] ?? '');
          return (dateA ?? DateTime(0)).compareTo(dateB ?? DateTime(0));
        });
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
        final fotoBarang = item['fotoBarang'];
        final String kodeBarang = item['kodeBarang'] ?? 'Tidak diketahui';
        final String namaBarang = item['namaBarang'] ?? 'Tidak diketahui';
        final String tanggal = _tabController.index == 0
            ? item['tanggalMasuk'] ?? '-'
            : item['tanggalKeluar'] ?? '-';
        final String keterangan = item['keterangan'] ?? '-';
        final String jumlah = _tabController.index == 0
            ? item['jumlahMasuk']?.toString() ?? '-'
            : item['jumlahKeluar']?.toString() ?? '-';

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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: fotoBarang != null
                    ? Image.asset(
                        'assets/$fotoBarang',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.image_not_supported,
                        size: 80,
                        color: Colors.grey,
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kode Barang: $kodeBarang',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Modelcolor.primary,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text('Nama Barang: $namaBarang'),
                      const SizedBox(height: 5),
                      Text('Tanggal: $tanggal'),
                      const SizedBox(height: 5),
                      Text('Keterangan: $keterangan'),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 80,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      jumlah,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Modelcolor.primary,
                      ),
                    ),
                  ),
                ),
              ),
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
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Modelcolor.primaryDark2,
              Modelcolor.backgroundDark,
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  // Search Field
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
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
                                hintText: 'Cari...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Filter Dropdown
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Modelcolor.cardBackground,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFilter,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedFilter = newValue!;
                            _applyFilter();
                          });
                        },
                        items: <String>['A-Z', 'Z-A', 'Tanggal']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Icon(
                              value == 'A-Z'
                                  ? Icons.sort_by_alpha
                                  : value == 'Z-A'
                                      ? Icons.sort_by_alpha_outlined
                                      : Icons.date_range,
                              color: Modelcolor.primary,
                              size: 21,
                            ),
                          );
                        }).toList(),
                        isExpanded: false,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color.fromARGB(255, 0, 0, 0),
                          size: 24,
                        ),
                        dropdownColor: Modelcolor.cardBackground,
                        borderRadius: BorderRadius.circular(20),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white),
            Expanded(child: _buildDataList()),
          ],
        ),
      ),
    );
  }
}
