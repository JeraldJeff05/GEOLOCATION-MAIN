import 'package:flutter/material.dart';
import 'admin/employees_log.dart';
import 'admin/geofencing.dart';
import 'admin/clock.dart';
import 'admin/register.dart';
import 'admin/move_geofence.dart';
import 'admin/corporate_dashboard.dart';
import 'admin/quote_of_the_day.dart';
import 'admin/news_feature.dart';
import 'package:intl/intl.dart';
import 'admin/info_devs.dart';

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
    'Clock',
    'Change Geofence',
    'Register',
  ];

  @override
  void initState() {
    super.initState();
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
    _pageController.dispose();
    super.dispose();
  }

  Widget _getActiveFeature(String title) {
    switch (title) {
      case 'Employees Log':
        return EmployeesLogWidget();
      case 'Geofencing':
        return const GeofencingWidget();
      case 'Clock':
        return const ClockWidget();
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
        _buildHeader(false),
        const SizedBox(height: 20),
        _buildOptionsBar(),
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
                    color: Colors.black,
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
        Row(
          children: [
            Expanded(child: QuoteOfTheDay()),
            Expanded(child: NewsFeature()),
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
          bool isMobile =
              constraints.maxWidth < 1000 || constraints.maxHeight < 500;
          bool isTablet =
              constraints.maxWidth >= 1000 && constraints.maxWidth < 1000 ||
                  constraints.maxHeight >= 500 && constraints.maxHeight < 1500;

          if (isMobile) {
            // Center the message and time for small screens
            return Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${TimeOfDay.now().format(context)}", // Displays the current time without seconds
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${DateFormat('yyyy-MM-dd').format(DateTime.now())}", // Displays the current date and time with seconds
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "We Listen, We Anticipate, We Deliver",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Small Screen Is Currently Not Supported",
                      style: TextStyle(fontSize: 16, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // Default layout for larger screens
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
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: _buildAdminFeatures(),
                        ),
                      ),
                      Expanded(child: CorporateDashboard()),
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
          bool isMobile = constraints.maxWidth < 0;
          return isMobile
              ? _buildBottomNavigationBar()
              : const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment:
            isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: isMobile ? 25 : 30,
            backgroundColor: Colors.black,
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
                    color: Colors.white,
                  ),
                ),
                Text(
                  'FDS ASYA PHILIPPINES INC',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
        ],
      ),
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
          icon: const Icon(Icons.circle, color: Colors.white),
          label: title,
        );
      }).toList(),
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[400],
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
              color: _currentPage == index ? Colors.grey[800] : Colors.black,
              child: Center(
                child: Text(
                  _pageTitles[index],
                  style: const TextStyle(color: Colors.white),
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
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Center(
              child: Text(
                '${widget.firstName} ${widget.lastName}',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white),
            title: const Text('info', style: TextStyle(color: Colors.white)),
            onTap: () {
              NamesList();
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.white),
            title: const Text('Logout', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
