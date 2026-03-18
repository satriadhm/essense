import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class CommunityErrorState extends StatelessWidget {
  final VoidCallback onRetryTap;

  const CommunityErrorState({super.key, required this.onRetryTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_tethering_error_rounded,
              color: AppColors.accentOrange,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              'Couldn\'t load community feed',
              style: AppTextStyles.bannerTitle.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Please try again. This screen currently uses mock frontend data.',
              style: AppTextStyles.bannerSub,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: onRetryTap,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.accentOrange),
                foregroundColor: AppColors.accentOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
