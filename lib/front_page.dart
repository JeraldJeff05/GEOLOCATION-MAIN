import 'dart:async'; // Import for delayed execution
import 'package:flutter/material.dart';
import 'api_login.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String? _username, _password;

  // Initial and target positions for the login form
  double _topPosition = -500; // Start off-screen above
  final double _targetTopPosition = 275; // Desired final position

  bool _showOverlay = false; // State to control overlay visibility

  @override
  void initState() {
    super.initState();
    // Delay the animation to allow the widget to build
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _topPosition = _targetTopPosition;
      });
    });
  }

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      setState(() {
        _showOverlay = true; // Show overlay when login is clicked
      });

      final apiLogin = ApiLogin();
      final isLoggedIn = await apiLogin.login(
        id: _username!,
        password: _password!,
      );

      setState(() {
        _showOverlay = false; // Hide overlay after API call
      });

      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showDialog('Error', 'Wrong credentials. Please try again.');
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

  @override
  Widget build(BuildContext context) {
    final double centerLeftPosition =
        MediaQuery.of(context).size.width / 2 - -140;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/FinalBG.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            top: _topPosition, // Animated vertical position
            left: centerLeftPosition, // Centered horizontally
            child: _buildLoginForm(),
          ),
          if (_showOverlay)
            _buildOverlay(), // Show overlay if _showOverlay is true
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      width: 500,
      height: 500,
      padding: const EdgeInsets.all(40.0),
      decoration: BoxDecoration(
        color: Color(0xFFE6F3FA).withOpacity(0),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 0),
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
                const SizedBox(height: 34),
                _buildTextFieldWithValidation(
                  icon: Icons.person,
                  labelText: 'Employee ID', // Add label
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your ID number';
                    }
                    return null;
                  },
                  onSaved: (value) => _username = value,
                ),
                const SizedBox(height: 16),
                _buildTextFieldWithValidation(
                  icon: Icons.lock,
                  labelText: 'Password', // Add label
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value,
                  obscureText: true,
                ),
                const SizedBox(height: 1.5),
                _buildGifButton(_login),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGifButton(VoidCallback onPressed) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: SizedBox(
          height: 100,
          width: 250,
          child: Image.asset(
            'assets/Legit.gif',
            fit: BoxFit.contain,
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
    required String labelText,
    Color labelColor = Colors.black87, // Add labelText as a required parameter
  }) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle:
            TextStyle(color: labelColor), // Set the label for the text field
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Color(0xFFCBCACB).withOpacity(1),
        hintStyle: TextStyle(color: Colors.red.withOpacity(0.4)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.8), // Dark transparent overlay
      child: Center(
        child: Text(
          'We listen, We anticipate, We deliver',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
