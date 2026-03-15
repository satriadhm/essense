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
      width: width ?? 300,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AppGradients.cardShimmer,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Perfume icon
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 70, height: 100,
              color: AppColors.cardBg,
              child: Image.asset(
                imageAsset,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: AppTextStyles.cardSub),
                const SizedBox(height: 6),
                Text(title,
                    style: AppTextStyles.cardTitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Row(
                  children: [
                    // Share button (curved arrow)
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                      icon: const Icon(Icons.reply_rounded,
                          color: AppColors.textSecondary, size: 18),
                    ),
                    const SizedBox(width: 12),
                    // Download button
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                      icon: const Icon(Icons.download_outlined,
                          color: AppColors.textSecondary, size: 18),
                    ),
                    const Spacer(),
                    // Arrow
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.accentPurple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.arrow_forward_ios_rounded,
                          color: AppColors.accentViolet, size: 12),
                    ),
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
