import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../viewmodels/quran_viewmodel.dart';

class SurahDetailScreen extends StatefulWidget {
  final int surahNomor;
  final String surahName;
  const SurahDetailScreen({super.key, required this.surahNomor, required this.surahName});
  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranViewModel>().fetchSurahDetail(widget.surahNomor);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuranViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: isDark ? AppTheme.darkCard : AppTheme.primaryGreen,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark ? [AppTheme.darkSurface, AppTheme.darkCard] : [AppTheme.darkGreen, AppTheme.primaryGreen],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(56, 0, 20, 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (vm.currentSurah != null) ...[
                          Text(vm.currentSurah!.surah.nama, style: GoogleFonts.amiri(fontSize: 28, color: AppTheme.goldAccent, fontWeight: FontWeight.w700)),
                          Text(vm.currentSurah!.surah.namaLatin, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                          Text('${vm.currentSurah!.surah.arti} • ${vm.currentSurah!.surah.tempatTurun} • ${vm.currentSurah!.surah.jumlahAyat} Ayat',
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
                        ] else
                          Text(widget.surahName, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (vm.isLoadingDetail)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen)))
          else if (vm.currentSurah != null) ...[
            // Bismillah (kecuali At-Taubah)
            if (widget.surahNomor != 9)
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkCard : AppTheme.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.3)),
                  ),
                  child: Center(
                    child: Text('بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                      style: GoogleFonts.amiri(fontSize: 26, color: AppTheme.primaryGreen, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            // Ayat list
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final ayat = vm.currentSurah!.ayat[index];
                  final isBookmarked = vm.isAyatBookmarked(widget.surahNomor, ayat.nomorAyat);
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkCard : AppTheme.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1)),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      // Header ayat
                      Row(children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(color: AppTheme.primaryGreen.withValues(alpha: 0.1), shape: BoxShape.circle),
                          child: Center(child: Text('${ayat.nomorAyat}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.primaryGreen))),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: isBookmarked ? AppTheme.goldAccent : AppTheme.textGrey, size: 22),
                          onPressed: () => vm.toggleBookmark(widget.surahNomor, ayat.nomorAyat),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      // Teks Arab
                      Text(ayat.teksArab,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.amiri(fontSize: 24, height: 2.2, color: isDark ? AppTheme.textLight : AppTheme.textDark)),
                      const SizedBox(height: 12),
                      // Teks Latin
                      Text(ayat.teksLatin, style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.primaryGreen, fontStyle: FontStyle.italic)),
                      const SizedBox(height: 8),
                      // Terjemahan
                      Text(ayat.teksIndonesia, style: GoogleFonts.poppins(fontSize: 13, color: isDark ? Colors.white70 : AppTheme.textGrey, height: 1.5)),
                    ]),
                  );
                },
                childCount: vm.currentSurah!.ayat.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ],
      ),
    );
  }
}
