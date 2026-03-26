import 'dart:math' as math;
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/camera_service.dart';

class ARVisualizationScreen extends StatefulWidget {
  final bool showBottomNav;
  final VoidCallback? onBackPressed;
  final String productName;
  final double driftRadius;
  final double estimatedDuration;

  const ARVisualizationScreen({
    super.key,
    this.showBottomNav = true,
    this.onBackPressed,
    this.productName = 'CALM • SILLAGE',
    this.driftRadius = 2.1,
    this.estimatedDuration = 6.5,
  });

  @override
  State<ARVisualizationScreen> createState() => _ARVisualizationScreenState();
}

class _ARVisualizationScreenState extends State<ARVisualizationScreen>
    with TickerProviderStateMixin {
  static const _accentCyan = Color(0xFF4DD9FF);
  static const _secondaryText = Color(0xFFD1D5DB);

  final CameraService _cameraService = CameraService();

  late final AnimationController _entranceController;
  late final AnimationController _recordingController;
  late final AnimationController _sillageController;

  bool _isCameraInitialized = false;
  String? _toastMessage;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _recordingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _sillageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initializeCamera();
      if (!mounted) return;
      setState(() => _isCameraInitialized = true);
    } catch (_) {
      if (!mounted) return;
      _showToast('Camera is unavailable, showing preview fallback.');
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _recordingController.dispose();
    _sillageController.dispose();
    _cameraService.dispose();
    super.dispose();
  }

  void _showToast(String message) {
    setState(() => _toastMessage = message);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _toastMessage = null);
      }
    });
  }

  void _onShare() {
    _showToast('Sharing #OwnYourEssence...');
  }

  void _onSave() {
    _showToast('Saved to Journal.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          FadeTransition(
            opacity: CurvedAnimation(
              parent: _entranceController,
              curve: const Interval(0, 0.6, curve: Curves.easeOut),
            ),
            child: _ARViewLayer(
              cameraService: _cameraService,
              isCameraInitialized: _isCameraInitialized,
              animation: _sillageController,
            ),
          ),
          _ARHeader(
            recordingAnimation: _recordingController,
            entranceAnimation: _entranceController,
            onBack: widget.onBackPressed ?? () => Navigator.of(context).pop(),
          ),
          _ProductInfoCard(
            entranceAnimation: _entranceController,
            productName: widget.productName,
            driftRadius: widget.driftRadius,
            estimatedDuration: widget.estimatedDuration,
          ),
          _BottomInfoCard(entranceAnimation: _entranceController),
          _ActionButtons(
            entranceAnimation: _entranceController,
            onShare: _onShare,
            onSave: _onSave,
          ),
          if (_toastMessage != null)
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.22,
              left: 24,
              right: 24,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _accentCyan.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    _toastMessage!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ARViewLayer extends StatelessWidget {
  const _ARViewLayer({
    required this.cameraService,
    required this.isCameraInitialized,
    required this.animation,
  });

  final CameraService cameraService;
  final bool isCameraInitialized;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final controller = cameraService.controller;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (isCameraInitialized &&
            controller != null &&
            controller.value.isInitialized)
          CameraPreview(controller)
        else
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1B1E24), Color(0xFF0B0D11)],
              ),
            ),
          ),
        Container(color: const Color(0xFF4DD9FF).withValues(alpha: 0.05)),
        AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            return CustomPaint(
              painter: _SillagePainter(progress: animation.value),
            );
          },
        ),
      ],
    );
  }
}

class _ARHeader extends StatelessWidget {
  const _ARHeader({
    required this.recordingAnimation,
    required this.entranceAnimation,
    required this.onBack,
  });

  final Animation<double> recordingAnimation;
  final Animation<double> entranceAnimation;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: entranceAnimation,
          curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.08),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: entranceAnimation,
              curve: const Interval(0.2, 0.9, curve: Curves.easeOut),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                InkWell(
                  onTap: onBack,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 60,
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Row(
                    children: [
                      AnimatedBuilder(
                        animation: recordingAnimation,
                        builder: (context, _) => Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(
                              0xFFFF6B6B,
                            ).withValues(alpha: 0.5 + (recordingAnimation.value * 0.5)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Rec',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductInfoCard extends StatelessWidget {
  const _ProductInfoCard({
    required this.entranceAnimation,
    required this.productName,
    required this.driftRadius,
    required this.estimatedDuration,
  });

  final Animation<double> entranceAnimation;
  final String productName;
  final double driftRadius;
  final double estimatedDuration;

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: entranceAnimation,
      curve: const Interval(0.3, 0.9, curve: Curves.easeOutBack),
    );

    return Positioned(
      top: 80,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1).animate(animation),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF4DD9FF).withValues(alpha: 0.6),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 32,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        productName,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Drift radius: ${driftRadius.toStringAsFixed(1)}m',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFD1D5DB),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Est. duration: ${estimatedDuration.toStringAsFixed(1)}h',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFD1D5DB),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomInfoCard extends StatelessWidget {
  const _BottomInfoCard({required this.entranceAnimation});

  final Animation<double> entranceAnimation;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: entranceAnimation,
          curve: const Interval(0.4, 1, curve: Curves.easeOut),
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.12),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: entranceAnimation,
              curve: const Interval(0.4, 1, curve: Curves.easeOut),
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding + 92),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your Calm sillage is visualised',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This is how your boosted Libre trails through your environment',
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: GoogleFonts.inter(
                    color: _ARVisualizationScreenState._secondaryText,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.entranceAnimation,
    required this.onShare,
    required this.onSave,
  });

  final Animation<double> entranceAnimation;
  final VoidCallback onShare;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: MediaQuery.of(context).padding.bottom + 20,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: entranceAnimation,
          curve: const Interval(0.5, 1, curve: Curves.easeOut),
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: onShare,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A0E27),
                    elevation: 4,
                    shadowColor: Colors.black.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(text: 'share\n'),
                        TextSpan(text: '#OwnYourEssence'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: onSave,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF4DD9FF), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Save to Journal',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFF4DD9FF),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SillagePainter extends CustomPainter {
  const _SillagePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.52);
    final baseRadius = 42 + (progress * 68);
    final pulse = (math.sin(progress * math.pi * 2) + 1) / 2;

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xFF4DD9FF).withValues(alpha: 0.35 - (progress * 0.22));

    canvas.drawCircle(center, baseRadius, ringPaint);
    canvas.drawCircle(center, baseRadius + 28, ringPaint..strokeWidth = 1.2);

    final particlePaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 18; i++) {
      final seed = (i + 1) * 0.23;
      final angle = (progress * 2 * math.pi) + (seed * 4);
      final radius = 22 + ((i * 6) * (0.45 + pulse * 0.55));
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius * 0.65;
      particlePaint.color = const Color(
        0xFF4DD9FF,
      ).withValues(alpha: (0.3 + (0.2 * math.sin(angle))).clamp(0.1, 0.55));
      canvas.drawCircle(Offset(x, y), 1.8 + (i % 4) * 0.6, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SillagePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
