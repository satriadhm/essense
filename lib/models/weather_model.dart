class WeatherModel {
  final String condition;
  final int temperature;
  final String feelsLike;
  final int humidity;
  final int dewPoint;
  final String date;

  const WeatherModel({
    required this.condition,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.dewPoint,
    required this.date,
  });
}
