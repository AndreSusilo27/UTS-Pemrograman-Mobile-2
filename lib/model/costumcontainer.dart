import 'package:flutter/material.dart';
import 'package:pemmob2/model/modelcolor.dart';

class Customcontainer {
  static widgetContainer(
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
        margin: const EdgeInsets.symmetric(
            horizontal: 5, vertical: 5), // Margin luar
        padding: const EdgeInsets.all(10), // Padding dalam
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(
              0.5), // Transparansi lebih banyak untuk container utama
          borderRadius: BorderRadius.circular(15), // Sudut membulat lebih besar
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.2), // Warna bayangan lebih gelap
              blurRadius: 15, // Tingkat blur bayangan yang lebih besar
              offset: const Offset(0, 6), // Posisi bayangan lebih terlihat
            ),
          ],
          border: Border.all(
            color: Modelcolor.whiteTransparent20
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
                color: Modelcolor.whiteTransparent10.withOpacity(
                    0.85), // Warna latar belakang judul dengan transparansi
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
                  color: Modelcolor.textPrimary, // Warna teks judul
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
}
