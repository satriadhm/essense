import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class DeviceStatusCard extends StatelessWidget {
  final int batteryPercent;
  const DeviceStatusCard({super.key, required this.batteryPercent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: AppGradients.deviceCard,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: AppColors.accentDevice.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Card title row — dashed green accent outline (interactive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppColors.accentDevice.withValues(alpha: 0.6),
                width: 1,
              ),
            ),
            child: Text(
              'Device Status',
              style: AppTextStyles.cardTitle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.statWhiteCool,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Horizontal layout: circular device icon left, large % + subtitle right
          Row(
            children: [
              // Circular device icon — dark fill + lighter border, glowing ring
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow ring — green accent
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accentDevice.withValues(alpha: 0.5),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentDevice.withValues(alpha: 0.25),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    // Device body — dark green fill + lighter green border
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF0F1F1A),
                        border: Border.all(
                          color: AppColors.accentDevice.withValues(alpha: 0.6),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.smartphone_rounded,
                        color: AppColors.accentDevice.withValues(alpha: 0.9),
                        size: 18,
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
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$batteryPercent',
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
                      'Battery Life',
                      style: AppTextStyles.cardSub.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: AppColors.accentDevice.withValues(alpha: 0.65),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
