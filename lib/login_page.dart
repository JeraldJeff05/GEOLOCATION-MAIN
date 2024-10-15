import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String? _username, _password;

  final double minLatitude = 14.06727248844374;
  final double maxLatitude = 14.068567511556262;
  final double minLongitude = 121.32635146800003;
  final double maxLongitude = 121.32768653199999;

  final double _loginBoxTop = 250.0; // Position from the top
  final double _loginBoxLeft = 495.5; // Position from the left

  Future<void> _getCurrentLocationAndLogin() async {
    if (!await _checkLocationService()) return;
    Position position = await _getCurrentPosition();
    if (!_isLocationInRange(position.latitude, position.longitude)) {
      _showLocationErrorDialog(
          "You are not within the allowed location range and cannot access this site.");
    } else {
      _login();
    }
  }

  Future<bool> _checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationErrorDialog(
          "Location services are disabled. Please enable them in your device settings.");
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationErrorDialog(
            "Location permissions are denied. Please grant permissions to proceed.");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationErrorDialog(
          "Location permissions are permanently denied. Please enable them in settings.");
      return false;
    }
    return true;
  }

  Future<Position> _getCurrentPosition() {
    return Geolocator.getCurrentPosition();
  }

  bool _isLocationInRange(double latitude, double longitude) {
    return latitude >= minLatitude &&
        latitude <= maxLatitude &&
        longitude >= minLongitude &&
        longitude <= maxLongitude;
  }

  Future<void> _showCurrentLocationDialog() async {
    try {
      Position position = await _getCurrentPosition();
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

  void _showTestLocationDialog() {
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
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.orangeAccent),
        ),
        filled: true,
        fillColor: const Color(0xFF800000),
      ),
      keyboardType: TextInputType.number,
    );
  }

  void _validateTestLocation(String latitude, String longitude) {
    double? lat = double.tryParse(latitude);
    double? lon = double.tryParse(longitude);
    if (lat != null && lon != null) {
      _showSnackbar(_isLocationInRange(lat, lon)
          ? 'Input location is within the allowed range.'
          : 'Input location is NOT within the allowed range.');
    } else {
      _showSnackbar('Please enter valid latitude and longitude.');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (_username == 'admin' && _password == 'admin') {
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final loginBoxWidth = screenSize.width; // 80% of screen width

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bgminimalist.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: _loginBoxLeft, // Use your defined position
            top: _loginBoxTop, // Use your defined position
            child: _buildLoginForm(loginBoxWidth),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSettingsMenu,
        backgroundColor: Colors.transparent, // No background color
        foregroundColor:
            Colors.transparent, // Change to your desired icon color
        elevation: 0, // Remove shadow
        child: const Icon(
          Icons.settings,
          size: 50, // Change this value to adjust the icon size
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showSettingsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Show Location'),
                onTap: () {
                  Navigator.pop(context);
                  _showCurrentLocationDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Test Input Location'),
                onTap: () {
                  Navigator.pop(context);
                  _showTestLocationDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoginForm(double width) {
    return Container(
      width: 450,
      padding: const EdgeInsets.all(50.0),
      height: 450, // Optional: You can also set a height if needed
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withOpacity(1.0),
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 5), // changes the position of the shadow
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Associate's Log",
              style: TextStyle(
                height: 1,
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            const Text(
              "",
              style: TextStyle(
                height: 1,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
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
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 100,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.transparent, // Set background color to transparent
          elevation: 0, // Remove shadow
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF800000), Color(0xFF800000)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            constraints:
                const BoxConstraints(maxWidth: double.infinity, minHeight: 50),
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithValidation(String labelText,
      String? Function(String?)? validator, void Function(String?)? onSaved,
      {bool obscureText = false}) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.orangeAccent),
        ),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
      ),
      style: const TextStyle(color: Colors.white),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
