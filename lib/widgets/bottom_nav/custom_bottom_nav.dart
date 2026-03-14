import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const CustomBottomNav({
    super.key, required this.currentIndex, required this.onTap,
  });

  static const _icons = [
    Icons.home_rounded,
    Icons.article_rounded,   // Details
    Icons.view_in_ar_rounded, // VR
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.navBarHeight,
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        0,
        AppSpacing.screenHorizontal,
        AppSpacing.navBarBottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.navBarBg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_icons.length, (i) {
          final isActive = i == currentIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.activeNavPill
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Row(
                children: [
                  Icon(
                    _icons[i],
                    color: isActive
                        ? AppColors.bgDeep
                        : AppColors.textSecondary,
                    size: 24,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
