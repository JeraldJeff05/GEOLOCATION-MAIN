import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChartData {
  final String label;
  final double value;

  ChartData(this.label, this.value);
}

class CalendarSection extends StatefulWidget {
  final Function(DateTime, List<Map<String, dynamic>>, List<String>) onTasksUpdated;
  final Function(DateTime, List<ChartData>) onBarChartUpdate;

  CalendarSection({required this.onTasksUpdated, required this.onBarChartUpdate});

  @override
  _CalendarSectionState createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  late Map<DateTime, List<Map<String, dynamic>>> _deletedTasks;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, String> _notes = {};
  final Map<DateTime, List<Map<String, dynamic>>> _tasks = {};
  final Map<DateTime, List<String>> _finishedTasks = {};
  List<String> _currentFinishedTasks = [];
  List<dynamic> _getEventsForDay(DateTime day) {
    return _tasks[day]?.isNotEmpty == true ? ['Task'] : [];

  }

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadData();
    _deletedTasks = {};
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load notes
    final savedNotes = prefs.getString('notes') ?? '{}';
    final Map<String, String> loadedNotes = Map<String, String>.from(jsonDecode(savedNotes));
    loadedNotes.forEach((key, value) {
      _notes[DateTime.parse(key)] = value;
    });

    // Load tasks
    final savedTasks = prefs.getString('tasks') ?? '{}';
    final Map<String, dynamic> loadedTasks = jsonDecode(savedTasks);
    loadedTasks.forEach((key, value) {
      DateTime date = DateTime.parse(key);
      _tasks[date] = List<Map<String, dynamic>>.from(value);
    });

    // Load finished tasks
    final savedFinishedTasks = prefs.getString('finishedTasks') ?? '{}';
    final Map<String, dynamic> loadedFinishedTasks = jsonDecode(savedFinishedTasks);
    loadedFinishedTasks.forEach((key, value) {
      _finishedTasks[DateTime.parse(key)] = List<String>.from(value);
    });

