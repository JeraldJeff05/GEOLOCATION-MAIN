import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class LocationService {
  static const double minLatitude = 14.06727248844374;
  static const double maxLatitude = 14.068567511556262;
  static const double minLongitude = 121.32635146800003;
  static const double maxLongitude = 121.32768653199999;

  static Future<bool> checkLocationService(
      Function(String) showLocationErrorDialog) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showLocationErrorDialog(
          "Location services are disabled. Please 7 enable them in your device settings.");
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
    return latitude >= minLatitude &&
        latitude <= maxLatitude &&
        longitude >= minLongitude &&
        longitude <= maxLongitude;
  }
}
