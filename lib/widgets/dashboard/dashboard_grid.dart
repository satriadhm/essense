import 'package:flutter/material.dart';
import '../../models/dashboard_grid_data.dart';
import '../../theme/app_theme.dart';
import '../cards/weather_card.dart';
import '../cards/device_status_card.dart';
import '../cards/cartridge_volume_card.dart';

/// Dashboard grid section: 2-column asymmetric layout.
/// Left: weather card (~52% width, ~310px tall). Right: device status + cartridge
/// volume stacked (~46% width), each ~145px tall. Right column height matches left.
class DashboardGrid extends StatelessWidget {
  final int batteryPercent;
  final int cartridgeVolumePercent;
  final DashboardGridData? data;

  static const double _sectionHeight = 310;
  static const int _leftFlex = 52;
  static const int _rightFlex = 46;

  const DashboardGrid({
    super.key,
    this.batteryPercent = 65,
    this.cartridgeVolumePercent = 70,
    this.data,
  });

  int get _battery => data?.batteryPercent ?? batteryPercent;
  int get _cartridge => data?.cartridgeVolumePercent ?? cartridgeVolumePercent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gridHorizontal),
      child: _buildGridLayout(),
    );
  }

  /// 2-column asymmetric grid: left = tall weather card, right = two stacked cards.
  Widget _buildGridLayout() {
    return SizedBox(
      height: _sectionHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: _leftFlex,
            child: const WeatherCard(),
          ),
          const SizedBox(width: AppSpacing.gridGap),
          Expanded(
            flex: _rightFlex,
            child: Column(
              children: [
                Expanded(child: DeviceStatusCard(batteryPercent: _battery)),
                const SizedBox(height: 8),
                Expanded(child: CartridgeVolumeCard(volumePercent: _cartridge)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