    setState(() {
      _displayFinishedTasksForSelectedDay();
    });
  }

  void addTask(String taskText) {
    if (_selectedDay != null) {
      setState(() {
        if (_tasks[_selectedDay] == null) {
          _tasks[_selectedDay!] = [];
        }
        _tasks[_selectedDay!]!.add({'text': taskText, 'completed': false});
        widget.onTasksUpdated(
          _selectedDay!,
          _tasks[_selectedDay!]!,
          _finishedTasks[_selectedDay] ?? [],
        );
      });
      _saveData();
    }
  }

  void _markTaskAsDone(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Are you sure you are finished with this task?"),
          actions: [
            TextButton(
              onPressed: () {
                // Update the task and mark it as done
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    if (_selectedDay != null) {
                      // Remove the task from _tasks and add it to finished tasks
                      _tasks[_selectedDay]!.remove(task);
                      _finishedTasks.putIfAbsent(_selectedDay!, () => []);
                      _finishedTasks[_selectedDay!]!.add(task['text']);
                      _currentFinishedTasks = _finishedTasks[_selectedDay!]!;

                      widget.onTasksUpdated(
                        _selectedDay!,
                        _tasks[_selectedDay!]!,
                        _currentFinishedTasks,
                      );
                      widget.onBarChartUpdate(
                        _selectedDay!,
                        [_generateChartData()],
                      );
                    }
                  });
                  _saveData();
                  Navigator.pop(context);
                });
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  void _displayFinishedTasksForSelectedDay() {
    if (_selectedDay != null) {
      _currentFinishedTasks = _finishedTasks[_selectedDay] ?? [];
      widget.onBarChartUpdate(
        _selectedDay!,
        [_generateChartData()],
      );
    }
  }

  ChartData _generateChartData() {
    double finishedTaskCount = _currentFinishedTasks.length.toDouble();
    return ChartData('Finished Tasks', finishedTaskCount);
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Save notes
    final dataToSaveNotes = _notes.map((key, value) =>
        MapEntry(key.toIso8601String(), value));
    prefs.setString('notes', jsonEncode(dataToSaveNotes));

    // Save tasks
    final dataToSaveTasks = _tasks.map((key, value) =>
        MapEntry(key.toIso8601String(), value));
    prefs.setString('tasks', jsonEncode(dataToSaveTasks));

    // Save finished tasks
    final dataToSaveFinishedTasks = _finishedTasks.map((key, value) =>
        MapEntry(key.toIso8601String(), value));
    prefs.setString('finishedTasks', jsonEncode(dataToSaveFinishedTasks));
  }

  Widget _buildNoteBox() {
    return Card(
      color: Colors.lightGreen[50],
      child: Column(
        children: [
          const Text('Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView(
              children: _notes.entries.map((entry) {
                return ListTile(
                  title: Text(entry.value),
                  subtitle: Text(entry.key.toIso8601String()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _notes.remove(entry.key);
                        _saveData();
                        widget.onTasksUpdated(
                          _selectedDay!,
                          _tasks[_selectedDay!] ?? [],
                          _finishedTasks[_selectedDay] ?? [],
                        );
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskBox() {
    return Card(
      color: Colors.blue[50],
      child: Column(
        children: [
          const Text('Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView(
              children: (_tasks[_selectedDay] ?? []).map((task) {
                return ListTile(
                  title: Text(task['text']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_box_outline_blank),
                        onPressed: () => _markTaskAsDone(task),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Show confirmation dialog before deleting
                          _showDeleteConfirmationDialog(task);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  // Remove the task from the tasks list
                  _tasks[_selectedDay]!.remove(task);

                  // Add the task to the deleted tasks map
                  DateTime now = DateTime.now();
                  Map<String, dynamic> deletedTask = {
                    ...task,
                    'deletedAt': now.toIso8601String(), // Add the deletedAt timestamp
                  };

                  // Ensure deleted tasks are stored in the deletedTasks map
                  _deletedTasks.putIfAbsent(_selectedDay!, () => []).add(deletedTask);

                  // Save data if necessary
                  _saveData();
                  widget.onTasksUpdated(
                    _selectedDay!,
                    _tasks[_selectedDay!]!,
                    _finishedTasks[_selectedDay] ?? [],
                  );
                });

                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without deleting
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }



  Widget _buildFinishedTaskBox() {
    return Card(
      color: Colors.orange[50],
      child: Column(
        children: [
          const Text('Finished Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView(
              children: _currentFinishedTasks.map((task) {
                return ListTile(title: Text(task));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showNoteDialog() {
    TextEditingController noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.lightGreen[100],
          title: const Text("Add Note"),
          content: TextField(
            controller: noteController,
            decoration: const InputDecoration(hintText: 'Enter note here'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String noteText = noteController.text.trim();
                if (noteText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a note.', style: TextStyle(color: Color(0xff04fb18)))),
                  );
                } else {
                  setState(() {
                    _notes[_selectedDay!] = noteText;
                  });
                  _saveData();
                  widget.onTasksUpdated(
                    _selectedDay!,
                    _tasks[_selectedDay!] ?? [],
                    _finishedTasks[_selectedDay] ?? [],
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showTaskDialog() {
    TextEditingController taskController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue[100],
          title: const Text("Add Task"),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(hintText: 'Enter task here'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String taskText = taskController.text.trim();
                if (taskText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a task.', style: TextStyle(color: Color(0xff04fb18)))),
                  );
                } else {
                  addTask(taskText);
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar with Notes and Tasks'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _displayFinishedTasksForSelectedDay();
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                  _displayFinishedTasksForSelectedDay();
                });
              },
              eventLoader: _getEventsForDay, // Added this line
              calendarStyle: CalendarStyle(
                markerDecoration: const BoxDecoration(
                  color: Colors.blue, // Customize marker color
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_selectedDay != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _showNoteDialog,
                    child: const Text('Add Note'),
                  ),
                  ElevatedButton(
                    onPressed: _showTaskDialog,
                    child: const Text('Add Task'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 500),
                child: Row(
                  children: [
                    Expanded(child: _buildNoteBox()),
                    const SizedBox(width: 10),
                    Expanded(child: _buildTaskBox()),
                    const SizedBox(width: 10),
                    Expanded(child: _buildFinishedTaskBox()),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

