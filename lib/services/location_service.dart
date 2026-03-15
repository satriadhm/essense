import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<Map<String, dynamic>> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.',
        );
      }

      // Get current position
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get city name from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final placemark = placemarks.isNotEmpty ? placemarks.first : null;

      return {
        'lat': position.latitude,
        'lon': position.longitude,
        'city': placemark?.locality ?? 'Unknown',
        'country': placemark?.isoCountryCode ?? '',
        'countryName': placemark?.country ?? '',
      };
    } catch (e) {
      throw Exception('Location Service Error: $e');
    }
  }

  Future<Map<String, dynamic>> getLocationByCity(String city) async {
    try {
      List<Location> locations = await locationFromAddress(city);
      if (locations.isEmpty) {
        throw Exception('City not found');
      }

      final location = locations.first;
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      final placemark = placemarks.isNotEmpty ? placemarks.first : null;

      return {
        'lat': location.latitude,
        'lon': location.longitude,
        'city': placemark?.locality ?? city,
        'country': placemark?.isoCountryCode ?? '',
        'countryName': placemark?.country ?? '',
      };
    } catch (e) {
      throw Exception('Location Service Error: $e');
    }
  }
}
