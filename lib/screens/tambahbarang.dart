import 'package:flutter/material.dart';

class TambahBarangPage extends StatelessWidget {
  const TambahBarangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Barang'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan ikon gambar
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 30),
                      onPressed: () {
                        // Tambahkan logika upload gambar
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Input Kode Barang
            _buildInputField(
              label: "Kode Barang (Wajib)",
              hint: "Masukkan kode barang",
              suffixIcon: Icons.qr_code_scanner,
              onSuffixTap: () {
                // Tambahkan logika scan QR
              },
            ),
            const SizedBox(height: 10),

            // Input Nama Barang
            _buildInputField(
              label: "Nama Barang (Wajib)",
              hint: "Masukkan nama barang",
            ),
            const SizedBox(height: 10),

            // Input Stok Awal
            _buildInputField(
              label: "Stok Awal (Wajib)",
              hint: "Masukkan stok awal",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),

            // Input Harga Modal
            _buildInputField(
              label: "Harga Modal",
              hint: "Masukkan harga modal",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // Bagian Harga Jual
            const Text(
              "Harga Jual",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: "Harga Ecer",
                    hint: "Nominal",
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    label: "Nama Harga (Wajib)",
                    hint: "Contoh: Eceran",
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {
                // Tambahkan logika untuk harga grosir
              },
              icon: const Icon(Icons.add),
              label: const Text("Tambah Harga Grosir"),
            ),
            const SizedBox(height: 20),

            // Bagian lainnya (opsional)
            ExpansionTile(
              title: const Text("Lainnya"),
              children: [
                _buildInputField(
                  label: "Deskripsi Barang",
                  hint: "Masukkan deskripsi",
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                _buildInputField(
                  label: "Kategori Barang",
                  hint: "Masukkan kategori barang",
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Tambahkan logika simpan data
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    String? hint,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(suffixIcon),
                    onPressed: onSuffixTap,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
