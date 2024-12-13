import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const EmployeeApp());

class EmployeeApp extends StatelessWidget {
  const EmployeeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Insights',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black54,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const EmployeesLogWidget(),
    );
  }
}

class EmployeesLogWidget extends StatefulWidget {
  const EmployeesLogWidget({Key? key}) : super(key: key);

  @override
  _EmployeesLogWidgetState createState() => _EmployeesLogWidgetState();
}

class _EmployeesLogWidgetState extends State<EmployeesLogWidget> {
  List<Map<String, String>> employees = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchEmployeeData();
  }

  Future<void> _fetchEmployeeData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

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
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load employee data';
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employees Logs',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchEmployeeData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Database',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_errorMessage.isNotEmpty)
                  Center(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                          ),
                          columns: const [
                            DataColumn(
                                label: Text(
                                    'ID                                         ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text(
                                    'First Name                                   ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text(
                                    'Last Name                           ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Role',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: employees
                              .map((employee) => DataRow(
                                    cells: [
                                      DataCell(Text(employee['ID']!)),
                                      DataCell(Text(employee['FirstName']!)),
                                      DataCell(Text(employee['LastName']!)),
                                      DataCell(Text(employee['Role']!)),
                                    ],
                                  ))
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
