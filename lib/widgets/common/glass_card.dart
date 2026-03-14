import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// A card with glassmorphism/frosted glass effect for the ESSENCE app.
/// Wraps content with blur, semi-transparent fill, and consistent styling.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final Border? border;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.gradient,
    this.boxShadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: gradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.cardBgLight.withValues(alpha: 0.6),
                    AppColors.cardBg.withValues(alpha: 0.5),
                  ],
                ),
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: border ?? Border.all(color: AppColors.cardBorder, width: 1),
            boxShadow: boxShadow ??
                [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
          ),
          child: child,
        ),
      ),
    );
  }
}
