import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class CommunityEmptyState extends StatelessWidget {
  final VoidCallback onExploreTap;

  const CommunityEmptyState({super.key, required this.onExploreTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.groups_2_outlined,
              color: AppColors.textSecondary,
              size: 44,
            ),
            const SizedBox(height: 12),
            Text(
              'No posts in this filter yet',
              style: AppTextStyles.bannerTitle.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Try another filter or explore creators to populate your community feed.',
              style: AppTextStyles.bannerSub,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: onExploreTap,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.accentCyan),
                foregroundColor: AppColors.accentCyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
              ),
              child: const Text('Explore creators'),
            ),
          ],
        ),
      ),
    );
  }
}
