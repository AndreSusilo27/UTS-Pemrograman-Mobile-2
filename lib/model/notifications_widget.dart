import 'package:flutter/material.dart';

/// Method untuk mendapatkan notifikasi hari ini
List<Map<String, dynamic>> getTodaySchedules(
    List<Map<String, dynamic>> schedules) {
  final today = DateTime.now();
  return schedules.where((schedule) {
    final scheduleDate = DateTime.parse(schedule['date']);
    return scheduleDate.year == today.year &&
        scheduleDate.month == today.month &&
        scheduleDate.day == today.day &&
        !(schedule['completed'] ?? false); // Hanya jadwal yang belum selesai
  }).toList();
}

/// Widget untuk Icon Notifikasi dengan animasi, badge, dan kotak centang
Widget notificationsIcon({
  required BuildContext context,
  required List<Map<String, dynamic>> schedules,
  required Function(Map<String, dynamic>)
      onComplete, // Callback ketika restock selesai
}) {
  final todaySchedules = getTodaySchedules(schedules);

  // Fungsi untuk menampilkan dialog notifikasi
  void showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Notifikasi Hari Ini',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9, // Lebih besar
            height: MediaQuery.of(context).size.height * 0.6, // Lebih besar
            child: todaySchedules.isEmpty
                ? const Center(
                    child: Text('Tidak ada jadwal restock hari ini.'),
                  )
                : ListView.builder(
                    itemCount: todaySchedules.length,
                    itemBuilder: (context, index) {
                      final schedule = todaySchedules[index];
                      return Card(
                        color: Colors.amber[50],
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text('Barang: ${schedule['item']}'),
                          subtitle: Text('Jumlah: ${schedule['quantity']}'),
                          trailing: Checkbox(
                            value: schedule['completed'] ?? false,
                            onChanged: (value) {
                              onComplete(schedule); // Menandai selesai
                              Navigator.of(context).pop(); // Tutup dialog
                              showNotificationsDialog(); // Refresh dialog
                            },
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

  return GestureDetector(
    onTap: showNotificationsDialog,
    child: Stack(
      alignment: Alignment.topRight,
      children: [
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 500),
          tween: Tween<double>(
              begin: 0.0, end: todaySchedules.isNotEmpty ? 2.0 : 0.0),
          curve: Curves.easeInOut,
          builder: (context, offset, child) {
            return Transform.translate(
              offset: Offset(offset as double, 0),
              child: child,
            );
          },
          child: Icon(
            Icons.notifications,
            size: 30,
            color: Colors.amber.shade600,
          ),
        ),
        if (todaySchedules.isNotEmpty)
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
                '${todaySchedules.length}',
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
