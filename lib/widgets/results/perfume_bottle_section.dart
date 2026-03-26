import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/results_data.dart';
import '../../theme/app_theme.dart';

Color _noteColor(String note) {
  final n = note.toLowerCase();
  if (['bergamot', 'lemon', 'citrus', 'grapefruit', 'orange']
      .any((k) => n.contains(k))) {
    return const Color(0xFFFFD700);
  }
  if (['lavender', 'geranium', 'rose', 'jasmine', 'violet']
      .any((k) => n.contains(k))) {
    return const Color(0xFFD4BFEC);
  }
  if (['patchouli', 'vetiver', 'sandalwood', 'musk', 'amber', 'tobacco']
      .any((k) => n.contains(k))) {
    return const Color(0xFF8B3AED);
  }
  if (['aquatic', 'marine', 'sage', 'mint', 'juniper']
      .any((k) => n.contains(k))) {
    return const Color(0xFF4DD9FF);
  }
  if (['vanilla', 'tonka', 'cinnamon', 'incense'].any((k) => n.contains(k))) {
    return const Color(0xFFFF9500);
  }
  return const Color(0xFF4DD9FF);
}

class PerfumeBottleSection extends StatefulWidget {
  final ResultsData data;

  const PerfumeBottleSection({super.key, required this.data});

  @override
  State<PerfumeBottleSection> createState() => _PerfumeBottleSectionState();
}

