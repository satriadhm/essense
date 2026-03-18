import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class CornerGuidePainter extends CustomPainter {
  final double cornerLength;
  final double strokeWidth;
  final double frameWidthFactor;
  final double frameHeightFactor;
  final double centerYOffset;
  final double radius;

  const CornerGuidePainter({
    this.cornerLength = 40,
    this.strokeWidth = 3,
    this.frameWidthFactor = 0.68,
    this.frameHeightFactor = 0.36,
    this.centerYOffset = -30,
    this.radius = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentCyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final frameWidth = size.width * frameWidthFactor;
    final frameHeight = size.height * frameHeightFactor;
    final centerX = size.width / 2;
    final centerY = (size.height / 2) + centerYOffset;
    final left = centerX - (frameWidth / 2);
    final right = centerX + (frameWidth / 2);
    final top = centerY - (frameHeight / 2);
    final bottom = centerY + (frameHeight / 2);

    final path = Path()
      // top-left
      ..moveTo(left + cornerLength, top)
      ..lineTo(left + radius, top)
      ..arcToPoint(
        Offset(left, top + radius),
        radius: Radius.circular(radius),
        clockwise: false,
      )
      ..lineTo(left, top + cornerLength)
      // top-right
      ..moveTo(right - cornerLength, top)
      ..lineTo(right - radius, top)
      ..arcToPoint(Offset(right, top + radius), radius: Radius.circular(radius))
      ..lineTo(right, top + cornerLength)
      // bottom-right
      ..moveTo(right, bottom - cornerLength)
      ..lineTo(right, bottom - radius)
      ..arcToPoint(
        Offset(right - radius, bottom),
        radius: Radius.circular(radius),
      )
      ..lineTo(right - cornerLength, bottom)
      // bottom-left
      ..moveTo(left + cornerLength, bottom)
      ..lineTo(left + radius, bottom)
      ..arcToPoint(
        Offset(left, bottom - radius),
        radius: Radius.circular(radius),
        clockwise: false,
      )
      ..lineTo(left, bottom - cornerLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CornerGuidePainter oldDelegate) {
    return oldDelegate.cornerLength != cornerLength ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.frameWidthFactor != frameWidthFactor ||
        oldDelegate.frameHeightFactor != frameHeightFactor ||
        oldDelegate.centerYOffset != centerYOffset ||
        oldDelegate.radius != radius;
  }
}
