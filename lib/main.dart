import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

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
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationErrorDialog("Location services are disabled.");
      return;
    }

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationErrorDialog("Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationErrorDialog("Location permissions are permanently denied.");
      return;
    }

    // Get the current position of the user
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Check if the user's location is within the allowed area
    if (!_isLocationInRange(position.latitude, position.longitude)) {
      _showLocationErrorDialog(
          "You are not within the allowed location range and cannot access this site.");
    } else {
      // Proceed with login if within the allowed location range
      _login();
    }
  }

  // Function to check if the location is within the defined ranges
  bool _isLocationInRange(double latitude, double longitude) {
    return latitude >= minLatitude &&
        latitude <= maxLatitude &&
        longitude >= minLongitude &&
        longitude <= maxLongitude;
  }

  Future<void> _showCurrentLocationDialog() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Current Location'),
            content: Text(
                'Latitude: ${position.latitude}, Longitude: ${position.longitude}'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      _showLocationErrorDialog("Unable to get location: $e");
    }
  }

  void _showLocationErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Access Denied'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Welcome'),
          content: Text('Welcome to FDS!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (_username == 'admin' && _password == 'admin') {
        // Show welcome dialog and then navigate to home
        _showWelcomeDialog();
      } else {
        // Login failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid username or password')),
        );
      }
    }
  }

  // Function to show input dialog for testing location
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
              TextField(
                controller: latitudeController,
                decoration: InputDecoration(
                  labelText: 'Latitude',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: longitudeController,
                decoration: InputDecoration(
                  labelText: 'Longitude',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                double? latitude = double.tryParse(latitudeController.text);
                double? longitude = double.tryParse(longitudeController.text);

                if (latitude != null && longitude != null) {
                  if (_isLocationInRange(latitude, longitude)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Input location is within the allowed range.')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Input location is NOT within the allowed range.')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Please enter valid latitude and longitude.')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Test'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) => _username = value,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Login'),
                onPressed: _getCurrentLocationAndLogin,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Show Location'),
                onPressed: _showCurrentLocationDialog,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Test Input Location'),
                onPressed: _showTestLocationDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to the home screen'),
      ),
    );
  }
}
