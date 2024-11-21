import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pemmob2/model/modelcolor.dart';

class TambahBarangPage extends StatefulWidget {
  const TambahBarangPage({super.key});

  @override
  State<TambahBarangPage> createState() => _TambahBarangPageState();
}

class _TambahBarangPageState extends State<TambahBarangPage> {
  final List<Map<String, TextEditingController>> grosirFields = [];
  File? _selectedImage;
  @override
  void dispose() {
    for (var field in grosirFields) {
      field['harga']?.dispose();
      field['jumlah']?.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Modelcolor.primaryDark,
        title: const Text(
          'Tambah Barang',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bghome2.jpg'),
            fit: BoxFit.cover,
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
                  // Header dengan gambar
                  Center(
                    child: GestureDetector(
                      onTap:
                          _pickImage, // Menggunakan CircleAvatar langsung untuk memilih gambar
                      child: CircleAvatar(
                        radius: 68,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!) as ImageProvider
                            : null,
                        child: _selectedImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 50,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Pilih Foto',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )
                            : null,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  _buildInputField(
                    label: "Kode Barang (Wajib)",
                    hint: "Masukkan kode barang",
                  ),
                  const SizedBox(height: 10),
                  _buildInputField(
                    label: "Nama Barang (Wajib)",
                    hint: "Masukkan nama barang",
                  ),
                  const SizedBox(height: 10),
                  _buildInputField(
                    label: "Stok Awal (Wajib)",
                    hint: "Masukkan stok awal",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  _buildInputField(
                    label: "Harga Modal",
                    hint: "Masukkan harga modal",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Harga Jual",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Modelcolor.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          label: "Harga Eceran",
                          hint: "Harga",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildInputField(
                          label: "Nominal",
                          hint: "Jumlah",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        grosirFields.add({
                          'harga': TextEditingController(),
                          'jumlah': TextEditingController(),
                        });
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Tambah Harga Grosir"),
                    style: TextButton.styleFrom(
                      foregroundColor: Modelcolor.accent,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (var i = 0; i < grosirFields.length; i++) ...[
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            label: "Harga Grosir",
                            hint: "Harga",
                            keyboardType: TextInputType.number,
                            controller: grosirFields[i]['harga'],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildInputField(
                            label: "Jumlah Grosir",
                            hint: "Jumlah",
                            keyboardType: TextInputType.number,
                            controller: grosirFields[i]['jumlah'],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              grosirFields.removeAt(i);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],

                  // Bagian lainnya (opsional)
                  ExpansionTile(
                    title: const Text(
                      "Lainnya",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      _buildDatePickerField(
                        context: context,
                        label: "Pilih Tanggal",
                      ),
                      const SizedBox(height: 10),
                      _buildInputField(
                        label: "Kategori Barang",
                        hint: "Masukkan kategori barang",
                      ),
                      const SizedBox(height: 10),
                      _buildInputField(
                        label: "Deskripsi Barang",
                        hint: "Masukkan deskripsi",
                        maxLines: 3,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Tambahkan logika simpan data
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
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    TextEditingController? controller,
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
}

Widget _buildDatePickerField({
  required BuildContext context,
  required String label,
}) {
  TextEditingController dateController = TextEditingController();

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
        controller: dateController,
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
            // Format tanggal menjadi lebih user-friendly
            String formattedDate =
                "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
            dateController.text = formattedDate;
          }
        },
      ),
    ],
  );
}
