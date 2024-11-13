import 'dart:async'; // Import for delayed execution
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'location_service.dart';
import 'sign_in.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String? _username, _password;
  String? _savedUsername, _savedPassword;

  // Initial and target positions for the login form
  double _leftPosition = -620; // Start off-screen to the left
  final double _targetLeftPosition =
      0; // Will calculate final position dynamically

  @override
  void initState() {
    super.initState();
    // Delay the animation to allow the widget to build
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _leftPosition = _targetLeftPosition;
      });
    });
  }

  Future<void> _getCurrentLocationAndLogin() async {
    if (!await LocationService.checkLocationService(_showLocationErrorDialog)) {
      return;
    }
    Position position = await LocationService.getCurrentPosition();
    if (!LocationService.isLocationInRange(
        position.latitude, position.longitude)) {
      _showLocationErrorDialog(
          "You are not within the allowed location range and cannot access this site.");
    } else {
      _login();
    }
  }

  void _showLocationErrorDialog(String message) {
    _showDialog('Access Denied', message);
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (_username == _savedUsername && _password == _savedPassword) {
        _showWelcomeDialog();
      } else if (_username == 'admin' && _password == 'admin') {
        _showWelcomeDialog();
      } else {
        _showSnackbar('Invalid username or password');
      }
    }
  }

  void _showWelcomeDialog() {
    _showDialog('Welcome', 'Welcome to FDS!');
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double centerLeftPosition =
        MediaQuery.of(context).size.width / 2 - 250;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/CorporateBG1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            top: 100, // Fixed position vertically
            left: _leftPosition == _targetLeftPosition
                ? centerLeftPosition
                : _leftPosition,
            child: _buildLoginForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      width: 500,
      height: 620,
      padding: const EdgeInsets.all(40.0),
      decoration: BoxDecoration(
        color: Color(0xFFE6F3FA).withOpacity(0.8),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 27.5),
                Image.asset(
                  'assets/FINALFDS.png',
                  width: 500,
                  height: 140,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                _buildTextFieldWithValidation(
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  onSaved: (value) => _username = value,
                ),
                const SizedBox(height: 12),
                _buildTextFieldWithValidation(
                  icon: Icons.lock,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value,
                  obscureText: true,
                ),
                const SizedBox(height: 20.5),
                _buildGradientButton('Login', _getCurrentLocationAndLogin),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(thickness: 2, color: Color(0xFF6D4C41)),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      style: TextStyle(
                        fontFamily: 'CustomFont',
                        fontSize: 12,
                      ),
                      "Sign up ",
                    ),
                    GestureDetector(
                      onTap: _signIn,
                      child: Text(
                        "Here",
                        style: TextStyle(
                          color: Color(0xFF630606),
                          fontFamily: 'CustomFont',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Divider(thickness: 2, color: Color(0xFF6D4C41)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Today is your opportunity to build the tomorrow you want",
                  style: TextStyle(
                    color: Color(0xFF630606),
                    fontSize: 20,
                    fontFamily: 'CustomFont',
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Divider(thickness: 2, color: Color(0xFF6D4C41)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.language, color: Color(0xFF000000), size: 20),
                    const SizedBox(width: 5),
                    Text(
                      'https://fdsap-ph.fortress-asya.com',
                      style: TextStyle(
                        color: Color(0xFF6D4C41),
                        fontSize: 14,
                        fontFamily: 'CustomFont',
                      ),
                    ),
                    const SizedBox(width: 20),
                    Icon(Icons.phone, color: Color(0xFF000000), size: 20),
                    const SizedBox(width: 5),
                    Text(
                      '+63 947 362 3226',
                      style: TextStyle(
                        color: Color(0xFF6D4C41),
                        fontSize: 14,
                        fontFamily: 'CustomFont',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _signIn() {
    showSignInDialog(
      context: context,
      onSignIn: (username, password) {
        setState(() {
          _savedUsername = username;
          _savedPassword = password;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "Sign-up successful! Use the new credentials to log in.")),
        );
      },
    );
  }

  Widget _buildGradientButton(String text, VoidCallback onPressed) {
    return Center(
      child: SizedBox(
        height: 30,
        width: 130, // Slightly wider for better appearance
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 3,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent
                ], // New gradient
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 0,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: 'CustomFont',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithValidation({
    required IconData icon,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
    bool obscureText = false,
  }) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        // Add the icon here
        border: InputBorder.none,
        filled: true,
        // Fill the background color
        fillColor: Color(0xFF111111).withOpacity(0.4),
        // Background color for the text field

        contentPadding: const EdgeInsets.symmetric(
            vertical: 15.0, horizontal: 7.0), // Padding inside the text field
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
