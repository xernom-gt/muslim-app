import 'package:flutter/material.dart';
import '../models/surah.dart';
import '../services/quran_service.dart';
import '../services/cache_service.dart';

/// ============================================
/// VIEWMODEL: Quran (Al-Qur'an)
/// ============================================
/// Mengelola state untuk fitur Al-Qur'an:
/// - Daftar surat (114 surat)
/// - Detail surat + ayat
/// - Pencarian surat
/// - Bookmark ayat

class QuranViewModel extends ChangeNotifier {
  final QuranService _service = QuranService();

  List<Surah> _surahList = [];
  List<Surah> _filteredList = [];
  SurahDetail? _currentSurah;
  bool _isLoading = false;
  bool _isLoadingDetail = false;
  String _error = '';
  String _searchQuery = '';
  Set<String> _bookmarkedAyat = {};

  // Getters
  List<Surah> get surahList => _filteredList.isEmpty && _searchQuery.isEmpty
      ? _surahList
      : _filteredList;
  SurahDetail? get currentSurah => _currentSurah;
  bool get isLoading => _isLoading;
  bool get isLoadingDetail => _isLoadingDetail;
  String get error => _error;
  String get searchQuery => _searchQuery;
  Set<String> get bookmarkedAyat => _bookmarkedAyat;

  /// Mengambil daftar semua surat
  Future<void> fetchAllSurah() async {
    if (_surahList.isNotEmpty) return; // Sudah ada data, skip

    _isLoading = true;
    _error = '';
    notifyListeners();

    final result = await _service.getAllSurah();

    if (result.isNotEmpty) {
      _surahList = result;
      _filteredList = result;
    } else {
      _error = 'Gagal memuat daftar surat';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Mengambil detail surat (ayat-ayat)
  Future<void> fetchSurahDetail(int nomor) async {
    _isLoadingDetail = true;
    _currentSurah = null;
    notifyListeners();

    final result = await _service.getSurahDetail(nomor);

    if (result != null) {
      _currentSurah = result;
      // Load bookmarks untuk surat ini
      await _loadBookmarks(nomor);
    }

    _isLoadingDetail = false;
    notifyListeners();
  }

  /// Mencari surat berdasarkan nama
  void searchSurah(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredList = _surahList;
    } else {
      _filteredList = _surahList.where((s) {
        return s.namaLatin.toLowerCase().contains(query.toLowerCase()) ||
            s.arti.toLowerCase().contains(query.toLowerCase()) ||
            s.nomor.toString() == query;
      }).toList();
    }
    notifyListeners();
  }

  /// Toggle bookmark untuk ayat tertentu
  Future<void> toggleBookmark(int surahNomor, int ayatNomor) async {
    final id = '${surahNomor}_$ayatNomor';
    await CacheService.toggleBookmark('ayat', id);
    if (_bookmarkedAyat.contains(id)) {
      _bookmarkedAyat.remove(id);
    } else {
      _bookmarkedAyat.add(id);
    }
    notifyListeners();
  }

  bool isAyatBookmarked(int surahNomor, int ayatNomor) {
    return _bookmarkedAyat.contains('${surahNomor}_$ayatNomor');
  }

  Future<void> _loadBookmarks(int surahNomor) async {
    final bookmarks = await CacheService.getBookmarks('ayat');
    _bookmarkedAyat = bookmarks
        .where((b) => b.startsWith('${surahNomor}_'))
        .toSet();
  }
}
