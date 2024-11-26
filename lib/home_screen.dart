import 'package:flutter/material.dart';
import 'nearbyfriends.dart'; // Assuming NearbyFriendsScreen is in nearby_friends.dart
import 'features/calendar_section.dart';
// import 'settings_section.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NearbyFriendsScreen()),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.person_search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

Widget _buildNavigationDrawer() {
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
          _buildDrawerItem(Icons.logout, 'Logout', null, isLogout: true),
        ],
      ),
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF707070), Color(0xFF4A4A4A)],
          ),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_picture.png'),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('John Doe',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 5),
                Text('john.doe@example.com',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                SizedBox(height: 5),
                Text('Role: Employee',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKanbanBoard() {
    List<String> wishlistTasks = ['Task A', 'Task B', 'Task C'];
    List<String> doingTasks = ['Task D', 'Task E'];
    List<String> finishedTasks = ['Task F'];

    void moveTask(String task, List<String> fromList, List<String> toList) {
      setState(() {
        fromList.remove(task);
        toList.add(task);
      });
    }

    void addTask(String task, List<String> targetList) {
      setState(() {
        targetList.add(task);
      });
    }

    void editTask(String oldTask, String newTask, List<String> taskList) {
      setState(() {
        final index = taskList.indexOf(oldTask);
        if (index != -1) {
          taskList[index] = newTask;
        }
      });
    }

    void deleteTask(String task, List<String> taskList) {
      setState(() {
        taskList.remove(task);
      });
    }

    Widget buildKanbanColumn(String title, List<String> tasks,
        List<String> Function() getTargetList) {
      return Expanded(
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF707070), Color(0xFF4A4A4A)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        TextEditingController taskController =
                            TextEditingController();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Add Task'),
                            content: TextField(
                              controller: taskController,
                              decoration: const InputDecoration(
                                hintText: 'Task Name',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (taskController.text.isNotEmpty) {
                                    addTask(
                                        taskController.text, getTargetList());
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('Add'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: DragTarget<String>(
                    builder: (context, candidateData, rejectedData) {
                      return ListView(
                        children: tasks.map((task) {
                          return Draggable<String>(
                            data: task,
                            feedback: Material(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                color: const Color(0xFF00E676),
                                child: Text(
                                  task,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onDoubleTap: () {
                                      TextEditingController editController =
                                          TextEditingController(text: task);
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Edit Task'),
                                          content: TextField(
                                            controller: editController,
                                            decoration: const InputDecoration(
                                              hintText: 'Task Name',
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                editTask(task,
                                                    editController.text, tasks);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Text(
                                      task,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => deleteTask(task, tasks),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                    onWillAcceptWithDetails: (details) {
                      final data = details.data;
                      final fromList = [
                        wishlistTasks,
                        doingTasks,
                        finishedTasks
                      ].firstWhere((list) => list.contains(data));
                      return fromList != getTargetList();
                    },
                    onAcceptWithDetails: (details) {
                      final data = details.data;
                      final fromList = [
                        wishlistTasks,
                        doingTasks,
                        finishedTasks
                      ].firstWhere((list) => list.contains(data));
                      moveTask(data, fromList, getTargetList());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF707070), Color(0xFF4A4A4A)],
          ),
        ),
        child: Row(
          children: [
            buildKanbanColumn('Wishlist', wishlistTasks, () => wishlistTasks),
            const SizedBox(width: 8),
            buildKanbanColumn('Doing', doingTasks, () => doingTasks),
            const SizedBox(width: 8),
            buildKanbanColumn('Finished', finishedTasks, () => finishedTasks),
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
                Text(
                  'Attendance System',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
                Text(
                  _isCheckedIn
                      ? 'Log In: ${formatDate(_checkInTime!)} at ${formatTime(_checkInTime!)}'
                      : 'Not Log In',
                  style: TextStyle(
                    color: _isCheckedIn ? Colors.green : Colors.white,
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
                Text(
                  _isCheckedOut
                      ? 'Log Out: ${formatDate(_checkOutTime!)} at ${formatTime(_checkOutTime!)}'
                      : 'Logging Out?',
                  style: TextStyle(
                    color: _isCheckedOut ? Colors.green : Colors.white,
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
        height: 400, // Reduced height
        padding: const EdgeInsets.all(8), // Reduced padding
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF707070), Color(0xFF4A4A4A)]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 1), // Reduced spacing
            Expanded(
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: DateTime.now(),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  defaultTextStyle: const TextStyle(color: Colors.white, fontSize: 12), // Smaller font
                  weekendTextStyle: const TextStyle(color: Colors.white, fontSize: 12),
                  outsideTextStyle: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleTextStyle: const TextStyle(color: Colors.white, fontSize: 14), // Reduced font size
                  leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white, size: 16),
                  rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white, size: 16),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white, fontSize: 10), // Smaller font
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

