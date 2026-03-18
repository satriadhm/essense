import 'package:flutter/material.dart';

import '../../models/community_models.dart';
import '../../theme/app_theme.dart';

class CommunityFilterChips extends StatelessWidget {
  final CommunityFilter activeFilter;
  final ValueChanged<CommunityFilter> onFilterSelected;

  const CommunityFilterChips({
    super.key,
    required this.activeFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: CommunityFilter.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = CommunityFilter.values[index];
          final isActive = filter == activeFilter;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onFilterSelected(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.accentOrange.withValues(alpha: 0.2)
                    : AppColors.cardBgLight,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: isActive
                      ? AppColors.accentOrange
                      : AppColors.cardBgLight.withValues(alpha: 0.9),
                ),
              ),
              child: Center(
                child: Text(
                  filter.label,
                  style: AppTextStyles.cardSub.copyWith(
                    color: isActive
                        ? AppColors.accentOrange
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
