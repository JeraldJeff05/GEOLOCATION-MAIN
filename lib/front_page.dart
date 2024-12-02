import 'dart:async';
import 'package:flutter/material.dart';
import 'api/api_login.dart';
import 'dart:ui';

import 'admin/admin_page.dart'; // Import AdminPage

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String? _username, _password;

  double _topPosition = -500;
  final double _targetTopPosition = 275;

  bool _showOverlay = false;
  bool _showLoginForm = false;

  @override
  void initState() {
    super.initState();
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

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      setState(() {
        _showOverlay = true;
      });

      final apiLogin = ApiLogin();
      final response = await apiLogin.login(
        id: _username!,
        password: _password!,
      );

      setState(() {
        _showOverlay = false;
      });

      if (response == "employee") {
        Navigator.pushReplacementNamed(
            context, '/home'); // Navigate to homepage
      } else if (response == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const AdminPage()), // Navigate to Admin Page
        );
      } else {
        _showDialog('Error', 'Wrong credentials. Please try again.');
      }
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
    final double centerLeftPosition =
        MediaQuery.of(context).size.width / 2 - -140;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/FinalBG.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (!_showLoginForm)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            top: MediaQuery.of(context).size.height > 600
                ? _topPosition
                : MediaQuery.of(context).size.height / 2 - 250,
            left: MediaQuery.of(context).size.width > 1200
                ? centerLeftPosition
                : MediaQuery.of(context).size.width / 2 - 250,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 1000),
              opacity: _showLoginForm ? 1.0 : 0.0,
              child: _buildLoginForm(),
            ),
          ),
          if (_showOverlay) _buildOverlay(),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    bool isScreenMinimized = MediaQuery.of(context).size.width < 1200;

    return Container(
      width: 500,
      height: 330,
      padding: const EdgeInsets.all(40.0),
      decoration: BoxDecoration(
        color: isScreenMinimized
            ? Colors.black26.withOpacity(0.8)
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
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                ),
                const SizedBox(height: 16),
                _buildTextFieldWithValidation(
                  icon: Icons.lock,
                  labelText: '',
                  hintText: 'User ID',

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value,
                  obscureText: true,
                  onSubmit: _login, // Trigger login on Enter
                ),
                const SizedBox(height: 1.5),
                _buildGifButton(_login),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGifButton(VoidCallback onPressed) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: SizedBox(
          height: 100,
          width: 250,
          child: Image.asset(
            'assets/Legit.gif',
            fit: BoxFit.contain,
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
  }) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(color: labelColor),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFCBCACB).withOpacity(1),
        hintStyle: TextStyle(color: Colors.black.withOpacity(1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
      onFieldSubmitted: (value) {
        if (onSubmit != null) {
          onSubmit();
        }
      },
    );
  }

  Widget _buildOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: const Center(
        child: Text(
          'We listen, We anticipate, We deliver',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
