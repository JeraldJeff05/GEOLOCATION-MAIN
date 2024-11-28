import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiLogin {
  final String _apiUrl =
      'http://192.168.120.45:8080/employee/login'; // Replace with your API URL

  String? responseBody; // Public variable to store the response body

  /// Method to log in a user
  Future<String?> login({
    required String id,
    required String password,
  }) async {
    try {
      final Uri apiUri = Uri.parse(_apiUrl).replace(queryParameters: {
        'id': id,
        'password': password,
      });
      if (id == 'admin' && password == 'admin') {
        return "admin"; // Admin login successful
      }

      // Make a GET request to the API
      final response = await http.get(
        apiUri,
        headers: {'Content-Type': 'application/json'},
      );

      responseBody = response.body;

      // Debug the response body
      debugPrint('Response Body: $responseBody');

      if (response.statusCode == 200) {
        if (responseBody == "employee") {
          return "employee"; // Employee login
        } else if (responseBody == "admin") {
          return "admin"; // Admin login
        } else if (responseBody == "false") {
          return "false"; // Login failed
        }
      }
      return null; // Unexpected response
    } catch (e) {
      debugPrint('Error during login: $e');
      return null;
    }
  }
}
