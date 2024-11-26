import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CalendarSection extends StatefulWidget {
  @override
  _CalendarSectionState createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, String> _notes = {};
  final Map<DateTime, List<Map<String, dynamic>>> _tasks = {};
  final Map<DateTime, List<String>> _finishedTasks = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final savedNotes = prefs.getString('notes') ?? '{}';
    final Map<String, String> loadedNotes = Map<String, String>.from(jsonDecode(savedNotes));
    loadedNotes.forEach((key, value) {
      _notes[DateTime.parse(key)] = value;
    });

    final savedTasks = prefs.getString('tasks') ?? '{}';
    final Map<String, dynamic> loadedTasks = jsonDecode(savedTasks);
    loadedTasks.forEach((key, value) {
      DateTime date = DateTime.parse(key);
      _tasks[date] = List<Map<String, dynamic>>.from(value);
    });

    final savedFinishedTasks = prefs.getString('finishedTasks') ?? '{}';
    final Map<String, List<String>> loadedFinishedTasks = Map<String, List<String>>.from(jsonDecode(savedFinishedTasks));
    loadedFinishedTasks.forEach((key, value) {
      _finishedTasks[DateTime.parse(key)] = List<String>.from(value);
    });

    setState(() {});
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    final dataToSaveNotes = _notes.map((key, value) => MapEntry(key.toIso8601String(), value));
    prefs.setString('notes', jsonEncode(dataToSaveNotes));

    final dataToSaveTasks = _tasks.map((key, value) => MapEntry(key.toIso8601String(), value));
    prefs.setString('tasks', jsonEncode(dataToSaveTasks));

    final dataToSaveFinishedTasks = _finishedTasks.map((key, value) => MapEntry(key.toIso8601String(), value));
    prefs.setString('finishedTasks', jsonEncode(dataToSaveFinishedTasks));
  }

  // Mark a task as done with confirmation
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
                setState(() {
                  if (_selectedDay != null) {
                    _tasks[_selectedDay]!.remove(task);
                    _finishedTasks.putIfAbsent(_selectedDay!, () => []);
                    _finishedTasks[_selectedDay]!.add(task['text']);
                  }
                });
                _saveData();
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  // Show dialog for adding a new task
  Future<void> _showTaskDialog(DateTime selectedDay) async {
    TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Task"),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(
              hintText: "Enter task",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  if (taskController.text.isNotEmpty) {
                    _tasks.putIfAbsent(selectedDay, () => []);
                    _tasks[selectedDay]!.add({'text': taskController.text, 'completed': false});
                  }
                });
                _saveData();
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Show dialog for adding/editing a note
  Future<void> _showNoteDialog(DateTime selectedDay) async {
    TextEditingController noteController = TextEditingController(text: _notes[selectedDay]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add/Edit Note"),
          content: TextField(
            controller: noteController,
            decoration: const InputDecoration(
              hintText: "Enter note for selected date",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _notes[selectedDay] = noteController.text;
                });
                _saveData();
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
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
      body: Column(
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
              });
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                // Add a marker for days with notes or tasks
                if (_notes[date] != null || _tasks[date]?.isNotEmpty == true) {
                  return Positioned(
                    bottom: 1,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.blue, // Mark color
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return SizedBox.shrink(); // No marker if no note or task
              },
            ),
          ),
          const SizedBox(height: 20),
          if (_selectedDay != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _buildNoteBox()),
                Expanded(child: _buildTaskBox()),
                Expanded(child: _buildFinishedTaskBox()),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildNoteBox() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Note for ${_selectedDay?.toLocal().toString().split(' ')[0]}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _notes.remove(_selectedDay);
                  });
                  _saveData();
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _notes[_selectedDay] ?? "No note for this day",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _showNoteDialog(_selectedDay!),
            child: const Text("Add/Edit Note"),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskBox() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tasks for ${_selectedDay?.toLocal().toString().split(' ')[0]}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Column(
            children: _tasks[_selectedDay]?.map((task) {
              return CheckboxListTile(
                title: Text(
                  task['text'],
                  style: TextStyle(
                    decoration: task['completed'] ? TextDecoration.lineThrough : null,
                  ),
                ),
                value: task['completed'],
                onChanged: (bool? value) {
                  if (value != null && value) {
                    _markTaskAsDone(task); // Show the confirmation dialog before marking as done
                  }
                },
                secondary: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _tasks[_selectedDay]!.remove(task);
                    });
                    _saveData();
                  },
                ),
              );
            }).toList() ??
                [const Text("No tasks for this day")],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _showTaskDialog(_selectedDay!),
            child: const Text("Add Task"),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishedTaskBox() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.purple),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Finished Tasks for ${_selectedDay?.toLocal().toString().split(' ')[0]}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Column(
            children: _finishedTasks[_selectedDay]?.map((task) {
              return ListTile(
                title: Text(task),
              );
            }).toList() ??
                [const Text("No finished tasks for this day")],
          ),
        ],
      ),
    );
  }
}
