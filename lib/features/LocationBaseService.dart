import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LocationBasedServicesScreen(),
  ));
}

class LocationBasedServicesScreen extends StatefulWidget {
  @override
  _LocationBasedServicesScreenState createState() =>
      _LocationBasedServicesScreenState();
}

class _LocationBasedServicesScreenState
    extends State<LocationBasedServicesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location-Based Services Overview'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen.
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Key Components'),
            Tab(text: 'Applications'),
            Tab(text: 'Benefits'),
            Tab(text: 'Challenges'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildKeyComponentsTab(),
          _buildApplicationsTab(),
          _buildBenefitsTab(),
          _buildChallengesTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What are Location-Based Services (LBS)?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Location-Based Services (LBS) are applications that utilize the geographical location of a device to provide relevant information, services, or entertainment to the user. '
                'These services leverage various technologies, including GPS, Wi-Fi, cellular networks, and Bluetooth, to determine the user\'s location in real-time.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyComponentsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key Components of LBS',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '1. Location Determination:\n'
                '- GPS (Global Positioning System): The most common method for determining location, GPS uses a network of satellites to provide accurate location data.\n'
                '- Cellular Triangulation: This method estimates a device\'s location based on its proximity to cell towers. While less accurate than GPS, it can be useful in urban areas where GPS signals may be obstructed.\n'
                '- Wi-Fi Positioning: Utilizes the signal strength from nearby Wi-Fi networks to determine location, particularly effective indoors.\n'
                '- Bluetooth Beacons: Small devices that transmit signals to nearby smartphones, allowing for proximity-based services.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '2. Data Processing:\n'
                '- Once the location is determined, the data is processed to provide relevant services or information. This may involve querying databases, analyzing user preferences, or integrating with other services.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '3. User Interface:\n'
                '- The final component is the user interface, which presents the information or services to the user in a user-friendly manner, often through mobile applications.\n',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Applications of Location-Based Services',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '1. Navigation and Mapping:\n'
                '- LBS are widely used in navigation applications (e.g., Google Maps, Waze) to provide real-time directions, traffic updates, and estimated arrival times.\n'
                '2. Geofencing:\n'
                '- Businesses can create virtual boundaries (geofences) to trigger notifications or actions when users enter or exit a specified area. This is commonly used in marketing to send promotions to customers when they are near a store.\n',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Benefits of Location-Based Services',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '1. Personalization:\n'
                '- LBS can provide tailored experiences based on a user\'s location, preferences, and behavior.\n'
                '2. Convenience:\n'
                '- Users can access relevant information and services without needing to search manually, enhancing their overall experience.\n',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Challenges and Considerations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '1. Privacy Concerns:\n'
                '- The collection and use of location data raise significant privacy issues. Users may be uncomfortable with their location being tracked, leading to potential misuse of data.\n',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
