import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class DotProgressionLoader extends StatefulWidget {
  final int dotCount;
  final double size;
  final VoidCallback? onComplete;

  const DotProgressionLoader({
    super.key,
    this.dotCount = 12,
    this.size = 120,
    this.onComplete,
  });

  @override
  State<DotProgressionLoader> createState() => _DotProgressionLoaderState();
}

class _DotProgressionLoaderState extends State<DotProgressionLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _didComplete = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 4100),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed && !_didComplete) {
            _didComplete = true;
            widget.onComplete?.call();
          }
        });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _DotProgressionPainter(
              progress: _controller.value,
              dotCount: widget.dotCount,
            ),
          ),
        );
      },
    );
  }
}

class _DotProgressionPainter extends CustomPainter {
  final double progress;
  final int dotCount;

  const _DotProgressionPainter({
    required this.progress,
    required this.dotCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final fullDotSize = 12.0;
    final circleRadius = size.width / 2 - (fullDotSize / 2);

    // First 3600ms for dots, last 500ms hold state.
    final normalizedDotProgress = (progress * 4100 / 3600).clamp(0.0, 1.0);

    for (int i = 0; i < dotCount; i++) {
      final angle = (i / dotCount) * 2 * math.pi;
      final dotCenter = Offset(
        center.dx + (circleRadius * math.cos(angle)),
        center.dy + (circleRadius * math.sin(angle)),
      );

      final start = i / dotCount;
      final end = (i + 1) / dotCount;

      double sizeFactor;
      double opacity;
      Color color;

      if (normalizedDotProgress >= end) {
        // Completed
        sizeFactor = 10 / 12;
        opacity = 1.0;
        color = AppColors.accentCyan;
      } else if (normalizedDotProgress > start) {
        // Active animation for this dot
        final localT = ((normalizedDotProgress - start) / (end - start)).clamp(
          0.0,
          1.0,
        );
        sizeFactor = (8 + (4 * Curves.easeOut.transform(localT))) / 12;
        opacity = 0.6 + (0.4 * Curves.easeOut.transform(localT));
        color = AppColors.accentCyan;
      } else {
        // Pending
        sizeFactor = 8 / 12;
        opacity = 0.6;
        color = AppColors.analysisMutedCyan;
      }

      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(dotCenter, (fullDotSize / 2) * sizeFactor, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DotProgressionPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.dotCount != dotCount;
  }
}
