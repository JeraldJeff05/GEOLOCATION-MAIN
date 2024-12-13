import 'package:flutter/material.dart';

class NamesList extends StatefulWidget {
  const NamesList({super.key});

  @override
  _NamesListState createState() => _NamesListState();
}

class _NamesListState extends State<NamesList> {
  final List<Map<String, String>> creators = [
    {
      'name': 'Jerald Jeff Madera',
      'role': 'Team Leader',
      'Contributions':
          'Jeff is a passionate developer with over 5 years of experience in mobile app development.',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'name': 'Brandon Kyle Monteagudo',
      'role': 'Frontend Developer',
      'info': 'Brandon specializes in website functions',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'name': 'Adrielle Young',
      'role': 'Backend Developer/Database Administrator',
      'info':
          'Peter has a knack for managing projects and ensuring timely delivery of products.',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'name': 'Vincent Canilao',
      'role': 'Quality Assurance',
      'info':
          'Vincent is dedicated to ensuring the quality of the product through rigorous testing.',
      'image': 'https://via.placeholder.com/150'
    },
    // Add more creators as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meet the Creators'),
      ),
      body: ListView.builder(
        itemCount: creators.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  ClipOval(
                    child: Image.network(
                      creators[index]['image']!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    creators[index]['name']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    creators[index]['role']!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    creators[index]['info']!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign
                        .center, // Center the text for better appearance
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
