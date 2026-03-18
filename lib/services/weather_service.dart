import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import '../models/weather_model.dart';

class WeatherService {
  // TODO: Move to environment variable or secure configuration
  // Get your free API key from: https://openweathermap.org/api
  static const String _apiKey = 'f30dfc06833562e6eea7c604ae2b3f9f';
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  /// Parse JSON response from OpenWeatherMap API
  /// Note: dew_point is not available in /weather endpoint (only in One Call API v3.0)
  static WeatherModel _parseWeatherResponse(Map<String, dynamic> json) {
    try {
      print('[WeatherService] Parsing JSON response...');

      final weather = json['weather'] as List?;
      if (weather == null || weather.isEmpty) {
        throw Exception('Missing weather array in response');
      }

      final main = json['main'] as Map<String, dynamic>?;
      if (main == null) {
        throw Exception('Missing main data in response');
      }

      print('[WeatherService] JSON parsing successful');

      return WeatherModel(
        condition: weather[0]['main'] ?? 'Unknown',
        temperature: ((main['temp'] ?? 0) as num).round(),
        tempMin: ((main['temp_min'] ?? 0) as num).round(),
        tempMax: ((main['temp_max'] ?? 0) as num).round(),
        feelsLike: (main['feels_like'] ?? 0).toStringAsFixed(1),
        humidity: (main['humidity'] ?? 0) as int,
        dewPoint: 0, // Not available from /weather endpoint
        date: DateTime.now().toString(),
      );
    } catch (e) {
      print('[WeatherService] JSON parsing error: $e');
      throw Exception('Failed to parse weather response: $e');
    }
  }

  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon) async {
    try {
      final url = '$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
      developer.log('Fetching weather from: $url');
      print('[WeatherService] Fetching weather from: $url');

      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Weather API request timed out');
            },
          );

      developer.log('Response status: ${response.statusCode}');
      print('[WeatherService] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        developer.log('Weather response: $json');
        print('[WeatherService] Weather response: $json');
        return _parseWeatherResponse(json);
      } else if (response.statusCode == 401) {
        throw Exception(
          'Invalid API key. Please update in weather_service.dart',
        );
      } else {
        developer.log('Error response body: ${response.body}');
        print('[WeatherService] Error response body: ${response.body}');
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } on Exception {
      rethrow;
    } catch (e) {
      developer.log('Unexpected error: $e');
      print('[WeatherService] Unexpected error: $e');
      throw Exception('Weather Service Error: $e');
    }
  }

  Future<WeatherModel> getWeatherByCity(String city) async {
    try {
      final url = '$_baseUrl?q=$city&appid=$_apiKey&units=metric';
      developer.log('Fetching weather for city: $city');
      print('[WeatherService] Fetching weather for city: $city');

      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Weather API request timed out');
            },
          );

      developer.log('Response status: ${response.statusCode}');
      print('[WeatherService] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        developer.log('Weather response: $json');
        print('[WeatherService] Weather response: $json');
        return _parseWeatherResponse(json);
      } else if (response.statusCode == 401) {
        throw Exception(
          'Invalid API key. Please update in weather_service.dart',
        );
      } else {
        developer.log('Error response body: ${response.body}');
        print('[WeatherService] Error response body: ${response.body}');
        throw Exception(
          'Failed to load weather for $city: ${response.statusCode}',
        );
      }
    } on Exception {
      rethrow;
    } catch (e) {
      developer.log('Unexpected error: $e');
      print('[WeatherService] Unexpected error: $e');
      throw Exception('Weather Service Error: $e');
    }
  }
}
