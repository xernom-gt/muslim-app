import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/doa.dart';
import 'cache_service.dart';

/// ============================================
/// SERVICE: Doa API
/// ============================================
/// Mengambil data doa-doa dari API.
///
/// Endpoint: https://doa-doa-api-ahmadramadhan.fly.dev/api

class DoaService {
  static const String _baseUrl =
      'https://doa-doa-api-ahmadramadhan.fly.dev/api';

  /// Mengambil semua doa
  Future<List<Doa>> getAllDoa() async {
    const cacheKey = 'doa_all';

    // Cek cache
    final cached = await CacheService.getJsonFromCache(cacheKey);
    if (cached != null) {
      final list = cached as List<dynamic>;
      return list.map((d) => Doa.fromJson(d as Map<String, dynamic>)).toList();
    }

    try {
      // Gunakan CORS proxy jika berjalan di Web
      final String fetchUrl = kIsWeb
          ? 'https://api.allorigins.win/raw?url=${Uri.encodeComponent(_baseUrl)}'
          : _baseUrl;

      final response = await http.get(Uri.parse(fetchUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;

        // Simpan ke cache
        await CacheService.saveJsonToCache(cacheKey, data);

        return data
            .map((d) => Doa.fromJson(d as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print('Error fetching doa: $e');
    }
    return [];
  }
}
