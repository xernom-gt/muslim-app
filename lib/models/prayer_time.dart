/// ============================================
/// MODEL: Jadwal Sholat (Prayer Schedule)
/// ============================================
/// Merepresentasikan data jadwal sholat dari API.
/// Model ini menyimpan waktu-waktu sholat dalam sehari.

class PrayerTime {
  final String tanggal;  // Tanggal (contoh: "Kamis, 02/01/2025")
  final String imsak;
  final String subuh;
  final String terbit;
  final String dhuha;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;

  PrayerTime({
    required this.tanggal,
    required this.imsak,
    required this.subuh,
    required this.terbit,
    required this.dhuha,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
  });

  /// Factory constructor: membuat PrayerTime dari JSON API.
  /// API mengembalikan data dalam format nested "jadwal".
  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    return PrayerTime(
      tanggal: json['tanggal'] ?? '',
      imsak: json['imsak'] ?? '',
      subuh: json['subuh'] ?? '',
      terbit: json['terbit'] ?? '',
      dhuha: json['dhuha'] ?? '',
      dzuhur: json['dzuhur'] ?? '',
      ashar: json['ashar'] ?? '',
      maghrib: json['maghrib'] ?? '',
      isya: json['isya'] ?? '',
    );
  }

  /// Mengembalikan list pasangan [nama waktu, jam]
  /// untuk ditampilkan di UI.
  List<Map<String, String>> toDisplayList() {
    return [
      {'name': 'Imsak', 'time': imsak, 'icon': 'night'},
      {'name': 'Subuh', 'time': subuh, 'icon': 'subuh'},
      {'name': 'Terbit', 'time': terbit, 'icon': 'sunrise'},
      {'name': 'Dhuha', 'time': dhuha, 'icon': 'morning'},
      {'name': 'Dzuhur', 'time': dzuhur, 'icon': 'noon'},
      {'name': 'Ashar', 'time': ashar, 'icon': 'afternoon'},
      {'name': 'Maghrib', 'time': maghrib, 'icon': 'sunset'},
      {'name': 'Isya', 'time': isya, 'icon': 'night'},
    ];
  }
}
