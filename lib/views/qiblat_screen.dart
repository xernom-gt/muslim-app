import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

/// ============================================
/// VIEW: Qiblat Screen (Arah Kiblat)
/// ============================================
/// Menampilkan kompas arah kiblat.
/// Catatan: Untuk real sensor, flutter_compass membutuhkan
/// permission dan perangkat fisik. Di emulator, kita tampilkan
/// UI kompas statis yang informatif.

class QiblatScreen extends StatefulWidget {
  const QiblatScreen({super.key});
  @override
  State<QiblatScreen> createState() => _QiblatScreenState();
}

class _QiblatScreenState extends State<QiblatScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _animation;

  // Arah Kiblat default (dari Indonesia ~295 derajat)
  final double _qiblaDirection = 295.0;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(begin: 0, end: _qiblaDirection).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut),
    );
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Arah Kiblat', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: isDark ? AppTheme.darkCard : AppTheme.primaryGreen,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppTheme.darkBg, AppTheme.darkCard]
                : [AppTheme.softGreen, AppTheme.offWhite],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Kaaba icon
                      Text('🕋', style: const TextStyle(fontSize: 40)),
                      const SizedBox(height: 8),
                      Text('Ka\'bah - Makkah', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? AppTheme.textLight : AppTheme.textDark)),
                      const SizedBox(height: 30),

                      // Compass
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return SizedBox(
                            width: 280,
                            height: 280,
                            child: CustomPaint(
                              painter: _CompassPainter(
                                direction: _animation.value,
                                isDark: isDark,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),

                      // Direction info
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.darkCard : AppTheme.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.goldAccent.withValues(alpha: 0.3)),
                        ),
                        child: Column(children: [
                          Text('Arah Kiblat', style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textGrey)),
                          const SizedBox(height: 4),
                          Text('${_qiblaDirection.toStringAsFixed(1)}° dari Utara', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                          const SizedBox(height: 8),
                          Text('Barat Laut', style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.goldAccent, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: AppTheme.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              const Icon(Icons.info_outline, color: AppTheme.primaryGreen, size: 18),
                              const SizedBox(width: 8),
                              Flexible(child: Text('Gunakan perangkat fisik untuk kompas real-time', style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.primaryGreen))),
                            ]),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 20),
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
}

/// Custom painter untuk kompas
class _CompassPainter extends CustomPainter {
  final double direction;
  final bool isDark;

  _CompassPainter({required this.direction, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Outer circle
    final outerPaint = Paint()
      ..color = isDark ? AppTheme.darkSurface : AppTheme.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, outerPaint);

    // Border
    final borderPaint = Paint()
      ..color = AppTheme.primaryGreen.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, borderPaint);

    // Inner circle
    final innerPaint = Paint()
      ..color = AppTheme.primaryGreen.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.7, innerPaint);

    // Direction markers (N, E, S, W)
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final dirs = ['U', 'T', 'S', 'B']; // Utara, Timur, Selatan, Barat
    for (int i = 0; i < 4; i++) {
      final angle = (i * 90) * math.pi / 180 - math.pi / 2;
      final x = center.dx + (radius - 25) * math.cos(angle);
      final y = center.dy + (radius - 25) * math.sin(angle);

      textPainter.text = TextSpan(
        text: dirs[i],
        style: TextStyle(
          color: i == 0 ? AppTheme.primaryGreen : (isDark ? Colors.white54 : AppTheme.textGrey),
          fontSize: i == 0 ? 18 : 14,
          fontWeight: i == 0 ? FontWeight.bold : FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }

    // Tick marks
    for (int i = 0; i < 36; i++) {
      final angle = (i * 10) * math.pi / 180 - math.pi / 2;
      final outerR = radius - 5;
      final innerR = i % 9 == 0 ? radius - 18 : radius - 12;

      canvas.drawLine(
        Offset(center.dx + innerR * math.cos(angle), center.dy + innerR * math.sin(angle)),
        Offset(center.dx + outerR * math.cos(angle), center.dy + outerR * math.sin(angle)),
        Paint()
          ..color = (isDark ? Colors.white30 : Colors.grey.withValues(alpha: 0.3))
          ..strokeWidth = i % 9 == 0 ? 2 : 1,
      );
    }

    // Qibla arrow
    final qiblaAngle = direction * math.pi / 180 - math.pi / 2;
    final arrowLength = radius * 0.55;

    final arrowPaint = Paint()
      ..color = AppTheme.primaryGreen
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;

    // Arrow head
    final path = Path();
    final tipX = center.dx + arrowLength * math.cos(qiblaAngle);
    final tipY = center.dy + arrowLength * math.sin(qiblaAngle);
    final leftAngle = qiblaAngle + 2.8;
    final rightAngle = qiblaAngle - 2.8;
    final baseLen = 20.0;

    path.moveTo(tipX, tipY);
    path.lineTo(center.dx + baseLen * math.cos(leftAngle), center.dy + baseLen * math.sin(leftAngle));
    path.lineTo(center.dx + baseLen * math.cos(rightAngle), center.dy + baseLen * math.sin(rightAngle));
    path.close();

    canvas.drawPath(path, arrowPaint);

    // Center dot
    canvas.drawCircle(center, 6, Paint()..color = AppTheme.goldAccent);
    canvas.drawCircle(center, 3, Paint()..color = AppTheme.white);
  }

  @override
  bool shouldRepaint(covariant _CompassPainter old) => old.direction != direction || old.isDark != isDark;
}
