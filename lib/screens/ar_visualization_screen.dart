import 'dart:math' as math;
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/camera_service.dart';

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
  final VoidCallback? onBackPressed;

  const ARVisualizationScreen({
    super.key,
    this.showBottomNav = true,
    this.onBackPressed,
  });

  @override
  State<ARVisualizationScreen> createState() => _ARVisualizationScreenState();
}

class _ARVisualizationScreenState extends State<ARVisualizationScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _entranceController;
  late AnimationController _boosterPulseController;
  late AnimationController _capturePressController;
  
  final CameraService _cameraService = CameraService();
  bool _isCameraInitialized = false;
  String? _captureMessage;

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
    
    // Initialize camera
    _initializeCamera();
  }
  
  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initializeCamera();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint('Failed to initialize camera: $e');
      _showMessage('Camera failed to initialize');
    }
  }
  
  void _showMessage(String message) {
    setState(() {
      _captureMessage = message;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _captureMessage = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _entranceController.dispose();
    _boosterPulseController.dispose();
    _capturePressController.dispose();
    _cameraService.dispose();
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
          // Camera live feed background
          _isCameraInitialized
              ? _CameraBackground(cameraService: _cameraService)
              : const _GreyscaleBackground(),
          
          // AR flower overlays
          _ARFlowerOverlays(
            floatController: _floatController,
            entranceController: _entranceController,
          ),
          
          // Top content
          _TopContent(onBackPressed: widget.onBackPressed),
          
          // Bottom controls
          _BottomControls(
            boosterPulseController: _boosterPulseController,
            capturePressController: _capturePressController,
            onCapturePress: _onCapturePress,
            cameraService: _cameraService,
            onCaptureMessage: _showMessage,
          ),
          
          // Capture message overlay
          if (_captureMessage != null)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    _captureMessage!,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
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

// ═══════════════════════════════════════
// LAYER 1B — CAMERA BACKGROUND
// ═══════════════════════════════════════

class _CameraBackground extends StatelessWidget {
  final CameraService cameraService;

  const _CameraBackground({required this.cameraService});

  @override
  Widget build(BuildContext context) {
    final controller = cameraService.controller;
    
    if (controller == null || !controller.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Camera preview
        CameraPreview(controller),
        
        // Dark overlay for AR effect
        Container(
          color: Colors.black.withValues(alpha: 0.15),
        ),
        
        // Grid overlay (optional AR grid)
        CustomPaint(
          painter: _ARGridPainter(),
          size: Size.infinite,
        ),
      ],
    );
  }
}

class _ARGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 0.5;

    const gridSize = 60.0;
    
    // Vertical lines
    for (int i = 0; i <= (size.width / gridSize).ceil(); i++) {
      canvas.drawLine(
        Offset(i * gridSize, 0),
        Offset(i * gridSize, size.height),
        paint,
      );
    }

    // Horizontal lines
    for (int i = 0; i <= (size.height / gridSize).ceil(); i++) {
      canvas.drawLine(
        Offset(0, i * gridSize),
        Offset(size.width, i * gridSize),
        paint,
      );
    }
    
    // Center focus circle
    final centerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      80,
      centerPaint,
    );
    
    // Center crosshair
    const crossSize = 20.0;
    canvas.drawLine(
      Offset(size.width / 2 - crossSize, size.height / 2),
      Offset(size.width / 2 + crossSize, size.height / 2),
      centerPaint,
    );
    canvas.drawLine(
      Offset(size.width / 2, size.height / 2 - crossSize),
      Offset(size.width / 2, size.height / 2 + crossSize),
      centerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
  final VoidCallback? onBackPressed;
  
  const _TopContent({this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
            child: GestureDetector(
              onTap: () {
                // Navigate back to home screen via callback
                if (onBackPressed != null) {
                  onBackPressed!();
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
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

class _BottomControls extends StatefulWidget {
  final AnimationController boosterPulseController;
  final AnimationController capturePressController;
  final VoidCallback onCapturePress;
  final CameraService cameraService;
  final Function(String) onCaptureMessage;

  const _BottomControls({
    required this.boosterPulseController,
    required this.capturePressController,
    required this.onCapturePress,
    required this.cameraService,
    required this.onCaptureMessage,
  });

  @override
  State<_BottomControls> createState() => _BottomControlsState();
}

class _BottomControlsState extends State<_BottomControls> {
  bool _isCapturing = false;

  Future<void> _handleCapture() async {
    if (_isCapturing || !widget.cameraService.isInitialized) return;

    try {
      setState(() => _isCapturing = true);
      widget.onCapturePress();

      final filePath = await widget.cameraService.capturePhoto();
      widget.onCaptureMessage('Photo captured: ${filePath?.split('/').last}');
    } catch (e) {
      widget.onCaptureMessage('Failed to capture photo');
      debugPrint('Capture error: $e');
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  Future<void> _handleSwitchCamera() async {
    if (!widget.cameraService.isInitialized) return;

    try {
      await widget.cameraService.switchCamera();
      widget.onCaptureMessage('Camera switched');
    } catch (e) {
      widget.onCaptureMessage('Failed to switch camera');
      debugPrint('Switch camera error: $e');
    }
  }

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
              animation: widget.boosterPulseController,
              builder: (context, child) {
                final scale = 1.0 + math.sin(widget.boosterPulseController.value * math.pi) * 0.03;
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
                // Switch camera button
                GestureDetector(
                  onTap: _isCapturing ? null : _handleSwitchCamera,
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
                      Icons.flip_camera_ios_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Capture button
                GestureDetector(
                  onTap: _isCapturing ? null : _handleCapture,
                  child: AnimatedBuilder(
                    animation: widget.capturePressController,
                    builder: (context, child) {
                      final t = widget.capturePressController.value;
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
                      child: _isCapturing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.black,
                              size: 28,
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Flash button (placeholder)
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
                      Icons.flash_on_rounded,
                      color: Colors.white,
                      size: 24,
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
