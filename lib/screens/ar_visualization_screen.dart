import 'dart:math' as math;
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/results_data.dart';
import '../services/camera_service.dart';
import '../theme/app_theme.dart';

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

class ARVisualizationScreen extends StatefulWidget {
  final bool showBottomNav;
  final VoidCallback? onBackPressed;
  final ResultsData data;

  const ARVisualizationScreen({
    super.key,
    this.showBottomNav = true,
    this.onBackPressed,
    required this.data,
  });

  @override
  State<ARVisualizationScreen> createState() => _ARVisualizationScreenState();
}

class _ARVisualizationScreenState extends State<ARVisualizationScreen>
    with TickerProviderStateMixin {
  static const _accentCyan = Color(0xFF4DD9FF);

  final CameraService _cameraService = CameraService();

  late final AnimationController _entranceController;
  late final AnimationController _recordingController;
  late final AnimationController _baseLayerController;
  late final AnimationController _midLayerController;
  late final AnimationController _topLayerController;
  late final AnimationController _breathController;

  bool _isCameraInitialized = false;
  String? _toastMessage;

  Color get _topColor => _noteColor(widget.data.topNote);
  Color get _midColor => _noteColor(widget.data.middleNote);
  Color get _baseColor => _noteColor(widget.data.baseNote);

  double get _driftRadius =>
      1.6 + (widget.data.gsrPercentage / 100.0) * 1.8;
  double get _estimatedDuration =>
      5.0 + (100 - widget.data.gsrPercentage) / 100.0 * 4.5;

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
    _baseLayerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
    _midLayerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _topLayerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
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
    _baseLayerController.dispose();
    _midLayerController.dispose();
    _topLayerController.dispose();
    _breathController.dispose();
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
              topAnimation: _topLayerController,
              midAnimation: _midLayerController,
              baseAnimation: _baseLayerController,
              breathAnimation: _breathController,
              topColor: _topColor,
              midColor: _midColor,
              baseColor: _baseColor,
              driftRadius: _driftRadius,
              stressLevel: widget.data.gsrPercentage,
            ),
          ),
          _ARHeader(
            recordingAnimation: _recordingController,
            entranceAnimation: _entranceController,
            onBack: widget.onBackPressed ?? () => Navigator.of(context).pop(),
          ),
          _ProductInfoCard(
            entranceAnimation: _entranceController,
            data: widget.data,
            topColor: _topColor,
            midColor: _midColor,
            baseColor: _baseColor,
            driftRadius: _driftRadius,
            estimatedDuration: _estimatedDuration,
          ),
          _BottomInfoCard(
            entranceAnimation: _entranceController,
            data: widget.data,
          ),
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
    required this.topAnimation,
    required this.midAnimation,
    required this.baseAnimation,
    required this.breathAnimation,
    required this.topColor,
    required this.midColor,
    required this.baseColor,
    required this.driftRadius,
    required this.stressLevel,
  });

  final CameraService cameraService;
  final bool isCameraInitialized;
  final Animation<double> topAnimation;
  final Animation<double> midAnimation;
  final Animation<double> baseAnimation;
  final Animation<double> breathAnimation;
  final Color topColor;
  final Color midColor;
  final Color baseColor;
  final double driftRadius;
  final int stressLevel;

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
        Container(color: topColor.withValues(alpha: 0.05)),
        AnimatedBuilder(
          animation: Listenable.merge([
            topAnimation,
            midAnimation,
            baseAnimation,
            breathAnimation,
          ]),
          builder: (context, _) => CustomPaint(
            painter: _MultiLayerSillagePainter(
              topProgress: topAnimation.value,
              midProgress: midAnimation.value,
              baseProgress: baseAnimation.value,
              breathProgress: breathAnimation.value,
              topColor: topColor,
              midColor: midColor,
              baseColor: baseColor,
              driftRadius: driftRadius,
              stressLevel: stressLevel,
            ),
          ),
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
                            ).withValues(
                              alpha: 0.5 + (recordingAnimation.value * 0.5),
                            ),
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

