import 'package:flutter/material.dart';

void main() {
  runApp(LocationBasedServicesApp());
}

class LocationBasedServicesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LocationBasedServicesScreen(),
    );
  }
}

class LocationBasedServicesScreen extends StatefulWidget {
  @override
  _LocationBasedServicesScreenState createState() => _LocationBasedServicesScreenState();
}

class _LocationBasedServicesScreenState extends State<LocationBasedServicesScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();

  String? selectedService; // To track selected radio button
  bool isFormValid = true; // To track form validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location-Based Services'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location-Based Services (LBS)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Icon-Based Input Fields
            _buildTextFieldWithIcon(
              label: 'Name',
              icon: Icons.person,
              controller: nameController,
            ),
            const SizedBox(height: 16),
            _buildTextFieldWithIcon(
              label: 'Email',
              icon: Icons.email,
              controller: emailController,
            ),
            const SizedBox(height: 16),

            const Text(
              'Your Preferences for LBS',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildRadioListTile('Navigation Services', Icons.map),
            _buildRadioListTile('Geo-Marketing', Icons.local_offer),
            _buildRadioListTile('Fitness & Health', Icons.fitness_center),
            _buildRadioListTile('Emergency Services', Icons.warning),

            const SizedBox(height: 24),
            const Text(
              'Additional Feedback',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildTextFieldWithIcon(
              label: 'Share your feedback',
              icon: Icons.feedback,
              controller: feedbackController,
              maxLines: 4,
            ),
            const SizedBox(height: 24),

            // Show validation error if the form is invalid
            if (!isFormValid)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Please fill all fields before submitting.',
                  style: TextStyle(color: Colors.red),
                ),
              ),

    Center(
    child: Column(
    children: [
    ElevatedButton(
    onPressed: () {
    // Form validation logic
    if (nameController.text.isEmpty ||
    emailController.text.isEmpty ||
    selectedService == null ||
    feedbackController.text.isEmpty) {
    setState(() {
    isFormValid = false; // Set to false if any field is empty
    });
    } else {
    setState(() {
    isFormValid = true; // Set to true if form is valid
    });
    // Handle submission logic here
    _submitForm();
    }
    },
    child: const Text('Submit'),
    ),
    const SizedBox(height: 24), // Adds some spacing before the text
    const Text(
    'Location-Based Services (LBS) are applications that use geographic data to provide services or information based on the user\'s location. These services leverage technologies like GPS, Wi-Fi, and Bluetooth to provide real-time data, making the user experience more personalized and context-aware.',
    style: TextStyle(fontSize: 16, color: Colors.black87),
    textAlign: TextAlign.center, // Center the explanation text
    ),
    ],
    ),
    ),
]
    ),
      ),
    );
  }

  // A reusable method for creating input fields with icons
  Widget _buildTextFieldWithIcon({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }

  // A reusable method for creating radio button list items with icons
  Widget _buildRadioListTile(String title, IconData icon) {
    return RadioListTile<String>(
      value: title,
      groupValue: selectedService,
      onChanged: (value) {
        setState(() {
          selectedService = value; // Update selected service
        });
      },
      title: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }

  // Form submission method
  void _submitForm() {
    // Example of how to process the data, display a message, or save it
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Form Submitted'),
          content: Text(
            'Name: ${nameController.text}\n'
                'Email: ${emailController.text}\n'
                'Preferred Service: $selectedService\n'
                'Feedback: ${feedbackController.text}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
