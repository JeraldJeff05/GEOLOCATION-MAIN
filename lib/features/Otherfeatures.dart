import 'package:check_loc/features/Geofencing.dart';
import 'package:check_loc/features/LocationBaseService.dart';
import 'package:flutter/material.dart';
import 'package:check_loc/features/RealTimeLocationTracking.dart';

class OtherFeatures extends StatefulWidget {
  @override
  _OtherFeaturesState createState() => _OtherFeaturesState();
}

class _OtherFeaturesState extends State<OtherFeatures> {
  // Define hover states for the containers
  bool isHoveringFirst = false;
  bool isHoveringSecond = false;
  bool isHoveringThird = false;

  // Define hover states for "Learn more" buttons
  bool isHoveringLearnMoreFirst = false;
  bool isHoveringLearnMoreSecond = false;
  bool isHoveringLearnMoreThird = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 56, // Height of the AppBar
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF90e0ef), Colors.lightBlue],
                // Your gradient colors
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Text(
                    'Other Geolocation Features',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFeatureContainer(
                    image: 'geo1.png',
                    title: 'Real-Time Location Tracking',
                    isHovering: isHoveringFirst,
                    onHover: (hovering) {
                      setState(() {
                        isHoveringFirst = hovering;
                      });
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RealTimeLocationInfoScreen(),
                        ),
                      );
                    },
                    isHoveringLearnMore: isHoveringLearnMoreFirst,
                    onHoverLearnMore: (hovering) {
                      setState(() {
                        isHoveringLearnMoreFirst = hovering;
                      });
                    },
                  ),
                  SizedBox(width: 50),
                  _buildFeatureContainer(
                    image: 'geo2.png',
                    title: 'Geofencing',
                    isHovering: isHoveringSecond,
                    onHover: (hovering) {
                      setState(() {
                        isHoveringSecond = hovering;
                      });
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GeofencingScreen(),
                        ),
                      );
                    },
                    isHoveringLearnMore: isHoveringLearnMoreSecond,
                    onHoverLearnMore: (hovering) {
                      setState(() {
                        isHoveringLearnMoreSecond = hovering;
                      });
                    },
                  ),
                  SizedBox(width: 50),
                  _buildFeatureContainer(
                    image: 'geo3.png',
                    title: 'Location-Based Service',
                    isHovering: isHoveringThird,
                    onHover: (hovering) {
                      setState(() {
                        isHoveringThird = hovering;
                      });
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationBasedServicesScreen(),
                        ),
                      );
                    },
                    isHoveringLearnMore: isHoveringLearnMoreThird,
                    onHoverLearnMore: (hovering) {
                      setState(() {
                        isHoveringLearnMoreThird = hovering;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureContainer({
    required String image,
    required String title,
    required bool isHovering,
    required void Function(bool) onHover,
    required VoidCallback onTap,
    required bool isHoveringLearnMore,
    required void Function(bool) onHoverLearnMore,
  }) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          width: isHovering ? 400 : 380,
          height: isHovering ? 670 : 650,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isHovering
                  ? [Colors.lightBlueAccent, Color(0xFF90e0ef)]
                  : [Color(0xFF90e0ef), Colors.lightBlue],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                image,
                width: 220,
                height: 220,
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (title == 'Real-Time Location Tracking') ...[
                    const SizedBox(height: 8),
                    Container(
                      width: isHovering ? 200 : 280, // Adjust width here
                    child: Text(
                      'Real-time location tracking continuously updates a user’s live location on a map.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 19,
                      ),
                    ),
                    ),
                  ],
                  if (title == 'Geofencing') ...[
                    const SizedBox(height: 8),
                    Container(
                      width: isHovering ? 200 : 280,
                      child: Text(
                        'Geofencing creates virtual boundaries to trigger actions when entering or exiting them.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ],
                  if (title == 'Location-Based Service') ...[
                    const SizedBox(height: 8),
                    Container(
                      width: isHovering ? 200 : 280,
                      child: Text(
                        'Location-based services deliver features and content tailored to a users geographical location.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20),
              // Learn more button with slide color change effect on hover
              MouseRegion(
                onEnter: (_) => onHoverLearnMore(true),
                onExit: (_) => onHoverLearnMore(false),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  width: 320,
                  height: 65,
                  decoration: BoxDecoration(
                    gradient: isHoveringLearnMore
                        ? LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.blue.shade500,
                        Colors.blue.shade500,
                      ],
                    )
                        : LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF023e8a),
                        Color(0xFF023e8a),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      'Learn more',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void main() {
    runApp(MaterialApp(
      home: OtherFeatures(),
    ));
  }
}
