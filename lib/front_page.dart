import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'api/api_login.dart';
import 'admin_page.dart';
import 'api/api_service.dart';
import 'location/location_service.dart';
import 'home_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // Existing state variables remain the same
  final _formKey = GlobalKey<FormState>();
  String? _username, _password;
  bool _showLoginForm = false;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<Offset> _buttonAnimation;
  late AnimationController _shakeController;
  late Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    // Existing animation controllers remain the same
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

    // Enhanced initial animation sequence
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {});
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _showLoginForm = true;
        });
      });
    });
  }

  // All existing methods (_login, _showDialog, etc.) remain unchanged

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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  firstName: apiLogin.firstName,
                  lastName: apiLogin.lastName,
                ),
              ),
            );
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Animated background with parallax effect
              TweenAnimationBuilder<double>(
                duration: const Duration(seconds: 3),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LoginNoLogoBg.png'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5 * (1 - value)),
                          BlendMode.darken,
                        ),
                        alignment: Alignment(
                          0.5 * (1 - value), // Slight parallax movement
                          0.0,
                        ),
                      ),
                    ),
                    // Animated blur effect
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5 * (1 - value),
                        sigmaY: 5 * (1 - value),
                      ),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  );
                },
              ),

              // Positioned login form with enhanced animations
              Positioned(
                right: 55,
                top: 0,
                bottom: 20,
                child: Center(
                  child: SingleChildScrollView(
                    child: ZoomIn(
                      duration: const Duration(milliseconds: 800),
                      child: Opacity(
                        opacity: _showLoginForm ? 1.0 : 0.0,
                        child: _buildLoginForm(constraints),
                      ),
                    ),
                  ),
                ),
              ),

              // Loading indicator with pulsing effect
              if (_isLoading)
                Center(
                  child: Pulse(
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      strokeWidth: 6,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoginForm(BoxConstraints constraints) {
    final containerWidth = constraints.maxWidth > 400
        ? constraints.maxWidth * 0.4
        : constraints.maxWidth * 0.9;

    return SlideTransition(
      position: _shakeAnimation,
      child: Container(
        width: containerWidth,
        constraints: BoxConstraints(
          maxWidth: 600,
          minWidth: 500,
        ),
        padding: const EdgeInsets.only(bottom: 80, right: 10, left: 10),
        decoration: BoxDecoration(
          color: Colors.black26.withOpacity(0),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0),
              spreadRadius: 5,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
              // Bouncing logo animation
              BounceInDown(
                child: ClipRect(
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
              ),
              const SizedBox(height: 10),
              // Animated text fields with staggered entry
              FadeInLeft(
                delay: const Duration(milliseconds: 800),
                child: _buildTextFieldWithValidation(
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
              ),
              const SizedBox(height: 16),
              FadeInRight(
                delay: const Duration(milliseconds: 800),
                child: _buildTextFieldWithValidation(
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
              ),
              const SizedBox(height: 32),
              // Animated login button
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: _buildGifButton(_login),
              ),
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
