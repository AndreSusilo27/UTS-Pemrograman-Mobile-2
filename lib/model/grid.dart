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
    final List<String> assetImages = [
      'assets/keyboard_mechanical.png',
      'assets/keyboard_mechanical_costume.jpeg',
      'assets/keyboard_mechanical_rgb.jpeg',
      'assets/mouse_wireless.jpeg',
      'assets/mouse_logitech.jpeg',
      'assets/mouse_logitech_wireless.jpeg',
      'assets/usb_type_c.jpeg',
      'assets/usb_type_a.jpeg',
      'assets/laptop_acer_nitro_5.jpeg',
      'assets/laptop_dell.jpeg',
      'assets/laptop_acer_se.jpeg',
    ];

    final List<String> itemNames = [
      'Keyboard Mechanical',
      'Keyboard Mechanical Costume',
      'Keyboard Mechanical RGB',
      'Mouse Wireless',
      'Mouse Logitech M100r',
      'Mouse Logitech Wireless',
      'Kabel USB Type C',
      'Kabel USB Type A',
      'Laptop Acer Nitro 5',
      'Laptop Dell XPS',
      'Laptop Acer Special Edition',
    ];

    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Dua kolom dalam grid
          crossAxisSpacing: 15, // Ruang antar kolom
          mainAxisSpacing: 15, // Ruang antar baris
          childAspectRatio: 0.8, // Proporsi untuk desain yang proporsional
        ),
        itemCount: assetImages.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white, // Background putih untuk setiap kartu
              borderRadius: BorderRadius.circular(15), // Sudut melengkung
              border: Border.all(
                color: Colors.grey.withOpacity(0.4), // Border abu-abu lembut
                width: 1.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Bayangan lembut
                  blurRadius: 12, // Lebih halus
                  offset: const Offset(0, 6), // Bayangan turun sedikit
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Bagian Nama Item
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent
                        .withOpacity(0.2), // Warna lembut elegan
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15), // Sudut atas melengkung
                    ),
                  ),
                  child: Text(
                    itemNames[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple, // Warna teks
                    ),
                  ),
                ),

                // Bagian Gambar
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(10), // Melengkungkan gambar
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey
                                .withOpacity(0.4), // Border untuk gambar
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1), // Bayangan halus
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          assetImages[index],
                          fit: BoxFit.cover, // Gambar memenuhi area
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget produkTabel(BuildContext context) {
    final List<Map<String, dynamic>> productData = [
      {
        "name": "Laptop Acer Nitro 5",
        "stock": "7",
        "category": "Laptop",
        "price": "14,000,000"
      },
      {
        "name": "Laptop Acer Special Edition",
        "stock": "23",
        "category": "Laptop",
        "price": "5.500,000"
      },
      {
        "name": "Laptop Dell XPS",
        "stock": "7",
        "category": "Laptop",
        "price": "7,000,000"
      },
      {
        "name": "Mouse Wireless",
        "stock": "20",
        "category": "Mouse",
        "price": "300,000"
      },
      {
        "name": "Mouse Logitech M100r",
        "stock": "16",
        "category": "Mouse",
        "price": "150,000"
      },
      {
        "name": "Mouse Logitech Wireless",
        "stock": "8",
        "category": "Mouse",
        "price": "250,000"
      },
      {
        "name": "Keyboard Mechanical",
        "stock": "13",
        "category": "Keyboard",
        "price": "585,000"
      },
      {
        "name": "Keyboard Mechanical RGB",
        "stock": "5",
        "category": "Keyboard",
        "price": "1,250,000"
      },
      {
        "name": "Keyboard Mechanical Costume",
        "stock": "12",
        "category": "Keyboard",
        "price": "1,550,000"
      },
      {
        "name": "Kabel USD Type C",
        "stock": "33",
        "category": "Kabel",
        "price": "50,000"
      },
      {
        "name": "Kabel USD Type A",
        "stock": "19",
        "category": "Kabel",
        "price": "35,000"
      },
    ];

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: SingleChildScrollView(
        // Add horizontal scrolling
        scrollDirection: Axis.vertical, // Enable vertical scrolling
        child: SingleChildScrollView(
          // Add horizontal scrolling
          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
          child: DataTable(
            columnSpacing: 20,
            columns: const [
              DataColumn(
                label: Text(
                  "Nama",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  "Stok",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  "Kategori",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  "Harga",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
            rows: productData.map((product) {
              return DataRow(cells: [
                DataCell(Text(product["name"])),
                DataCell(Text(product["stock"])),
                DataCell(Text(product["category"])),
                DataCell(Text(product["price"])),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
