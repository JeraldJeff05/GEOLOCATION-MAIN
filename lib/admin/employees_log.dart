import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Table',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: EmployeesLogWidget(),
    );
  }
}

class EmployeesLogWidget extends StatefulWidget {
  @override
  _EmployeesLogWidgetState createState() => _EmployeesLogWidgetState();
}

class _EmployeesLogWidgetState extends State<EmployeesLogWidget> {
  List<Map<String, String>> employees = [];

  @override
  void initState() {
    super.initState();
    fetchEmployeeData();
  }

  // Function to fetch employee data from the API
  Future fetchEmployeeData() async {
    final url =
        'https://1lp44l1f-8080.asse.devtunnels.ms/employee/info?keyword=strawberry+shortcake';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<String> lines = response.body.split('\n');

        List<Map<String, String>> parsedEmployees = lines
            .map((line) {
              try {
                return jsonDecode(line);
              } catch (e) {
                print('Error decoding line: $line');
                return null;
              }
            })
            .whereType<Map<String, dynamic>>()
            .map((item) => {
                  'ID': item['ID'].toString(),
                  'FirstName': item['FirstName'].toString(),
                  'LastName': item['LastName'].toString(),
                  'Role': item['Role'].toString(),
                })
            .toList();

        setState(() {
          employees = parsedEmployees;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Table'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchEmployeeData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width *
                0.9, // 90% of the screen width
            height: MediaQuery.of(context).size.height *
                0.5, // 50% of the screen height
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Employee Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                Expanded(
                  child: employees.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 12,
                              columns: [
                                DataColumn(label: Text('ID                  ')),
                                DataColumn(
                                    label: Text(
                                        'First Name                                    ')),
                                DataColumn(
                                    label: Text(
                                        'Last Name                                    ')),
                                DataColumn(
                                    label: Text(
                                        'Role                                    ')),
                              ],
                              rows: employees
                                  .map((employee) => DataRow(cells: [
                                        DataCell(Text(employee['ID']!)),
                                        DataCell(Text(employee['FirstName']!)),
                                        DataCell(Text(employee['LastName']!)),
                                        DataCell(Text(employee['Role']!)),
                                      ]))
                                  .toList(),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
