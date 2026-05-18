import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../viewmodels/doa_viewmodel.dart';

class DoaScreen extends StatefulWidget {
  const DoaScreen({super.key});
  @override
  State<DoaScreen> createState() => _DoaScreenState();
}

class _DoaScreenState extends State<DoaScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoaViewModel>().fetchAllDoa();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DoaViewModel>();
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
                  gradient: LinearGradient(colors: isDark ? [AppTheme.darkSurface, AppTheme.darkCard] : [AppTheme.darkGreen, AppTheme.primaryGreen]),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        const Icon(Icons.volunteer_activism_rounded, color: AppTheme.goldAccent, size: 26),
                        const SizedBox(width: 10),
                        Text('Doa-Doa', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                      ]),
                    ]),
                  ),
                ),
              ),
            ),
          ),
          // Search
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkCard : AppTheme.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => vm.searchDoa(v),
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Cari doa...',
                    hintStyle: GoogleFonts.poppins(color: AppTheme.textGrey, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: AppTheme.primaryGreen),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
          ),
          if (vm.isLoading)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen)))
          else if (vm.error.isNotEmpty)
            SliverFillRemaining(child: Center(child: Text(vm.error)))
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final doa = vm.doaList[index];
                  return _doaTile(context, doa, vm, isDark);
                },
                childCount: vm.doaList.length,
              ),
            ),
        ],
      ),
    );
  }

  Widget _doaTile(BuildContext context, doa, DoaViewModel vm, bool isDark) {
    return GestureDetector(
      onTap: () => _showDoaDetail(context, doa, vm, isDark),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : AppTheme.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1)),
        ),
        child: Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: AppTheme.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: const Center(child: Icon(Icons.volunteer_activism_rounded, color: AppTheme.primaryGreen, size: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(doa.doa, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? AppTheme.textLight : AppTheme.textDark), maxLines: 2, overflow: TextOverflow.ellipsis)),
          IconButton(
            icon: Icon(vm.isDoaBookmarked(doa.id) ? Icons.bookmark : Icons.bookmark_border, color: vm.isDoaBookmarked(doa.id) ? AppTheme.goldAccent : AppTheme.textGrey, size: 22),
            onPressed: () => vm.toggleBookmark(doa.id),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textGrey),
        ]),
      ),
    );
  }

  void _showDoaDetail(BuildContext context, doa, DoaViewModel vm, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, ctrl) => Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkBg : AppTheme.offWhite,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(controller: ctrl, padding: const EdgeInsets.all(20), children: [
            // Handle bar
            Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)))),
            // Title
            Row(children: [
              Expanded(child: Text(doa.doa, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: isDark ? AppTheme.textLight : AppTheme.textDark))),
              IconButton(icon: Icon(vm.isDoaBookmarked(doa.id) ? Icons.bookmark : Icons.bookmark_border, color: AppTheme.goldAccent), onPressed: () => vm.toggleBookmark(doa.id)),
            ]),
            const SizedBox(height: 20),
            // Arabic
            if (doa.ayat.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkCard : AppTheme.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.3)),
                ),
                child: Text(doa.ayat, textAlign: TextAlign.right, style: GoogleFonts.amiri(fontSize: 24, height: 2.0, color: isDark ? AppTheme.textLight : AppTheme.textDark)),
              ),
              const SizedBox(height: 16),
            ],
            // Latin
            if (doa.latin.isNotEmpty) ...[
              Text('Bacaan Latin:', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primaryGreen)),
              const SizedBox(height: 6),
              Text(doa.latin, style: GoogleFonts.poppins(fontSize: 14, fontStyle: FontStyle.italic, color: isDark ? Colors.white70 : AppTheme.textGrey, height: 1.6)),
              const SizedBox(height: 16),
            ],
            // Translation
            Text('Artinya:', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primaryGreen)),
            const SizedBox(height: 6),
            Text(doa.artinya, style: GoogleFonts.poppins(fontSize: 14, color: isDark ? Colors.white70 : AppTheme.textGrey, height: 1.6)),
          ]),
        ),
      ),
    );
  }
}
