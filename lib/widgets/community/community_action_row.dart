import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class CommunityActionRow extends StatelessWidget {
  final bool isLiked;
  final bool isSaved;
  final int likeCount;
  final int commentCount;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onSaveTap;
  final VoidCallback onShareTap;

  const CommunityActionRow({
    super.key,
    required this.isLiked,
    required this.isSaved,
    required this.likeCount,
    required this.commentCount,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onSaveTap,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionButton(
          icon: isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          label: '$likeCount',
          color: isLiked ? AppColors.accentOrange : AppColors.textSecondary,
          onTap: onLikeTap,
        ),
        const SizedBox(width: 12),
        _ActionButton(
          icon: Icons.chat_bubble_outline_rounded,
          label: '$commentCount',
          onTap: onCommentTap,
        ),
        const Spacer(),
        _ActionButton(
          icon: isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          label: 'Save',
          color: isSaved ? AppColors.accentCyan : AppColors.textSecondary,
          onTap: onSaveTap,
        ),
        const SizedBox(width: 10),
        _ActionButton(
          icon: Icons.share_outlined,
          label: 'Share',
          onTap: onShareTap,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.cardSub.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
