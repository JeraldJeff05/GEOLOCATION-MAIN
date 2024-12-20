import 'package:flutter/material.dart';
import 'location/location_service.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'front_page.dart';
import 'home_screen.dart';
import 'admin_page.dart';
import 'package:animate_do/animate_do.dart';

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
        '/start': (context) => const StartScreen(),
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

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  final LocationService _locationService = LocationService();
  String _message = "";
  bool _showButton = true;
  bool _showLoadingOverlay = false;
  late Timer _typingTimer;
  int _messageIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create scale animation
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    // Create slide animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutQuart,
      ),
    );

    // Start the initial animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _typingTimer.cancel();
    _animationController.dispose();
    super.dispose();
  }

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

  // ... [previous method implementations remain unchanged]

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background with gradient effect
          TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 2),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    colors: [
                      Colors.grey.withOpacity(0.9 * value),
                      Colors.black.withOpacity(0.8 * value),
                    ],
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/startpagebg.png'),
                    fit: BoxFit.cover,
                    opacity: 0.8 * value,
                  ),
                ),
              );
            },
          ),

          // Loading overlay - remains the same as in original code
          if (_showLoadingOverlay)
            AnimatedOpacity(
              opacity: 0.8,
              duration: const Duration(milliseconds: 300),
              child: Container(
                color: Colors.black.withOpacity(0.8),
              ),
            ),

          // Animated loading content
          if (_showLoadingOverlay)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pulsating loading GIF
                  Pulse(
                    child: Image.asset(
                      'assets/rollingball.gif',
                      width: 300,
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Typing text animation
                  FadeIn(
                    child: Text(
                      _message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.blue,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Animated Get Started button
          if (_showButton)
            ScaleTransition(
              scale: _scaleAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: EdgeInsets.only(top: 90, left: 250),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.grey.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          splashColor: Colors.white.withOpacity(0.3),
                          highlightColor: Colors.white.withOpacity(0.2),
                          onTap: _fadeOutAndNavigate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '    Get Started',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 5.0,
                                        color: Colors.black.withOpacity(0.3),
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
