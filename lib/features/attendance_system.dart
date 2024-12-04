import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceSystem extends StatefulWidget {
  @override
  _AttendanceSystemState createState() => _AttendanceSystemState();
}

class _AttendanceSystemState extends State<AttendanceSystem> {
  bool _isCheckedIn = true; // Start as checked-in
  bool _isCheckedOut = false;
  bool _hasPressedAttendance = true; // Considered already checked-in
  bool _hasPressedCheckout = false;
  DateTime? _checkInTime;
  DateTime? _checkOutTime;

  @override
  void initState() {
    super.initState();
    // Automatically set the check-in state after logging in
    _isCheckedIn = true;
    _hasPressedAttendance = true;
    _checkInTime = DateTime.now();
  }

  void _saveAttendanceStatus(bool value) {
    setState(() {
      _isCheckedIn = value;
      _hasPressedAttendance = true;
      _checkInTime = DateTime.now();
    });
  }

  void _saveCheckoutStatus(bool value) {
    setState(() {
      _isCheckedOut = value;
      _hasPressedCheckout = true;
      _checkOutTime = DateTime.now();
    });
  }

  // Format for Date (MM/DD/YY)
  String formatDate(DateTime dateTime) {
    return DateFormat('MM/dd/yy').format(dateTime);
  }

  // Format for Time (12-hour format with AM/PM)
  String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime); // 12-hour format with AM/PM
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance System"),
        backgroundColor: Colors.blue,
      ),
      body: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF707070), Color(0xFF4A4A4A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Attendance System',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implement Log History navigation or function
                      Navigator.pushNamed(context, '/logHistory'); // Example route
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8), // Adjust padding
                    ),
                    child: const Text(
                      'Log History',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isCheckedIn
                        ? 'Log In: ${formatDate(_checkInTime!)} at ${formatTime(_checkInTime!)}'
                        : 'Not Logged In',
                    style: TextStyle(
                      color: _isCheckedIn ? Colors.green : Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: !_hasPressedAttendance
                        ? () {
                      _saveAttendanceStatus(true);
                      setState(() {
                        _isCheckedIn = true;
                        _checkInTime = DateTime.now();
                        _hasPressedAttendance = true; // Disable button
                      });
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      _hasPressedAttendance ? Colors.blueGrey : Colors.white,
                    ),
                    child: Text(
                      !_hasPressedAttendance ? 'Log in' : 'Log In Approved',
                      style: TextStyle(
                        color: !_hasPressedAttendance ? Colors.black : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox
                (height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isCheckedOut
                        ? 'Log Out: ${formatDate(_checkOutTime!)} at ${formatTime(_checkOutTime!)}'
                        : 'Logging Out?',
                    style: TextStyle(
                      color: _isCheckedOut ? Colors.green : Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: !_hasPressedCheckout
                        ? () {
                      _saveCheckoutStatus(true);
                      setState(() {
                        _isCheckedOut = true;
                        _checkOutTime = DateTime.now();
                        _hasPressedCheckout = true; // Disable button
                      });
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      _hasPressedCheckout ? Colors.blueGrey : Colors.white,
                    ),
                    child: Text(
                      !_hasPressedCheckout ? 'Log Out' : 'Log Out Approved',
                      style: TextStyle(
                        color: !_hasPressedCheckout ? Colors.black : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}