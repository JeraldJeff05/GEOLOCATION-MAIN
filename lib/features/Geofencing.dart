import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(GeofencingApp());
}

class GeofencingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GeofencingScreen(),
    );
  }
}

class GeofencingScreen extends StatelessWidget {
  final List<Map<String, String>> sections = [
    {
      'title': 'What is Geofencing?',
      'content': 'Geofencing is a location-based service that creates a virtual boundary...'
    },
    {
      'title': 'How Geofencing Works',
      'content': '1. Define the Boundary: The geofence is established using latitude...'
    },
    {
      'title': 'Applications of Geofencing',
      'content': '1. Marketing and Retail: Sends promotions or advertisements...'
    },
    {
      'title': 'Benefits of Geofencing',
      'content': '1. Personalization: Offers tailored experiences based on location...'
    },
    {
      'title': 'Challenges of Geofencing',
      'content': '1. Privacy Concerns: Continuous location monitoring can raise...'
    },
    {
      'title': 'Future of Geofencing',
      'content': 'Advanced AI: Enhances geofencing capabilities with predictive...'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geofencing Overview'),
        centerTitle: true,
      ),
      body: CarouselSlider.builder(
        itemCount: sections.length,
        itemBuilder: (context, index, realIndex) {
          return _buildCarouselItem(sections[index]['title']!, sections[index]['content']!);
        },
        options: CarouselOptions(
          height: 400,
          autoPlay: true,
          enlargeCenterPage: true,
        ),
      ),
    );
  }

  Widget _buildCarouselItem(String title, String content) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(content, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}