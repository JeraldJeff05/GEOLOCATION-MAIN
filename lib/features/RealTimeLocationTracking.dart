import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RealTimeLocationInfoScreen(),
  ));
}

class RealTimeLocationInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RealTimeLocationTrackingScreen();
  }
}

class RealTimeLocationTrackingScreen extends StatefulWidget {
  @override
  _RealTimeLocationTrackingScreenState createState() =>
      _RealTimeLocationTrackingScreenState();
}

class _RealTimeLocationTrackingScreenState
    extends State<RealTimeLocationTrackingScreen> with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _videoController = VideoPlayerController.asset(
      'assets/RTLTvid.mp4', // Replace with your video path
    )
      ..initialize().then((_) {
        setState(() {}); // Update UI once the video is initialized
      });

    // Auto-play video when switching tabs
    _tabController.addListener(() {
      // Check if the "Overview" tab (index 0) is selected
      if (_tabController.index == 0 && !_videoController.value.isPlaying) {
        if (_videoController.value.isInitialized) {
          _videoController.play();
        }
      } else if (_tabController.index != 0 && _videoController.value.isPlaying) {
        // Pause video when leaving the "Overview" tab
        _videoController.pause();
      }
    });

    // Start playing video if the Overview tab is initially selected
    if (_tabController.index == 0 && !_videoController.value.isPlaying) {
      _videoController.play();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Location Tracking Overview',style: TextStyle(color: Colors.white, fontSize: 20)),
        centerTitle: true,
        backgroundColor: Color(0xff28658a),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Properly navigate to the previous page
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xff63baed), // Color of the tab indicator
          labelColor: Colors.white, // Color of the selected tab label
          unselectedLabelColor: Color(0xff90e0ef),
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'How It Works'),
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
          _buildHowItWorksTab(),
          _buildApplicationsTab(),
          _buildBenefitsTab(),
          _buildChallengesTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What is Real-Time Location Tracking?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Real-time location tracking refers to the ability to monitor and track the geographical position of an object or individual in real-time using various technologies. '
                  'This capability has become increasingly prevalent due to advancements in GPS (Global Positioning System), mobile devices, and internet connectivity. '
                  'Real-time location tracking is utilized across various sectors, including transportation, logistics, healthcare, and personal safety.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _videoController.value.isInitialized
                ? AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: VideoPlayer(_videoController),
            )
                : const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorksTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key Technologies Behind Real-Time Location Tracking',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '1. Global Positioning System (GPS):\n'
                '- GPS is a satellite-based navigation system that provides accurate location information anywhere on Earth. GPS receivers in smartphones and other devices can determine their location by triangulating signals from multiple satellites.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '2. Cellular Networks:\n'
                '- Mobile phones can be tracked using cellular network data. By determining which cell towers a device is connected to, service providers can estimate its location. This method is less accurate than GPS but can be useful in urban areas where GPS signals may be obstructed.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '3. Wi-Fi Positioning:\n'
                '- Wi-Fi positioning uses the signal strength from nearby Wi-Fi networks to determine a device\'s location. This method is particularly effective in indoor environments where GPS signals may be weak or unavailable.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '4. Bluetooth Beacons:\n'
                '- Bluetooth beacons are small devices that transmit signals to nearby smartphones. When a device comes within range, it can determine its location based on the strength of the signal from the beacon. This technology is often used in retail environments for proximity marketing.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '5. RFID (Radio-Frequency Identification):\n'
                '- RFID technology uses electromagnetic fields to automatically identify and track tags attached to objects. This method is commonly used in inventory management and supply chain logistics.\n',
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
            'Applications of Real-Time Location Tracking',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '1. Transportation and Logistics:\n'
                '- Real-time tracking of vehicles helps companies optimize routes, reduce fuel consumption, and improve delivery times. Fleet management systems use GPS to monitor vehicle locations and provide updates to customers.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '2. Public Safety and Emergency Services:\n'
                '- Emergency responders can use real-time location tracking to quickly locate individuals in distress. This technology is also used in personal safety applications, allowing users to share their location with trusted contacts.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '3. Healthcare:\n'
                '- In healthcare settings, real-time location tracking can be used to monitor the location of patients, staff, and medical equipment. This can improve patient care and operational efficiency in hospitals.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '4. Retail and Marketing:\n'
                '- Retailers can use location tracking to analyze customer behavior, optimize store layouts, and send targeted promotions to customers based on their location within the store.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '5. Smart Cities:\n'
                '- Real-time location tracking is integral to the development of smart cities, where data from various sources is used to improve urban planning, traffic management, and public transportation systems.\n',
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
            'Benefits of Real-Time Location Tracking',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '- Increased Efficiency: Businesses can optimize operations by tracking assets, employees, and deliveries in real-time.\n'
                '- Improved Safety: Location tracking helps in emergency situations and ensures the safety of individuals.\n'
                '- Better Customer Experience: Real-time tracking allows businesses to offer timely services, such as delivery updates and fleet tracking.\n',
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
            'Challenges of Real-Time Location Tracking',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '- Privacy Concerns: Tracking individuals can raise privacy issues, especially when data is used without consent.\n'
                '- Accuracy: The accuracy of location tracking can vary depending on the technology used and environmental factors.\n'
                '- Security Risks: Location data can be vulnerable to hacking or unauthorized access if not properly secured.\n',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
