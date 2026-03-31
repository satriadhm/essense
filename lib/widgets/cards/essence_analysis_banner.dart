import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../screens/analysis/add_fragrance_screen.dart';

class EssenceAnalysisBanner extends StatelessWidget {
  const EssenceAnalysisBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Card with gradient (clipped to rounded rect)
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 168,
            decoration: BoxDecoration(
              gradient: AppGradients.analysisBanner,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.borderCyan.withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              // Symmetric horizontal inset: typography stays centered in the card
              // while clearing the decorative bottles on both sides.
              padding: const EdgeInsets.fromLTRB(64, 16, 64, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Start Using Essense',
                                  style: AppTextStyles.bannerTitle.copyWith(
                                    fontSize: 18,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Personalize your scent to your skin and surroundings',
                                  style: AppTextStyles.bannerSub.copyWith(
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const AddFragranceScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accentCyan,
                        side: const BorderSide(
                          color: AppColors.accentCyan,
                          width: 1.5,
                        ),
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Start It Now',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Left perfume bottle — overflows card bottom-left
        Positioned(
          left: -30,
          bottom: -10,
          width: 90,
          height: 110,
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.9,
              child: Transform.rotate(
                angle: 0.15,
                child: Image.asset(
                  'assets/images/ysl_perfume.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        // Right perfume bottle — overflows card top-right
        Positioned(
          right: -16,
          top: -12,
          width: 88,
          height: 112,
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.85,
              child: Transform.rotate(
                angle: -0.15,
                child: Image.asset(
                  'assets/images/givenchy_perfume.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
