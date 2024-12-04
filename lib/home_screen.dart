import 'package:check_loc/features/Otherfeatures.dart';
import 'package:flutter/material.dart';
import 'features/calendar_section.dart';
// import 'settings_section.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChartData {
  ChartData(this.task, this.value);
  final String task;
  final double value;
}
class MoodTracker extends StatefulWidget {
  @override
  _MoodTrackerState createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  final List<String> moods = ["😄", "😐", "😞"]; // Emojis representing moods
  String? selectedMood;
  List<String> moodHistory = [];
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadMoodHistory();
  }

  // Load mood history from shared preferences
  Future<void> _loadMoodHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      moodHistory = prefs.getStringList(currentDate) ?? [];
    });
  }

  // Save the selected mood to shared preferences
  Future<void> _saveMood(String mood) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Limit mood history to 5 items for the current day
    if (moodHistory.length < 5) {
      moodHistory.add(mood); // Add the new mood
      await prefs.setStringList(currentDate, moodHistory);
    }
  }

  // Handle mood selection
  void _onMoodSelected(String mood) {
    if (moodHistory.length < 5) {
      setState(() {
        selectedMood = mood;
      });
      _saveMood(mood);
    } else {
      // Show a message if the limit is reached
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You can only select up to 5 moods per day."),
        ),
      );
    }
  }

