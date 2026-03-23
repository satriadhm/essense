import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class PerfumeBottleSection extends StatelessWidget {
  const PerfumeBottleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _BackgroundWavesPainter()),
            ),
          ),
          Positioned(
            bottom: 48,
            child: Container(
              width: 250,
              height: 170,
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(120),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentCyan.withValues(alpha: 0.08),
                    blurRadius: 48,
                    spreadRadius: 14,
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TODO: replace with assets/images/perfume_bottle_3d.png when available.
              Image.asset(
                'assets/images/ysl_perfume.png',
                width: 220,
                height: 220,
                fit: BoxFit.contain,
              ),
              Container(
                width: 180,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 18,
                      spreadRadius: 4,
                      offset: const Offset(0, 9),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackgroundWavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cyanPaint = Paint()
      ..color = AppColors.accentCyan.withValues(alpha: 0.14)
      ..style = PaintingStyle.fill;
    final purplePaint = Paint()
      ..color = AppColors.analysisPurpleStart.withValues(alpha: 0.10)
      ..style = PaintingStyle.fill;

    final leftPath = Path()
      ..moveTo(0, size.height * 0.72)
      ..cubicTo(
        size.width * 0.12,
        size.height * 0.62,
        size.width * 0.22,
        size.height * 0.80,
        size.width * 0.34,
        size.height * 0.70,
      )
      ..cubicTo(
        size.width * 0.44,
        size.height * 0.62,
        size.width * 0.52,
        size.height * 0.72,
        size.width * 0.60,
        size.height * 0.67,
      )
      ..lineTo(size.width * 0.60, size.height)
      ..lineTo(0, size.height)
      ..close();

    final rightPath = Path()
      ..moveTo(size.width * 0.44, size.height * 0.75)
      ..cubicTo(
        size.width * 0.56,
        size.height * 0.66,
        size.width * 0.64,
        size.height * 0.83,
        size.width * 0.74,
        size.height * 0.73,
      )
      ..cubicTo(
        size.width * 0.84,
        size.height * 0.63,
        size.width * 0.92,
        size.height * 0.76,
        size.width,
        size.height * 0.70,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * 0.44, size.height)
      ..close();

    canvas.drawPath(leftPath, purplePaint);
    canvas.drawPath(rightPath, cyanPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
