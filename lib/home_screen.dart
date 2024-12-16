import 'package:check_loc/features/Otherfeatures.dart';
import 'package:check_loc/features/archive_page.dart';
import 'package:flutter/material.dart';
import 'features/calendar_section.dart';
// import 'settings_section.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'features/MoodTracker.dart'; // Adjust the path as necessary
import 'features/kanbanImage.dart';
import 'features/Quotes.dart';

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

class HomeScreen extends StatefulWidget {
  final String? firstName;
  final String? lastName;

  const HomeScreen({super.key, this.firstName, this.lastName});
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

  void main() {
    int currentDay = DateTime.now().day;
    Quote dailyQuote = Quotes.quotes[currentDay % Quotes.quotes.length];
    print(dailyQuote.text);
    print(dailyQuote.author);
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
                              Expanded(
                                  child: _buildCalendar(
                                context,
                              )),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if the screen size is large or small (e.g., for desktop vs mobile)
        bool isWideScreen = constraints.maxWidth > 600;

        return Container(
          width: isWideScreen
              ? 280
              : constraints.maxWidth * 0.7, // Adjust width based on screen size
          color: Color(0xff28658a),
          child: Column(
            children: [
              Container(
                height: isWideScreen
                    ? 150
                    : 120, // Adjust height for smaller screens
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
                        child:
                            Icon(Icons.person, size: 30, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${widget.firstName} ${widget.lastName}',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildDrawerItem(
                          Icons.note, 'Other Features', OtherFeatures(),
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
                      _buildDrawerItem(Icons.logout, 'Logout', null,
                          isLogout: true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
              'completedAt': DateTime.now()
                  .toIso8601String(), // Replace with actual completion time
            };
          }).toList();
        });

        // Navigate to the ArchivePage and pass formattedFinishedTasks
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArchivePage(
              finishedTasks: formattedFinishedTasks,
              deletedTasks: {},
              onTaskChanged: (date, task, isRestored) {
                // Implement the logic here to handle task changes
                // Example:
                if (isRestored) {
                  // Add the restored task back to your calendar section
                } else {
                  // Remove the task from finished tasks in the calendar section
                }
              },
            ),
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _logout(); // Call the logout function
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    // Perform any logout logic here (e.g., clear user data, session, etc.)
    // Then navigate to the homepage (root screen)

    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isMinimized = constraints.maxWidth <
                600; // Set threshold for "minimized" state

            return Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'assets/profile_picture.png'), // Ensure this image exists in your assets
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.firstName ?? 'John'} ${widget.lastName ?? 'Doe'}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (!isMinimized) ...[
                            SizedBox(height: 5),
                            Text(
                              'john.doe@example.com',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Role: Employee',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (!isMinimized) ...[
                  Positioned(
                    top: 16,
                    right: 16,
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
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildKanbanBoard() {
    // Clear the task lists
    List<String> tasksProgress = []; // Empty list for Task Progress
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

    // Get the current date and use it to select a quote
    int currentDay = DateTime.now().day;
    String dailyQuote = Quotes.quotes[currentDay % Quotes.quotes.length].text;

    Widget buildChart() {
      return SfCartesianChart(
        title: ChartTitle(
          text: 'Task Distribution',
          textStyle: TextStyle(color: Colors.white),
        ),
        primaryXAxis: CategoryAxis(
          labelStyle: TextStyle(color: Colors.white),
          title: AxisTitle(
              text: 'Task Status', textStyle: TextStyle(color: Colors.white)),
        ),
        primaryYAxis: NumericAxis(
          labelStyle: TextStyle(color: Colors.white),
        ),
        series: <CartesianSeries>[
          ColumnSeries<ChartData, String>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.task,
            yValueMapper: (ChartData data, _) => data.value,
            color: Colors.blue,
          )
        ],
        backgroundColor: const Color(0xFF2A2A2A),
      );
    }

    Widget buildKanbanColumn(String title, List<String> tasks) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          return Expanded(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xff28658a),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: screenWidth < 600 ? 16 : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (title ==
                          'Task Progress') // Insert chart in Task Progress column
                        Container(
                          height: screenHeight < 800 ? 150 : 200,
                          child: buildChart(),
                        ),
                      if (title ==
                          'Quotes') // Display the quote in the Quotes column
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            height: screenHeight < 800 ? 200 : 250,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dailyQuote,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                    fontSize: screenWidth < 600 ? 14 : 16,
                                  ),
                                ),
                                Text(
                                  '- ${Quotes.quotes[currentDay % Quotes.quotes.length].author}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth < 600 ? 12 : 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (title ==
                          'Mood') // Add Mood Tracker in Finished column
                        Container(
                          height: screenHeight < 800 ? 250 : 300,
                          child: SingleChildScrollView(
                            child: MoodTracker(),
                          ),
                        ),
                      if (title == 'Task Progress' && tasks.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        ...tasks
                            .map((task) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    task,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth < 600 ? 14 : 16,
                                    ),
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
        },
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
        child: SizedBox(
          height: 400,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Task Progress column
              if (MediaQuery.of(context).size.width > 600) ...[
                Flexible(
                  child: SizedBox(
                    width: 350,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 300,
                        minHeight: 300,
                        maxWidth: 600,
                        maxHeight: 600,
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child:
                            buildKanbanColumn('Task Progress', tasksProgress),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              // Quotes column
              if (MediaQuery.of(context).size.width > 1400) ...[
                Flexible(
                  child: SizedBox(
                    width: 350,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 300,
                        minHeight: 300,
                        maxWidth: 600,
                        maxHeight: 600,
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: buildKanbanColumn('Quotes', []),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              // Mood column - Now hides earlier at screenWidth > 1200
              if (MediaQuery.of(context).size.width > 1400) ...[
                Flexible(
                  child: SizedBox(
                    width: 350,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 300,
                        minHeight: 300,
                        maxWidth: 600,
                        maxHeight: 600,
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: buildKanbanColumn('Mood', mood),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Flexible(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 1300, // Limit the maximum width for the entire layout
          ),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF000814),
                    Color(0xFF001d3d),
                    Color(0xFF003566),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Check the width of the screen and adjust layout accordingly
                        if (constraints.maxWidth < 700) {
                          // For smaller screens, stack the elements vertically
                          return Column(
                            children: [
                              // Calendar widget
                              Container(
                                width: double.infinity,
                                height: screenHeight *
                                    0.4, // Adjust height dynamically
                                child: SingleChildScrollView(
                                  child: TableCalendar(
                                    firstDay: DateTime.utc(2020, 1, 1),
                                    lastDay: DateTime.utc(2030, 12, 31),
                                    focusedDay: DateTime.now(),
                                    calendarStyle: CalendarStyle(
                                      todayDecoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      selectedDecoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      defaultTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                      weekendTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                      outsideTextStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                    headerStyle: HeaderStyle(
                                      formatButtonVisible: false,
                                      titleTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                      leftChevronIcon: const Icon(
                                        Icons.chevron_left,
                                        color: Colors.white,
                                        size: 17,
                                      ),
                                      rightChevronIcon: const Icon(
                                        Icons.chevron_right,
                                        color: Colors.white,
                                        size: 17,
                                      ),
                                    ),
                                    daysOfWeekStyle: const DaysOfWeekStyle(
                                      weekdayStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                      weekendStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Kanban Image widget
                              Container(
                                width: double.infinity,
                                height: screenHeight *
                                    0.4, // Adjust height dynamically
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            KanbanImageDetailPage(),
                                      ),
                                    );
                                  },
                                  child: Hero(
                                    tag: 'kanban_image',
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        'assets/kanbanpic.jpg',
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          // For larger screens, display them side by side
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 1,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 300,
                                    maxWidth:
                                        screenWidth * 0.5, // Use a percentage
                                    maxHeight:
                                        screenHeight * 0.5, // Use a percentage
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: TableCalendar(
                                            firstDay: DateTime.utc(2020, 1, 1),
                                            lastDay: DateTime.utc(2030, 12, 31),
                                            focusedDay: DateTime.now(),
                                            calendarStyle: CalendarStyle(
                                              todayDecoration: BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                              ),
                                              selectedDecoration: BoxDecoration(
                                                color: Colors.blue,
                                                shape: BoxShape.circle,
                                              ),
                                              defaultTextStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                              ),
                                              weekendTextStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                              ),
                                              outsideTextStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11,
                                              ),
                                            ),
                                            headerStyle: HeaderStyle(
                                              formatButtonVisible: false,
                                              titleTextStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                              leftChevronIcon: const Icon(
                                                Icons.chevron_left,
                                                color: Colors.white,
                                                size: 17,
                                              ),
                                              rightChevronIcon: const Icon(
                                                Icons.chevron_right,
                                                color: Colors.white,
                                                size: 17,
                                              ),
                                            ),
                                            daysOfWeekStyle:
                                                const DaysOfWeekStyle(
                                              weekdayStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                              ),
                                              weekendStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  width: 16), // Adjust spacing dynamically
                              Flexible(
                                flex: 1,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 300,
                                    maxWidth:
                                        screenWidth * 0.5, // Use a percentage
                                    maxHeight:
                                        screenHeight * 0.5, // Use a percentage
                                  ),
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: const BoxDecoration(
                                        color: Color(0xff28658a),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  KanbanImageDetailPage(),
                                            ),
                                          );
                                        },
                                        child: Hero(
                                          tag: 'kanban_image',
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Image.asset(
                                              'assets/kanbanpic.jpg',
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
