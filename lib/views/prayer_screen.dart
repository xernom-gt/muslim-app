import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../viewmodels/prayer_viewmodel.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});
  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrayerViewModel>().fetchPrayerTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PrayerViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: isDark ? AppTheme.darkCard : AppTheme.primaryGreen,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [AppTheme.darkSurface, AppTheme.darkCard]
                        : [AppTheme.darkGreen, AppTheme.primaryGreen],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.mosque_rounded, color: AppTheme.goldAccent, size: 26),
                          const SizedBox(width: 10),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Jadwal Sholat', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text(vm.prayerTime?.tanggal ?? 'Memuat...', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
                          ]),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (vm.isLoading)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen)))
          else if (vm.error.isNotEmpty)
            SliverFillRemaining(child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.error_outline, size: 48, color: AppTheme.goldAccent),
              const SizedBox(height: 12),
              Text(vm.error),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () => vm.fetchPrayerTime(), child: const Text('Coba Lagi')),
            ])))
          else if (vm.prayerTime != null)
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                _nextPrayerCard(vm, isDark),
                const SizedBox(height: 16),
                ...vm.prayerTime!.toDisplayList().map((item) => _prayerItem(item['name']!, item['time']!, item['icon']!, vm.getCurrentPrayer() == item['name'], isDark)),
              ]),
            )),
        ],
      ),
    );
  }

  Widget _nextPrayerCard(PrayerViewModel vm, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: isDark ? [AppTheme.darkSurface, AppTheme.darkCard] : [AppTheme.primaryGreen, AppTheme.lightGreen]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppTheme.primaryGreen.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(children: [
        Text('Waktu Sholat Selanjutnya', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 8),
        Text(vm.getNextPrayer(), style: GoogleFonts.poppins(color: AppTheme.goldAccent, fontSize: 28, fontWeight: FontWeight.bold)),
        const Icon(Icons.mosque_rounded, color: Colors.white38, size: 36),
      ]),
    );
  }

  Widget _prayerItem(String name, String time, String iconType, bool isActive, bool isDark) {
    IconData icon = switch (iconType) {
      'subuh' => Icons.nightlight_round,
      'sunrise' => Icons.wb_twilight_rounded,
      'morning' => Icons.wb_sunny_rounded,
      'noon' => Icons.light_mode_rounded,
      'afternoon' => Icons.wb_cloudy_rounded,
      'sunset' => Icons.nights_stay_rounded,
      _ => Icons.dark_mode_rounded,
    };
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isActive ? (isDark ? AppTheme.darkSurface : AppTheme.primaryGreen.withValues(alpha: 0.1)) : (isDark ? AppTheme.darkCard : AppTheme.white),
        borderRadius: BorderRadius.circular(16),
        border: isActive ? Border.all(color: AppTheme.primaryGreen, width: 2) : Border.all(color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.15)),
        boxShadow: isActive ? [BoxShadow(color: AppTheme.primaryGreen.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))] : null,
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: isActive ? AppTheme.primaryGreen.withValues(alpha: 0.15) : (isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.08)), shape: BoxShape.circle),
          child: Icon(icon, color: isActive ? AppTheme.primaryGreen : (isDark ? Colors.white54 : AppTheme.textGrey), size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(child: Text(name, style: GoogleFonts.poppins(fontSize: 16, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500, color: isActive ? AppTheme.primaryGreen : (isDark ? AppTheme.textLight : AppTheme.textDark)))),
        Text(time, style: GoogleFonts.poppins(fontSize: 18, fontWeight: isActive ? FontWeight.w700 : FontWeight.w600, color: isActive ? AppTheme.primaryGreen : (isDark ? AppTheme.textLight : AppTheme.textDark))),
        if (isActive) ...[
          const SizedBox(width: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppTheme.primaryGreen, borderRadius: BorderRadius.circular(8)),
            child: Text('NOW', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white))),
        ],
      ]),
    );
  }
}
