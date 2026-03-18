import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ActivityCard extends StatelessWidget {
  final String date;
  final String title;
  final String imageAsset;
  final double? width;

  const ActivityCard({
    super.key,
    required this.date,
    required this.title,
    required this.imageAsset,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.cardShimmer,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderCyan.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 80,
              height: 80,
              color: AppColors.cardBg,
              child: Image.asset(imageAsset, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: AppTextStyles.cardSub.copyWith(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    '"$title"',
                    style: AppTextStyles.cardTitle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const _ActionIcon(icon: Icons.favorite_border_rounded),
                    const SizedBox(width: 10),
                    const _ActionIcon(icon: Icons.bookmark_border_rounded),
                    const SizedBox(width: 10),
                    const _ActionIcon(icon: Icons.share_outlined),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;

  const _ActionIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {},
      radius: 16,
      child: Icon(icon, color: AppColors.textSecondary, size: 18),
    );
  }
}
