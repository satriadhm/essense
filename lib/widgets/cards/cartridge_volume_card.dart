import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CartridgeVolumeCard extends StatelessWidget {
  final int volumePercent;
  const CartridgeVolumeCard({super.key, required this.volumePercent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: AppGradients.cartridgeCard,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: AppColors.iconBorderGlow.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Tall perfume bottle icon — dark fill + lighter border, glass-like
          SizedBox(
            width: 40,
            height: 56,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cap — dark fill + brighter border
                Container(
                  width: 18,
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: AppColors.iconFillDark,
                    border: Border.all(
                      color: AppColors.accentCartridge.withValues(alpha: 0.6),
                      width: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                // Bottle body — glass-like translucent
                Container(
                  width: 24,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                      bottom: Radius.circular(12),
                    ),
                    color: AppColors.iconFillDark.withValues(alpha: 0.6),
                    border: Border.all(
                      color: AppColors.accentCartridge.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$volumePercent',
                      style: AppTextStyles.percentLarge.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: AppColors.statWhiteWarm,
                      ),
                    ),
                    Text(
                      '%',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.statWhiteWarm,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Cartridge Volume',
                  style: AppTextStyles.cardSub.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.accentCartridge.withValues(alpha: 0.65),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
