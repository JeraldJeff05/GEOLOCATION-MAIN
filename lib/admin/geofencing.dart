import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ApiService {
  static const String _apiUrl =
      "http://192.168.120.50:8080/geofence/check"; // Replace with your API URL

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black54, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Geofence Check",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 24 : 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Expanded(
                      child: isSmallScreen
                          ? Column(
                              children: [
                                _buildFirstColumn(isSmallScreen),
                                const SizedBox(height: 16.0),
                                _buildSecondColumn(),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: _buildFirstColumn(isSmallScreen),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  flex: 2,
                                  child: _buildSecondColumn(),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFirstColumn(bool isSmallScreen) {
    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 125,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: Colors.white,
              ),
              child: Text(
                _selectedLocation != null
                    ? 'Selected Location:\n${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}'
                    : "Select Location",
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 5.0),
            Container(
              height: 90,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: Colors.white,
              ),
              child: Text(
                _responseMessage.isEmpty
                    ? "Waiting for the response..."
                    : _responseMessage,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _checkGeofence,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 32.0,
                ),
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              child: const Text(
                "Check Geofence",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondColumn() {
    return Container(
      height: double.infinity,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(14.067833722868489, 121.3270708600162),
          initialZoom: 20.0,
          onTap: (_, latLng) => _onTap(latLng),
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _selectedLocation != null
                ? [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _selectedLocation!,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                  ]
                : [],
          ),
        ],
      ),
    );
  }
}
