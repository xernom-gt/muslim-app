import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../viewmodels/tasbih_viewmodel.dart';

class TasbihScreen extends StatelessWidget {
  const TasbihScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TasbihViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentDzikir = vm.dzikirList.firstWhere(
      (d) => d['name'] == vm.currentDzikir,
      orElse: () => vm.dzikirList[0],
    );
    final progress = vm.targetCount > 0 ? vm.count / vm.targetCount : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasbih Digital', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: isDark ? AppTheme.darkCard : AppTheme.primaryGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.list_rounded),
            onPressed: () => _showDzikirPicker(context, vm),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark ? [AppTheme.darkBg, AppTheme.darkCard] : [AppTheme.softGreen, AppTheme.offWhite],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Dzikir name
                      Text(currentDzikir['arabic'] as String, style: GoogleFonts.amiri(fontSize: 32, color: AppTheme.primaryGreen, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(currentDzikir['name'] as String, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? AppTheme.textLight : AppTheme.textDark)),
                      Text(currentDzikir['meaning'] as String, style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textGrey)),
                      const SizedBox(height: 30),

                      // Counter circle
                      Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              vm.increment();
                            },
                            child: SizedBox(
                              width: 240,
                              height: 240,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Progress ring
                                  SizedBox(
                                    width: 240, height: 240,
                                    child: CustomPaint(painter: _ProgressPainter(progress: progress.clamp(0.0, 1.0), isDark: isDark)),
                                  ),
                                  // Inner circle
                                  Container(
                                    width: 200, height: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isDark ? AppTheme.darkCard : AppTheme.white,
                                      boxShadow: [BoxShadow(color: AppTheme.primaryGreen.withValues(alpha: 0.15), blurRadius: 20, spreadRadius: 2)],
                                    ),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      Text('${vm.count}', style: GoogleFonts.poppins(fontSize: 52, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                                      Text('/ ${vm.targetCount}', style: GoogleFonts.poppins(fontSize: 16, color: AppTheme.textGrey)),
                                      const SizedBox(height: 4),
                                      Text('TAP', style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.goldAccent, fontWeight: FontWeight.w600, letterSpacing: 2)),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Bottom info & reset
                      Container(
                        padding: const EdgeInsets.all(24),
                        child: Column(children: [
                          // Total count
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: isDark ? AppTheme.darkCard : AppTheme.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.3)),
                            ),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              const Icon(Icons.star_rounded, color: AppTheme.goldAccent, size: 20),
                              const SizedBox(width: 8),
                              Text('Total Zikir: ', style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textGrey)),
                              Text('${vm.totalCount}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                            ]),
                          ),
                          const SizedBox(height: 16),
                          // Reset button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: () => vm.reset(),
                              icon: const Icon(Icons.refresh_rounded),
                              label: Text('Reset Counter', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  void _showDzikirPicker(BuildContext context, TasbihViewModel vm) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.offWhite,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Text('Pilih Dzikir', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: isDark ? AppTheme.textLight : AppTheme.textDark)),
          const SizedBox(height: 12),
          ...vm.dzikirList.map((d) => ListTile(
            onTap: () {
              vm.changeDzikir(d['name'] as String);
              Navigator.pop(context);
            },
            leading: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: AppTheme.primaryGreen.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Center(child: Icon(Icons.touch_app, color: AppTheme.primaryGreen, size: 20)),
            ),
            title: Text(d['name'] as String, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            subtitle: Text(d['arabic'] as String, style: GoogleFonts.amiri(fontSize: 16, color: AppTheme.primaryGreen)),
            trailing: Text('${d['target']}x', style: GoogleFonts.poppins(color: AppTheme.textGrey)),
            selected: vm.currentDzikir == d['name'],
            selectedTileColor: AppTheme.primaryGreen.withValues(alpha: 0.05),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          )),
        ]),
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double progress;
  final bool isDark;
  _ProgressPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    // Background ring
    canvas.drawCircle(center, radius, Paint()
      ..color = isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8);
    // Progress arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, Paint()
      ..color = AppTheme.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant _ProgressPainter old) => old.progress != progress;
}
