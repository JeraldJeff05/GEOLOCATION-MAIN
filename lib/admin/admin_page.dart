import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final PageController _pageController = PageController(
    initialPage: 2, // Set the initial page to "Calendar"
    viewportFraction:
        0.8, // Makes the current page smaller and the next one peeks
  );
  int _currentPage = 2; // Start at "Calendar" page

  final List<String> _pageTitles = [
    'Employees Log',
    'Geofencing',
    'Calendar',
    'Attendance',
  ];

  @override
  void initState() {
    super.initState();
    // Adding a listener to update the current page index
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
          // Check if the screen width is small (e.g., mobile)
          bool isMobile = constraints.maxWidth < 600;

          return Row(
            children: [
              // The Drawer is now a persistent sidebar for larger screens
              if (!isMobile)
                Container(
                  width: 250, // Fixed width for the drawer on larger screens
                  child: _buildNavigationDrawer(),
                ),
              // Main content is pushed to the right side of the screen
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Info Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.black.withOpacity(0.8),
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
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Admin Name',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'admin@company.com',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Container Box for Sections with Swiping
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount:
                              _pageTitles.length * 1000, // Infinite pages
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            int actualIndex = index % _pageTitles.length;
                            return _buildPage(
                              _pageTitles[actualIndex],
                              Colors.grey.withOpacity(0.8),
                            );
                          },
                        ),
                      ),

                      // Page indicator (dots) at the bottom to show page navigation
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_pageTitles.length, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              height: 10,
                              width: _currentPage % _pageTitles.length == index
                                  ? 20
                                  : 10,
                              decoration: BoxDecoration(
                                color:
                                    _currentPage % _pageTitles.length == index
                                        ? Colors.black
                                        : Colors.grey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            );
                          }),
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
    );
  }

  // Function to build each page section with the text and color
  Widget _buildPage(String title, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10), // For the 3D effect
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[800]!,
            Colors.grey[600]!
          ], // 3D effect with a gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15), // Rounded corners for 3D feel
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.5), // Darker shadow for a floating effect
            spreadRadius: 3,
            blurRadius: 10,
            offset:
                const Offset(4, 4), // Slightly offset shadow to create depth
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  // Build the side navigation drawer
  Widget _buildNavigationDrawer() {
    return Drawer(
      child: Container(
        color: const Color(0xFF1A1A1A), // Dark grey background
        child: Column(
          children: [
            Container(
              height: 150,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF555555), Color(0xFF3B3B3B)],
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
                      'Welcome, Admin!',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white),
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

  // Drawer item widget
  Widget _buildDrawerItem(IconData icon, String label, Widget? destination,
      {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[400]),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
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
