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
            height: 160,
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Start Using Essense Analysis',
                        style: AppTextStyles.bannerTitle.copyWith(fontSize: 18),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Tailored your personalized scent via skin bio-rhythms and real-time environment data.',
                        style: AppTextStyles.bannerSub.copyWith(fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                );
              },
            ),
          ),
        ),
        // Left perfume bottle — overflows card bottom-left
        Positioned(
          left: -30,
          bottom: -10,
          width: 90,
          height: 110,
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
        // Right perfume bottle — overflows card top-right
        Positioned(
          right: -16,
          top: -12,
          width: 88,
          height: 112,
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
      ],
    );
  }
}
