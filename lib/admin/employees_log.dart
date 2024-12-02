import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeesLogWidget extends StatelessWidget {
  // Function to send GET request with extended logging
  Future<void> _sendGetRequest() async {
    final url = Uri.parse(
        'http://192.168.120.19:8080/employee/info?keyword=strawberry+shortcake'); // API URL

    print('Sending GET request to $url');

    final client = http.Client();
    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        // Print response body if successful
        print('Response: ${response.body}');
      } else {
        // Enhanced error logging
        print('Failed to load data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Enhanced exception handling
      print('Error occurred: $e');
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees Log'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _sendGetRequest, // Trigger GET request on button press
          child: Text('Send GET Request'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EmployeesLogWidget(),
  ));
}
