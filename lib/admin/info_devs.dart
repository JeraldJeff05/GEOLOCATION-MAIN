import 'package:flutter/material.dart';

class NamesList extends StatefulWidget {
  const NamesList({super.key});

  @override
  _NamesListState createState() => _NamesListState();
}

class _NamesListState extends State<NamesList> {
  final List<String> names = [
    'John Doe',
    'Jane Smith',
    'Peter Jones',
    'Mary Brown',
    // Add more names as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Names'),
      ),
      body: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(names[index]),
          );
        },
      ),
    );
  }
}
