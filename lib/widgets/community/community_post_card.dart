import 'package:flutter/material.dart';

import '../../models/community_models.dart';
import '../../theme/app_theme.dart';
import 'community_action_row.dart';

class CommunityPostCard extends StatelessWidget {
  final CommunityPost post;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onSaveTap;
  final VoidCallback onShareTap;

  const CommunityPostCard({
    super.key,
    required this.post,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onSaveTap,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        gradient: AppGradients.cardShimmer,
        border: Border.all(color: AppColors.cardBgLight.withValues(alpha: 0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.iconFillDark,
                child: Text(
                  post.authorName.substring(0, 1).toUpperCase(),
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 13),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.authorName, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 2),
                    Text(
                      '${post.authorHandle} • ${post.location} • ${post.timeAgo}',
                      style: AppTextStyles.cardSub,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.more_horiz_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.caption,
            style: AppTextStyles.bannerSub.copyWith(color: AppColors.textPrimary),
          ),
          if (post.imageAsset != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.asset(
                  post.imageAsset!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: AppColors.cardBgLight),
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: post.tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pillBg,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      tag,
                      style: AppTextStyles.cardSub.copyWith(
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          CommunityActionRow(
            isLiked: post.isLiked,
            isSaved: post.isSaved,
            likeCount: post.likeCount,
            commentCount: post.commentCount,
            onLikeTap: onLikeTap,
            onCommentTap: onCommentTap,
            onSaveTap: onSaveTap,
            onShareTap: onShareTap,
          ),
        ],
      ),
    );
  }
}
