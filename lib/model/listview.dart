import 'package:flutter/material.dart';
import 'package:pemmob2/model/modelcolor.dart';

class Costumlistview {
// Widget untuk GridView Horizontal dalam SizedBox
  static Widget horizontalListView(BuildContext context) {
    // Data dengan warna ikon berdasarkan kondisi
    List<Map<String, dynamic>> statData = [
      {
        "title": "Total Barang",
        "count": "163",
        "icon": Icons.inventory_2_outlined,
        "condition": "", // Hijau untuk kondisi positif
      },
      {
        "title": "Barang Masuk",
        "count": "305",
        "icon": Icons.add_shopping_cart_outlined,
        "condition": "positive", // Hijau
      },
      {
        "title": "Barang Keluar",
        "count": "142",
        "icon": Icons.remove_shopping_cart_outlined,
        "condition": "negative", // Merah
      },
      {
        "title": "Jumlah Produk",
        "count": "11",
        "icon": Icons.widgets_outlined,
        "condition": "warning", // Kuning
      },
      {
        "title": "Jumlah Kategori",
        "count": "4",
        "icon": Icons.category_outlined,
        "condition": "neutral", // Biru
      },
    ];

    return SizedBox(
      height:
          MediaQuery.of(context).size.height * 0.25, // Tinggi dapat disesuaikan
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: statData.length,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: listViewStat(
              title: statData[index]["title"],
              count: statData[index]["count"],
              icon: statData[index]["icon"],
              iconColor: getColorBasedOnCondition(statData[index]["condition"]),
              boxWidth:
                  MediaQuery.of(context).size.width * 0.3, // Lebar fleksibel
            ),
          );
        },
      ),
    );
  }

// Widget untuk elemen kotak statistik
  static Widget listViewStat({
    required String title,
    required String count,
    required IconData icon,
    required Color iconColor, // Warna ikon spesifik berdasarkan kondisi
    required double boxWidth,
  }) {
    return Container(
      width: boxWidth,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Modelcolor.cardBackground,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 36,
            color: iconColor, // Warna ikon dari parameter
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

// Fungsi untuk menentukan warna ikon berdasarkan kondisi
  static Color getColorBasedOnCondition(String condition) {
    switch (condition) {
      case "positive":
        return Colors.green; // Hijau untuk kondisi positif
      case "negative":
        return Colors.red; // Merah untuk kondisi negatif
      case "neutral":
        return Colors.orange; // Oranye untuk netral
      case "warning":
        return const Color.fromARGB(255, 192, 180, 78); // Oranye untuk netral
      default:
        return Colors.blue; // Biru sebagai default
    }
  }

  static Widget verticalListView(BuildContext context) {
    final items = List.generate(10, (index) => "Item ${index + 1}");

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.photo_camera_back_outlined,
                  color: Colors.deepPurple),
              Text(
                items[index],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                items[index],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                items[index],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                items[index],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                items[index],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Icon(Icons.arrow_forward, color: Colors.deepPurple),
            ],
          ),
        );
      },
    );
  }
}
