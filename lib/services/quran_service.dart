import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah.dart';
import 'cache_service.dart';

/// ============================================
/// SERVICE: Quran API
/// ============================================
/// Mengambil data Al-Qur'an dari API equran.id.
/// Fitur: daftar surat, detail surat + ayat.
///
/// Endpoint: https://equran.id/api/v2/surat
///           https://equran.id/api/v2/surat/{nomor}

class QuranService {
  static const String _baseUrl = 'https://equran.id/api/v2/surat';

  /// Mengambil daftar seluruh 114 surat
  Future<List<Surah>> getAllSurah() async {
    const cacheKey = 'quran_all_surah';

    // Cek cache
    final cached = await CacheService.getJsonFromCache(cacheKey);
    if (cached != null) {
      final list = cached as List<dynamic>;
      return list.map((s) => Surah.fromJson(s as Map<String, dynamic>)).toList();
    }

    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final surahList = data['data'] as List<dynamic>;

        // Simpan ke cache
        await CacheService.saveJsonToCache(cacheKey, surahList);

        return surahList
            .map((s) => Surah.fromJson(s as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print('Error fetching surah list: $e');
    }
    return [];
  }

  /// Mengambil detail surat (beserta semua ayat) berdasarkan nomor
  Future<SurahDetail?> getSurahDetail(int nomor) async {
    final cacheKey = 'quran_surah_$nomor';

    // Cek cache
    final cached = await CacheService.getJsonFromCache(cacheKey);
    if (cached != null) {
      return SurahDetail.fromJson(cached as Map<String, dynamic>);
    }

    try {
      final response = await http.get(Uri.parse('$_baseUrl/$nomor'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final surahData = data['data'] as Map<String, dynamic>;

        // Simpan ke cache
        await CacheService.saveJsonToCache(cacheKey, surahData);

        return SurahDetail.fromJson(surahData);
      }
    } catch (e) {
      print('Error fetching surah detail: $e');
    }
    return null;
  }
}
