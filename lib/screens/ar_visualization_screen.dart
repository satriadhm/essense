import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════
// GREYSCALE MATRIX
// ═══════════════════════════════════════
const _kGreyscaleMatrix = <double>[
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0,      0,      0,      1, 0,
];

// Flower asset paths (in assets/images/ for consistency with existing app)
const _kGalleryBg = 'assets/images/gallery_bg.jpg';
const _kFlowerYellowLeaf = 'assets/images/flower_yellow_leaf.png';
const _kFlowerPinkLily = 'assets/images/flower_pink_lily.png';
const _kFlowerCoralRed = 'assets/images/flower_coral_red.png';
const _kFlowerPinkSmall = 'assets/images/flower_pink_small.png';
const _kFlowerOrangeTulip = 'assets/images/flower_orange_tulip.png';
const _kFlowerSpotted = 'assets/images/flower_spotted.png';
const _kFlowerHotpinkRight = 'assets/images/flower_hotpink_right.png';

class ARVisualizationScreen extends StatefulWidget {
  final bool showBottomNav;

  const ARVisualizationScreen({super.key, this.showBottomNav = true});

  @override
  State<ARVisualizationScreen> createState() => _ARVisualizationScreenState();
}

class _ARVisualizationScreenState extends State<ARVisualizationScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _entranceController;
  late AnimationController _boosterPulseController;
  late AnimationController _capturePressController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _boosterPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _capturePressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _entranceController.dispose();
    _boosterPulseController.dispose();
    _capturePressController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _GreyscaleBackground(),
          _ARFlowerOverlays(
            floatController: _floatController,
            entranceController: _entranceController,
          ),
          const _TopContent(),
          _BottomControls(
            boosterPulseController: _boosterPulseController,
            capturePressController: _capturePressController,
            onCapturePress: _onCapturePress,
          ),
        ],
      ),
    );
  }

  void _onCapturePress() {
    _capturePressController.forward(from: 0);
  }
}

// ═══════════════════════════════════════
// LAYER 1 — GREYSCALE BACKGROUND
// ═══════════════════════════════════════

class _GreyscaleBackground extends StatelessWidget {
  const _GreyscaleBackground();

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 600),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.matrix(_kGreyscaleMatrix),
            child: Image.asset(
              _kGalleryBg,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) => _GalleryFallback(),
            ),
          ),
          Container(
            color: Colors.black.withValues(alpha: 0.25),
          ),
        ],
      ),
    );
  }
}

class _GalleryFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF2A2A2A),
            const Color(0xFF1A1A1A),
            const Color(0xFF0D0D0D),
          ],
        ),
      ),
      child: CustomPaint(
        painter: _GalleryPlaceholderPainter(),
      ),
    );
  }
}

class _GalleryPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < 4; i++) {
      final rect = Rect.fromLTWH(40.0 + i * 90.0, 120.0, 70, 90);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════
// LAYER 2 — AR FLOWER OVERLAYS
// ═══════════════════════════════════════

class _ARFlowerOverlays extends StatelessWidget {
  final AnimationController floatController;
  final AnimationController entranceController;

  const _ARFlowerOverlays({
    required this.floatController,
    required this.entranceController,
  });

  static const _phaseOffsets = [0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0];

  @override
  Widget build(BuildContext context) {
    final flowers = [
      _FlowerData(asset: _kFlowerYellowLeaf, top: -40, left: -30, right: null, rotate: -0.3, width: 230, phaseIndex: 0),
      _FlowerData(asset: _kFlowerPinkLily, top: -20, left: null, right: -30, rotate: 0.15, width: 200, phaseIndex: 1),
      _FlowerData(asset: _kFlowerPinkSmall, top: 300, left: 180, right: null, rotate: 0.1, width: 180, phaseIndex: 2),
      _FlowerData(asset: _kFlowerCoralRed, top: 100, left: null, right: -20, rotate: -0.1, width: 170, phaseIndex: 3),
      _FlowerData(asset: _kFlowerOrangeTulip, top: 650, left: 140, right: null, rotate: 0.05, width: 200, phaseIndex: 4),
      _FlowerData(asset: _kFlowerSpotted, top: 700, left: 340, right: null, rotate: -0.2, width: 130, phaseIndex: 5),
      _FlowerData(asset: _kFlowerHotpinkRight, top: 550, left: null, right: -10, rotate: 0.2, width: 180, phaseIndex: 6),
    ];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        for (int i = 0; i < flowers.length; i++)
          _AnimatedFlower(
            data: flowers[i],
            floatController: floatController,
            entranceController: entranceController,
            staggerDelayMs: i * 100,
            phaseOffset: _phaseOffsets[i % _phaseOffsets.length],
          ),
      ],
    );
  }
}

