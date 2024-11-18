import 'package:flutter/material.dart';

class JadwalRestokPage extends StatefulWidget {
  const JadwalRestokPage({super.key});

  @override
  State<JadwalRestokPage> createState() => _JadwalRestokPageState();
}

class _JadwalRestokPageState extends State<JadwalRestokPage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final List<Map<String, dynamic>> _schedules = [];

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  void _addSchedule() {
    if (_itemController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua data!')),
      );
      return;
    }

    final newSchedule = {
      'item': _itemController.text,
      'quantity': _quantityController.text,
      'date': _dateController.text,
    };

    setState(() {
      _schedules.add(newSchedule);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Jadwal restock berhasil ditambahkan!')),
    );

    _itemController.clear();
    _quantityController.clear();
    _dateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penjadwalan Restock'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tambah Jadwal Restock',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _itemController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Barang',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah Restock',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Tanggal Restock',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _addSchedule,
                        child: const Text('Tambahkan Jadwal'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daftar Jadwal Restock',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _schedules.isEmpty
                        ? const Center(
                            child: Text(
                              'Belum ada jadwal restock',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _schedules.length,
                            itemBuilder: (context, index) {
                              final schedule = _schedules[index];
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ListTile(
                                  title: Text(schedule['item']),
                                  subtitle: Text(
                                    'Jumlah: ${schedule['quantity']} | Tanggal: ${schedule['date']}',
                                  ),
                                ),
                              );
                            },
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
