import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ApiService {
  static const String _apiUrl =
      "https://1lp44l1f-8080.asse.devtunnels.ms/geofence/check"; // Replace with your API URL

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
        // Determine screen size categories
        final isWideScreen = constraints.maxWidth > 1200;
        final isMediumScreen =
            constraints.maxWidth > 800 && constraints.maxWidth <= 1200;

        // Minimum size check
        if (constraints.maxWidth < 300 || constraints.maxHeight < 400) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                "Please increase screen size",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        // Responsive layouts
        if (isWideScreen || isMediumScreen) {
          return _buildWideScreenLayout();
        } else {
          return _buildNarrowScreenLayout();
        }
      },
    );
  }

  Widget _buildWideScreenLayout() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildControlPanel(),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildMapView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNarrowScreenLayout() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Geofence Check",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: _buildMapView(),
              ),
              Expanded(
                flex: 1,
                child: _buildControlPanel(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white10,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Location Display
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                _selectedLocation != null
                    ? 'Location:\n${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}'
                    : "Select a Location on Map",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),

            // Response Display
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                _responseMessage.isEmpty
                    ? "Waiting for response..."
                    : _responseMessage,
                style: TextStyle(
                  color: _responseMessage.contains("allowed")
                      ? Colors.green
                      : Colors.red,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),

            // Check Geofence Button
            ElevatedButton(
              onPressed: _checkGeofence,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white24,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Check Geofence",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(14.067833722868489, 121.3270708600162),
            initialZoom: 18.0,
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
                        width: 20.0,
                        height: 20.0,
                        point: _selectedLocation!,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ]
                  : [],
            ),
          ],
        ),
      ),
    );
  }
}
