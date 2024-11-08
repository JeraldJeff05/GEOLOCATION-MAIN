import 'package:flutter/material.dart';
import 'kanban_board.dart'; // Import Kanban Board
import 'calendar_section.dart';
import 'todolist_section.dart';
import 'settings_section.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F), // Dark silvery app bar
        elevation: 1,
        title: const Text(
          'FDSASYA PHILIPPINES INC',
          style: TextStyle(
            fontFamily: 'CustomFont',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD0D0D0), // Silvery text color
          ),
        ),
        centerTitle: true,
        iconTheme:
            const IconThemeData(color: Color(0xFFD0D0D0)), // Silvery icon
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF1C1C1E), // Dark drawer background
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF2C2C2E)),
              child: const Center(
                child: Text(
                  'Welcome',
                  style: TextStyle(
                    color: Color(0xFFD0D0D0), // Silvery text color
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
      body: SingleChildScrollView(
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
      leading: Icon(icon, color: const Color(0xFFB0B0B0)), // Silvery icon
      title: Text(
        label,
        style: const TextStyle(color: Color(0xFFD0D0D0)), // Silvery text
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
            color: Color(0xFFD0D0D0), // Silvery text color
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: Color(0xFF5A5A5A)), // Subtle icon
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
                      'assets/profile_picture.png'), // Replace with actual profile image path
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
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
            _buildProfileDetailRow(
                Icons.date_range, 'Member since: January 2022'),
            _buildProfileDetailRow(Icons.badge, 'Position: Associate'),
            _buildProfileDetailRow(
                Icons.location_on, 'Location: City, Country'),
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
