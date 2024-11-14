import 'package:flutter/material.dart';
import 'dart:async';
import 'front_page.dart';
import 'home_screen.dart';

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
        //'/start': (context) => const StartScreen(),
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
  bool _isLoading = false;
  String _displayedText = "";
  final String _fullText = "WE LISTEN WE ANTICIPATE WE DELIVER";
  int _charIndex = 0;

  // Variables for font customization
  final String _fontFamily = 'Arial'; // Change to your preferred font
  final double _fontSize = 30.0; // Adjust the font size as needed

  void _startTypingAnimation() {
    Timer.periodic(const Duration(milliseconds: 95), (timer) {
      if (_charIndex < _fullText.length) {
        setState(() {
          _displayedText += _fullText[_charIndex];
          _charIndex++;
        });
      } else {
        timer.cancel();
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushNamed(context, '/'); // Navigate to the next screen
        });
      }
    });
  }

  void _fadeOutAndStartTyping() {
    setState(() {
      _opacity = 1.0; // Start darkening animation
      _isLoading = true; // Trigger the typing animation
    });

    _startTypingAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/startupbg2.png',
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
          // Center the animated text
          Center(
            child: _isLoading
                ? Text(
                    _displayedText,
                    style: TextStyle(
                      fontSize: _fontSize,
                      fontFamily: _fontFamily,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : const SizedBox.shrink(), // Empty widget when not loading
          ),
          // Positioned "Get Started" button
          Align(
            alignment:
                const Alignment(0.59, -0.12), // Adjust vertical alignment
            child: _isLoading
                ? null
                : ElevatedButton(
                    onPressed: _fadeOutAndStartTyping,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      backgroundColor: Colors.white, // White inside
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Curved sides
                        side: const BorderSide(
                          color: Color(0xFF630606), // Maroon border
                          width: 2,
                        ),
                      ),
                      elevation: 2, // Slight elevation for modern look
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF630606), // Maroon text
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                            width: 10), // Space between text and circle
                        Container(
                          width: 20,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFF630606), // Maroon circle color
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              '>',
                              style: TextStyle(
                                color: Colors.white, // White arrow color
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
