import 'package:flutter/material.dart';
import '../models/doa.dart';
import '../services/doa_service.dart';
import '../services/cache_service.dart';

/// ============================================
/// VIEWMODEL: Doa
/// ============================================
/// Mengelola state untuk fitur doa-doa.

class DoaViewModel extends ChangeNotifier {
  final DoaService _service = DoaService();

  List<Doa> _doaList = [];
  List<Doa> _filteredList = [];
  bool _isLoading = false;
  String _error = '';
  String _searchQuery = '';
  Set<String> _bookmarkedDoa = {};

  // Getters
  List<Doa> get doaList =>
      _filteredList.isEmpty && _searchQuery.isEmpty ? _doaList : _filteredList;
  bool get isLoading => _isLoading;
  String get error => _error;
  Set<String> get bookmarkedDoa => _bookmarkedDoa;

  /// Mengambil semua doa dari API
  Future<void> fetchAllDoa() async {
    if (_doaList.isNotEmpty) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    final result = await _service.getAllDoa();

    if (result.isNotEmpty) {
      _doaList = result;
      _filteredList = result;
      await _loadBookmarks();
    } else {
      _error = 'Gagal memuat doa';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Mencari doa berdasarkan judul
  void searchDoa(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredList = _doaList;
    } else {
      _filteredList = _doaList
          .where((d) => d.doa.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  /// Toggle bookmark doa
  Future<void> toggleBookmark(String doaId) async {
    await CacheService.toggleBookmark('doa', doaId);
    if (_bookmarkedDoa.contains(doaId)) {
      _bookmarkedDoa.remove(doaId);
    } else {
      _bookmarkedDoa.add(doaId);
    }
    notifyListeners();
  }

  bool isDoaBookmarked(String doaId) {
    return _bookmarkedDoa.contains(doaId);
  }

  Future<void> _loadBookmarks() async {
    final bookmarks = await CacheService.getBookmarks('doa');
    _bookmarkedDoa = bookmarks.toSet();
    notifyListeners();
  }
}