class _NoteLayerDot extends StatelessWidget {
  const _NoteLayerDot({
    required this.label,
    required this.note,
    required this.layerColor,
  });

  final String label;
  final String note;
  final Color layerColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: layerColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            note,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductInfoCard extends StatelessWidget {
  const _ProductInfoCard({
    required this.entranceAnimation,
    required this.data,
    required this.topColor,
    required this.midColor,
    required this.baseColor,
    required this.driftRadius,
    required this.estimatedDuration,
  });

  final Animation<double> entranceAnimation;
  final ResultsData data;
  final Color topColor;
  final Color midColor;
  final Color baseColor;
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
                  width: 300,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: topColor.withValues(alpha: 0.6),
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
                        data.fragranceName,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Divider(
                        color: Colors.white.withValues(alpha: 0.15),
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _NoteLayerDot(
                            label: 'Top',
                            note: data.topNote,
                            layerColor: topColor,
                          ),
                          _NoteLayerDot(
                            label: 'Mid',
                            note: data.middleNote,
                            layerColor: midColor,
                          ),
                          _NoteLayerDot(
                            label: 'Base',
                            note: data.baseNote,
                            layerColor: baseColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${driftRadius.toStringAsFixed(1)}m · ${estimatedDuration.toStringAsFixed(1)}h est.',
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
  const _BottomInfoCard({
    required this.entranceAnimation,
    required this.data,
  });

  final Animation<double> entranceAnimation;
  final ResultsData data;

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
                  '${data.recommendation} Sillage Active',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Material(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Text(
                        'Stress level:',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (data.gsrPercentage / 100).clamp(0.0, 1.0),
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.12),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              data.gsrPercentage > 65
                                  ? AppColors.warningRed
                                  : data.gsrPercentage > 40
                                      ? AppColors.accentGold
                                      : AppColors.accentCyan,
                            ),
                            minHeight: 5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${data.gsrPercentage}%',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${data.topNote} drifts above you · ${data.middleNote} wraps around · ${data.baseNote} grounds the trail',
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
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
                        fontSize: 12,
                      ),
                      children: [
                        const TextSpan(text: 'share\n'),
                        const TextSpan(text: '#OwnYourEssence'),
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

class _MultiLayerSillagePainter extends CustomPainter {
  const _MultiLayerSillagePainter({
    required this.topProgress,
    required this.midProgress,
    required this.baseProgress,
    required this.breathProgress,
    required this.topColor,
    required this.midColor,
    required this.baseColor,
    required this.driftRadius,
    required this.stressLevel,
  });

  final double topProgress;
  final double midProgress;
  final double baseProgress;
  final double breathProgress;
  final Color topColor;
  final Color midColor;
  final Color baseColor;
  final double driftRadius;
  final int stressLevel;

  void _drawSoftBlob(
    Canvas canvas,
    Offset c,
    double radius,
    Color color,
    double opacity,
  ) {
    for (var j = 0; j < 5; j++) {
      final ox = math.cos(j * 1.23) * 4;
      final oy = math.sin(j * 1.71) * 4;
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = color.withValues(
          alpha: (opacity * (1.0 - j * 0.16)).clamp(0.02, 1.0),
        );
      canvas.drawCircle(c + Offset(ox, oy), radius + j * 2.2, paint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final topCount = 20 + (stressLevel * 0.15).round();
    final midCount = 16 + (stressLevel * 0.10).round();
    const baseBlobCount = 6;

    final baseCx = size.width / 2;
    final baseCy = size.height * 0.65;
    final baseRx = driftRadius * 38;
    final baseRy = driftRadius * 18;

    for (var i = 0; i < baseBlobCount; i++) {
      final seed = (i + 1) * 0.37;
      final angle = baseProgress * 2 * math.pi + seed * 4.2;
      final ox = math.cos(angle) * baseRx;
      final oy = math.sin(angle) * baseRy;
      final blobCenter = Offset(baseCx + ox, baseCy + oy);
      final r = 60 + (i % 3) * 12 + 6 * math.sin(seed * 3);
      final op = 0.08 + (i % 4) * 0.015;
      _drawSoftBlob(canvas, blobCenter, r, baseColor, op);
    }

    final horizonPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..color = baseColor.withValues(alpha: 0.06);
    canvas.drawCircle(
      Offset(baseCx, baseCy),
      55 + breathProgress * 40,
      horizonPaint,
    );

    final midCx = size.width / 2;
    final midCy = size.height * 0.50;
    final midRx = driftRadius * 28;
    final midRy = driftRadius * 16;
    final ringAlpha = math.max(0.0, 0.3 - midProgress * 0.28);
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = midColor.withValues(alpha: ringAlpha);
    canvas.drawCircle(
      Offset(midCx, midCy),
      50 + midProgress * 90,
      ringPaint,
    );
    canvas.drawCircle(
      Offset(midCx, midCy),
      80 + midProgress * 60,
      ringPaint..strokeWidth = 1,
    );

    final midParticlePaint = Paint()..style = PaintingStyle.fill;
    final driftY = math.sin(midProgress * math.pi) * 15;
    for (var i = 0; i < midCount; i++) {
      final t = i / math.max(midCount, 1);
      final angle = midProgress * 2 * math.pi * 1.2 + t * 2 * math.pi;
      var x = midCx + math.cos(angle) * midRx;
      var y = midCy + math.sin(angle) * midRy * 0.72 + driftY;
      final pr = 2.5 + (i % 5) * 0.5;
      final pa = 0.2 + (i % 7) * 0.035;
      midParticlePaint.color = midColor.withValues(alpha: pa.clamp(0.2, 0.45));
      canvas.drawCircle(Offset(x, y), pr, midParticlePaint);
    }

    final topCx = size.width / 2;
    final topCy = size.height * 0.35;
    final topRx = driftRadius * 14;
    final topRy = driftRadius * 9;
    final topParticlePaint = Paint()..style = PaintingStyle.fill;
    final breathMod = 0.7 + breathProgress * 0.3;

    for (var i = 0; i < topCount; i++) {
      final t = i / math.max(topCount, 1);
      final angle = topProgress * 2 * math.pi * 2.2 + t * 2 * math.pi;
      final x = topCx + math.cos(angle) * topRx;
      final y = topCy + math.sin(angle) * topRy * 0.68;
      var pr = 1.0 + (i % 4) * 0.4;
      if (i % 5 == 0) {
        pr *= 1 + math.sin(topProgress * math.pi * 3 + i) * 0.5;
      }
      final baseOp = (0.15 + (i % 8) * 0.045).clamp(0.15, 0.55);
      topParticlePaint.color = topColor.withValues(
        alpha: (baseOp * breathMod).clamp(0.05, 1.0),
      );
      canvas.drawCircle(Offset(x, y), pr, topParticlePaint);
    }

    final auraCenter = Offset(size.width / 2, size.height / 2);
    final auraR = size.width * 0.55 + breathProgress * 30;
    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          midColor.withValues(alpha: 0.06),
          midColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: auraCenter, radius: auraR));
    canvas.drawCircle(auraCenter, auraR, auraPaint);
  }

  @override
  bool shouldRepaint(covariant _MultiLayerSillagePainter oldDelegate) {
    return oldDelegate.topProgress != topProgress ||
        oldDelegate.midProgress != midProgress ||
        oldDelegate.baseProgress != baseProgress ||
        oldDelegate.breathProgress != breathProgress ||
        oldDelegate.topColor != topColor ||
        oldDelegate.midColor != midColor ||
        oldDelegate.baseColor != baseColor ||
        oldDelegate.driftRadius != driftRadius ||
        oldDelegate.stressLevel != stressLevel;
  }
}
