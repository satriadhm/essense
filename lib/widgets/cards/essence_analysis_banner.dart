import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class EssenceAnalysisBanner extends StatelessWidget {
  const EssenceAnalysisBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Card with gradient (clipped to rounded rect)
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: AppGradients.analysisBanner,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: AppColors.accentPurple.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentPurple.withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding =
                    (constraints.maxWidth * 0.15).clamp(16.0, 80.0);
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding, 20, horizontalPadding, 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Start Using ESSENCE. Analysis',
                        style: AppTextStyles.bannerTitle,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Get personalized olfactory diagnostics by syncing your skin's bio-rhythm with real-time environmental data.",
                        style: AppTextStyles.bannerSub,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(
                            color: AppColors.textPrimary,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                        ),
                        child: const Text(
                          'Generate the Result',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        // Left perfume bottle — overflows card top edge
        Positioned(
          left: -24,
          bottom: -20,
          child: Opacity(
            opacity: 0.9,
            child: Icon(
              Icons.liquor_rounded,
              color: AppColors.accentBlue.withValues(alpha: 0.4),
              size: 160,
            ),
          ),
        ),
        // Right perfume bottle — overflows card top edge
        Positioned(
          right: -20,
          top: -24,
          child: Opacity(
            opacity: 0.85,
            child: Icon(
              Icons.liquor_rounded,
              color: AppColors.accentPurple.withValues(alpha: 0.45),
              size: 170,
            ),
          ),
        ),
      ],
    );
  }
}
