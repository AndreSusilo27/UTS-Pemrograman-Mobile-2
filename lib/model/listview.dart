import 'package:flutter/material.dart';

class Costumlistview {
// Fungsi untuk membuat Card statistik
  static listViewStat(String title, String count, IconData icon, double d) {
    return Container(
      width: 100,
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
  static Widget horizontalListView(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        itemBuilder: (context, index) {
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
            {
              "title": "Jumlah Produk",
              "count": "80",
              "icon": Icons.widgets_outlined
            },
            {
              "title": "Jumlah Kategori",
              "count": "20",
              "icon": Icons.category_outlined
            },
          ];
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: listViewStat(
              statData[index]["title"],
              statData[index]["count"],
              statData[index]["icon"],
              MediaQuery.of(context).size.width * 0.21,
            ),
          );
        },
      ),
    );
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
