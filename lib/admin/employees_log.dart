import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmployeesLogWidget extends StatefulWidget {
  const EmployeesLogWidget({Key? key}) : super(key: key);

  @override
  _EmployeesLogWidgetState createState() => _EmployeesLogWidgetState();
}

class _EmployeesLogWidgetState extends State<EmployeesLogWidget> {
  String? responseBody; // Holds the raw API response
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    final url = Uri.parse(
        'http://192.168.120.45:8080/geofence/check'); // Replace with your API endpoint
    try {
      final response = await http.get(url);
      setState(() {
        responseBody = response.body; // Store the raw response body
        isLoading = false;
      });

      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to load logs: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        responseBody = 'Error: $e'; // Store error message in responseBody
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Logs'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                responseBody ?? 'No data available.',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
    );
  }
}
