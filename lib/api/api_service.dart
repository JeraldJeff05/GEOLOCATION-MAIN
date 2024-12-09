import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiUrl =
      "http://192.168.120.50:8080/geofence/check"; // Replace with your API URL

  Future<String> sendCoordinates(String lat, String lng) async {
    try {
      // Validate latitude and longitude values
      if (lat.isEmpty || lng.isEmpty) {
        return "Latitude and Longitude cannot be empty";
      }

      // Concatenate latitude and longitude as query parameters in the URL
      final url = Uri.parse("$_apiUrl?lat=$lat&lng=$lng");

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      // Check if status code is 200
      if (response.statusCode == 200) {
        if (response.body.trim().toLowerCase() == 'true') {
          return "Location is allowed";
        } else if (response.body.trim().toLowerCase() == 'false') {
          return "Location not allowed";
        } else {
          return "Unexpected response: ${response.body}";
        }
      } else {
        return "Error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
