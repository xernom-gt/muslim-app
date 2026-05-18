import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ============================================
/// VIEWMODEL: Tasbih (Zikir Counter)
/// ============================================
/// Mengelola state untuk fitur tasbih digital.
/// Counter disimpan di SharedPreferences agar tidak hilang.

class TasbihViewModel extends ChangeNotifier {
  int _count = 0;
  int _targetCount = 33;
  int _totalCount = 0;
  String _currentDzikir = 'Subhanallah';

  // Getters
  int get count => _count;
  int get targetCount => _targetCount;
  int get totalCount => _totalCount;
  String get currentDzikir => _currentDzikir;

  // Daftar dzikir yang tersedia
  final List<Map<String, dynamic>> dzikirList = [
    {
      'name': 'Subhanallah',
      'arabic': 'سُبْحَانَ اللّٰهِ',
      'meaning': 'Maha Suci Allah',
      'target': 33,
    },
    {
      'name': 'Alhamdulillah',
      'arabic': 'اَلْحَمْدُ لِلّٰهِ',
      'meaning': 'Segala Puji bagi Allah',
      'target': 33,
    },
    {
      'name': 'Allahu Akbar',
      'arabic': 'اَللّٰهُ أَكْبَرُ',
      'meaning': 'Allah Maha Besar',
      'target': 33,
    },
    {
      'name': 'Istighfar',
      'arabic': 'أَسْتَغْفِرُ اللّٰهَ',
      'meaning': 'Aku memohon ampun kepada Allah',
      'target': 100,
    },
    {
      'name': 'La ilaha illallah',
      'arabic': 'لَا إِلٰهَ إِلَّا اللّٰهُ',
      'meaning': 'Tiada Tuhan selain Allah',
      'target': 100,
    },
    {
      'name': 'Shalawat',
      'arabic': 'اَللّٰهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
      'meaning': 'Ya Allah, berilah shalawat atas Nabi Muhammad',
      'target': 100,
    },
  ];

  TasbihViewModel() {
    _loadData();
  }

  /// Memuat data tersimpan
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _totalCount = prefs.getInt('tasbih_total') ?? 0;
    notifyListeners();
  }

  /// Increment counter
  void increment() {
    _count++;
    _totalCount++;
    _saveTotal();
    notifyListeners();
  }

  /// Reset counter ke 0
  void reset() {
    _count = 0;
    notifyListeners();
  }

  /// Ganti dzikir yang aktif
  void changeDzikir(String name) {
    _currentDzikir = name;
    final dzikir = dzikirList.firstWhere(
      (d) => d['name'] == name,
      orElse: () => dzikirList[0],
    );
    _targetCount = dzikir['target'] as int;
    _count = 0;
    notifyListeners();
  }

  /// Set target custom
  void setTarget(int target) {
    _targetCount = target;
    notifyListeners();
  }

  Future<void> _saveTotal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tasbih_total', _totalCount);
  }
}
