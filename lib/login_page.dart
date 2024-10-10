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
      _showLocationErrorDialog("Location services are disabled.");
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationErrorDialog("Location permissions are denied.");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _showLocationErrorDialog("Location permissions are permanently denied.");
      return false;
    }
    return true;
  }

  Future<Position> _getCurrentPosition() {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
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
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showWelcomeDialog() {
    _showDialog('Welcome', 'Welcome to FDS!');
    Navigator.pushReplacementNamed(context, '/home');
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

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showTestLocationDialog() {
    final TextEditingController latitudeController = TextEditingController();
    final TextEditingController longitudeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Test Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(latitudeController, 'Latitude'),
              SizedBox(height: 10),
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
              child: Text('Test'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
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
        border: OutlineInputBorder(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/background.png'), // Background image path
                fit: BoxFit.cover, // Cover the entire background
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight, // Aligns the form to the right
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildLoginForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      width: 500, // Adjust the width of the login form
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white38.withOpacity(1.0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Employee’s Log",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: _buildTextFieldWithValidation('Username', (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              }, (value) => _username = value),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: _buildTextFieldWithValidation('Password', (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              }, (value) => _password = value, obscureText: true),
            ),
            SizedBox(height: 30),
            _buildGradientButton('Login', _getCurrentLocationAndLogin),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showCurrentLocationDialog,
              child: Text('Show Location'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showTestLocationDialog,
              child: Text('Test Input Location'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton(String text, VoidCallback onPressed) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.red],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithValidation(String labelText,
      String? Function(String?) validator, void Function(String?) onSaved,
      {bool obscureText = false}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      obscureText: obscureText,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
