import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: AppGradients.weatherCard,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: AppColors.iconBorderGlow.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final hasBoundedHeight = constraints.maxHeight < double.infinity;
            return Column(
              mainAxisSize: hasBoundedHeight ? MainAxisSize.max : MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // 1. Date label
            Text(
              'Mon, 29 Jan 2026',
              style: AppTextStyles.cardSub.copyWith(
                fontSize: 10,
                color: AppColors.accentWeather.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 10),

            // 2. Large temp + weather icon (side by side — temp first, then icon)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '15',
                          style: AppTextStyles.tempLarge.copyWith(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: AppColors.statWhiteCool,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            '°',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: AppColors.statWhiteCool,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 56,
                  height: 56,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 2,
                        right: 6,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: [
                                Color(0xFFFFB347),
                                Color(0xFFFF8C00),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF8C00).withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 6,
                        left: 0,
                        child: Icon(
                          Icons.cloud_rounded,
                          color: AppColors.accentWeather,
                          size: 40,
                        ),
                      ),
                      ...List.generate(4, (i) => Positioned(
                            bottom: 2 + (i * 5),
                            left: 14 + (i * 10),
                            child: Container(
                              width: 2,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.accentWeather.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(1),
                              ),
                              transform: Matrix4.rotationZ(-0.3),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),

            // 3. "feels like" + condition text (stacked)
            const SizedBox(height: 6),
            Text(
              'Feels like 20°',
              style: AppTextStyles.cardSub.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.accentWeather.withValues(alpha: 0.7),
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              'Light Rain',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.accentWeather,
              ),
              overflow: TextOverflow.ellipsis,
            ),

            // 4. Humidity + Dew Point (side by side)
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: _WeatherStat(
                    icon: Icons.water_drop_rounded,
                    value: '18%',
                    label: 'Humidity',
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: _WeatherStat(
                    icon: Icons.thermostat_outlined,
                    value: '7°',
                    label: 'Dew Point',
                  ),
                ),
              ],
            ),

            if (hasBoundedHeight) const Spacer() else const SizedBox(height: 16),

            // 5. Forward arrow button — anchored bottom right (small white arrow)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ],
        );
          },
        ),
      ),
    );
  }
}

class _WeatherStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _WeatherStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.accentWeather, size: 14),
        const SizedBox(width: 3),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.statWhiteCool),
                overflow: TextOverflow.ellipsis),
            Text(label,
                style: AppTextStyles.cardSub.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.accentWeather.withValues(alpha: 0.65)),
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ],
    );
  }
}
