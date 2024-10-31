import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCBDCEB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFCBDCEB),
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: const Color(0xFF133E87)),
              child: Center(
                child: Text(
                  'Welcome',
                  style: TextStyle(
                    color: Color(0xFF001F3F),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: const Color(0xFF8B1E3F)),
              title: Text('Logout'),
              onTap: () => Navigator.pushReplacementNamed(context, '/'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDashboardHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                children: [
                  AttendanceSection(),
                  CalendarSection(),
                  ToDoListSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'Your Dashboard',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333A3A),
          ),
        ),
      ],
    );
  }
}

// Attendance Section
class AttendanceSection extends StatefulWidget {
  @override
  _AttendanceSectionState createState() => _AttendanceSectionState();
}

class _AttendanceSectionState extends State<AttendanceSection> {
  bool isPresent = false;

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      color: const Color(0xFF94E0D0),
      title: 'Attendance',
      icon: Icons.check_circle,
      iconColor: const Color(0xFF8B1E3F),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Mark Attendance',
            style: TextStyle(fontSize: 18, color: Color(0xFF383A3A)),
          ),
          Checkbox(
            value: isPresent,
            onChanged: (bool? value) {
              setState(() {
                isPresent = value ?? false;
              });
            },
            activeColor: const Color(0xFF8B1E3F),
          ),
        ],
      ),
    );
  }
}

// Calendar Section
class CalendarSection extends StatefulWidget {
  @override
  _CalendarSectionState createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Set<DateTime> _importantDates = {};

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      color: const Color(0xFFF5D0C5),
      title: 'Calendar',
      icon: Icons.calendar_today,
      iconColor: const Color(0xFF8B1E3F),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;

            // Toggle important date
            if (_importantDates.contains(selectedDay)) {
              _importantDates.remove(selectedDay);
            } else {
              _importantDates.add(selectedDay);
            }
          });
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.redAccent,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        eventLoader: (day) =>
            _importantDates.contains(day) ? ['Important'] : [],
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
      ),
    );
  }
}

// To-Do List Section
class ToDoListSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildCard(
      color: const Color(0xFFFAD4D8),
      title: 'To-Do List',
      icon: Icons.list,
      iconColor: const Color(0xFF8B1E3F),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child:
            Text('To-Do list widget goes here', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

// A utility function to create styled cards with a title and icon.
Widget _buildCard({
  required Color color,
  required String title,
  required IconData icon,
  required Color iconColor,
  required Widget child,
}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    color: color,
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: iconColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(child: child),
        ],
      ),
    ),
  );
}
