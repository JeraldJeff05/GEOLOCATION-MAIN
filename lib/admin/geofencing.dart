import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiUrl =
      "http://192.168.120.19:8080/geofence/check"; // Replace with your API URL

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

class GeofencingWidget extends StatefulWidget {
  const GeofencingWidget({Key? key}) : super(key: key);

  @override
  _GeofencingWidgetState createState() => _GeofencingWidgetState();
}

class _GeofencingWidgetState extends State<GeofencingWidget> {
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final ApiService _apiService = ApiService();
  String _responseMessage = "";

  void _checkGeofence() async {
    final lat = _latitudeController.text.trim();
    final lng = _longitudeController.text.trim();

    final response = await _apiService.sendCoordinates(lat, lng);
    setState(() {
      _responseMessage = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Geofence Check",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _latitudeController,
            decoration: InputDecoration(
              labelText: "Latitude",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _longitudeController,
            decoration: InputDecoration(
              labelText: "Longitude",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _checkGeofence,
            child: Text("Check Geofence"),
          ),
          SizedBox(height: 16.0),
          Text(
            _responseMessage,
            style: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
