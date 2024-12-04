import 'package:flutter/material.dart';

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
    extends State<RealTimeLocationTrackingScreen>
    with SingleTickerProviderStateMixin {
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
        title: const Text('Real-Time Location Tracking Overview'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Properly navigate to the previous page
          },
        ),
        bottom: TabBar(
          controller: _tabController,
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
    return Padding(
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
        ],
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
            '- Increased Efficiency: Businesses can optimize operations, reduce costs, and improve service delivery by monitoring assets and personnel in real-time.\n'
                '- Enhanced Safety: Real-time tracking can improve personal safety by allowing individuals to share their location with trusted contacts or emergency services.\n'
                '- Better Decision-Making: Access to real-time data enables organizations to make informed decisions quickly, responding to changing conditions and demands.\n',
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
                '- Real-time location tracking raises significant privacy issues. Users may be uncomfortable with their location being monitored, leading to potential misuse of data.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '2. Data Security:\n'
                '- Protecting the data collected through location tracking is crucial. Organizations must implement robust security measures to prevent unauthorized access and data breaches.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '3. Accuracy and Reliability:\n'
                '- The accuracy of location tracking can vary based on the technology used and environmental factors. For example, GPS signals can be obstructed by buildings or natural features.\n',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            '4. Regulatory Compliance:\n'
                '- Organizations must comply with local and international regulations regarding data protection and privacy, such as the General Data Protection Regulation (GDPR) in Europe.\n',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}