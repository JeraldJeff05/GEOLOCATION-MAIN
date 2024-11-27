import 'package:flutter/material.dart';
import 'features/calendar_section.dart';
// import 'settings_section.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    List<Map<String, dynamic>> attendanceTasks = [
      {'task': 'Check in for daily report', 'checked': false, 'time': null},
      {
        'task': 'Check in for team meeting at 10 AM',
        'checked': false,
        'time': null
      },
      {
        'task': 'Check in for project proposal submission by 3 PM',
        'checked': false,
        'time': null
      },
    ];

    void toggleCheckIn(int index) {
      setState(() {
        if (!attendanceTasks[index]['checked']) {
          attendanceTasks[index]['checked'] = true;
          attendanceTasks[index]['time'] = DateTime.now();
        } else {
          attendanceTasks[index]['checked'] = false;
          attendanceTasks[index]['time'] = null;
        }
      });
    }

    return _buildFeatureCard(
      'Attendance System',
      [
        ...attendanceTasks.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> task = entry.value;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  task['task'],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Checkbox(
                value: task['checked'],
                onChanged: (value) => toggleCheckIn(index),
                checkColor: Colors.white,
                fillColor: WidgetStateProperty.resolveWith<Color>(
                  (states) => states.contains(WidgetState.selected)
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
              if (task['time'] != null)
                Text(
                  'Checked in at: ${task['time'].hour}:${task['time'].minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
            ],
          );
        }).toList(),
      ],
      height: 300, // Adjust height as needed
    );
  }

  Widget _buildCalendar() {
    return _buildFeatureCard(
      'Calendar/Schedule',
      [
        const Text('Upcoming Meeting: 10 AM',
            style: TextStyle(color: Colors.white)),
        const Text('Project Deadline: 3 PM',
            style: TextStyle(color: Colors.white)),
      ],
      height: 300, // Set a taller height to match To-Do List
    );
  }

  // Updated to accept height for consistent sizes
  Widget _buildFeatureCard(String title, List<Widget> children,
      {double height = 250}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF707070), Color(0xFF4A4A4A)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}
