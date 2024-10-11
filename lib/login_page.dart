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
      _login(); // Make sure this function does what you intend
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
        labelStyle: TextStyle(color: Colors.white), // Set label color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.white), // Set border color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              BorderSide(color: Colors.white), // Set enabled border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
              color: Colors.orangeAccent), // Set focused border color
        ),
        filled: true,
        fillColor: Color(0xFF800000), // Background color
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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/background.png'), // Background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildLoginForm(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSettingsMenu,
        child: Icon(Icons.settings),
        backgroundColor: Colors.white38,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showSettingsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Show Location'),
                onTap: () {
                  Navigator.pop(context);
                  _showCurrentLocationDialog();
                },
              ),
              ListTile(
                leading: Icon(Icons.settings), // Changed to an available icon
                title: Text('Test Input Location'),
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

  Widget _buildLoginForm() {
    return Container(
      width: 400,
      padding: EdgeInsets.all(50.00),
      decoration: BoxDecoration(
        color: Color(0xFF800000).withOpacity(1.0),
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
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
          colors: [Colors.deepOrange, Colors.red],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Change color to black here
          ),
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
        labelStyle: TextStyle(color: Colors.white), // Set label color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.white), // Set border color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              BorderSide(color: Colors.white), // Set enabled border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
              color: Colors.deepOrangeAccent), // Set focused border color
        ),
        filled: true,
        fillColor: Color(0xFF800000), // Background color
      ),
      obscureText: obscureText,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
