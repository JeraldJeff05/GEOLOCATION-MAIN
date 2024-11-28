import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For time formatting
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get current time
    String currentTime = DateFormat('hh:mm a').format(DateTime.now());

    // Ensure focusedDay is within range
    DateTime currentDay = DateTime.now();
    DateTime firstDay = DateTime.utc(2020, 01, 01);
    DateTime lastDay = DateTime.utc(2023, 12, 31);

    // Adjust focusedDay to be within the range
    DateTime focusedDay = currentDay.isBefore(lastDay) ? currentDay : lastDay;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Calendar Widget
        TableCalendar(
          firstDay: firstDay,
          lastDay: lastDay,
          focusedDay: focusedDay,
          calendarFormat: CalendarFormat.month,
          onDaySelected: (selectedDay, focusedDay) {
            // Handle day selection
            print('Selected day: $selectedDay');
          },
        ),
        const SizedBox(height: 20), // Space between calendar and clock
        // Clock
        Text(
          'Current Time: $currentTime',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
