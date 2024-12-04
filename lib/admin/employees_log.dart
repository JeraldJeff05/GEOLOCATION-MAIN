import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeesLogWidget extends StatefulWidget {
  @override
  _EmployeesLogWidgetState createState() => _EmployeesLogWidgetState();
}

class _EmployeesLogWidgetState extends State<EmployeesLogWidget> {
  List<Map<String, dynamic>> _employees = [];
  bool _isAscending = true; // Track sorting order
  String _sortColumn = 'first_name'; // Default sorting column

  Future<void> _sendGetRequest() async {
    final url = Uri.parse(
        'http://192.168.120.19:8080/employee/info?keyword=strawberry+shortcake'); // API URL

    print('Sending GET request to $url');

    final client = http.Client();
    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        // Parse response body if successful
        final data = response.body.split('\n');
        setState(() {
          _employees = data
              .where((line) => line.trim().isNotEmpty) // Filter out empty lines
              .map((line) => json.decode(line) as Map<String,
                  dynamic>) // Explicitly cast to Map<String, dynamic>
              .toList();

          // Sort employees initially by first name alphabetically
          _sortEmployees();
        });
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

  void _sortEmployees() {
    setState(() {
      _employees.sort((a, b) {
        int result;

        switch (_sortColumn) {
          case 'id':
            result = a['id'].compareTo(b['id']);
            break;
          case 'first_name':
            result = a['first_name']
                .toLowerCase()
                .compareTo(b['first_name'].toLowerCase());
            break;
          case 'last_name':
            result = a['last_name']
                .toLowerCase()
                .compareTo(b['last_name'].toLowerCase());
            break;
          case 'role':
            result = a['role'].toLowerCase().compareTo(b['role'].toLowerCase());
            break;
          default:
            result = 0;
        }

        return _isAscending
            ? result
            : -result; // Reverse the order if descending
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _sendGetRequest(); // Automatically fetch data when widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Allow scrolling if content overflows
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              if (_employees.isNotEmpty)
                Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical, // Vertical scrolling
                      child: SingleChildScrollView(
                        scrollDirection:
                            Axis.horizontal, // Horizontal scrolling
                        child: DataTable(
                          columnSpacing: 20,
                          columns: [
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.important_devices, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                      'ID                                      '),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                setState(() {
                                  _sortColumn = 'id';
                                  _isAscending = ascending;
                                  _sortEmployees();
                                });
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.person, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                      'First Name                                           '),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                setState(() {
                                  _sortColumn = 'first_name';
                                  _isAscending = ascending;
                                  _sortEmployees();
                                });
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.person, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                      'Last Name                                           '),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                setState(() {
                                  _sortColumn = 'last_name';
                                  _isAscending = ascending;
                                  _sortEmployees();
                                });
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.work, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                      'Role                                      '),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                setState(() {
                                  _sortColumn = 'role';
                                  _isAscending = ascending;
                                  _sortEmployees();
                                });
                              },
                            ),
                          ],
                          rows: _employees
                              .map((employee) => DataRow(cells: [
                                    DataCell(Text(employee['id'].toString())),
                                    DataCell(Text(employee['first_name'])),
                                    DataCell(Text(employee['last_name'])),
                                    DataCell(Text(employee['role'])),
                                  ]))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              if (_employees.isEmpty)
                Center(
                  child: Text(
                    'No data available, please wait...',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
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
