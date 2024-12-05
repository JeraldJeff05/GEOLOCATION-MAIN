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
  final PageController _pageController = PageController(initialPage: 2);
  int _currentPage = 2;

  final List<String> _pageTitles = [
    'Employees Log',
    'Geofencing',
    'Calendar',
    'Change Geofence',
    'Register',
  ];

  @override
  void initState() {
    super.initState();
    // Listen to page changes
    _pageController.addListener(() {
      final newPage = _pageController.page?.round();
      if (newPage != null && _currentPage != newPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });
  }

  @override
  void dispose() {
    // Dispose the controller to prevent memory leaks
    _pageController.dispose();
    super.dispose();
  }

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

  Widget _buildAdminFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Header
        _buildHeader(
            false), // You can use false here to indicate it's not a mobile view
        const SizedBox(height: 20),
        _buildOptionsBar(), // Bar above the features
        const SizedBox(height: 20),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: _pageTitles.length,
            itemBuilder: (context, index) {
              double scale = _currentPage == index ? 1.0 : 0.9;
              return Transform.scale(
                scale: scale,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: _getActiveFeature(_pageTitles[index]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        // Adding the two containers for 'Other Features' and 'News Features'
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quote Of the Day',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Add your additional features here
                    TextButton(
                      onPressed: () {
                        // Add action for other feature
                      },
                      child: const Text('Feature 1'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'News Features',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Add your news features here
                    TextButton(
                      onPressed: () {
                        // Add action for news feature
                      },
                      child: const Text('News Feature 1'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildNavigationDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;
          bool isTablet =
              constraints.maxWidth >= 600 && constraints.maxWidth < 1024;

          return Row(
            children: [
              if (!isMobile)
                SizedBox(
                  width: isTablet ? 200 : 250,
                  child: _buildNavigationDrawer(),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Admin Features container
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: _buildAdminFeatures(),
                        ),
                      ),
                      // Other Features container
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Long Features Here',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Add your additional features here
                              TextButton(
                                onPressed: () {
                                  // Add action for other feature
                                },
                                child: const Text('Feature 1'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Add action for other feature
                                },
                                child: const Text('Feature 2'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;
          return isMobile
              ? _buildBottomNavigationBar()
              : const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      mainAxisAlignment:
          isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: isMobile ? 25 : 30,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person,
            color: Colors.black,
            size: isMobile ? 35 : 40,
          ),
        ),
        if (!isMobile) const SizedBox(width: 16),
        if (!isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.firstName} ${widget.lastName}',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'FDS ASYA PHILIPPINES INC',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentPage,
      onTap: (index) {
        setState(() {
          _currentPage = index;
          _pageController.jumpToPage(index);
        });
      },
      items: _pageTitles.map((title) {
        return BottomNavigationBarItem(
          icon: const Icon(Icons.circle),
          label: title,
        );
      }).toList(),
    );
  }

  Widget _buildOptionsBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
                color: _currentPage == index ? Colors.black : Colors.grey[400],
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
    );
  }

  Widget _buildNavigationDrawer() {
    return Drawer(
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
                    'Welcome, ${widget.lastName}',
                    style: const TextStyle(
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
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, Widget? destination,
      {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(label, style: const TextStyle(color: Colors.black)),
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
