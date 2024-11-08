import 'package:flutter/material.dart';

void showSignInDialog({
  required BuildContext context,
  required Function(String username, String password) onSignIn,
}) {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isRobotChecked = false;
  bool isPasswordVisible = false;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFFF9D689),
            title: const Text(
              'Sign Up',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF6D4C41),
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: SizedBox(
              height: 300,
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Username',
                      labelStyle: TextStyle(color: Color(0xFF8D6E63)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8D6E63)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
                      labelStyle: const TextStyle(color: Color(0xFF8D6E63)),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8D6E63)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF8D6E63),
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
                  TextField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(color: Color(0xFF8D6E63)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8D6E63)),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: isRobotChecked,
                        activeColor: const Color(0xFF6D4C41),
                        onChanged: (bool? value) {
                          setState(() {
                            isRobotChecked = value ?? false;
                          });
                        },
                      ),
                      const Text("Are you a Human?",
                          style: TextStyle(color: Color(0xFF8D6E63))),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (passwordController.text ==
                      confirmPasswordController.text) {
                    if (isRobotChecked) {
                      onSignIn(
                          usernameController.text, passwordController.text);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("Please confirm you are not a robot.")),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Passwords do not match. Please try again.")),
                    );
                  }
                },
                style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF6D4C41)),
                child: const Text('Save'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF6D4C41)),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    },
  );
}
