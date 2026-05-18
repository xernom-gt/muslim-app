import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prayer_time.dart';
import 'cache_service.dart';

/// ============================================
/// SERVICE: Prayer Time API
/// ============================================
/// Mengambil data jadwal sholat dari API myquran.com.
/// Mendukung caching agar tidak fetch ulang setiap kali.
///
/// Endpoint: /v2/sholat/jadwal/{kota_id}/{tahun}/{bulan}
/// Default kota: 1206 (Medan)

class PrayerService {
  static const String _baseUrl = 'https://api.myquran.com/v2/sholat/jadwal';

  /// Mengambil jadwal sholat untuk hari ini
  /// [kotaId] = ID kota (default 1206)
  Future<PrayerTime?> getTodayPrayer({String kotaId = '1206'}) async {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;

    // Buat cache key unik per hari
    final cacheKey = 'prayer_${kotaId}_${year}_${month}_$day';

    // Cek cache dulu
    final cached = await CacheService.getJsonFromCache(cacheKey);
    if (cached != null) {
      return PrayerTime.fromJson(cached as Map<String, dynamic>);
    }

    try {
      // Fetch dari API jika cache tidak ada/expired
      final url = '$_baseUrl/$kotaId/$year/$month';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final jadwalList = data['data']?['jadwal'] as List<dynamic>?;

        if (jadwalList != null && jadwalList.isNotEmpty) {
          // Cari jadwal untuk hari ini (index = day - 1)
          final todayIndex = day - 1;
          if (todayIndex < jadwalList.length) {
            final jadwalJson = jadwalList[todayIndex] as Map<String, dynamic>;
            // Simpan ke cache
            await CacheService.saveJsonToCache(cacheKey, jadwalJson);
            return PrayerTime.fromJson(jadwalJson);
          }
        }
      }
    } catch (e) {
      // Error handling: return null jika gagal fetch
      // ignore: avoid_print
      print('Error fetching prayer times: $e');
    }
    return null;
  }
}
