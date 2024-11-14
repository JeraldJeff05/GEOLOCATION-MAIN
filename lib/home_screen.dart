import 'package:flutter/material.dart';
import 'kanban_board.dart';
import 'calendar_section.dart';
import 'todolist_section.dart';
import 'settings_section.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isCheckedIn = false;
  bool _isCheckedOut = false;
  bool _hasPressedAttendance = false;
  bool _hasPressedCheckout = false;
  DateTime? _checkInTime;
  DateTime? _checkOutTime;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D98BA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 1,
        title: const Text(
          'FDSASYA PHILIPPINES INC',
          style: TextStyle(
            fontFamily: 'CustomFont',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD0D0D0),
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFD0D0D0)),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF1C1C1E),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF2C2C2E)),
              child: const Center(
                child: Text(
                  'Welcome',
                  style: TextStyle(
                    color: Color(0xFFD0D0D0),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.calendar_today,
              label: 'Calendar',
              context: context,
              destination: CalendarSection(),
            ),
            _buildDrawerItem(
              icon: Icons.list,
              label: 'To-Do List',
              context: context,
              destination: ToDoListSection(),
            ),
            _buildDrawerItem(
              icon: Icons.view_kanban,
              label: 'Kanban Board',
              context: context,
              destination: KanbanBoard(),
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              label: 'Settings',
              context: context,
              destination: SettingsSection(),
            ),
            _buildDrawerItem(
              icon: Icons.logout,
              label: 'Logout',
              context: context,
              onTap: () => Navigator.pushReplacementNamed(context, '/'),
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/startupbg2.png',
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 20),
                  _buildProfileInfo(),
                  const SizedBox(height: 20),
                  _buildPerformanceOverview(),
                  const SizedBox(height: 20),
                  _buildActivityFeed(),
                  const SizedBox(height: 20),
                  _buildTeamMembers(),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 120,
            right: 180,
            child: Column(
              children: [
                // New outer container wrapping both checkboxes
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF004C4C), // Outer container color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // Check-in container
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF008080),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Mark Check in: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            if (!_isCheckedIn)
                              Checkbox(
                                value: _isCheckedIn,
                                activeColor: const Color(0xFF800000),
                                checkColor: Colors.white,
                                onChanged: _hasPressedAttendance
                                    ? null
                                    : (bool? value) {
                                  if (value != null && !_isCheckedIn) {
                                    _saveAttendanceStatus(value);
                                  }
                                },
                              ),
                            if (_isCheckedIn)
                              const Text(
                                'Check in Approved',
                                style: TextStyle(
                                  color: Colors.lightGreenAccent,
                                  fontSize: 18,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (_checkInTime != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'Checked in at: ${_checkInTime.toString()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      // Check-out container (only visible after check-in)
                      if (_isCheckedIn)
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF008080),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Mark Check out: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              if (!_isCheckedOut)
                                Checkbox(
                                  value: _isCheckedOut,
                                  activeColor: const Color(0xFF800000),
                                  checkColor: Colors.white,
                                  onChanged: _isCheckedIn && !_hasPressedCheckout
                                      ? (bool? value) {
                                    if (value != null && !_isCheckedOut) {
                                      _saveCheckoutStatus(value);
                                    }
                                  }
                                      : null, // Disable checkout until check-in
                                ),
                              if (_isCheckedOut)
                                const Text(
                                  'Check out Approved',
                                  style: TextStyle(
                                    color: Colors.lightGreenAccent,
                                    fontSize: 18,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      if (_checkOutTime != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'Checked out at: ${_checkOutTime.toString()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required BuildContext context,
    Widget? destination,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFB0B0B0)),
      title: Text(
        label,
        style: const TextStyle(color: Color(0xFFD0D0D0)),
      ),
      onTap: onTap ??
              () {
            Navigator.pop(context);
            if (destination != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destination),
              );
            }
          },
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'My Dashboard',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: Color(0xFF5A5A5A)),
          onPressed: () {
            // Add edit functionality here
          },
        ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Card(
      color: const Color(0xFF1C1C1E), // Dark silvery background
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF3A3A3C), // Subtle border
                  backgroundImage: const AssetImage(
                      'assets/profile_picture.png'), // Placeholder image
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD0D0D0), // Silvery text color
                      ),
                    ),
                    Text(
                      'john.doe@example.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9A9A9A), // Subtle silvery-grey text
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(
              color: Color(0xFF3A3A3C), // Dark divider
              thickness: 1,
            ),
            const SizedBox(height: 10),
            const Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFFD0D0D0), // Silvery text color
              ),
            ),
            const SizedBox(height: 10),
            _buildProfileDetailRow(Icons.date_range, 'Member since: January 2022'),
            _buildProfileDetailRow(Icons.badge, 'Position: Associate'),
            _buildProfileDetailRow(Icons.location_on, 'Location: City, Country'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFB0B0B0)), // Silvery icon
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFD0D0D0), // Silvery text color
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceOverview() {
    return Card(
      color: const Color(0xFF1C1C1E), // Dark card
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          'Performance Overview (e.g., graphs or stats)',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFD0D0D0),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityFeed() {
    return Card(
      color: const Color(0xFF1C1C1E), // Dark card
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          'Activity Feed (e.g., notifications or updates)',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFD0D0D0),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMembers() {
    return Card(
      color: const Color(0xFF1C1C1E), // Dark card
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          'Team Members (e.g., profile pictures and names)',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFD0D0D0),
          ),
        ),
      ),
    );
  }
}
