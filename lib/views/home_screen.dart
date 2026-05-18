import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../viewmodels/prayer_viewmodel.dart';
import '../viewmodels/theme_viewmodel.dart';
import 'prayer_screen.dart';
import 'quran_screen.dart';
import 'doa_screen.dart';
import 'qiblat_screen.dart';
import 'tasbih_screen.dart';

/// ============================================
/// VIEW: Home Screen
/// ============================================
/// Halaman utama aplikasi dengan bottom navigation.
/// Menampilkan ringkasan jadwal sholat dan menu fitur.

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _DashboardView(),
    const QuranScreen(),
    const DoaScreen(),
    const TasbihScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              activeIcon: Icon(Icons.menu_book_rounded),
              label: 'Al-Qur\'an',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.volunteer_activism_rounded),
              activeIcon: Icon(Icons.volunteer_activism_rounded),
              label: 'Doa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.touch_app_rounded),
              activeIcon: Icon(Icons.touch_app_rounded),
              label: 'Tasbih',
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================
/// Dashboard View (Tab pertama di Home)
/// ============================================
class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  @override
  void initState() {
    super.initState();
    // Fetch jadwal sholat saat pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrayerViewModel>().fetchPrayerTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeVm = context.watch<ThemeViewModel>();

    return CustomScrollView(
      slivers: [
        // ── App Bar dengan gradient ──
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [AppTheme.darkSurface, AppTheme.darkCard]
                      : [AppTheme.primaryGreen, AppTheme.darkGreen],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            '☪ ',
                            style: GoogleFonts.amiri(
                              fontSize: 28,
                              color: AppTheme.goldAccent,
                            ),
                          ),
                          Text(
                            'Islamic App',
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          // Dark mode toggle
                          IconButton(
                            onPressed: () => themeVm.toggleTheme(),
                            icon: Icon(
                              themeVm.isDarkMode
                                  ? Icons.light_mode_rounded
                                  : Icons.dark_mode_rounded,
                              color: AppTheme.goldAccent,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                        style: GoogleFonts.amiri(
                          fontSize: 20,
                          color: AppTheme.lightGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dengan menyebut nama Allah Yang Maha Pengasih lagi Maha Penyayang',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── Konten Dashboard ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Jadwal Sholat Card
                _buildPrayerCard(context),
                const SizedBox(height: 20),

                // Menu Grid
                Text(
                  'Menu Utama',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isDark ? AppTheme.textLight : AppTheme.textDark,
                      ),
                ),
                const SizedBox(height: 12),
                _buildMenuGrid(context),
                const SizedBox(height: 20),

                // Ayat Hari Ini
                _buildDailyVerse(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Card jadwal sholat
  Widget _buildPrayerCard(BuildContext context) {
    final prayerVm = context.watch<PrayerViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PrayerScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppTheme.darkSurface, AppTheme.darkCard]
                : [AppTheme.primaryGreen, AppTheme.lightGreen],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryGreen.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    color: AppTheme.goldAccent, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Jadwal Sholat Hari Ini',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.white70, size: 16),
              ],
            ),
            const SizedBox(height: 12),
            if (prayerVm.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              )
            else if (prayerVm.prayerTime != null) ...[
              // Waktu sholat berikutnya
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mosque_rounded,
                        color: AppTheme.goldAccent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Selanjutnya: ${prayerVm.getNextPrayer()}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Grid jadwal ringkas
              _buildMiniPrayerGrid(prayerVm),
            ] else
              Text(
                'Tap untuk melihat jadwal',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniPrayerGrid(PrayerViewModel vm) {
    final prayer = vm.prayerTime!;
    final current = vm.getCurrentPrayer();
    final items = [
      {'name': 'Subuh', 'time': prayer.subuh},
      {'name': 'Dzuhur', 'time': prayer.dzuhur},
      {'name': 'Ashar', 'time': prayer.ashar},
      {'name': 'Maghrib', 'time': prayer.maghrib},
      {'name': 'Isya', 'time': prayer.isya},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((item) {
        final isActive = item['name'] == current;
        return Column(
          children: [
            Text(
              item['name']!,
              style: GoogleFonts.poppins(
                color: isActive ? AppTheme.goldAccent : Colors.white70,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item['time']!,
              style: GoogleFonts.poppins(
                color: isActive ? AppTheme.goldAccent : Colors.white,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  /// Menu grid fitur
  Widget _buildMenuGrid(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final menus = [
      {
        'icon': Icons.access_time_rounded,
        'label': 'Jadwal\nSholat',
        'color': AppTheme.primaryGreen,
        'screen': const PrayerScreen(),
      },
      {
        'icon': Icons.menu_book_rounded,
        'label': 'Al-Qur\'an',
        'color': const Color(0xFF1565C0),
        'screen': const QuranScreen(),
      },
      {
        'icon': Icons.volunteer_activism_rounded,
        'label': 'Doa\nHarian',
        'color': const Color(0xFFE65100),
        'screen': const DoaScreen(),
      },
      {
        'icon': Icons.explore_rounded,
        'label': 'Arah\nKiblat',
        'color': const Color(0xFF6A1B9A),
        'screen': const QiblatScreen(),
      },
      {
        'icon': Icons.touch_app_rounded,
        'label': 'Tasbih\nDigital',
        'color': const Color(0xFF00838F),
        'screen': const TasbihScreen(),
      },
      {
        'icon': Icons.dark_mode_rounded,
        'label': 'Mode\nGelap',
        'color': const Color(0xFF37474F),
        'screen': null,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: menus.length,
      itemBuilder: (context, index) {
        final menu = menus[index];
        return GestureDetector(
          onTap: () {
            if (menu['screen'] != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => menu['screen'] as Widget),
              );
            } else {
              // Toggle dark mode
              context.read<ThemeViewModel>().toggleTheme();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkCard : AppTheme.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (menu['color'] as Color).withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (menu['color'] as Color).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    menu['icon'] as IconData,
                    color: menu['color'] as Color,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  menu['label'] as String,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppTheme.textLight : AppTheme.textDark,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Ayat hari ini
  Widget _buildDailyVerse(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.goldAccent.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.goldAccent.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome,
                  color: AppTheme.goldAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                'Ayat Hari Ini',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDark ? AppTheme.textLight : AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
            style: GoogleFonts.amiri(
              fontSize: 26,
              color: AppTheme.primaryGreen,
              height: 1.8,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          Text(
            '"Sesungguhnya bersama kesulitan itu ada kemudahan."',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.white70 : AppTheme.textGrey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '— QS. Al-Insyirah: 6',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppTheme.goldAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
