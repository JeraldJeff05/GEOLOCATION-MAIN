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
  bool _isLoading = false;
  String _displayedText = "";
  final String _fullText = "We Listen We Anticipate We Deliver";
  int _charIndex = 0;

  void _startTypingAnimation() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
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
            'assets/Autumn.png',
            fit: BoxFit.cover,
          ),
          // Fade-out overlay
          AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            child: Container(
              color: Colors.black
                  .withOpacity(0.5), // Semi-transparent black overlay
            ),
          ),
          // Centered button or typing animation
          Center(
            child: _isLoading
                ? Text(
                    _displayedText,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : ElevatedButton(
                    onPressed: _fadeOutAndStartTyping,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      backgroundColor: Colors.deepOrangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
