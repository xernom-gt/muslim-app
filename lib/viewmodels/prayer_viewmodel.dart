import 'package:flutter/material.dart';
import '../models/prayer_time.dart';
import '../services/prayer_service.dart';

/// ============================================
/// VIEWMODEL: Prayer (Jadwal Sholat)
/// ============================================
/// Mengelola state untuk fitur jadwal sholat.
/// Menggunakan ChangeNotifier (Provider pattern).
///
/// State: loading, prayerTime, error
/// Method: fetchPrayerTime(), getCurrentPrayer()

class PrayerViewModel extends ChangeNotifier {
  final PrayerService _service = PrayerService();

  PrayerTime? _prayerTime;
  bool _isLoading = false;
  String _error = '';

  // Getters (akses state dari UI)
  PrayerTime? get prayerTime => _prayerTime;
  bool get isLoading => _isLoading;
  String get error => _error;

  /// Mengambil jadwal sholat hari ini
  Future<void> fetchPrayerTime() async {
    _isLoading = true;
    _error = '';
    notifyListeners(); // Beritahu UI bahwa state berubah

    final result = await _service.getTodayPrayer();

    if (result != null) {
      _prayerTime = result;
    } else {
      _error = 'Gagal memuat jadwal sholat';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Menentukan waktu sholat yang sedang berlangsung
  /// berdasarkan jam saat ini.
  String getCurrentPrayer() {
    if (_prayerTime == null) return '';

    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;

    // Parse jam dari string "HH:mm"
    int parseTime(String time) {
      try {
        final parts = time.split(':');
        return int.parse(parts[0]) * 60 + int.parse(parts[1]);
      } catch (_) {
        return 0;
      }
    }

    final times = {
      'Isya': parseTime(_prayerTime!.isya),
      'Maghrib': parseTime(_prayerTime!.maghrib),
      'Ashar': parseTime(_prayerTime!.ashar),
      'Dzuhur': parseTime(_prayerTime!.dzuhur),
      'Dhuha': parseTime(_prayerTime!.dhuha),
      'Terbit': parseTime(_prayerTime!.terbit),
      'Subuh': parseTime(_prayerTime!.subuh),
      'Imsak': parseTime(_prayerTime!.imsak),
    };

    // Cek dari waktu terbesar ke terkecil
    for (final entry in times.entries) {
      if (nowMinutes >= entry.value) {
        return entry.key;
      }
    }

    return 'Isya'; // Default jika sebelum imsak
  }

  /// Mendapatkan waktu sholat berikutnya
  String getNextPrayer() {
    if (_prayerTime == null) return '';

    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;

    int parseTime(String time) {
      try {
        final parts = time.split(':');
        return int.parse(parts[0]) * 60 + int.parse(parts[1]);
      } catch (_) {
        return 0;
      }
    }

    final orderedTimes = [
      {'name': 'Imsak', 'minutes': parseTime(_prayerTime!.imsak)},
      {'name': 'Subuh', 'minutes': parseTime(_prayerTime!.subuh)},
      {'name': 'Terbit', 'minutes': parseTime(_prayerTime!.terbit)},
      {'name': 'Dhuha', 'minutes': parseTime(_prayerTime!.dhuha)},
      {'name': 'Dzuhur', 'minutes': parseTime(_prayerTime!.dzuhur)},
      {'name': 'Ashar', 'minutes': parseTime(_prayerTime!.ashar)},
      {'name': 'Maghrib', 'minutes': parseTime(_prayerTime!.maghrib)},
      {'name': 'Isya', 'minutes': parseTime(_prayerTime!.isya)},
    ];

    for (final time in orderedTimes) {
      if ((time['minutes'] as int) > nowMinutes) {
        return time['name'] as String;
      }
    }

    return 'Imsak'; // Sudah lewat isya, next is imsak besok
  }
}
