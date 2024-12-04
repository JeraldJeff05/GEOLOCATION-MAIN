import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiUrl =
      "http://192.168.120.19:8080/geofence/check"; // Replace with your API URL

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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Geofence Check",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _latitudeController,
                            decoration: InputDecoration(
                              labelText: "Latitude",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16.0),
                          TextField(
                            controller: _longitudeController,
                            decoration: InputDecoration(
                              labelText: "Longitude",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: _checkGeofence,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      "Check Geofence",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  AnimatedOpacity(
                    opacity: _responseMessage.isEmpty ? 0 : 1,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        _responseMessage,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
