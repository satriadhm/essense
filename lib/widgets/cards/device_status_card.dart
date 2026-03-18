import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class DeviceStatusCard extends StatelessWidget {
  final int batteryPercent;
  const DeviceStatusCard({super.key, required this.batteryPercent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: AppGradients.deviceCard,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: AppColors.accentDevice.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Device image asset
          SizedBox(
            width: 60,
            height: 80,
            child: Image.asset(
              'assets/images/device.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Percentage row — % superscripted to top of number
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$batteryPercent',
                      style: AppTextStyles.percentLarge.copyWith(
                        fontSize: 44,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        color: AppColors.statWhiteWarm,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '%',
                        style: TextStyle(
                          fontSize: 20,
                          height: 1.0,
                          color: AppColors.statWhiteWarm,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Battery Life',
                  style: AppTextStyles.cardSub.copyWith(
                    fontSize: 13,
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
    );
  }
}
