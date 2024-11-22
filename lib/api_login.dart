import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiLogin {
  final String _apiUrl =
      'http://192.168.120.45:8080/employee/login'; // Replace with your API URL

  /// Method to log in a user
  Future<bool> login({
    required String id,
    required String password,
  }) async {
    // Bypass for admin credentials
    if (id == 'admin' && password == 'admin') {
      return true; // Admin login successful
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

      // Display only the response body
      debugPrint('${response.body}');

      if (response.statusCode == 200) {
        // Parse the response body
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return true; // Login successful
        } else if (data['failed'] == false) {
          return true; // Login failed
        } else {
          return false; // Login failed
        }
      } else {
        // Handle server errors
        return false;
      }
    } catch (e) {
      // Handle network errors
      return false;
    }
  }
}