class _PerfumeBottleSectionState extends State<PerfumeBottleSection>
    with TickerProviderStateMixin {
  late final AnimationController _breathController;
  late final AnimationController _rippleController;
  late final AnimationController _particleController;
  /// Nullable so hot reload (which skips `initState`) can still create this on first use.
  AnimationController? _auroraController;

  late final Color _primaryGlow;
  late final Color _secondaryGlow;

  @override
  void initState() {
    super.initState();
    final d = widget.data;
    _primaryGlow = d.middleNote.trim().isEmpty
        ? AppColors.accentCyan
        : _noteColor(d.middleNote);
    _secondaryGlow = d.baseNote.trim().isEmpty
        ? AppColors.analysisPurpleStart
        : _noteColor(d.baseNote);

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();

    _ensureAuroraController();
  }

  void _ensureAuroraController() {
    if (_auroraController != null) return;
    _auroraController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7000),
    )..repeat();
  }

  @override
  void dispose() {
    _breathController.dispose();
    _rippleController.dispose();
    _particleController.dispose();
    _auroraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ensureAuroraController();
    final aurora = _auroraController!;
    return SizedBox(
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: Listenable.merge([_breathController, aurora]),
              builder: (context, _) => CustomPaint(
                painter: _AuroraPainter(
                  breath: _breathController.value,
                  aurora: aurora.value,
                  primary: _primaryGlow,
                  secondary: _secondaryGlow,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _breathController,
                _rippleController,
                _particleController,
              ]),
              builder: (context, _) => CustomPaint(
                painter: _BottleAtmospherePainter(
                  breath: _breathController.value,
                  ripple: _rippleController.value,
                  orbit: _particleController.value,
                  primaryColor: _primaryGlow,
                  secondaryColor: _secondaryGlow,
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _breathController,
            builder: (context, child) => Transform.scale(
              scale: 1.0 + _breathController.value * 0.018,
              child: child,
            ),
            child: Image.asset(
              'assets/images/ysl_perfume.png',
              width: 210,
              height: 210,
              fit: BoxFit.contain,
              errorBuilder: (context, _, _) => Icon(
                Icons.water_drop_rounded,
                size: 120,
                color: _primaryGlow.withValues(alpha: 0.6),
              ),
            ),
          ),
          Positioned(
            top: 28,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.07),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuroraPainter extends CustomPainter {
  const _AuroraPainter({
    required this.breath,
    required this.aurora,
    required this.primary,
    required this.secondary,
  });

  final double breath;
  final double aurora;
  final Color primary;
  final Color secondary;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    final t = aurora * 2 * math.pi;
    final wave = math.sin(t);
    final waveB = math.sin(t + 1.2);
    final waveC = math.sin(t + 2.5);
    final waveSlow = math.sin(t * 0.52 + 0.9);
    final shimmer = math.sin(t * 1.9 + 0.35) * 0.42;
    final breathFactor = 0.82 + breath * 0.18;
    final tertiary = Color.lerp(primary, secondary, 0.48) ?? primary;
    final drift = waveSlow * w * 0.028;
    final ySh = shimmer * h * 0.018;
    final yBottom = h * 0.945;
    final bottomBellyY = h * 0.948;

    final peakY = h *
        (0.285 +
            (wave + waveB + waveC) / 3 * 0.035 +
            ySh / h);

    // Crest + ribbon top: two quadratics meeting at cx = smooth circular dome
    Path crestPath() {
      return Path()
        ..moveTo(0, yBottom)
        ..quadraticBezierTo(
          w * 0.28,
          h * (0.405 + wave * 0.045 + ySh / h),
          cx,
          peakY,
        )
        ..quadraticBezierTo(
          w * 0.72,
          h * (0.405 + waveC * 0.045 + ySh / h),
          w,
          yBottom,
        );
    }

    /// Rounded bowl bottom — cubic so the base reads as a smooth U, not a kink.
    void closeCurtainBottom(Path p) {
      p
        ..lineTo(w, h)
        ..cubicTo(
          w * 0.74,
          bottomBellyY,
          w * 0.26,
          bottomBellyY,
          0,
          h,
        )
        ..close();
    }

    final ribbonSky = Rect.fromCenter(
      center: Offset(cx + drift * 0.2, h * 0.16),
      width: w * 1.35,
      height: h * 0.48,
    );
    canvas.drawPath(
      Path()..addOval(ribbonSky),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment(waveSlow * 0.12 - 0.45, -1),
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            tertiary.withValues(alpha: 0.07 * breathFactor),
            primary.withValues(alpha: 0.11 * breathFactor),
            Colors.transparent,
          ],
          stops: const [0.0, 0.38, 0.64, 1.0],
        ).createShader(ribbonSky)
        ..blendMode = BlendMode.screen,
    );

    // Back: source glow — circular radial (evenly round, not stretched oval)
    final glowCenter = Offset(cx + drift * 0.35, h * 0.46 + ySh * 0.5);
    final glowR = math.min(w, h) * 0.40 * breathFactor;
    final glowShaderRect = Rect.fromCircle(center: glowCenter, radius: glowR);
    canvas.drawCircle(
      glowCenter,
      glowR,
      Paint()
        ..shader = RadialGradient(
          colors: [
            primary.withValues(alpha: 0.34 + breath * 0.14),
            Color.lerp(primary, secondary, 0.35)!
                .withValues(alpha: 0.20 + breath * 0.08),
            secondary.withValues(alpha: 0.10),
            secondary.withValues(alpha: 0.04),
            Colors.transparent,
          ],
          stops: const [0.0, 0.28, 0.52, 0.72, 1.0],
        ).createShader(glowShaderRect)
        ..blendMode = BlendMode.screen,
    );

    // Ribbon 1 — wide primary curtain (same dome as crest)
    final ribbon1Path = Path()
      ..moveTo(0, yBottom)
      ..quadraticBezierTo(
        w * 0.28,
        h * (0.405 + wave * 0.045 + ySh / h),
        cx,
        peakY,
      )
      ..quadraticBezierTo(
        w * 0.72,
        h * (0.405 + waveC * 0.045 + ySh / h),
        w,
        yBottom,
      );
    closeCurtainBottom(ribbon1Path);

    final sweep = waveSlow * 0.22;
    canvas.drawPath(
      ribbon1Path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment(-0.85 + sweep, -1),
          end: Alignment(0.85 - sweep, 1),
          colors: [
            primary.withValues(alpha: 0.58 * breathFactor),
            primary.withValues(alpha: 0.38 * breathFactor),
            tertiary.withValues(alpha: 0.22 * breathFactor),
            primary.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.38, 0.62, 1.0],
        ).createShader(Rect.fromLTWH(0, h * 0.22, w, h * 0.78))
        ..blendMode = BlendMode.screen,
    );

    // Tertiary veil — iridescent band (rounder profile + rounded bottom inset)
    final vL = w * 0.04;
    final vR = w * 0.96;
    final veilBottom = h * 0.918;
    final veilPeak = h *
        (0.265 +
            (waveB + waveC + wave) / 3 * 0.032 +
            ySh / h);
    final veilBellyY = h * 0.942;
    final veilPath = Path()
      ..moveTo(vL, veilBottom)
      ..quadraticBezierTo(
        w * 0.30,
        h * (0.375 + waveC * 0.055 + ySh / h),
        cx,
        veilPeak,
      )
      ..quadraticBezierTo(
        w * 0.70,
        h * (0.375 + waveB * 0.055 + ySh / h),
        vR,
        veilBottom,
      )
      ..lineTo(w, h)
      ..cubicTo(
        w * 0.78,
        veilBellyY,
        math.max(vL + w * 0.08, w * 0.20),
        veilBellyY,
        vL,
        h,
      )
      ..close();

    canvas.drawPath(
      veilPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            tertiary.withValues(alpha: 0.36 * breathFactor),
            secondary.withValues(alpha: 0.14 * breathFactor),
            Colors.transparent,
          ],
          stops: const [0.0, 0.42, 1.0],
        ).createShader(Rect.fromLTWH(0, h * 0.16, w, h * 0.84))
        ..blendMode = BlendMode.screen,
    );

    // Ribbon 2 — secondary mid curtain
    final r2L = w * 0.06;
    final r2Bottom = h * 0.898;
    final r2Peak = h *
        (0.228 +
            (wave + waveC + waveB) / 3 * 0.038 +
            ySh / h);
    final r2BellyY = h * 0.938;
    final ribbon2Path = Path()
      ..moveTo(r2L, r2Bottom)
      ..quadraticBezierTo(
        w * 0.32,
        h * (0.345 + waveB * 0.055 + ySh / h),
        cx,
        r2Peak,
      )
      ..quadraticBezierTo(
        w * 0.68,
        h * (0.345 + waveC * 0.055 + ySh / h),
        w,
        r2Bottom,
      )
      ..lineTo(w, h)
      ..cubicTo(
        w * 0.76,
        r2BellyY,
        math.max(r2L + w * 0.07, w * 0.22),
        r2BellyY,
        r2L,
        h,
      )
      ..close();

    canvas.drawPath(
      ribbon2Path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            secondary.withValues(alpha: 0.52 * breathFactor),
            secondary.withValues(alpha: 0.22 * breathFactor),
            Color.lerp(secondary, primary, 0.25)!
                .withValues(alpha: 0.08 * breathFactor),
            Colors.transparent,
          ],
          stops: const [0.0, 0.38, 0.65, 1.0],
        ).createShader(Rect.fromLTWH(0, h * 0.14, w, h * 0.86))
        ..blendMode = BlendMode.screen,
    );

    final crest = crestPath();

    canvas.drawPath(
      crest,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7 + breath * 2
        ..strokeCap = StrokeCap.round
        ..color = primary.withValues(alpha: 0.14 * breathFactor)
        ..blendMode = BlendMode.screen
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    canvas.drawPath(
      crest,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2 + breath * 0.6
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withValues(alpha: 0.50 * breathFactor),
            primary.withValues(alpha: 0.75 * breathFactor),
            secondary.withValues(alpha: 0.45 * breathFactor),
            Colors.white.withValues(alpha: 0.48 * breathFactor),
            Colors.transparent,
          ],
          stops: const [0.0, 0.15, 0.4, 0.55, 0.82, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, w, h))
        ..blendMode = BlendMode.screen,
    );
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter old) =>
      old.breath != breath ||
      old.aurora != aurora ||
      old.primary != primary ||
      old.secondary != secondary;
}

