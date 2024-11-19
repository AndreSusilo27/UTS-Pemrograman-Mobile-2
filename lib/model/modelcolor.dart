import 'package:flutter/material.dart';

class Modelcolor {
  // ===== Warna Utama =====
  static const Color primary = Color.fromARGB(255, 115, 66, 200); // Deep Purple
  static const Color primaryLight =
      Color.fromRGBO(143, 83, 255, 1); // Light Purple
  static const Color primaryDark = Color.fromARGB(255, 63, 34, 133);
  static Color primaryDark2 = Colors.deepPurpleAccent;
  static Color primaryblack = Colors.black87;
  static Color primary2 = const Color.fromARGB(255, 89, 51, 156);

  // ===== Warna Aksen =====
  static const Color accent = Color(0xFF7C4DFF); // Bright Purple
  static const Color accentLight =
      Color.fromARGB(255, 214, 186, 255); // Soft Purple
  static const Color accentDark = Color(0xFF311B92); // Darker Purple

  // ===== Warna Status =====
  static const Color success = Color(0xFF4CAF50); // Hijau untuk sukses
  static const Color error = Color(0xFFF44336); // Merah untuk error
  static const Color warning = Color(0xFFFFC107); // Amber untuk peringatan
  static const Color info = Color(0xFF03A9F4); // Biru untuk informasi

  // ===== Warna Teks =====
  static const Color textPrimary = Color(0xFF212121); // Hitam (Teks utama)
  static const Color textSecondary =
      Color(0xFF757575); // Abu-abu (Teks pendukung)
  static const Color textLight =
      Color(0xFFFFFFFF); // Putih (Teks di atas warna gelap)

  // ===== Warna Latar Belakang =====
  static const Color backgroundLight = Color(0xFFF5F5F5); // Background terang
  static const Color backgroundDark =
      Color.fromARGB(255, 44, 44, 44); // Background gelap
  static const Color cardBackground = Color(0xFFFFFFFF); // Warna kartu (terang)

  // ===== Warna Transparan =====
  static const Color transparent = Colors.transparent; // Transparan penuh
  static const Color whiteTransparent10 =
      Color(0x1AFFFFFF); // Putih transparan 10%
  static const Color whiteTransparent20 =
      Color(0x33FFFFFF); // Putih transparan 20%

  // ===== Gradien =====
  static const Gradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient accentGradient = LinearGradient(
    colors: [accentLight, accent],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // ===== Warna Shadow =====
  static const Color shadowLight = Color(0x29000000); // Shadow terang
  static const Color shadowDark = Color(0x73000000); // Shadow gelap
}
