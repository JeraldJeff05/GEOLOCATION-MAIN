import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For time formatting
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/scheduler.dart'; // For Ticker

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _ticker = Ticker((_) {
      setState(() {
        _currentTime = DateTime.now();
      });
    })
      ..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure focusedDay is within range
    DateTime currentDay = DateTime.now();
    DateTime firstDay = DateTime.utc(2020, 01, 01);
    DateTime lastDay = DateTime.utc(2023, 12, 31);

    // Adjust focusedDay to be within the range
    DateTime focusedDay = currentDay.isBefore(lastDay) ? currentDay : lastDay;

    // Get formatted current time
    String formattedTime = DateFormat('hh:mm:ss a').format(_currentTime);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Show clock only if height is below 400
        bool isSmallScreen = constraints.maxHeight < 450;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isSmallScreen) // Show the calendar only if there's enough height
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    firstDay: firstDay,
                    lastDay: lastDay,
                    focusedDay: focusedDay,
                    calendarFormat: CalendarFormat.month,
                    onDaySelected: (selectedDay, focusedDay) {
                      // Handle day selection
                      print('Selected day: $selectedDay');
                    },
                  ),
                ),
              ),
            const SizedBox(height: 20), // Space between calendar and clock
            // Clock
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  formattedTime,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 3,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
