import 'package:check_loc/features/Geofencing.dart';
import 'package:check_loc/features/LocationBaseService.dart';
import 'package:flutter/material.dart';
import 'package:check_loc/features/RealTimeLocationTracking.dart';

void main() {
  runApp(MaterialApp(
    home: OtherFeatures(),
  ));
}

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
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 800, // Minimum width
              maxWidth: 1200, // Maximum width
              minHeight: 600, // Minimum height
              maxHeight: 800, // Maximum height
            ),
            child: FittedBox(
              child: Align(
                alignment:
                    Alignment.center, // Center both horizontally and vertically
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
                      isHoveringLearnMore: isHoveringLearnMoreFirst,
                      onHoverLearnMore: (hovering) {
                        setState(() {
                          isHoveringLearnMoreFirst = hovering;
                        });
                      },
                      onLearnMoreTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RealTimeLocationInfoScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 50),
                    _buildFeatureContainer(
                      image: 'geo2.png',
                      title: 'Geofencing',
                      isHovering: isHoveringSecond,
                      onHover: (hovering) {
                        setState(() {
                          isHoveringSecond = hovering;
                        });
                      },
                      isHoveringLearnMore: isHoveringLearnMoreSecond,
                      onHoverLearnMore: (hovering) {
                        setState(() {
                          isHoveringLearnMoreSecond = hovering;
                        });
                      },
                      onLearnMoreTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GeofencingScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 50),
                    _buildFeatureContainer(
                      image: 'geo3.png',
                      title: 'Location-Based Service',
                      isHovering: isHoveringThird,
                      onHover: (hovering) {
                        setState(() {
                          isHoveringThird = hovering;
                        });
                      },
                      isHoveringLearnMore: isHoveringLearnMoreThird,
                      onHoverLearnMore: (hovering) {
                        setState(() {
                          isHoveringLearnMoreThird = hovering;
                        });
                      },
                      onLearnMoreTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationBasedServicesScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
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
    required bool isHoveringLearnMore,
    required void Function(bool) onHoverLearnMore,
    required VoidCallback onLearnMoreTap,
  }) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
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
                const SizedBox(height: 8),
                Text(
                  _getDescription(title),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 19,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            MouseRegion(
              onEnter: (_) => onHoverLearnMore(true),
              onExit: (_) => onHoverLearnMore(false),
              child: GestureDetector(
                onTap: onLearnMoreTap,
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
            ),
          ],
        ),
      ),
    );
  }

  String _getDescription(String title) {
    switch (title) {
      case 'Real-Time Location Tracking':
        return 'Real-time location tracking continuously updates a user’s live location on a map.';
      case 'Geofencing':
        return 'Geofencing creates virtual boundaries to trigger actions when entering or exiting them.';
      case 'Location-Based Service':
        return 'Location-based services deliver features tailored to a user\'s geographical location.';
      default:
        return '';
    }
  }
}
