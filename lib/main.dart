import 'package:flutter/material.dart';
import 'location_service.dart';
import 'api_service.dart';
import 'dart:async';
import 'front_page.dart';
import 'home_screen.dart';
import 'admin_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GEOLOCATION',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/start',
      routes: {
        '/start': (context) => const StartScreen(),
        '/': (context) => MyHomePage(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  double _opacity = 0.0;
  final LocationService _locationService = LocationService();
  final ApiService _apiService = ApiService();
  String _message = ""; // Initial message
  bool _isLoading = false; // To control loading animation visibility
  bool _showButton = true; // Tracks visibility of the button

  void _fadeOutAndNavigate() async {
    setState(() {
      _showButton = false; // Hide the button when clicked
      _opacity = 1.0; // Start darkening animation
      _message = "Getting current location"; // First message
      _isLoading = true; // Show loading animation
    });

    // Wait for 1.5 seconds to display "Getting current location"
    await Future.delayed(const Duration(seconds: 1));

    // Fetch user's location
    await _locationService.getCurrentLocation();

    // If location is available, send it to the API
    if (_locationService.lat != null && _locationService.lng != null) {
      String response = await _apiService.sendCoordinates(
        _locationService.lat!.toString(),
        _locationService.lng!.toString(),
      );

      if (response == "Location is allowed") {
        setState(() {
          _message =
              "Location is within the premises, redirecting..."; // Update message
        });

        // Wait for 2 seconds before navigating to the next page
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushNamed(context, '/');
      } else if (response == "Location not allowed") {
        setState(() {
          _message = "Outside Specified Area";
        });
      } else {
        setState(() {
          _message = "Cannot connect to API. Please refresh the site.";
        });
      }
    } else {
      setState(() {
        _message = "Unable to fetch location.";
      });
    }

    // Reset opacity and loading state after the check
    setState(() {
      _opacity = 0.0; // Reset darkening animation
      _isLoading = false; // Hide loading animation
      _showButton = true; // Show the button again if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/reversebg.png',
            fit: BoxFit.cover,
          ),
          // Fade-out overlay
          AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: Container(
              color: Colors.black
                  .withOpacity(0.85), // Semi-transparent black overlay
            ),
          ),
          // Centered message showing the API response
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _message,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (_isLoading) // Show GIF when loading
                  const SizedBox(height: 20),
                if (_isLoading)
                  Image.asset(
                    'assets/loadingwhite.gif', // Path to your GIF
                    width: 50, // Adjust the size as needed
                    height: 50,
                  ),
              ],
            ),
          ),
          // Positioned "Get Started" button
          if (_showButton) // Show the button only if _showButton is true
            if (_showButton) // Show the button only if _showButton is true
              Align(
                alignment:
                    const Alignment(-0.65, -0.1), // Adjust alignment as needed
                child: GestureDetector(
                  onTap:
                      _fadeOutAndNavigate, // Trigger the function when the GIF is tapped
                  child: Image.asset(
                    'assets/startbutton.gif', // Path to the GIF file
                    width: 200, // Adjust the size of the GIF
                    height: 150, // Adjust height as needed
                    fit: BoxFit
                        .contain, // Ensure the GIF fits well within the bounds
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
