import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class CommunityLoadingSkeleton extends StatelessWidget {
  const CommunityLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.card),
          color: AppColors.cardBgLight,
        ),
      ),
    );
  }
}
