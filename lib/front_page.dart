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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _username, _password;

  bool _showLoginForm = false;
  bool _isLoading = false; // Loading indicator state

  late AnimationController _animationController;
  late Animation<Offset> _buttonAnimation;
  late AnimationController _shakeController;
  late Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for button
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _buttonAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -0.10),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Initialize shake animation controller
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _shakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.05, 0.0),
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    // Delayed animations for login form appearance
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {});
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _showLoginForm = true;
        });
      });
    });
  }

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      setState(() {
        _isLoading = true;
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
          _isLoading = false;
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
        final locationService = LocationService();
        await locationService.getCurrentLocation();

        if (locationService.lat == null || locationService.lng == null) {
          _showDialog('Error', 'Unable to fetch location. Please try again.');
          setState(() {
            _isLoading = false;
          });
          return;
        }

        final apiService = ApiService();
        final locationResponse = await apiService.sendCoordinates(
          locationService.lat!.toString(),
          locationService.lng!.toString(),
        );

        if (locationResponse == "Location is allowed") {
          _showDialog(
              'Access Granted', 'Your location is within the allowed area.');

          await Future.delayed(const Duration(seconds: 1));

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
        _showDialog('Error', 'Wrong credentials. Please try again.');
      }

      setState(() {
        _isLoading = false;
      });
    } else {
      _shakeController.forward(from: 0.0); // Trigger shake animation
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
  void dispose() {
    _animationController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/LoginNoLogoBg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 55,
                // 5% from the right on narrow screens
                top: 0,
                bottom: 20,

                child: Center(
                  child: SingleChildScrollView(
                    child: Opacity(
                      opacity: _showLoginForm ? 1.0 : 0.0,
                      child: _buildLoginForm(constraints),
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoginForm(BoxConstraints constraints) {
    // Calculate responsive width
    final containerWidth = constraints.maxWidth > 600
        ? constraints.maxWidth * 0.4 // Wider screens get 40% width
        : constraints.maxWidth * 0.9; // Narrow screens get 90% width

    return SlideTransition(
      position: _shakeAnimation,
      child: Container(
        width: containerWidth,
        constraints: BoxConstraints(
          maxWidth: 600, // Maximum width to prevent excessive stretching
          minWidth: 500, // Minimum width to ensure readability
        ),
        padding: const EdgeInsets.only(bottom: 80, right: 10, left: 10),
        decoration: BoxDecoration(
          color: Colors.black26.withOpacity(0),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0),
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
              const SizedBox(height: 5),
              ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/FLlogo.png',
                    width: 350,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                width: containerWidth * 0.8,
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
                onSubmit: _login,
                width: containerWidth * 0.8,
              ),
              const SizedBox(height: 32),
              _buildGifButton(_login),
            ],
          ),
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
          height: 25,
          width: 100,
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
                letterSpacing: 10.5,
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
    double width = 200,
    double height = 35,
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
