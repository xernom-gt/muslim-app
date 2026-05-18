import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// ============================================
/// SERVICE: Cache Manager
/// ============================================
/// Mengelola cache data API menggunakan SharedPreferences.
/// Data disimpan dengan timestamp agar bisa expired otomatis.
/// Ini mencegah fetch berulang ke API yang tidak perlu.

class CacheService {
  static const int _cacheMinutes = 60; // Cache berlaku 60 menit

  /// Menyimpan data ke cache beserta timestamp
  static Future<void> saveToCache(String key, String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, data);
    await prefs.setInt(
      '${key}_timestamp',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Mengambil data dari cache jika masih valid (belum expired)
  /// Mengembalikan null jika cache sudah expired atau tidak ada
  static Future<String?> getFromCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    final timestamp = prefs.getInt('${key}_timestamp');

    if (data == null || timestamp == null) return null;

    final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    // Cek apakah cache masih dalam batas waktu
    if (now.difference(cachedTime).inMinutes > _cacheMinutes) {
      // Cache sudah expired, hapus
      await prefs.remove(key);
      await prefs.remove('${key}_timestamp');
      return null;
    }

    return data;
  }

  /// Menyimpan dan mengambil data JSON (List atau Map)
  static Future<void> saveJsonToCache(String key, dynamic data) async {
    await saveToCache(key, jsonEncode(data));
  }

  static Future<dynamic> getJsonFromCache(String key) async {
    final data = await getFromCache(key);
    if (data == null) return null;
    return jsonDecode(data);
  }

  /// Menyimpan bookmark ayat/doa
  static Future<void> toggleBookmark(String type, String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'bookmarks_$type';
    final bookmarks = prefs.getStringList(key) ?? [];

    if (bookmarks.contains(id)) {
      bookmarks.remove(id);
    } else {
      bookmarks.add(id);
    }

    await prefs.setStringList(key, bookmarks);
  }

  static Future<bool> isBookmarked(String type, String id) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList('bookmarks_$type') ?? [];
    return bookmarks.contains(id);
  }

  static Future<List<String>> getBookmarks(String type) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('bookmarks_$type') ?? [];
  }
}
