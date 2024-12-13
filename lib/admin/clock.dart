import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({Key? key}) : super(key: key);

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late DateTime _currentTime;
  late String _currentDay;
  late String _currentDate;
  late String _currentLocation;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _ticker = Ticker((_) {
      setState(() {
        _updateDateTime();
      });
    })
      ..start();
  }

  void _updateDateTime() {
    _currentTime = DateTime.now();
    _currentDay = DateFormat('EEEE').format(_currentTime);
    _currentDate = DateFormat('MMM dd, yyyy').format(_currentTime);
    _currentLocation =
        'San Pablo City, Philippines HQ'; // Replace with actual location logic
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('hh:mm:ss a').format(_currentTime);

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 600;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade700,
                Colors.blue.shade900,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12 : 20,
            vertical: isSmallScreen ? 10 : 15,
          ),
          margin: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Time and Date Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: isSmallScreen ? 20 : 25,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 20 : 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_currentDay, $_currentDate',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                ],
              ),

              // Location and Additional Info Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white70,
                        size: isSmallScreen ? 16 : 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _currentLocation,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Corporate Dashboard',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: isSmallScreen ? 10 : 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
