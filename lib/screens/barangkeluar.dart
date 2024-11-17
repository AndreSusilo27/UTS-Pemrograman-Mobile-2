import 'package:flutter/material.dart';
import 'package:pemmob2/model/modelcolor.dart';

class BarangKeluarPage extends StatefulWidget {
  const BarangKeluarPage({super.key});

  @override
  State<BarangKeluarPage> createState() => _BarangKeluarPageState();
}

class _BarangKeluarPageState extends State<BarangKeluarPage> {
  final TextEditingController kodeBarangController = TextEditingController();
  final TextEditingController namaBarangController = TextEditingController();
  final TextEditingController jumlahKeluarController = TextEditingController();
  final TextEditingController tanggalKeluarController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();

  @override
  void dispose() {
    kodeBarangController.dispose();
    namaBarangController.dispose();
    jumlahKeluarController.dispose();
    tanggalKeluarController.dispose();
    keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Modelcolor.primaryDark,
        title: const Text(
          'Barang Keluar',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Modelcolor.primaryDark2,
              Modelcolor.backgroundDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Modelcolor.cardBackground.withOpacity(0.88),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10.0,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  _buildInputField(
                    label: "Kode Barang (Wajib)",
                    hint: "Masukkan kode barang",
                    controller: kodeBarangController,
                  ),
                  const SizedBox(height: 10),
                  _buildInputField(
                    label: "Nama Barang",
                    hint: "Masukkan nama barang",
                    controller: namaBarangController,
                  ),
                  const SizedBox(height: 10),
                  _buildInputField(
                    label: "Jumlah Keluar (Wajib)",
                    hint: "Masukkan jumlah barang keluar",
                    controller: jumlahKeluarController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  _buildDatePickerField(
                    context: context,
                    label: "Tanggal Keluar",
                    controller: tanggalKeluarController,
                  ),
                  const SizedBox(height: 10),
                  _buildInputField(
                    label: "Keterangan",
                    hint: "Tambahkan keterangan (opsional)",
                    controller: keteranganController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Tambahkan logika untuk menyimpan data barang keluar
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Modelcolor.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        "Simpan",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
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

  Widget _buildInputField({
    required String label,
    String? hint,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Modelcolor.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: hint,
            filled: true,
            fillColor: Colors.grey.shade200,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 10.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildDatePickerField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Modelcolor.primary,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: Modelcolor.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onTap: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (selectedDate != null) {
              controller.text =
                  "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
            }
          },
        ),
      ],
    );
  }
}
