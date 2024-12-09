import 'package:flutter/material.dart';
import 'location/location_service.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'front_page.dart';
import 'home_screen.dart';
import 'admin_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set the app to full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

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
        //'/start': (context) => const StartScreen(),
        '/': (context) => const MyHomePage(),
        '/home': (context) => const HomeScreen(),
        '/admin': (context) => const AdminPage(),
      },
    );
  }
}

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  double _opacity = 0.0;
  final LocationService _locationService = LocationService();

  String _message = ""; // Initial message
  // To control loading animation visibility
  bool _showButton = true; // Tracks visibility of the button
  bool _showGif = false; // Controls visibility of the rolling ball GIF
  bool _showMessage = false; // Controls visibility of the message text
  late Timer _typingTimer; // Timer for typing animation
  int _messageIndex = 0; // Index to track the typing animation
  // Current message being typed

  // Method to start typing animation and loop it
  void _startTypingAnimation(String message, VoidCallback onComplete) {
    _messageIndex = 0;

    setState(() {
      _message = ""; // Reset message
    });

    _typingTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_messageIndex < message.length) {
        setState(() {
          _message += message[_messageIndex]; // Append each character
        });
        _messageIndex++;
      } else {
        // Stop the typing animation and trigger the next step
        _typingTimer.cancel();
        onComplete(); // Call the callback when typing is complete
      }
    });
  }

  void _fadeOutAndNavigate() async {
    setState(() {
      _showButton = false; // Hide the button when clicked
      _opacity = 0.8; // Start darkening animation
      _showGif = true; // Show the rolling ball GIF
      _showMessage = true; // Show message in place of the button
    });

    // Wait for 1.5 seconds before showing the GIF
    await Future.delayed(const Duration(seconds: 1));

    // Start the typing animation for "Getting Current location..."
    _startTypingAnimation("Getting Current location...", () async {
      // Fetch user's location
      await _locationService.getCurrentLocation();

      // Check if the location is available
      if (_locationService.lat != null && _locationService.lng != null) {
        _startTypingAnimation("Location fetched successfully!", () async {
          // Wait for 2 seconds before navigating to the next page
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushNamed(context, '/');
        });
      } else {
        setState(() {
          _message = "Unable to fetch location.";
        });

        // Show a dialog with a warning icon when the location can't be fetched
        _showLocationErrorDialog();
      }
    });
  }

  void _showLocationErrorDialog() {
    // Hide the button and message upon location error
    setState(() {
      _showButton = false;
      _showMessage = false;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(
                Icons.warning,
                color: Colors.yellow,
              ),
              SizedBox(
                width: 50,
                height: 200,
              ),
              Text('Location Denied'),
            ],
          ),
          content:
              const Text('Please agree towards the user of location services'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Dispose the typing timer when the screen is disposed
    _typingTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/startpagebg.png',
            fit: BoxFit.cover,
          ),
          // Fade-out overlay
          AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: Container(
              color: Colors.black.withOpacity(0.85),
            ),
          ),
          // Centered message showing the API response
          if (_showMessage)
            Positioned(
              top: 425, // Aligns the message where the button was
              left: 83,
              child: Text(
                _message,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          // Positioned "Get Started" button
          if (_showButton)
            Align(
              alignment: const Alignment(-0.6, 0.13),
              child: GestureDetector(
                onTap: _fadeOutAndNavigate,
                child: Image.asset(
                  'assets/cleansilvbut.png',
                  width: 170,
                  height: 130,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          // GIF on the right side of the screen (shows when clicked)
          if (_showGif)
            Align(
              alignment: const Alignment(0.83, -0.3),
              // Aligns to the right center
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0), // Add some padding
                child: Image.asset(
                  'assets/rollingball.gif', // Path to your GIF
                  width: 630, // Adjust the width as needed
                  height: 650, // Adjust the height as needed
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
