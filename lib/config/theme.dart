import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ============================================
/// THEME CONFIGURATION
/// ============================================
/// Mendefinisikan tema visual aplikasi islami.
/// Menggunakan warna hijau lembut, putih, dan gold
/// sebagai aksen ringan sesuai nuansa islami.

class AppTheme {
  // ── Warna Utama ──
  static const Color primaryGreen = Color(0xFF2E7D4F);
  static const Color lightGreen = Color(0xFF4CAF6E);
  static const Color darkGreen = Color(0xFF1B5E3A);
  static const Color softGreen = Color(0xFFE8F5E9);
  static const Color goldAccent = Color(0xFFD4A843);
  static const Color lightGold = Color(0xFFF5E6C8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFAFAFA);
  static const Color darkBg = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF16213E);
  static const Color darkSurface = Color(0xFF0F3460);
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textGrey = Color(0xFF757575);
  static const Color textLight = Color(0xFFE0E0E0);

  // ── Light Theme ──
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.light,
      primary: primaryGreen,
      secondary: goldAccent,
      surface: white,
      onPrimary: white,
      onSecondary: textDark,
      onSurface: textDark,
    ),
    scaffoldBackgroundColor: offWhite,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryGreen,
      foregroundColor: white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: white,
      ),
    ),
    cardTheme: CardThemeData(
      color: white,
      elevation: 2,
      shadowColor: primaryGreen.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textDark,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textDark,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textDark,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        color: textDark,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        color: textDark,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        color: textGrey,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: white,
      selectedItemColor: primaryGreen,
      unselectedItemColor: textGrey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryGreen,
      foregroundColor: white,
    ),
  );

  // ── Dark Theme ──
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.dark,
      primary: lightGreen,
      secondary: goldAccent,
      surface: darkCard,
      onPrimary: white,
      onSecondary: white,
      onSurface: textLight,
    ),
    scaffoldBackgroundColor: darkBg,
    appBarTheme: AppBarTheme(
      backgroundColor: darkCard,
      foregroundColor: white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: white,
      ),
    ),
    cardTheme: CardThemeData(
      color: darkCard,
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textLight,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textLight,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textLight,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textLight,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        color: textLight,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        color: textLight,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        color: textGrey,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkCard,
      selectedItemColor: lightGreen,
      unselectedItemColor: textGrey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: lightGreen,
      foregroundColor: white,
    ),
  );
}
