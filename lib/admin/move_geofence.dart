import 'dart:convert'; // For JSON encoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InputPointsScreen(),
    );
  }
}

class InputPointsScreen extends StatefulWidget {
  @override
  _InputPointsScreenState createState() => _InputPointsScreenState();
}

class _InputPointsScreenState extends State<InputPointsScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'lat1': TextEditingController(),
    'lng1': TextEditingController(),
    'lat2': TextEditingController(),
    'lng2': TextEditingController(),
    'lat3': TextEditingController(),
    'lng3': TextEditingController(),
    'lat4': TextEditingController(),
    'lng4': TextEditingController(),
  };

  String _response = '';

  Future<void> _submitData() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Prepare the points
      final points = {
        'point1': {
          'latitude': _controllers['lat1']!.text,
          'longitude': _controllers['lng1']!.text,
        },
        'point2': {
          'latitude': _controllers['lat2']!.text,
          'longitude': _controllers['lng2']!.text,
        },
        'point3': {
          'latitude': _controllers['lat3']!.text,
          'longitude': _controllers['lng3']!.text,
        },
        'point4': {
          'latitude': _controllers['lat4']!.text,
          'longitude': _controllers['lng4']!.text,
        },
      };

      // Encode data into JSON format
      final String jsonData = jsonEncode(points);

      // API URL with concatenated JSON data
      final String url =
          'http://192.168.120.47:8080/employee/login?data=$jsonData';

      debugPrint('URL: $url');
      debugPrint('Payload (JSON): $jsonData');

      try {
        // Send GET request
        final response = await http.get(Uri.parse(url));

        // Debug response details
        debugPrint('Response Status Code: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');

        // Process response
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
        debugPrint('Error occurred: $e');
        setState(() {
          _response = 'Error: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Points'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (int i = 1; i <= 4; i++) ...[
                  Text('Point $i', style: const TextStyle(fontSize: 18)),
                  TextFormField(
                    controller: _controllers['lat$i'],
                    decoration: InputDecoration(labelText: 'Latitude'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter latitude';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _controllers['lng$i'],
                    decoration: InputDecoration(labelText: 'Longitude'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter longitude';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                ElevatedButton(
                  onPressed: _submitData,
                  child: const Text('Submit Data'),
                ),
                const SizedBox(height: 16),
                Text(_response),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
