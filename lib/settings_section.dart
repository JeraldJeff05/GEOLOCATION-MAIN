import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'location_service.dart'; // Import your LocationService

class SettingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333A3A),
              ),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.notifications, color: Color(0xFF8B1E3F)),
              title: Text('Notifications'),
            ),
            const ListTile(
              leading: Icon(Icons.help, color: Color(0xFF8B1E3F)),
              title: Text('Help & Support'),
            ),
            ListTile(
              leading: Icon(Icons.location_on, color: const Color(0xFF8B1E3F)),
              title: const Text('Geolocation'),
              onTap: () => _showGeolocationDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showGeolocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Geolocation Options'),
          content: const Text('Choose an option below:'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                _showCurrentLocation(context);
              },
              child: const Text('Show Current Location'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _showLatLongInputDialog(context);
              },
              child: const Text('Check Lat/Long Range'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showCurrentLocation(BuildContext context) async {
    final showLocationErrorDialog = (String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    };

    bool locationEnabled =
        await LocationService.checkLocationService(showLocationErrorDialog);

    if (!locationEnabled) return;

    Position position = await LocationService.getCurrentPosition();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Current Location'),
        content: Text(
            'Latitude: ${position.latitude}, Longitude: ${position.longitude}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLatLongInputDialog(BuildContext context) {
    final TextEditingController latController = TextEditingController();
    final TextEditingController longController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Latitude and Longitude'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: latController,
                decoration: const InputDecoration(
                  labelText: 'Latitude',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: longController,
                decoration: const InputDecoration(
                  labelText: 'Longitude',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                double? latitude = double.tryParse(latController.text);
                double? longitude = double.tryParse(longController.text);

                if (latitude == null || longitude == null) {
                  _showErrorDialog(context, 'Invalid Latitude or Longitude');
                  return;
                }

                bool inRange =
                    LocationService.isLocationInRange(latitude, longitude);
                _showRangeResultDialog(context, inRange);
              },
              child: const Text('Check'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showRangeResultDialog(BuildContext context, bool inRange) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Location Check Result'),
        content: Text(inRange
            ? 'The location is within the accessible area.'
            : 'The location is outside the accessible area.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
