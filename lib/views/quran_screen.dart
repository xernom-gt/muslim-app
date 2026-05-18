import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../viewmodels/quran_viewmodel.dart';
import 'surah_detail_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});
  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranViewModel>().fetchAllSurah();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuranViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
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
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.menu_book_rounded, color: AppTheme.goldAccent, size: 26),
                          const SizedBox(width: 10),
                          Text('Al-Qur\'an', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                          const Spacer(),
                          Text('114 Surat', style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkCard : AppTheme.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => vm.searchSurah(v),
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Cari surat...',
                    hintStyle: GoogleFonts.poppins(color: AppTheme.textGrey, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: AppTheme.primaryGreen),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
          ),
          // Surah list
          if (vm.isLoading)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen)))
          else if (vm.error.isNotEmpty)
            SliverFillRemaining(child: Center(child: Text(vm.error)))
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final surah = vm.surahList[index];
                  return _surahTile(context, surah, isDark);
                },
                childCount: vm.surahList.length,
              ),
            ),
        ],
      ),
    );
  }

  Widget _surahTile(BuildContext context, surah, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SurahDetailScreen(surahNomor: surah.nomor, surahName: surah.namaLatin))),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : AppTheme.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1)),
        ),
        child: Row(children: [
          // Nomor surat
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text('${surah.nomor}', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.primaryGreen))),
          ),
          const SizedBox(width: 14),
          // Info surat
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(surah.namaLatin, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? AppTheme.textLight : AppTheme.textDark)),
            const SizedBox(height: 2),
            Text('${surah.arti} • ${surah.jumlahAyat} Ayat', style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textGrey)),
          ])),
          // Nama Arab
          Text(surah.nama, style: GoogleFonts.amiri(fontSize: 22, color: AppTheme.primaryGreen, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}
