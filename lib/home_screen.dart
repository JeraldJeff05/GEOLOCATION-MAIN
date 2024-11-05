import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'kanban_board.dart'; // Import Kanban Board

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCBDCEB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFCBDCEB),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
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
              leading:
                  Icon(Icons.calendar_today, color: const Color(0xFF8B1E3F)),
              title: Text('Calendar'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarSection()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list, color: const Color(0xFF8B1E3F)),
              title: Text('To-Do List'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ToDoListSection()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.view_kanban, color: const Color(0xFF8B1E3F)),
              title: Text('Kanban Board'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KanbanBoard()),
                );
              },
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
            _buildProfileHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: _buildProfileInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'Your Profile',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333A3A),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/profile_picture.png'), // Replace with actual profile image path
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Username',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'user@example.com',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(color: Colors.grey),
        const SizedBox(height: 10),
        Text(
          'Additional Information',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333A3A)),
        ),
        const SizedBox(height: 10),
        _buildProfileDetailRow(Icons.date_range, 'Member since: January 2022'),
        _buildProfileDetailRow(Icons.badge, 'Position: Associate'),
        _buildProfileDetailRow(Icons.location_on, 'Location: City, Country'),
      ],
    );
  }

  Widget _buildProfileDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF8B1E3F)),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontSize: 16),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            if (_importantDates.contains(selectedDay)) {
              _importantDates.remove(selectedDay);
            } else {
              _importantDates.add(selectedDay);
            }
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
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Center(
        child:
            Text('To-Do list widget goes here', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
