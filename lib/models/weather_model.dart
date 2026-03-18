class WeatherModel {
  final String condition;
  final int temperature;
  final int tempMin;
  final int tempMax;
  final String feelsLike;
  final int humidity;
  final int dewPoint;
  final String date;

  const WeatherModel({
    required this.condition,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.feelsLike,
    required this.humidity,
    required this.dewPoint,
    required this.date,
  });
}
