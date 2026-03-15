    import 'package:flutter/material.dart';
    import 'package:provider/provider.dart';
    import 'package:intl/intl.dart';
    import '../../theme/app_theme.dart';
    import '../../services/weather_provider.dart';

    class WeatherCard extends StatelessWidget {
      const WeatherCard({super.key});

      @override
      Widget build(BuildContext context) {
        return Consumer<WeatherProvider>(
          builder: (context, weatherProvider, child) {
            final weather = weatherProvider.weather;
            final isLoading = weatherProvider.isLoading;
            final error = weatherProvider.error;

            if (error != null) {
              return _buildErrorCard(context, error);
            }

            if (isLoading || weather == null) {
              return _buildLoadingCard(context);
            }

            return _buildWeatherCard(context, weather);
          },
        );
      }

      Widget _buildLoadingCard(BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            decoration: BoxDecoration(
              gradient: AppGradients.weatherCard,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: AppColors.iconBorderGlow.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 12),
                  Text(
                    'Loading weather...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      Widget _buildErrorCard(BuildContext context, String error) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            decoration: BoxDecoration(
              gradient: AppGradients.weatherCard,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: AppColors.iconBorderGlow.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Failed to load weather',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Show detailed error message
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      error,
                      style: TextStyle(
                        color: Colors.yellow[300],
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Provider.of<WeatherProvider>(context, listen: false)
                          .fetchWeatherByLocation();
                    },
                    child: Text(
                      'Retry',
                      style: TextStyle(
                        color: Colors.blue[300],
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      Widget _buildWeatherCard(BuildContext context, dynamic weather) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Main Card Background and Content
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
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

                  Widget contentCols = Padding(
                    padding: const EdgeInsets.only(left: 130),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Temperature
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.white, Color(0xFF4A7CBD)],
                          ).createShader(bounds),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${weather.temperature}',
                                style: const TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: Text(
                                  '°',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Feels like ${weather.feelsLike}°',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.statWhiteCool.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          weather.condition,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );

                  return Column(
                      mainAxisSize: hasBoundedHeight ? MainAxisSize.max : MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Top Right Date
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            DateFormat('EEE, d MMM yyyy').format(DateTime.now()),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.statWhiteCool.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                        
                        // 2. Main content: Space for Image + Temp Info
                        const SizedBox(height: 8),
                        if (hasBoundedHeight)
                          Expanded(child: contentCols)
                        else
                          contentCols,
                        
                        // 3. Bottom Stats
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Stats Row
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _WeatherStat(
                                    icon: Icons.water_drop,
                                    value: '${weather.humidity}%',
                                    label: 'Humidity',
                                  ),
                                  _WeatherStat(
                                    icon: Icons.thermostat,
                                    value: '${weather.dewPoint}°',
                                    label: 'Dew Point',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Action button
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            
            // Overlapping Weather Illustration
            Positioned(
              top: -30,
              left: -10,
              child: SizedBox(
                width: 160,
                height: 160,
                child: Image.asset(
                  'assets/images/weather_illustration.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.cloud,
                    size: 80,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
          ],
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF4A7CBD), size: 30),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.1),
                    overflow: TextOverflow.ellipsis),
                Text(label,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.8),
                        height: 1.1),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ],
        );
      }
    }
