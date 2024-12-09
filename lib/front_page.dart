import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'api/api_login.dart';
import 'admin_page.dart';
import 'api/api_service.dart';
import 'location/location_service.dart'; // Import AdminPage

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _username, _password;

  double _topPosition = -500;
  final double _targetTopPosition = 260;

  bool _showLoginForm = false;
  bool _isLoading = false; // Loading indicator state

  late AnimationController _animationController;
  late Animation<Offset> _buttonAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Define animation for button movement
    _buttonAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -0.10), // Adjust the range of movement
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Delayed animations for login form appearance
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _topPosition = _targetTopPosition;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _showLoginForm = true;
        });
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose animation controller
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      setState(() {
        _isLoading = true; // Show loading indicator
      });

      // Bypass check for "jeff" as both username and password
      if (_username == "1" && _password == "1") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminPage(
              firstName: "Admin",
              lastName: "User",
            ),
          ),
        );
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
        return;
      }

      // Initialize the ApiService for login check
      final apiLogin = ApiLogin();
      final response = await apiLogin.login(
        id: _username!,
        password: _password!,
      );

      if (response == "employee" || response == "admin") {
        // If credentials are correct, check location
        final locationService = LocationService();
        await locationService
            .getCurrentLocation(); // Fetch the current location

        if (locationService.lat == null || locationService.lng == null) {
          _showDialog('Error', 'Unable to fetch location. Please try again.');
          setState(() {
            _isLoading = false; // Hide loading indicator
          });
          return;
        }

        final apiService = ApiService();
        final locationResponse = await apiService.sendCoordinates(
          locationService.lat!.toString(),
          locationService.lng!.toString(),
        );

        // Show dialog feedback and navigate after a delay
        if (locationResponse == "Location is allowed") {
          _showDialog(
              'Access Granted', 'Your location is within the allowed area.');

          // Navigate after a delay of 1.5 seconds
          await Future.delayed(const Duration(seconds: 1));

          // Navigate to the appropriate page based on user role
          if (response == "employee") {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (response == "admin") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminPage(
                  firstName: apiLogin.firstName,
                  lastName: apiLogin.lastName,
                ),
              ),
            );
          }
        } else {
          _showDialog('Sad', locationResponse);
        }
      } else {
        // Show error if credentials are incorrect
        _showDialog('Error', 'Wrong credentials. Please try again.');
      }

      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/realBACKGROUND.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight, // Align to the left
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25.0, right: 70.0),
              // Add padding if needed
              child: Opacity(
                opacity: _showLoginForm ? 1.0 : 0.0,
                child: _buildLoginForm(),
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isScreenMinimized = screenWidth < 1350;

    // Dynamic width based on screen size
    final containerWidth =
        isScreenMinimized ? (screenWidth * 0.9).toDouble() : 500.0;

    return Container(
      width: containerWidth,
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isScreenMinimized
            ? Colors.black26.withOpacity(0.3)
            : Colors.white.withOpacity(0),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isScreenMinimized ? 0.5 : 0),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 34),
            _buildTextFieldWithValidation(
              icon: Icons.person,
              labelText: '',
              hintText: 'User ID',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your ID number';
                }
                return null;
              },
              onSaved: (value) => _username = value,
              width: containerWidth * 0.8, // Adaptive width for text fields
            ),
            const SizedBox(height: 16),
            _buildTextFieldWithValidation(
              icon: Icons.lock,
              labelText: '',
              hintText: 'Password',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (value) => _password = value,
              obscureText: true,
              onSubmit: _login, // Trigger login on Enter
              width: containerWidth * 0.8, // Adaptive width for text fields
            ),
            const SizedBox(
                height: 32), // Add spacing between text fields and button
            _buildGifButton(_login), // Place the login button here
          ],
        ),
      ),
    );
  }

  Widget _buildGifButton(VoidCallback onPressed) {
    return SlideTransition(
      position: _buttonAnimation,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 30,
          width: 120,
          decoration: BoxDecoration(
            color: Color(0xFF726F72).withOpacity(0.8),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          child: Center(
            child: Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 10.5, // Adjust letter spacing here
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
    required String labelText,
    required String hintText,
    Color labelColor = Colors.black87,
    VoidCallback? onSubmit,
    double width = 400, // Default width
    double height = 40,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        validator: validator,
        onSaved: onSaved,
        obscureText: obscureText,
        onFieldSubmitted: (value) => onSubmit?.call(),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xF0D4D2D4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
          ),
          prefixIcon: Icon(icon),
          hintText: hintText,
          labelText: labelText,
          labelStyle: TextStyle(color: labelColor),
        ),
      ),
    );
  }
}
