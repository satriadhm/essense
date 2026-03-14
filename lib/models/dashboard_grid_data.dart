import 'device_model.dart';
import 'weather_model.dart';

/// Data model for the dashboard grid section.
/// Holds props for [WeatherCard], [DeviceStatusCard], and [CartridgeVolumeCard].
class DashboardGridData {
  final WeatherModel? weather;
  final DeviceModel? device;

  const DashboardGridData({
    this.weather,
    this.device,
  });

  int get batteryPercent => device?.batteryPercent ?? 65;
  int get cartridgeVolumePercent => device?.cartridgeVolumePercent ?? 70;
}
