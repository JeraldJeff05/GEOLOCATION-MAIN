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
        '/home': (context) => HomeScreen(),
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
  String _message = "";
  bool _showButton = true;
  bool _showLoadingOverlay = false; // New flag for overlay visibility
  late Timer _typingTimer;
  int _messageIndex = 0;

  // Method to start typing animation
  void _startTypingAnimation(String message, VoidCallback onComplete) {
    _messageIndex = 0;

    setState(() {
      _message = ""; // Reset message
    });

    _typingTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_messageIndex < message.length) {
        setState(() {
          _message += message[_messageIndex];
        });
        _messageIndex++;
      } else {
        timer.cancel();
        onComplete();
      }
    });
  }

  void _fadeOutAndNavigate() async {
    setState(() {
      _showButton = false; // Hide button
      _showLoadingOverlay = true; // Show overlay
    });

    // Start typing animation for "Getting Current location..."
    _startTypingAnimation("Getting Current location...", () async {
      await _locationService.getCurrentLocation();

      if (_locationService.lat != null && _locationService.lng != null) {
        _startTypingAnimation("Location fetched successfully!", () async {
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushNamed(context, '/');
        });
      } else {
        setState(() {
          _message = "Unable to fetch location.";
        });
        _showLocationErrorDialog();
      }
    });
  }

  void _showLocationErrorDialog() {
    setState(() {
      _showLoadingOverlay = false; // Hide overlay
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.warning, color: Colors.yellow),
              SizedBox(width: 10),
              Text('Location Denied'),
            ],
          ),
          content: const Text('Please agree to the use of location services.'),
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
    _typingTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/startpagebg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Dark overlay
          if (_showLoadingOverlay)
            AnimatedOpacity(
              opacity: 0.8,
              duration: const Duration(milliseconds: 300),
              child: Container(
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          // Loading GIF and message
          if (_showLoadingOverlay)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/rollingball.gif',
                    width: 300,
                    height: 200,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          // Get Started button
          if (_showButton)
            Padding(
              padding: EdgeInsets.only(
                  top: 90, left: 250), // Adjust the padding values as needed
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: _fadeOutAndNavigate,
                  child: Image.asset(
                    'assets/cleansilvbut.png',
                    width: 170,
                    height: 130,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
