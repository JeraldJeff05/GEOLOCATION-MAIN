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

  Future<void> _showCurrentLocationDialog() async {
    try {
      Position position = await LocationService.getCurrentPosition();
      _showDialog('Current Location',
          'Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    } catch (e) {
      _showLocationErrorDialog("Unable to get location: $e");
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

  Future<void> _showTestLocationDialog() async {
    final TextEditingController latitudeController = TextEditingController();
    final TextEditingController longitudeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Test Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(latitudeController, 'Latitude'),
              const SizedBox(height: 10),
              _buildTextField(longitudeController, 'Longitude'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _validateTestLocation(
                    latitudeController.text, longitudeController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Test'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  void _validateTestLocation(String latitude, String longitude) {
    double? lat = double.tryParse(latitude);
    double? lon = double.tryParse(longitude);
    if (lat != null && lon != null) {
      _showSnackbar(LocationService.isLocationInRange(lat, lon)
          ? 'Input location is within the allowed range.'
          : 'Input location is NOT within the allowed range.');
    } else {
      _showSnackbar('Please enter valid latitude and longitude.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/muchmorebetterbg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: screenHeight *
                0.335, // Adjust this percentage to move form up/down
            left: 0,
            right: 0,
            child: Center(
              child: _buildLoginForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      width: 420,
      height: 400,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: PopupMenuButton(
              icon: Icon(Icons.settings, color: Colors.transparent),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text("Show Current Location"),
                  value: "show_location",
                ),
                PopupMenuItem(
                  child: Text("Test Location"),
                  value: "test_location",
                ),
              ],
              onSelected: (value) {
                if (value == "show_location") {
                  _showCurrentLocationDialog();
                } else if (value == "test_location") {
                  _showTestLocationDialog();
                }
              },
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Associate's Log",
                  style: TextStyle(
                    fontFamily: 'CustomFont',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextFieldWithValidation('Username', (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                }, (value) => _username = value),
                const SizedBox(height: 20),
                _buildTextFieldWithValidation('Password', (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                }, (value) => _password = value, obscureText: true),
                const SizedBox(height: 30),
                _buildGradientButton('Login', _getCurrentLocationAndLogin),
                const SizedBox(height: 10),
                _buildGradientButton('Sign In', _signIn),
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
        bool isRobotChecked = false; // Initial state for the robot checkbox
        bool isPasswordVisible = false; // Initial state for password visibility

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Sign Up'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: usernameController,
                    decoration:
                        const InputDecoration(labelText: 'Enter Username'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
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
                  Row(
                    children: [
                      Checkbox(
                        value: isRobotChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isRobotChecked = value ?? false;
                          });
                        },
                      ),
                      const Text("Are you a Human?"),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
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
                  },
                  child: const Text('Save'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
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
    return SizedBox(
      height: 60,
      width: 400,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.red, Color(0xFF002220)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithValidation(
    String labelText,
    FormFieldValidator<String> validator,
    FormFieldSetter<String> onSaved, {
    bool obscureText = false,
  }) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
