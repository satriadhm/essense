import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../services/camera_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/analysis/corner_guide_painter.dart';
import 'scan_biometrics_screen.dart';

class ScanProductScreen extends StatefulWidget {
  const ScanProductScreen({super.key});

  @override
  State<ScanProductScreen> createState() => _ScanProductScreenState();
}

class _ScanProductScreenState extends State<ScanProductScreen>
    with SingleTickerProviderStateMixin {
  final CameraService _cameraService = CameraService();
  Timer? _recognitionTimer;
  bool _cameraReady = false;
  bool _isFlashOn = false;
  bool _showRecognizedModal = false;
  String? _cameraError;

  late final AnimationController _modalScaleController;
  late final Animation<double> _modalScaleAnimation;

  @override
  void initState() {
    super.initState();
    _modalScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _modalScaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _modalScaleController, curve: Curves.easeOutBack),
    );
    _initializeCamera();
  }

  @override
  void dispose() {
    _recognitionTimer?.cancel();
    _modalScaleController.dispose();
    _cameraService.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initializeCamera();
      if (!mounted) return;
      setState(() {
        _cameraReady = _cameraService.isInitialized;
        _cameraError = null;
      });
      _startRecognitionTimer();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cameraError = 'Unable to access camera';
        _cameraReady = false;
      });
    }
  }

  void _startRecognitionTimer() {
    _recognitionTimer?.cancel();
    _recognitionTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _showRecognizedModal = true);
      _modalScaleController.forward(from: 0);
    });
  }

  Future<void> _toggleFlash() async {
    if (!_cameraReady) return;
    _isFlashOn = !_isFlashOn;
    await _cameraService.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
    if (mounted) setState(() {});
  }

  void _onContinue() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const ScanBiometricsScreen()),
    );
  }

  void _onRescan() {
    setState(() => _showRecognizedModal = false);
    _modalScaleController.reset();
    _startRecognitionTimer();
  }

  @override
  Widget build(BuildContext context) {
    final cameraController = _cameraService.controller;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: _cameraReady && cameraController != null
                ? CameraPreview(cameraController)
                : Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: Text(
                      _cameraError ?? 'Preparing camera...',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
          Positioned.fill(
            child: CustomPaint(painter: const CornerGuidePainter()),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 16,
            left: 16,
            child: _CircleIconButton(
              icon: _isFlashOn
                  ? Icons.flash_on_rounded
                  : Icons.flash_off_rounded,
              iconColor: _isFlashOn ? AppColors.analysisGolden : Colors.white,
              onTap: _toggleFlash,
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 16,
            right: 16,
            child: _CircleIconButton(
              icon: Icons.close_rounded,
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.black.withValues(alpha: 0.45),
                    Colors.black.withValues(alpha: 0.0),
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Scan My Fragrance',
                      style: AppTextStyles.h2.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Place your fragrance near the scanner to capture its profile',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_showRecognizedModal) ...[
            Positioned.fill(
              child: Container(color: Colors.black.withValues(alpha: 0.6)),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ScaleTransition(
                  scale: _modalScaleAnimation,
                  child: _FragranceRecognizedModal(
                    onContinue: _onContinue,
                    onRescan: _onRescan,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
    );
  }
}

class _FragranceRecognizedModal extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onRescan;

  const _FragranceRecognizedModal({
    required this.onContinue,
    required this.onRescan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 318,
      constraints: const BoxConstraints(maxWidth: 318),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1E3F), Color(0xFF0F1535)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accentCyan.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: Image.asset(
              'assets/images/ysl_perfume.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Fragrance Recognized!',
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'YSL - Y Eau De Parfum',
            style: AppTextStyles.buttonLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.analysisDarkBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onRescan,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3F4F6),
                foregroundColor: const Color(0xFF1A1E3F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Re-Scan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
