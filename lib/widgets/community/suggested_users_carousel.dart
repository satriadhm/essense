import 'package:flutter/material.dart';

import '../../models/community_models.dart';
import '../../theme/app_theme.dart';

class SuggestedUsersCarousel extends StatelessWidget {
  final List<CommunitySuggestion> suggestions;
  final ValueChanged<String> onFollowToggle;

  const SuggestedUsersCarousel({
    super.key,
    required this.suggestions,
    required this.onFollowToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final user = suggestions[index];

          return Container(
            width: 172,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: AppColors.cardBgLight.withValues(alpha: 0.9),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.iconFillDark,
                  child: Text(
                    user.name.substring(0, 1).toUpperCase(),
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user.name,
                  style: AppTextStyles.cardTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  user.handle,
                  style: AppTextStyles.cardSub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  user.niche,
                  style: AppTextStyles.cardSub.copyWith(color: AppColors.accentCyan),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: OutlinedButton(
                    onPressed: () => onFollowToggle(user.id),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: user.isFollowing
                            ? AppColors.accentOrange
                            : AppColors.accentCyan,
                      ),
                      foregroundColor: user.isFollowing
                          ? AppColors.accentOrange
                          : AppColors.accentCyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(user.isFollowing ? 'Following' : 'Follow'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
