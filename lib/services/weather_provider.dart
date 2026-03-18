import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../models/weather_model.dart';
import 'weather_service.dart';
import 'location_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  WeatherModel? _weather;
  String? _city;
  String? _country;
  bool _isLoading = false;
  String? _error;

  // Getters
  WeatherModel? get weather => _weather;
  String? get city => _city;
  String? get country => _country;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch weather using current device location
  Future<void> fetchWeatherByLocation() async {
    developer.log('[WeatherProvider] Starting fetchWeatherByLocation');
    print('[WeatherProvider] Starting fetchWeatherByLocation');
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      developer.log('[WeatherProvider] Getting current location...');
      print('[WeatherProvider] Getting current location...');
      
      final location = await _locationService.getCurrentLocation();
      developer.log('[WeatherProvider] Location: $location');
      print('[WeatherProvider] Location: $location');
      
      developer.log('[WeatherProvider] Fetching weather for lat=${location['lat']}, lon=${location['lon']}');
      print('[WeatherProvider] Fetching weather for lat=${location['lat']}, lon=${location['lon']}');
      
      final weather = await _weatherService.getWeatherByCoordinates(
        location['lat'] as double,
        location['lon'] as double,
      );

      developer.log('[WeatherProvider] Weather fetched: $weather');
      print('[WeatherProvider] Weather fetched: $weather');
      
      _weather = weather;
      _city = location['city'] as String;
      _country = location['country'] as String;
      _isLoading = false;
      notifyListeners();
      
      developer.log('[WeatherProvider] Success!');
      print('[WeatherProvider] Success!');
    } catch (e) {
      developer.log('[WeatherProvider] ERROR: $e');
      print('[WeatherProvider] ERROR: $e');
      
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch weather for a specific city
  Future<void> fetchWeatherByCity(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final location = await _locationService.getLocationByCity(city);
      final weather = await _weatherService.getWeatherByCoordinates(
        location['lat'] as double,
        location['lon'] as double,
      );

      _weather = weather;
      _city = location['city'] as String;
      _country = location['country'] as String;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh weather data
  Future<void> refreshWeather() async {
    if (_city != null) {
      await fetchWeatherByCity(_city!);
    } else {
      await fetchWeatherByLocation();
    }
  }
}
