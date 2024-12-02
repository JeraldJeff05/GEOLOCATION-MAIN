import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Handles API requests related to Employees Log.
class EmployeesApi {
  final String _apiUrl = 'http://192.168.120.19:8080/employee/info'; // API URL

  /// Sends a POST request to the server with the specified keyword.
  Future<String?> sendPostRequest({required String keyword}) async {
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'Keyword': keyword});

    debugPrint('Sending POST request to $_apiUrl with body $body');

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        debugPrint('Response: ${response.body}');
        return response.body; // Return the response body if successful
      } else {
        debugPrint('Failed to load data: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return null; // Return null on failure
      }
    } catch (e) {
      debugPrint('Error occurred: $e');
      return null; // Return null on error
    }
  }
}

class EmployeesLogWidget extends StatelessWidget {
  final EmployeesApi _api =
      EmployeesApi(); // Create an instance of EmployeesApi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees Log'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Trigger POST request on button press
            final response = await _api.sendPostRequest(
              keyword: 'strawberry shortcake',
            );
            if (response != null) {
              debugPrint('API Response: $response');
              // Show success or handle response data
            } else {
              debugPrint('Failed to fetch data from the API');
              // Show error or retry logic
            }
          },
          child: Text('Send POST Request'),
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
