import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'viewmodels/prayer_viewmodel.dart';
import 'viewmodels/quran_viewmodel.dart';
import 'viewmodels/doa_viewmodel.dart';
import 'viewmodels/tasbih_viewmodel.dart';
import 'viewmodels/theme_viewmodel.dart';
import 'views/home_screen.dart';

/// ============================================
/// MAIN: Entry Point Aplikasi
/// ============================================
/// Aplikasi dimulai dari sini. Kita mendaftarkan semua
/// ViewModel (Provider) di level teratas agar bisa
/// diakses dari mana saja di widget tree.

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const IslamicApp());
}

class IslamicApp extends StatelessWidget {
  const IslamicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Mendaftarkan semua ViewModel
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider(create: (_) => PrayerViewModel()),
        ChangeNotifierProvider(create: (_) => QuranViewModel()),
        ChangeNotifierProvider(create: (_) => DoaViewModel()),
        ChangeNotifierProvider(create: (_) => TasbihViewModel()),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeVm, _) {
          return MaterialApp(
            title: 'Islamic App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeVm.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
