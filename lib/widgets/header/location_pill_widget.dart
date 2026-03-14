import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class LocationPillWidget extends StatelessWidget {
  final String city;
  final String flagEmoji;
  const LocationPillWidget({
    super.key,
    required this.city,
    required this.flagEmoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.pillBg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.accentPurple.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(flagEmoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
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
    );
  }
}
