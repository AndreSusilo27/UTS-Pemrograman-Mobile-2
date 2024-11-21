import 'package:flutter/material.dart';

/// Method untuk mendapatkan notifikasi yang diurutkan berdasarkan tanggal
List<Map<String, dynamic>> sortSchedules(List<Map<String, dynamic>> schedules) {
  schedules.sort((a, b) {
    final dateA = DateTime.parse(a['date']);
    final dateB = DateTime.parse(b['date']);
    return dateA.compareTo(dateB); // Urutkan dari yang terdekat ke terjauh
  });
  return schedules;
}

/// Widget untuk Icon Notifikasi dengan animasi, badge, dan pengelompokan warna
Widget notificationsIcon({
  required BuildContext context,
  required List<Map<String, dynamic>> schedules,
  required Function(Map<String, dynamic>)
      onComplete, // Callback ketika notifikasi selesai
  required Function(Map<String, dynamic>) onDelete, // Callback untuk hapus
}) {
  final sortedSchedules = sortSchedules(schedules);

  // Fungsi untuk menampilkan dialog notifikasi
  void showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Notifikasi Jadwal',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: sortedSchedules.isEmpty
                ? const Center(
                    child: Text('Tidak ada notifikasi yang tersedia.'),
                  )
                : ListView.builder(
                    itemCount: sortedSchedules.length,
                    itemBuilder: (context, index) {
                      final schedule = sortedSchedules[index];
                      final scheduleDate = DateTime.parse(schedule['date']);
                      final today = DateTime.now();

                      // Warna background berdasarkan status
                      Color backgroundColor;
                      if (schedule['completed'] ?? false) {
                        backgroundColor = Colors.grey.shade300; // Abu-abu
                      } else if (scheduleDate.year == today.year &&
                          scheduleDate.month == today.month &&
                          scheduleDate.day == today.day) {
                        backgroundColor = Colors.green.shade200; // Hijau
                      } else {
                        backgroundColor = Colors.yellow.shade200; // Kuning
                      }

                      return Card(
                        color: backgroundColor,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                schedule['title'] ?? 'No Title',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: (schedule['completed'] ?? false)
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                  'Nama Barang: ${schedule['item'] ?? 'Unknown'}'),
                            ],
                          ),
                          subtitle: Text(
                              'Tanggal: ${schedule['date']?.split('T').first ?? 'Unknown'}\nJumlah: ${schedule['quantity'] ?? 'N/A'}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: schedule['completed'] ?? false,
                                onChanged: (value) {
                                  onComplete(schedule); // Tandai selesai
                                  Navigator.of(context).pop(); // Tutup dialog
                                  showNotificationsDialog(); // Refresh dialog
                                },
                              ),
                              if (schedule['completed'] ?? false)
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    onDelete(schedule); // Hapus notifikasi
                                    Navigator.of(context).pop(); // Tutup dialog
                                    showNotificationsDialog(); // Refresh dialog
                                  },
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  // Ikon notifikasi dengan badge
  return GestureDetector(
    onTap: showNotificationsDialog,
    child: Stack(
      alignment: Alignment.topRight,
      children: [
        Icon(
          Icons.notifications,
          size: 30,
          color: Colors.amber.shade600,
        ),
        // Menghitung jumlah notifikasi hijau yang belum selesai (hari ini)
        if (sortedSchedules.any((s) => !((s['completed'] ?? false) ||
            (DateTime.parse(s['date']).day !=
                DateTime.now().day)))) // Menampilkan hanya yang hijau
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                borderRadius: BorderRadius.circular(12),
              ),
              constraints: const BoxConstraints(
                minWidth: 17,
                minHeight: 17,
              ),
              child: Text(
                '${sortedSchedules.where((s) => !(s['completed'] ?? false) && DateTime.parse(s['date']).day == DateTime.now().day).length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    ),
  );
}
