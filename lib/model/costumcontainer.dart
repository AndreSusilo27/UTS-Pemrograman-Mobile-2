import 'package:flutter/material.dart';

class Customcontainer {
  static Widget widgetContainer(
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
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade400,
              Colors.deepPurple.shade600,
              Colors.deepPurple.shade800,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ), // Gradien untuk latar belakang utama
          borderRadius: BorderRadius.circular(15), // Sudut membulat
          boxShadow: [
            BoxShadow(
              color:
                  Colors.deepPurple.shade200.withOpacity(0.3), // Warna bayangan
              blurRadius: 15, // Tingkat blur bayangan
              offset: const Offset(0, 6), // Posisi bayangan
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isCentered
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start, // Menentukan posisi judul
          children: [
            // Header judul
            Container(
              width: double.infinity, // Membuat judul penuh
              padding: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 12), // Padding dalam judul
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurpleAccent.shade100,
                    Colors.deepPurpleAccent.shade200,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ), // Gradien untuk latar belakang judul
                borderRadius: BorderRadius.circular(12), // Sudut membulat
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurpleAccent
                        .withOpacity(0.4), // Bayangan judul
                    blurRadius: 8, // Tingkat blur bayangan
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
                  shadows: [
                    Shadow(
                      blurRadius: 2,
                      color: Colors.black38, // Efek bayangan teks
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10), // Spasi antara judul dan konten
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.9), // Warna latar belakang konten
                  borderRadius: BorderRadius.circular(10), // Sudut membulat
                ),
                child: child, // Konten yang bisa diisi dengan widget lain
              ),
            ),
          ],
        ),
      ),
    );
  }

// Fungsi untuk membuat container dengan efek glow menggunakan DeepPurple
  static Widget widgetContainerWithGlow(BuildContext context,
      {required Widget child, double? width, double? height}) {
    return Container(
      width: width ?? double.infinity, // Menyesuaikan lebar
      height: height ?? double.infinity, // Menyesuaikan tinggi
      decoration: BoxDecoration(
        color: Colors.white
            .withOpacity(0.3), // Set background color dengan opacity
        borderRadius: BorderRadius.circular(15), // Rounded corners
        border: Border.all(
          color: Colors.blue.shade600, // Gunakan DeepPurple untuk border
          width: 3, // Lebar border
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 5, 8, 147)
                .withOpacity(0.8), // Warna shadow DeepPurple
            blurRadius: 25,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20), // Padding di dalam container
      margin: const EdgeInsets.all(20), // Margin sekitar container
      child: child, // Menyertakan widget anak
    );
  }
}
