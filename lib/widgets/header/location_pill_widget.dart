import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class LocationPillWidget extends StatelessWidget {
  final String city;
  final VoidCallback onTap;
  const LocationPillWidget({
    super.key,
    required this.city,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.pillBg,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: AppColors.accentPurple.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(city,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 13),
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary, size: 16),
          ],
        ),
      ),
    );
  }
}
