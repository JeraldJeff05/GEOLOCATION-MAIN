import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

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

  // Define the coordinates of the polygon
  final List<LatLng> polygon = [
    LatLng(14.06774778322239, 121.32702398552827),
    LatLng(14.06781200198926, 121.32696747614202),
    LatLng(14.068096626677226, 121.32723899181457),
    LatLng(14.06816583416237, 121.32714354050331),
    LatLng(14.06774778322239, 121.32702398552827),
  ];

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
    if (!_isPointInPolygon(
        LatLng(position.latitude, position.longitude), polygon)) {
      _showLocationErrorDialog(
          "You are not within the allowed location range and cannot access this site.");
    } else {
      // Proceed with login if within the allowed location range
      _login();
    }
  }

  // Function to determine if a point is inside a polygon
  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int intersectCount = 0;
    for (int j = 0; j < polygon.length - 1; j++) {
      if (_rayCastIntersect(point, polygon[j], polygon[j + 1])) {
        intersectCount++;
      }
    }
    return (intersectCount % 2) == 1; // odd count means inside
  }

  // Helper function for the ray-casting algorithm
  bool _rayCastIntersect(LatLng point, LatLng vertA, LatLng vertB) {
    double ax = vertA.longitude;
    double ay = vertA.latitude;
    double bx = vertB.longitude;
    double by = vertB.latitude;
    double px = point.longitude;
    double py = point.latitude;

    if ((ay > py && by > py) || (ay < py && by < py) || (ax < px && bx < px)) {
      return false;
    }

    double m = (by - ay) / (bx - ax);
    double intersectX = (py - ay) / m + ax;
    return intersectX > px;
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
      ),
      body: Center(
        child: Text('Welcome to the home screen'),
      ),
    );
  }
}
