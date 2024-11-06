import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'location_service.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String? _username, _password;
  String? _savedUsername, _savedPassword; //delete this if not working 1

  Future<void> _getCurrentLocationAndLogin() async {
    if (!await LocationService.checkLocationService(_showLocationErrorDialog))
      return;
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

      // Validate against saved username and password
      if (_username == _savedUsername && _password == _savedPassword) {
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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Autumn.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 0.0, // Adjust this value as needed to position vertically
            left: 0.0, // Ensures it’s pinned to the right side of the screen
            child: _buildLoginForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      width: 500,
      height: 1000,
      padding: const EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: Color(0xFFF9D689).withOpacity(0.8),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(50, 5),
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
                Image.asset(
                  'assets/FINALFDS.png',
                  width: 1050,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 0),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Employee's Log",
                    style: TextStyle(
                      color: Color(0xFF6D4C41),
                      fontSize: 40,
                      fontFamily: 'CustomFont',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
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
                const SizedBox(height: 30),
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
                        fontSize: 15,
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
                          fontSize: 15,
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
                const SizedBox(height: 40),
                const Text(
                  "We Listen We Anticipate We Deliver",
                  style: TextStyle(
                    color: Color(0xFF6D4C41),
                    fontSize: 26,
                    fontFamily: 'CustomFont',
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController usernameController =
            TextEditingController();
        final TextEditingController passwordController =
            TextEditingController();
        final TextEditingController confirmPasswordController =
            TextEditingController();
        bool isRobotChecked = false;
        bool isPasswordVisible = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor:
                  const Color(0xFFF9D689), // Light warm background color
              title: const Text(
                'Sign Up',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D4C41), // Autumn brown color for title text
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Username',
                      labelStyle: TextStyle(color: Color(0xFF8D6E63)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFF8D6E63)), // Accent color for focus
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
                      labelStyle: const TextStyle(color: Color(0xFF8D6E63)),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8D6E63)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xFF8D6E63), // Color for icon
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !isPasswordVisible,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(color: Color(0xFF8D6E63)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8D6E63)),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: isRobotChecked,
                        activeColor: const Color(0xFF6D4C41),
                        onChanged: (bool? value) {
                          setState(() {
                            isRobotChecked = value ?? false;
                          });
                        },
                      ),
                      const Text("Are you a Human?",
                          style: TextStyle(color: Color(0xFF8D6E63))),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (passwordController.text ==
                        confirmPasswordController.text) {
                      if (isRobotChecked) {
                        setState(() {
                          _savedUsername = usernameController.text;
                          _savedPassword = passwordController.text;
                        });
                        Navigator.of(context).pop();
                        _showSnackbar(
                            "Sign-up successful! Use the new credentials to log in.");
                      } else {
                        _showSnackbar("Please confirm you are not a robot.");
                      }
                    } else {
                      _showSnackbar(
                          "Passwords do not match. Please try again.");
                    }
                  },
                  style: TextButton.styleFrom(
                      foregroundColor: Color(0xFF6D4C41)), // Button color
                  child: const Text('Save'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style:
                      TextButton.styleFrom(foregroundColor: Color(0xFF6D4C41)),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
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
                colors: [Color(0xFFF9D689), Color(0xFFF9D689)], // New gradient
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
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
                  color: Colors.black87,
                  fontFamily: 'CustomFont',
                  fontSize: 15,
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
        fillColor: Color(0xFFF9D689),
        // Background color for the text field
        contentPadding: const EdgeInsets.symmetric(
            vertical: 15.0, horizontal: 10.0), // Padding inside the text field
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
