import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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

class GeofencingScreen extends StatefulWidget {
  @override
  _GeofencingScreenState createState() => _GeofencingScreenState();
}

class _GeofencingScreenState extends State<GeofencingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this); // Ensure length is 6
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
        title: const Text('Geofencing Overview',style: TextStyle(color: Colors.white, fontSize: 20)),
        centerTitle: true,
        backgroundColor: Color(0xff28658a), // Custom app bar color
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xff63baed), // Color of the tab indicator
          labelColor: Colors.white, // Color of the selected tab label
          unselectedLabelColor: Color(0xff90e0ef), // Color of the unselected tab label
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'How It Works'),
            Tab(text: 'Applications'),
            Tab(text: 'Benefits'),
            Tab(text: 'Challenges'),
            Tab(text: 'Future'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildHowItWorksTab(),
          _buildApplicationsTab(),
          _buildBenefitsTab(),
          _buildChallengesTab(),
          _buildFutureTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What is Geofencing?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Geofencing is a location-based service that creates a virtual boundary or "fence" around a specific geographic area. '
                'When a device enters or exits this predefined area, a notification or action is triggered. It is widely used in marketing, '
                'security, transportation, and other industries.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: VideoPlayerWidget(videoUrl: 'assets/Geofenz.mp4'), // Replace with your video URL
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How Geofencing Works',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '1. Define the Boundary:\n'
                '- The geofence is established using latitude, longitude, and radius parameters.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '2. Monitor Location:\n'
                '- Devices track their location using GPS, cellular networks, or Wi-Fi.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '3. Trigger Actions:\n'
                '- When a device enters or exits the geofence, actions such as notifications, app features, or data logging are triggered.\n',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Applications of Geofencing',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '1. Marketing and Retail:\n'
                '- Sends promotions or advertisements when customers enter a store or shopping area.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '2. Transportation:\n'
                '- Geofencing is used in fleet management to monitor vehicle movements and optimize routes.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '3. Security:\n'
                '- Used for securing restricted areas. Alerts are triggered when unauthorized access is detected.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '4. Smart Devices:\n'
                '- Automates home devices like lights or thermostats based on user proximity.\n',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Benefits of Geofencing',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '- Personalization: Offers tailored experiences based on location.\n'
                '- Efficiency: Streamlines operations like logistics and delivery tracking.\n'
                '- Security: Enhances safety by monitoring restricted areas.\n'
                '- Convenience: Automates tasks based on user location.\n',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Challenges of Geofencing',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '1. Privacy Concerns:\n'
                '- Continuous location monitoring can raise data privacy issues.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '2. Battery Usage:\n'
                '- Frequent location updates may drain device batteries.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '3. Accuracy:\n'
                '- Geofencing may struggle in densely populated or GPS-restricted areas.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '4. Setup Complexity:\n'
                '- Requires precise boundary definitions and integration with existing systems.\n',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildFutureTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Future of Geofencing',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '- Advanced AI: Enhances geofencing capabilities with predictive behaviors.\n'
                '- Indoor Geofencing: Improved indoor tracking through Wi-Fi and BLE technologies.\n'
                '- 5G Networks: Faster and more accurate geofencing with minimal latency.\n',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({required this.videoUrl, Key? key}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Update the widget once the video is initialized
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? VideoPlayer(_controller)
        : const Center(child: CircularProgressIndicator());
  }
}
