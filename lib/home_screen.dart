import 'package:check_loc/features/Otherfeatures.dart';
import 'package:check_loc/features/archive_page.dart';
import 'package:flutter/material.dart';
import 'features/calendar_section.dart';
// import 'settings_section.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/archive_page.dart';

class ChartData {
  final String task;
  final double value;
  final DateTime date;

  ChartData(this.task, this.value, this.date);

  // Modify the factory constructor to accept the date parameter
  factory ChartData.withDefaultDate(String task, double value, DateTime date) {
    return ChartData(task, value, date); // Use the provided date
  }
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
    return SingleChildScrollView(
      // Wrap the Column in a SingleChildScrollView
      child: Column(
        children: [
          Text(
            "How do you feel today?",
            style: TextStyle(
                fontSize: 20, color: Colors.white), // Set text color to white
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
                    style: TextStyle(
                        fontSize: 48,
                        color: Colors.white), // Set text color to white
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 3),
          if (selectedMood != null)
            Text(
              "You selected: $selectedMood",
              style: TextStyle(
                  fontSize: 20, color: Colors.white), // Set text color to white
            ),
          SizedBox(height: 3),
          Text(
            "Mood History:",
            style: TextStyle(
                fontSize: 15, color: Colors.white), // Set text color to white
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
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white), // Set text color to white
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _selectedDay;
  bool _isAttendanceApproved = false; // Track attendance approval

  Map<DateTime, List<Map<String, dynamic>>> _tasks = {};
  Map<DateTime, List<String>> _finishedTasks = {};

  @override
  void initState() {
    super.initState();
    // Show the attendance dialog after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAttendanceDialog();
    });
  }

  void _showAttendanceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Checking your Attendance"),
          content: Text("Please wait for the approval"),
          backgroundColor:
              Colors.green[100], // Set the background color to light green
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the button
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isAttendanceApproved =
                          true; // Mark attendance as approved
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text("OK"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _onTasksUpdated(DateTime selectedDay, List<Map<String, dynamic>> tasks,
      List<String> finishedTasks) {
    setState(() {
      _selectedDay = selectedDay;
      _tasks[selectedDay] = tasks;
      _finishedTasks[selectedDay] = finishedTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF153549),
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'bluebg.jpg', // Add the correct path to your image
                fit: BoxFit.cover, // Adjust the image's fit as necessary
              ),
            ),
            // Main Content Area
            Row(
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
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationDrawer() {
    return Container(
      width: 280,
      color: Color(0xff28658a),
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF000814),
                  Color(0xFF001d3d),
                  Color(0xFF003566)
                ],
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
          _buildDrawerItem(Icons.note, 'Other Features', OtherFeatures(),
              isDisabled: !_isAttendanceApproved),
          _buildDrawerItem(
              Icons.calendar_today,
              'Calendar',
              CalendarSection(
                onTasksUpdated: _onTasksUpdated,
                onBarChartUpdate: (date, chartData) {
                  // Handle bar chart update if needed
                },
              )),
          _buildArchiveButton(), // Adding the Archive button here
          _buildDrawerItem(Icons.logout, 'Logout', null, isLogout: true),
        ],
      ),
    );
  }

  Widget _buildArchiveButton() {
    return ListTile(
      leading: Icon(Icons.archive, color: const Color(0xFFB0B0B0)),
      title: Text(
        'Archive',
        style: const TextStyle(color: Color(0xFFE0E0E0)),
      ),
      onTap: () {
        // Convert finishedTasks to the expected format
        Map<DateTime, List<Map<String, dynamic>>> formattedFinishedTasks = {};

        _finishedTasks.forEach((date, tasks) {
          formattedFinishedTasks[date] = tasks.map((task) {
            // Assuming the String task only contains the task text, you can structure it like this
            return {
              'text': task,
              'completedAt': DateTime.now().toIso8601String(), // Replace with actual completion time
            };
          }).toList();
        });

        // Navigate to the ArchivePage and pass formattedFinishedTasks
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArchivePage(finishedTasks: formattedFinishedTasks),
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, Widget? destination,
      {bool isLogout = false, bool isDisabled = false}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFB0B0B0)),
      title: Text(
        label,
        style: const TextStyle(color: Color(0xFFE0E0E0)),
      ),
      onTap: isDisabled
          ? null
          : () {
              if (isLogout) {
                _showLogoutConfirmationDialog(); // Show logout confirmation dialog
              } else if (destination != null) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => destination));
              }
            },
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Log Out"),
          content: Text("Do you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Handle the logout logic here
                _logout();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Log Out"),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    // Perform logout operations, such as clearing user data or navigating to the login screen
    Navigator.of(context)
        .pushReplacementNamed('/'); // Navigate to the login screen
  }

  Widget _buildProfileInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000814), Color(0xFF001d3d), Color(0xFF003566)],
          ),
        ),
        child: Stack(
          // Use Stack to overlay the date/time
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'assets/profile_picture.png'), // Ensure this image exists in your assets
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
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'john.doe@example.com',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Role: Employee',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 16, // Adjust this value to position the text
              right: 16, // Adjust this value to position the text
              child: Text(
                'Log In at : '
                '${DateFormat('MM/dd/yy ').format(DateTime.now())} ${DateFormat('hh:mm a').format(DateTime.now())}', // Format the date and time
                style: const TextStyle(
                  color: Color(0xFF70e000), // Set text color to green
                  fontSize: 14, // Set font size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKanbanBoard() {
    // Clear the task lists
    List<String> tasksProgress = []; // Empty list for Task Progress
    List<String> quotes = []; // Empty list for Quotes
    List<String> mood = []; // Empty list for Mood

    // Get the count of unfinished and finished tasks for the selected day
    int unfinishedCount = _tasks[_selectedDay]
            ?.where((task) => task['completed'] == false)
            .length ??
        0;
    int finishedCount = _finishedTasks[_selectedDay]?.length ?? 0;

    // Sample data for the chart
    List<ChartData> chartData = [
      ChartData.withDefaultDate(
        'Unfinished',
        unfinishedCount.toDouble(),
        _selectedDay ??
            DateTime
                .now(), // Use the current date as a fallback if _selectedDay is null
      ),
      ChartData.withDefaultDate(
        'Finished',
        finishedCount.toDouble(),
        _selectedDay ??
            DateTime
                .now(), // Use the current date as a fallback if _selectedDay is null
      ),
    ];

    // Populate the tasksProgress list with unfinished tasks
    tasksProgress =
        _tasks[_selectedDay]?.map((task) => task['text'] as String).toList() ??
            [];

    // List of quotes
    List<String> quotesList = [
      "The only way to do great work is to love what you do. - Steve Jobs",
      "Success is not the key to happiness. Happiness is the key to success. - Albert Schweitzer",
      "Don't watch the clock; do what it does. Keep going. - Sam Levenson",
      "The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
      "You are never too old to set another goal or to dream a new dream. - C.S. Lewis",
      "Act as if what you do makes a difference. It does. - William James",
      "Success usually comes to those who are too busy to be looking for it. - Henry David Thoreau",
      "Opportunities don't happen. You create them. - Chris Grosser",
      "I find that the harder I work, the more luck I seem to have. - Thomas Jefferson",
      "The only limit to our realization of tomorrow will be our doubts of today. - Franklin D. Roosevelt",
      "Believe you can and you're halfway there. - Theodore Roosevelt",
      "It does not matter how slowly you go as long as you do not stop. - Confucius",
      "Hardships often prepare ordinary people for an extraordinary destiny. - C.S. Lewis",
      "Do what you can with all you have, wherever you are. - Theodore Roosevelt",
      "The best way to predict your future is to create it. - Abraham Lincoln",
      "Don't be pushed around by the fears in your mind. Be led by the dreams in your heart. - Roy T. Bennett",
      "Keep your face always toward the sunshine—and shadows will fall behind you. - Walt Whitman",
      "What lies behind us and what lies before us are tiny matters compared to what lies within us. - Ralph Waldo Emerson",
      "If you want to lift yourself up, lift up someone else. - Booker T. Washington",
      "The secret of getting ahead is getting started. - Mark Twain",
      "Dream big and dare to fail. - Norman Vaughan",
      "You are braver than you believe, stronger than you seem, and smarter than you think. - A.A. Milne",
      "The pessimist sees difficulty in every opportunity. The optimist sees opportunity in every difficulty. - Winston Churchill",
      "You miss 100% of the shots you don’t take. - Wayne Gretzky",
      "Happiness is not something ready-made. It comes from your own actions. - Dalai Lama",
      "Success is not final, failure is not fatal: It is the courage to continue that counts. - Winston Churchill",
      "Don't let yesterday take up too much of today. - Will Rogers",
      "Your time is limited, so don’t waste it living someone else’s life. - Steve Jobs",
      "Do one thing every day that scares you. - Eleanor Roosevelt",
      "Strive not to be a success, but rather to be of value. - Albert Einstein"
    ];

    // Get the current date and use it to select a quote
    int currentDay = DateTime.now().day;
    String dailyQuote = quotesList[
        currentDay % quotesList.length]; // Select a quote based on the day

    Widget buildChart() {
      return SfCartesianChart(
        title: ChartTitle(
          text: 'Task Distribution',
          textStyle:
              TextStyle(color: Colors.white), // Set title text color to white
        ),
        primaryXAxis: CategoryAxis(
          labelStyle:
              TextStyle(color: Colors.white), // Set X-axis label color to white
          title: AxisTitle(
              text: 'Task Status',
              textStyle:
                  TextStyle(color: Colors.white)), // Add label for X-axis
        ),
        primaryYAxis: NumericAxis(
          labelStyle:
              TextStyle(color: Colors.white), // Set Y-axis label color to white
        ),
        series: <CartesianSeries>[
          ColumnSeries<ChartData, String>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) =>
                data.task, // Show 'Finished' and 'Unfinished' as categories
            yValueMapper: (ChartData data, _) => data.value,
            color: Colors.blue, // Optional: Set the color of the columns
          )
        ],
        backgroundColor: const Color(
            0xFF2A2A2A), // Optional: Set the background color of the chart
      );
    }

    Widget buildKanbanColumn(String title, List<String> tasks) {
      return Expanded(
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xff28658a),
            ),
            child: SingleChildScrollView(
              // Allow scrolling within each column
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
                  if (title ==
                      'Task Progress') // Insert chart in Task Progress column
                    Container(
                      height: 200, // Set a specific height for the chart
                      child: buildChart(),
                    ),
                  if (title ==
                      'Quotes') // Display the quote in the Quotes column
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
                      height: 300, // Set a specific height for the MoodTracker
                      child: SingleChildScrollView(
                        child: MoodTracker(),
                      ),
                    ),
                  // Display tasks in the Task Progress column
                  if (title == 'Task Progress' && tasks.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    ...tasks
                        .map((task) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                task,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                  ],
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
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000814), Color(0xFF001d3d), Color(0xFF003566)],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1, // Set a 1:1 aspect ratio
                child: buildKanbanColumn('Task Progress', tasksProgress),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1, // Set a 1:1 aspect ratio
                child: buildKanbanColumn('Quotes', quotes),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1, // Set a 1:1 aspect ratio
                child: buildKanbanColumn('Mood', mood),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000814), Color(0xFF001d3d), Color(0xFF003566)],
          ),
        ),
        child: Row(
          // Use Row to align calendar and Kanban box side by side
          children: [
            Expanded(
              child: Container(
                height:
                    400, // Adjust height to ensure it fits well with the Kanban box
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2), // Reduced spacing
                    Expanded(
                      child: TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: DateTime.now(),
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                          selectedDecoration: BoxDecoration(
                              color: Colors.blue, shape: BoxShape.circle),
                          defaultTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 13), // Smaller font
                          weekendTextStyle: const TextStyle(
                              color: Colors.white, fontSize: 13),
                          outsideTextStyle:
                              const TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15), // Reduced font size
                          leftChevronIcon: const Icon(Icons.chevron_left,
                              color: Colors.white, size: 17),
                          rightChevronIcon: const Icon(Icons.chevron_right,
                              color: Colors.white, size: 17),
                        ),
                        daysOfWeekStyle: const DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 11), // Smaller font
                          weekendStyle:
                              TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20), // Space between calendar and Kanban box
            Container(
              width: 600, // Fixed width for Kanban box
              height: 400, // Same height as calendar to align properly
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xff28658a),
                  ),
                  child: Column(
                    children: [
                      // Insert the image inside the Kanban box
                      Image.asset(
                        'assets/kanbanpic.jpg', // Make sure this image exists in your assets folder
                        width: 600, // Adjust the width as necessary
                        height: 359, // Adjust the height as necessary
                        fit: BoxFit.cover, // Adjust the fit as necessary
                      ),
                      // Add your Kanban board contents here
                      // For example: Task list, mood tracker, etc.
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
