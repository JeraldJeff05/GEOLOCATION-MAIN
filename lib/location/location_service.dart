import 'package:geolocator/geolocator.dart';

class LocationService {
  double? lat;
  double? lng;

  // Function to get the user's current location
  Future<void> getCurrentLocation() async {
    try {
      // Check and request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, cannot request permissions.');
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      lat = position.latitude;
      lng = position.longitude;

      print('Latitude: $lat, Longitude: $lng'); // Debugging output
    } catch (e) {
      print('Error fetching location: $e');
    }
  }
}