@override
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return AspectRatio(
        aspectRatio: 16 / 9, // Set the aspect ratio to 16:9
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "How do you feel today?",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: moods.map((mood) {
                  return GestureDetector(
                    onTap: () => _onMoodSelected(mood),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        mood,
                        style: TextStyle(fontSize: 48),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 3),
              if (selectedMood != null)
                Text(
                  "You selected: $selectedMood",
                  style: TextStyle(fontSize: 20),
                ),
              SizedBox(height: 3),
              Text(
                "Mood History:",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 3),
              // Display mood history in a row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: moodHistory.map((mood) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      mood,
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
    },
  );
  }
}
  


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isCheckedIn = true; // Start as checked-in
  bool _isCheckedOut = false;
  bool _hasPressedAttendance = true; // Considered already checked-in
  bool _hasPressedCheckout = false;
  DateTime? _checkInTime;
  DateTime? _checkOutTime;

  @override
  void initState() {
    super.initState();
    // Automatically set the check-in state after logging in
    _isCheckedIn = true;
    _hasPressedAttendance = true;
    _checkInTime = DateTime.now();
  }

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
    backgroundColor: const Color(0xFF2A2A2A),
    body: Row(
      children: [
        // Navigation Drawer
        _buildNavigationDrawer(),
        // Main Content Area
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileInfo(),
                  const SizedBox(height: 16),
                  _buildKanbanBoard(),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildAttendanceSystem()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildCalendar()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

bool _isDrawerOpen = false;

Widget _buildNavigationDrawer() {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < 500) {
        // Mobile view: show as a drawer with a clickable button to unhide
        return Column(
          children: [
            Container(
              height: 50,
              color: const Color(0xFF363636),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      setState(() {
                        _isDrawerOpen = !_isDrawerOpen;
                      });
                    },
                  ),
                  Text('Navigation'),
                ],
              ),
            ),
            _isDrawerOpen
                ? Drawer(
                    child: Container(
                      color: const Color(0xFF363636),
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
                                    'Welcome, John!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _buildDrawerItem(Icons.calendar_today, 'Calendar', CalendarSection()),
                          // _buildDrawerItem(Icons.settings, 'Settings', SettingsSection()),
                          _buildDrawerItem(Icons.settings, 'Other Features', OtherFeatures()),
                          _buildDrawerItem(Icons.logout, 'Logout', null, isLogout: true),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        );
      } else {
        // Desktop view: show as a navigation bar
        return Container(
          width: 280,
          color: const Color(0xFF363636),
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
                        'Welcome, John!',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              _buildDrawerItem(Icons.calendar_today, 'Calendar', CalendarSection()),
              // _buildDrawerItem(Icons.settings, 'Settings', SettingsSection()),
              _buildDrawerItem(Icons.settings, 'Other Features', OtherFeatures()),
              _buildDrawerItem(Icons.logout, 'Logout', null, isLogout: true),
            ],
          ),
        );
      }
    },
  );
}


  Widget _buildDrawerItem(IconData icon, String label, Widget? destination,
      {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFB0B0B0)),
      title: Text(
        label,
        style: const TextStyle(color: Color(0xFFE0E0E0)),
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

Widget _buildProfileInfo() {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: constraints.maxWidth * 1, // Set the width to 100% of the screen width
          height: 200, // Set the height to a fixed value
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF707070), Color(0xFF4A4A4A)],
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 45, // Set the radius to 45
                backgroundImage: AssetImage('assets/profile_picture.png'),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'john.doe@example.com',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Role: Employee',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
  Widget _buildKanbanBoard() {
    // Clear the task lists
    List<String> Tasksprogress = []; // Empty list for Wishlist
    List<String> Quotes = []; // Empty list for Doing
    List<String> Mood = []; // Empty list for Finished

    // Sample data for the chart
    List<ChartData> chartData = [
      ChartData('Unfinished', 10),
      ChartData('Finished', 20),
    ];

    // List of quotes
    List<String> quotes = [
      "The only way to do great work is to love what you do. - Steve Jobs",
      "Success is not the key to happiness. Happiness is the key to success. - Albert Schweitzer",
      "Don't watch the clock; do what it does. Keep going. - Sam Levenson",
      "The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
      "You are never too old to set another goal or to dream a new dream. - C.S. Lewis",
      "Act as if what you do makes a difference. It does. - William James",
      "Success usually comes to those who are too busy to be looking for it. - Henry David Thoreau",
      "Opportunities don't happen. You create them. - Chris Grosser",
      "I find that the harder I work, the more luck I seem to have. - Thomas Jefferson",
      "The only limit to our realization of tomorrow will be our doubts of today. - Franklin D. Roosevelt"
    ];


    // Get the current date and use it to select a quote
    int currentDay = DateTime.now().day;
    String dailyQuote = quotes[currentDay % quotes.length]; // Select a quote based on the day

Widget buildChart() {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Container(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: FittedBox(
          child: SfCartesianChart(
            title: ChartTitle(text: 'Task Distribution'),
            primaryXAxis: CategoryAxis(
              minimum: 0,
              maximum: chartData.length - 1,
            ),
            primaryYAxis: NumericAxis(
              minimum: chartData.map((data) => data.value).reduce((a, b) => a < b ? a : b),
              maximum: chartData.map((data) => data.value).reduce((a, b) => a > b ? a : b),
            ),
            series: <CartesianSeries>[
              ColumnSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.task,
                yValueMapper: (ChartData data, _) => data.value,
              )
            ],
            margin: EdgeInsets.zero, // Remove the default margin
            plotAreaBorderWidth: 0, // Remove the default plot area border
          ),
        ),
      );
    },
  );
}

    Widget buildKanbanColumn(String title, List<String> tasks) {
      return Expanded(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6, // Set the height to 60% of the screen height
            width: (MediaQuery.of(context).size.width - 24) / 3, // Set the width to 1/3 of the screen width minus 24 pixels for padding
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF707070), Color(0xFF4A4A4A)],
              ),
            ),
            child: SingleChildScrollView( // Allow scrolling within each column
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (title == 'Task Progress') // Insert chart in Task Progress column
                    SizedBox(
                      height: (MediaQuery.of(context).size.height * 0.6) - 100, // Give it a specific height
                      child: buildChart(),
                    ),
                  if (title == 'Quotes') // Display the quote in the Quotes column
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(
                        child: Text(
                          dailyQuote,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  if (title == 'Mood') // Add Mood Tracker in Finished column
                    Container(
                      child: SingleChildScrollView(
                        child: MoodTracker(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width, // Set the width to the screen width
        child: Row(
          children: [
            Expanded(
              child: buildKanbanColumn('Task Progress', Tasksprogress),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: buildKanbanColumn('Quotes', Quotes),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: buildKanbanColumn('Mood', Mood),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildAttendanceSystem() {
    // Format for Date (MM/DD/YY)
    String formatDate(DateTime dateTime) {
      return DateFormat('MM/dd/yy').format(dateTime);
    }

    // Format for Time (12-hour format with AM/PM)
    String formatTime(DateTime dateTime) {
      return DateFormat('hh:mm a').format(dateTime); // 12-hour format with AM/PM
    }

    return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Container(
      constraints: BoxConstraints(
        minHeight: 300, // Minimum height
        minWidth: 300, // Minimum width
        maxHeight: 600, // Maximum height
        maxWidth: 800, // Maximum width
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF707070), Color(0xFF4A4A4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Attendance System',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Implement Log History navigation or function
                  Navigator.pushNamed(context, '/logHistory'); // Example route
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8), // Adjust padding
                ),
                child: const Text(
                  'Log History',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _isCheckedIn
                      ? 'Log In: ${formatDate(_checkInTime!)} at ${formatTime(_checkInTime!)}'
                      : 'Not Log In',
                  style: TextStyle(
                    color: _isCheckedIn ? Colors.green : Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: !_hasPressedAttendance
                    ? () {
                  _saveAttendanceStatus(true);
                  setState(() {
                    _isCheckedIn = true;
                    _checkInTime = DateTime.now();
                    _hasPressedAttendance = true; // Disable button
                  });
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  _hasPressedAttendance ? Colors.blueGrey : Colors.white,
                ),
                child: Text(
                  !_hasPressedAttendance ? 'Log in' : 'Log In Approved',
                  style: TextStyle(
                    color: !_hasPressedAttendance ? Colors.black : Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _isCheckedOut
                      ? 'Log Out: ${formatDate(_checkOutTime!)} at ${formatTime(_checkOutTime!)}'
                      : 'Logging Out?',
                  style: TextStyle(
                    color: _isCheckedOut ? Colors.green : Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: !_hasPressedCheckout
                    ? () {
                  _saveCheckoutStatus(true);
                  setState(() {
                    _isCheckedOut = true;
                    _checkOutTime = DateTime.now();
                    _hasPressedCheckout = true; // Disable button
                  });
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  _hasPressedCheckout ? Colors.blueGrey : Colors.white,
                ),
                child: Text(
                  !_hasPressedCheckout ? 'Log Out' : 'Log Out Approved',
                  style: TextStyle(
                    color: !_hasPressedCheckout ? Colors.black : Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


Widget _buildCalendar() {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Container(
      constraints: BoxConstraints(
        minHeight: 300, // Set the minimum height to 300
        minWidth: 300, // Set the minimum width to 300
        maxHeight: 600, // Set the maximum height to 600
        maxWidth: 800, // Set the maximum width to 800
      ),
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF707070), Color(0xFF4A4A4A)]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6, // Set the height to 60% of the screen
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                selectedDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                defaultTextStyle: const TextStyle(color: Colors.white, fontSize: 12),
                weekendTextStyle: const TextStyle(color: Colors.white, fontSize: 12),
                outsideTextStyle: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
                leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white, size: 16),
                rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white, size: 16),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.white, fontSize: 10),
                weekendStyle: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
  


