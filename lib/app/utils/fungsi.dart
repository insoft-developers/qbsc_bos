class Fungsi {
  static String formatToTime(String dateTimeString) {
    try {
      // Parse string ke DateTime
      DateTime dateTime = DateTime.parse(dateTimeString);
      // Ambil jam, menit, detik
      String formattedTime =
          "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
      return formattedTime;
    } catch (e) {
      return "-"; // kalau format salah
    }
  }

  static String tanggalIndo(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      const bulan = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      return "${date.day} ${bulan[date.month - 1]} ${date.year}";
    } catch (e) {
      return "-";
    }
  }

  static String formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime).toLocal();

    String twoDigit(int n) => n.toString().padLeft(2, '0');

    return '${twoDigit(dt.day)}-${twoDigit(dt.month)}-${dt.year} '
        '${twoDigit(dt.hour)}:${twoDigit(dt.minute)}';
  }
}

bool isJamDalamRange({
  required String jam, // contoh: 23:02:00
  required String jamAwal, // contoh: 12:09
  required String jamAkhir, // contoh: 12:30
}) {
  DateTime parseJam(String value) {
    final parts = value.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final second = parts.length > 2 ? int.parse(parts[2]) : 0;
    return DateTime(2000, 1, 1, hour, minute, second);
  }

  final jamCheck = parseJam(jam);
  var start = parseJam(jamAwal);
  var end = parseJam(jamAkhir);

  // ⏰ handle lintas hari (misal 22:00 - 02:00)
  if (end.isBefore(start)) {
    end = end.add(const Duration(days: 1));
    if (jamCheck.isBefore(start)) {
      return jamCheck.add(const Duration(days: 1)).isBefore(end);
    }
  }

  return jamCheck.isAfter(start) && jamCheck.isBefore(end);
}
