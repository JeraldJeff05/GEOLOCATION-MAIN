import 'package:check_loc/admin/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiLogin {
  final String _apiUrl =
      'https://1lp44l1f-8080.asse.devtunnels.ms/employee/login'; // Replace with your API URL

  String? responseBody; // Public variable to store the response body
  String? role; // Variable to store the role ('employee' or 'admin')
  String? firstName; // Variable to store the first name
  String? lastName; // Variable to store the last name

  /// Method to log in a user
  Future<String?> login({
    required String id,
    required String password,
  }) async {
    try {
      final apiUri = Uri.parse(APIEndpoints.login).replace(queryParameters: {
        // Uri.parse(_apiUrl).replace(queryParameters: {
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
// Only print the response body once
      debugPrint('Response Body: $responseBody');

      if (response.statusCode == 200) {
        // Split the response body by spaces
        List<String> responseParts = responseBody?.split(' ') ?? [];

        // Detect role (first word)
        role = responseParts.isNotEmpty ? responseParts[0] : null;

        // Store remaining words as first name and last name
        if (responseParts.length > 1) {
          firstName = responseParts[1]; // Second word is first name
        }
        if (responseParts.length > 2) {
          lastName = responseParts[2]; // Third word is last name
        }

        // Debug prints for first name and last name
        debugPrint('First Name: $firstName');
        debugPrint('Last Name: $lastName');

        // Return role based on the first word
        if (role == "employee") {
          return "employee"; // Employee login
        } else if (role == "admin") {
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
