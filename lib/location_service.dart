import 'package:geolocator/geolocator.dart';

class LocationService {
  static const double centerLatitude = 14.067882127247886;
  static const double centerLongitude = 121.32713395416246;
  static const double radiusInMeters = 15.0;

  static Future<bool> checkLocationService(
      Function(String) showLocationErrorDialog) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showLocationErrorDialog(
          "Location services are disabled. Please enable them in your device settings.");
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showLocationErrorDialog(
            "Location permissions are denied. Please grant permissions to proceed.");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showLocationErrorDialog(
          "Location permissions are permanently denied. Please enable them in settings.");
      return false;
    }
    return true;
  }

  static Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition();
  }

  static bool isLocationInRange(double latitude, double longitude) {
    // Calculate the distance between the current location and the center point
    double distanceInMeters = Geolocator.distanceBetween(
      latitude,
      longitude,
      centerLatitude,
      centerLongitude,
    );

    // Check if the distance is within the defined radius
    return distanceInMeters <= radiusInMeters;
  }
}
