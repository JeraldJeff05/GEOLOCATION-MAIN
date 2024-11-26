import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiLogin {
  final String _apiUrl =
      'http://192.168.120.17:8080/employee/login'; // Replace with your API URL

  /// Method to log in a user
  Future<bool> login({
    required String id,
    required String password,
  }) async {
// Bypass for admin credentials
    if (id == 'jeff' && password == 'jeff') {
      return true;
    }

    try {
// Encode the query parameters
      final Uri apiUri = Uri.parse(_apiUrl).replace(queryParameters: {
        'id': id,
        'password': password,
      });

// Make a GET request to the API
      final response = await http.get(
        apiUri,
        headers: {'Content-Type': 'application/json'},
      );

// Debug the response body
      debugPrint('${response.body}');

      if (response.statusCode == 200) {
// Directly check the response body
        if (response.body == "employee" || response.body == "admin") {
          return true; // Login successful
        } else if (response.body == "false") {
          return false; // Login failed
        }
      }
      return false; // Handle unexpected cases
    } catch (e) {
// Handle network or server errors
      debugPrint('Error during login: $e');
      return false;
    }
  }
}
