import 'package:flutter/material.dart';

class Costumgrid {
// Fungsi untuk membuat Card statistik
  static Widget gridStat(String title, String count, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade500,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: const Color.fromARGB(255, 255, 255, 255)),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 255, 255, 255)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            count,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 41, 237, 6)),
          ),
        ],
      ),
    );
  }

// Widget untuk GridView Horizontal dalam SizedBox
  static Widget horizontalGrid(BuildContext context) {
    List<Map<String, dynamic>> statData = [
      {
        "title": "Total Barang",
        "count": "150",
        "icon": Icons.inventory_2_outlined
      },
      {
        "title": "Barang Masuk",
        "count": "50",
        "icon": Icons.add_shopping_cart_outlined
      },
      {
        "title": "Barang Keluar",
        "count": "30",
        "icon": Icons.remove_shopping_cart_outlined
      },
      {"title": "Jumlah Produk", "count": "80", "icon": Icons.widgets_outlined},
      {
        "title": "Jumlah Kategori",
        "count": "20",
        "icon": Icons.category_outlined
      },
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(statData.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: gridStat(
                  statData[index]["title"],
                  statData[index]["count"],
                  statData[index]["icon"],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  static Widget verticalGrid(BuildContext context) {
    final items = List.generate(10, (index) => "Item ${index + 1}");

    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Dua kolom dalam grid
          crossAxisSpacing: 13,
          mainAxisSpacing: 13,
          childAspectRatio: 3 / 2, // Rasio lebar:tinggi
        ),
        itemCount: items.length,
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
            child: Center(
              child: Text(
                items[index],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
