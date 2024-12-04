import 'package:flutter/material.dart';
import 'admin/employees_log.dart';
import 'admin/geofencing.dart';
import 'admin/calendar.dart';
import 'admin/register.dart';
import 'admin/move_geofence.dart';

class AdminPage extends StatefulWidget {
  final String? firstName;
  final String? lastName;

  const AdminPage({super.key, this.firstName, this.lastName});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final PageController _pageController = PageController(
    initialPage: 2, // Set the initial page to "Calendar"
    viewportFraction: 0.85, // Adjust to show parts of adjacent pages
  );
  int _currentPage = 2;

  final List<String> _pageTitles = [
    'Employees Log',
    'Geofencing',
    'Calendar',
    'Change Geofence',
    'Register',
  ];

  Widget _getActiveFeature(String title) {
    switch (title) {
      case 'Employees Log':
        return EmployeesLogWidget();
      case 'Geofencing':
        return const GeofencingWidget();
      case 'Calendar':
        return const CalendarWidget();
      case 'Change Geofence':
        return InputPointsScreen();
      case 'Register':
        return const AttendanceWidget();
      default:
        return const Center(child: Text('Unknown Section!'));
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildNavigationDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

          return Row(
            children: [
              if (!isMobile)
                SizedBox(
                  width: 250,
                  child: _buildNavigationDrawer(),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildOptionsBar(),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Expanded(
                              child: PageView.builder(
                                controller: _pageController,
                                physics: const BouncingScrollPhysics(),
                                itemCount: _pageTitles.length,
                                itemBuilder: (context, index) {
                                  double scale = _currentPage == index
                                      ? 1.0
                                      : 0.9; // Scale adjacent pages
                                  return Transform.scale(
                                    scale: scale,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                      child:
                                          _getActiveFeature(_pageTitles[index]),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildPageIndicator(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOptionsBar() {
    return Container(
      width: double.infinity,
      height: 50,
      color: Colors.black.withOpacity(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the options
        children: List.generate(_pageTitles.length, (index) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentPage = index;
                  _pageController.jumpToPage(index);
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      _currentPage == index ? Colors.black : Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  _pageTitles[index],
                  style: TextStyle(
                    color:
                        _currentPage == index ? Colors.white : Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black.withOpacity(0.9),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Colors.black,
              size: 40,
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.firstName} ${widget.lastName}', // Display first and last name
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'FDS ASYA PHILIPPINES INC', // You can replace this with a dynamic email if necessary
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_pageTitles.length, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            height: 10,
            width: 200,
            decoration: BoxDecoration(
              color: _currentPage % _pageTitles.length == index
                  ? Colors.black
                  : Colors.grey[600],
              borderRadius: BorderRadius.circular(5),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavigationDrawer() {
    return Drawer(
      child: Container(
        color: const Color(0xFF1A1A1A),
        child: Column(
          children: [
            Container(
              height: 150,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF333333), Color(0xFF222222)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 30, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Welcome, ${widget.lastName}', // Display first and last name
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildDrawerItem(Icons.home, 'Home', null),
            _buildDrawerItem(Icons.settings, 'Settings', null),
            _buildDrawerItem(Icons.logout, 'Logout', null, isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, Widget? destination,
      {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: () {
        if (isLogout) {
          Navigator.pushReplacementNamed(context, '/');
        } else if (destination != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => destination));
        }
      },
    );
  }
}
