import 'dart:convert'; // For JSON encoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ),
      home: InputPointsScreen(),
    );
  }
}

class InputPointsScreen extends StatefulWidget {
  @override
  _InputPointsScreenState createState() => _InputPointsScreenState();
}

class _InputPointsScreenState extends State<InputPointsScreen> {
  final List<LatLng> _selectedPoints = [];
  String _response = '';

  void _onMapTap(LatLng latLng) {
    if (_selectedPoints.length < 4) {
      setState(() {
        _selectedPoints.add(latLng);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You can only select 4 points.")),
      );
    }
  }

  Future<void> _submitData() async {
    if (_selectedPoints.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select exactly 4 points.")),
      );
      return;
    }

    // Prepare the points as JSON
    final points = {
      'point1': {
        'latitude': _selectedPoints[0].latitude,
        'longitude': _selectedPoints[0].longitude
      },
      'point2': {
        'latitude': _selectedPoints[1].latitude,
        'longitude': _selectedPoints[1].longitude
      },
      'point3': {
        'latitude': _selectedPoints[2].latitude,
        'longitude': _selectedPoints[2].longitude
      },
      'point4': {
        'latitude': _selectedPoints[3].latitude,
        'longitude': _selectedPoints[3].longitude
      },
    };

    final String jsonData = jsonEncode(points);
    final String url = 'http://192.168.120.50:8080/coordinates?data=$jsonData';

    debugPrint('Payload: $jsonData');
    debugPrint('URL: $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _response = 'Response: ${response.body}';
        });
      } else {
        setState(() {
          _response =
              'Failed to fetch data. Status Code: ${response.statusCode}';
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Points'),
        elevation: 4,
      ),
      body: Row(
        children: [
          // First Column: Buttons and UI elements
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            color: Colors.grey[200],
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Points',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                ..._selectedPoints.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final point = entry.value;
                  return Text(
                    'Point $index: (${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)})',
                    style: const TextStyle(fontSize: 16),
                  );
                }),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child:
                      const Text('Submit Data', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 20),
                if (_response.isNotEmpty)
                  Text(
                    _response,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: _response.contains('Failed')
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
              ],
            ),
          ),

          // Second Column: Map
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(14.067833722868489, 121.3270708600162),
                initialZoom: 18.0,
                onTap: (_, latLng) => _onMapTap(latLng),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: _selectedPoints
                      .map(
                        (point) => Marker(
                          width: 40.0,
                          height: 40.0,
                          point: point,
                          child: const Icon(Icons.location_on,
                              color: Colors.red, size: 30),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
