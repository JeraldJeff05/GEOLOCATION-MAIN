import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiUrl =
      "https://1lp44l1f-8080.asse.devtunnels.ms/geofence/check";

  Future<String> sendCoordinates(String lat, String lng) async {
    try {
      if (lat.isEmpty || lng.isEmpty) {
        return "Latitude and Longitude cannot be empty";
      }

      final url = Uri.parse("$_apiUrl?lat=$lat&lng=$lng");

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

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
