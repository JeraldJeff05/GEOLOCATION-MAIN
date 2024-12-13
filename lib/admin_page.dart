import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
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

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 2);
  int _currentPage = 2;
  late AnimationController _animationController;

  final List<String> _pageTitles = [
    'Employees Log',
    'Geofencing',
    'Clock',
    'Change Geofence',
    'Register',
  ];

  final List<IconData> _pageIcons = [
    Icons.people_outline,
    Icons.location_on_outlined,
    Icons.access_time_outlined,
    Icons.move_up_outlined,
    Icons.app_registration_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _pageController.addListener(() {
      final newPage = _pageController.page?.round();
      if (newPage != null && _currentPage != newPage) {
        setState(() {
          _currentPage = newPage;
        });
        _animationController.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
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
              return Animate(
                effects: [
                  ScaleEffect(
                    begin: Offset.zero, // Use Offset.zero for the initial scale
                    end: const Offset(
                        1, 1), // Use Offset(1, 1) for the final scale
                    duration: 300.ms,
                  ),
                  FadeEffect(
                    begin: 0.5,
                    end: 1.0,
                    duration: 300.ms,
                  ),
                ],
                child: Transform.scale(
                  scale: scale,
                  child: GlassmorphicContainer(
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: 12,
                    blur: 20,
                    alignment: Alignment.bottomCenter,
                    border: 2,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ],
                      stops: const [0.1, 1],
                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    child: _getActiveFeature(_pageTitles[index]),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Animate(
                effects: [
                  SlideEffect(
                    begin: const Offset(-0.1, 0),
                    end: Offset.zero,
                    duration: 300.ms,
                  ),
                  FadeEffect(duration: 300.ms),
                ],
                child: QuoteOfTheDay(),
              ),
            ),
            Expanded(
              child: Animate(
                effects: [
                  SlideEffect(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                    duration: 300.ms,
                  ),
                  FadeEffect(duration: 300.ms),
                ],
                child: NewsFeature(),
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
      backgroundColor: Colors.black87,
      drawer: _buildNavigationDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile =
              constraints.maxWidth < 1260 || constraints.maxHeight < 700;
          bool isTablet =
              (constraints.maxWidth >= 1100 && constraints.maxWidth < 1260) ||
                  (constraints.maxHeight >= 700 && constraints.maxHeight < 400);

          if (isMobile) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black87,
                    Colors.black54,
                    Colors.black87.withOpacity(0.8),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Animate(
                      effects: [
                        FadeEffect(duration: 500.ms),
                        ScaleEffect(
                          begin: const Offset(0.7, 0.7),
                          // Use Offset(0.7, 0.7) for the initial scale
                          end: const Offset(1.0, 1.0),
                          // Use Offset(1.0, 1.0) for the final scale
                          duration: 500.ms,
                        ),
                      ],
                      child: Text(
                        TimeOfDay.now().format(context),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Animate(
                      effects: [
                        FadeEffect(delay: 200.ms, duration: 500.ms),
                        SlideEffect(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                          duration: 500.ms,
                        ),
                      ],
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(DateTime.now()),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "We Listen, We Anticipate, We Deliver",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white54,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Small Screen Is Currently Not Supported",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

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
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.black87,
                                Colors.blueGrey.shade900,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.only(right: 16),
                          child: _buildAdminFeatures(),
                        ),
                      ),
                      Expanded(
                        child: Animate(
                          effects: [
                            SlideEffect(
                              begin: const Offset(0.1, 0),
                              end: Offset.zero,
                              duration: 300.ms,
                            ),
                            FadeEffect(duration: 300.ms),
                          ],
                          child: CorporateDashboard(),
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
    return GlassmorphicContainer(
      width: double.infinity,
      height: 80,
      borderRadius: 12,
      blur: 10,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.1),
          Colors.white.withOpacity(0.05),
        ],
        stops: const [0.1, 1],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.5),
          Colors.white.withOpacity(0.1),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 35,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.firstName} ${widget.lastName}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
              ),
              Text(
                'FDS ASYA PHILIPPINES INC',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black87,
            Colors.blueGrey.shade900,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentPage,
        onTap: (index) {
          setState(() {
            _currentPage = index;
            _pageController.jumpToPage(index);
          });
        },
        items: List.generate(_pageTitles.length, (index) {
          return BottomNavigationBarItem(
            icon: Icon(_pageIcons[index], color: Colors.white),
            activeIcon: Icon(
              _pageIcons[index],
              color: Colors.white,
              size: 30,
            ),
            label: _pageTitles[index],
            backgroundColor: Colors.black87,
          );
        }),
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
      ),
    );
  }

  Widget _buildOptionsBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black87,
            Colors.black54,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.white.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _pageIcons[index],
                      color:
                          _currentPage == index ? Colors.white : Colors.white54,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _pageTitles[index],
                      style: TextStyle(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white54,
                        fontWeight: _currentPage == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavigationDrawer() {
    return Drawer(
      backgroundColor: Colors.black,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black87,
              Colors.blueGrey.shade900,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
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
              decoration: const BoxDecoration(
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
              title:
                  const Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