class _FlowerData {
  final String asset;
  final double top;
  final double? left;
  final double? right;
  final double rotate;
  final double width;
  final int phaseIndex;

  _FlowerData({
    required this.asset,
    required this.top,
    this.left,
    this.right,
    required this.rotate,
    required this.width,
    required this.phaseIndex,
  });
}

class _AnimatedFlower extends StatelessWidget {
  final _FlowerData data;
  final AnimationController floatController;
  final AnimationController entranceController;
  final int staggerDelayMs;
  final double phaseOffset;

  const _AnimatedFlower({
    required this.data,
    required this.floatController,
    required this.entranceController,
    required this.staggerDelayMs,
    required this.phaseOffset,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([floatController, entranceController]),
      builder: (context, child) {
        final entranceProgress = (entranceController.value * 800 - staggerDelayMs) / 700;
        final clampedProgress = entranceProgress.clamp(0.0, 1.0);
        final slideY = (1 - Curves.easeOut.transform(clampedProgress)) * 0.08;
        final opacity = Curves.easeOut.transform(clampedProgress);
        final floatY = math.sin(floatController.value * 2 * math.pi + phaseOffset) * 6;

        return Positioned(
          top: data.top + floatY,
          left: data.left,
          right: data.right,
          child: Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(0, MediaQuery.of(context).size.height * slideY),
              child: Transform.rotate(
                angle: data.rotate,
                child: Image.asset(
                  data.asset,
                  width: data.width,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => _FlowerPlaceholder(width: data.width),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FlowerPlaceholder extends StatelessWidget {
  final double width;

  const _FlowerPlaceholder({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width * 1.2,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            const Color(0xFFE91E63).withValues(alpha: 0.9),
            const Color(0xFFE91E63).withValues(alpha: 0.5),
            Colors.transparent,
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.local_florist_rounded,
        size: width * 0.5,
        color: Colors.white.withValues(alpha: 0.8),
      ),
    );
  }
}

// ═══════════════════════════════════════
// LAYER 3 — TOP CONTENT
// ═══════════════════════════════════════

class _TopContent extends StatelessWidget {
  const _TopContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title block
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ESSENCE AUGMENTED REALITY',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 2.5,
                    shadows: const [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Calming Lavender Bloom (+12%)\nSoothing your detected stress peaks.',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.5,
                    shadows: const [
                      Shadow(color: Colors.black38, blurRadius: 6),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════
// LAYER 4 — BOTTOM CONTROLS
// ═══════════════════════════════════════

class _BottomControls extends StatelessWidget {
  final AnimationController boosterPulseController;
  final AnimationController capturePressController;
  final VoidCallback onCapturePress;

  const _BottomControls({
    required this.boosterPulseController,
    required this.capturePressController,
    required this.onCapturePress,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Activate Booster button
            AnimatedBuilder(
              animation: boosterPulseController,
              builder: (context, child) {
                final scale = 1.0 + math.sin(boosterPulseController.value * math.pi) * 0.03;
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: GestureDetector(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'ACTIVATE THE\nBOOSTER',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Camera control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 60),
                GestureDetector(
                  onTap: onCapturePress,
                  child: AnimatedBuilder(
                    animation: capturePressController,
                    builder: (context, child) {
                      final t = capturePressController.value;
                      final scale = t < 0.5
                          ? 1.0 - (t * 2) * 0.08
                          : 0.92 + ((t - 0.5) * 2) * 0.08;
                      return Transform.scale(
                        scale: scale,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.6),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
