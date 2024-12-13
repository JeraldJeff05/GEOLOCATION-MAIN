import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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
      _showMaxPointsWarning();
    }
  }

  void _showMaxPointsWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You can only select 4 points."),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _clearPoints() {
    setState(() {
      _selectedPoints.clear();
    });
  }

  Future<void> _submitData() async {
    if (_selectedPoints.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select exactly 4 points."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
    final String url =
        'https://1lp44l1f-8080.asse.devtunnels.ms/coordinates?data=$jsonData';

    debugPrint('Payload: $jsonData');
    debugPrint('URL: $url');

    try {
      final response = await http.get(Uri.parse(url));

      String message;
      Color backgroundColor;

      if (response.statusCode == 200) {
        message = 'Response: ${response.body}';
        backgroundColor = Colors.green;
      } else {
        message = 'Failed to fetch data. Status Code: ${response.statusCode}';
        backgroundColor = Colors.red;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          duration: Duration(seconds: 1), // Display for 1 second
        ),
      );
    } catch (e) {
      debugPrint('Error: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1), // Display for 1 second
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine layout based on screen width
        bool isWideScreen = constraints.maxWidth > 1400;
        bool isMediumScreen =
            constraints.maxWidth > 800 && constraints.maxWidth <= 1500;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Geofence Configuration',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.black87,
            elevation: 0,
          ),
          body: isWideScreen || isMediumScreen
              ? _buildWideScreenLayout()
              : _buildNarrowScreenLayout(),
        );
      },
    );
  }

  Widget _buildWideScreenLayout() {
    return Row(
      children: [
        // Sidebar
        Container(
          width: 350,
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(2, 0),
              )
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected Points',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              ..._buildPointsList(),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _submitData,
                      icon: Icon(Icons.send),
                      label: Text('Submit Data'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.clear, color: Colors.red),
                    onPressed: _clearPoints,
                    tooltip: 'Clear Points',
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (_response.isNotEmpty)
                Text(
                  _response,
                  style: TextStyle(
                    fontSize: 16,
                    color: _response.contains('Failed')
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
            ],
          ),
        ),

        // Map
        Expanded(
          child: _buildMap(),
        ),
      ],
    );
  }

  Widget _buildNarrowScreenLayout() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: _buildMap(),
        ),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected Points',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ..._buildPointsList(),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _submitData,
                      icon: Icon(Icons.send),
                      label: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.clear, color: Colors.red),
                    onPressed: _clearPoints,
                    tooltip: 'Clear Points',
                  ),
                ],
              ),
              if (_response.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _response,
                    style: TextStyle(
                      fontSize: 16,
                      color: _response.contains('Failed')
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPointsList() {
    return _selectedPoints.asMap().entries.map((entry) {
      final index = entry.key + 1;
      final point = entry.value;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(1, 1),
              )
            ],
          ),
          child: Text(
            'Point $index: (${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)})',
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildMap() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(14.067833722868489, 121.3270708600162),
        initialZoom: 18.0,
        onTap: (_, latLng) => _onMapTap(latLng),
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: _selectedPoints
              .map(
                (point) => Marker(
                  width: 40.0,
                  height: 40.0,
                  point: point,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black45,
                        offset: Offset(3, 3),
                      )
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
