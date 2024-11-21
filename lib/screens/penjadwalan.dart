import 'package:flutter/material.dart';
import 'package:pemmob2/model/modelcolor.dart';

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
        foregroundColor: Colors.white,
        title: const Text(
          'Penjadwalan Restock',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Modelcolor.primaryDark,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bghome2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSection(
                        title: 'Tambah Jadwal Restock',
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _itemController,
                              label: 'Nama Barang',
                              icon: Icons.inventory,
                            ),
                            const SizedBox(height: 10),
                            _buildTextField(
                              controller: _quantityController,
                              label: 'Jumlah Restock',
                              icon: Icons.add_shopping_cart,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 10),
                            _buildTextField(
                              controller: _dateController,
                              label: 'Tanggal Restock',
                              icon: Icons.calendar_today,
                              isReadOnly: true,
                              onTap: () => _selectDate(context),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _addSchedule,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 20.0,
                                ),
                              ),
                              child: const Text(
                                'Tambahkan Jadwal',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSection(
                        title: 'Daftar Jadwal Restock',
                        child: _schedules.isEmpty
                            ? const Center(
                                child: Text(
                                  'Belum ada jadwal restock',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _schedules.length,
                                itemBuilder: (context, index) {
                                  final schedule = _schedules[index];
                                  return Card(
                                    color: Colors.deepPurple.shade50,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ListTile(
                                      leading: const CircleAvatar(
                                        backgroundColor: Colors.deepPurple,
                                        child: Icon(
                                          Icons.event,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        schedule['item'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Jumlah: ${schedule['quantity']} | Tanggal: ${schedule['date']}',
                                        style: TextStyle(
                                            color: Colors.grey.shade700),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isReadOnly = false,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: isReadOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.deepPurple.shade50,
      ),
      onTap: onTap,
    );
  }
}
