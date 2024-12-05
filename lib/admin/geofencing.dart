import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ApiService {
  static const String _apiUrl =
      "http://192.168.120.19:8080/geofence/check"; // Replace with your API URL

  Future<String> sendCoordinates(String lat, String lng) async {
    try {
      if (lat.isEmpty || lng.isEmpty) {
        return "Latitude and Longitude cannot be empty";
      }

      final url = Uri.parse("$_apiUrl?lat=$lat&lng=$lng");

      debugPrint('Sending request to API: $url');

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
  final ApiService _apiService = ApiService();
  String _responseMessage = "";
  LatLng? _selectedLocation;

  void _checkGeofence() async {
    if (_selectedLocation == null) {
      setState(() {
        _responseMessage = "Please select a location.";
      });
      return;
    }

    final lat = _selectedLocation!.latitude.toString();
    final lng = _selectedLocation!.longitude.toString();

    final response = await _apiService.sendCoordinates(lat, lng);
    setState(() {
      _responseMessage = response;
    });
  }

  void _onTap(LatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
              const SizedBox(height: 10.0),
              Expanded(
                child: Row(
                  children: [
                    // First column with geofence UI elements
                    Expanded(
                      flex: 1,
                      child: Card(
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Box for selected location
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[200],
                                ),
                                child: Text(
                                  _selectedLocation != null
                                      ? 'Selected Location:\n${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}'
                                      : "Select Location",
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              // Check Geofence Button
                              ElevatedButton(
                                onPressed: _checkGeofence,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 32.0),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                child: const Text(
                                  "Check Geofence",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              // Box for API Response
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[200],
                                ),
                                child: Text(
                                  _responseMessage.isEmpty
                                      ? "Waiting for the response.."
                                      : _responseMessage,
                                  style: const TextStyle(fontSize: 16.0),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    // Second column with the map
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: double.infinity,
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter:
                                LatLng(14.067833722868489, 121.3270708600162),
                            initialZoom: 20.0,
                            onTap: (_, latLng) => _onTap(latLng),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a', 'b', 'c'],
                            ),
                            MarkerLayer(
                              markers: _selectedLocation != null
                                  ? [
                                      Marker(
                                        width: 80.0,
                                        height: 80.0,
                                        point: _selectedLocation!,
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                      ),
                                    ]
                                  : [],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