class _BottleAtmospherePainter extends CustomPainter {
  _BottleAtmospherePainter({
    required this.breath,
    required this.ripple,
    required this.orbit,
    required this.primaryColor,
    required this.secondaryColor,
  });

  final double breath;
  final double ripple;
  final double orbit;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Layer 3 — Expanding ring ripples
    for (var i = 0; i < 3; i++) {
      final phase = (ripple + i / 3.0) % 1.0;
      final ringRadius = 30.0 + phase * (width * 0.42);
      final ringOpacity = (1.0 - phase) * 0.22;
      final ringPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = (1.5 - phase * 1.0).clamp(0.5, 1.5)
        ..color = primaryColor.withValues(
          alpha: ringOpacity.clamp(0.0, 0.22),
        );
      canvas.drawCircle(
        Offset(width / 2, height * 0.44),
        ringRadius,
        ringPaint,
      );
    }

    // Layer 4 — Floating particles
    final orbitPaint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 10; i++) {
      final seed = i / 10.0;
      final angle = (orbit * 2 * math.pi) + (seed * 2 * math.pi);
      final orbitW = (i % 2 == 0) ? width * 0.30 : width * 0.42;
      final orbitH = (i % 2 == 0) ? height * 0.14 : height * 0.20;
      final px = (width / 2) + math.cos(angle) * orbitW / 2;
      final py = (height * 0.42) + math.sin(angle) * orbitH / 2;
      final verticalFactor = (math.sin(angle) + 1) / 2;
      final radius = 1.2 + verticalFactor * 1.8;
      final opacity = 0.20 + verticalFactor * 0.30;
      final color = (i % 3 == 0) ? secondaryColor : primaryColor;
      orbitPaint.color = color.withValues(alpha: opacity);
      canvas.drawCircle(Offset(px, py), radius, orbitPaint);
    }

    // Layer 5 — Ground shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.28 + breath * 0.06)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(width / 2, height * 0.86),
        width: 110 + breath * 12,
        height: 18 + breath * 4,
      ),
      shadowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _BottleAtmospherePainter old) =>
      old.breath != breath ||
      old.ripple != ripple ||
      old.orbit != orbit ||
      old.primaryColor != primaryColor ||
      old.secondaryColor != secondaryColor;
}
