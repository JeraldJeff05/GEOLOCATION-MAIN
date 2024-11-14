import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarSection extends StatefulWidget {
  @override
  _CalendarSectionState createState() => _CalendarSectionState();
}

class Task {
  String description;
  bool isCompleted;

  Task({required this.description, this.isCompleted = false});
}

class _CalendarSectionState extends State<CalendarSection> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Task>> _tasks = {}; // Map to store tasks for specific dates
  final Map<DateTime, String> _notes = {};  // Map to store notes for specific dates

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar with Notes & Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Calendar widget from 'table_calendar' package
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _showNoteAndTaskDialog(selectedDay);  // Show the note and task dialog
              },
            ),
            const SizedBox(height: 20),
            // Display the note for the selected date
            if (_notes[_selectedDay] != null && _notes[_selectedDay]!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.blueGrey[50],
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Note for ${_selectedDay?.toLocal().toString().split(' ')[0]}:\n${_notes[_selectedDay]}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            // Display tasks for the selected day
            if (_tasks[_selectedDay] != null && _tasks[_selectedDay]!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tasks for ${_selectedDay?.toLocal().toString().split(' ')[0]}:',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ..._tasks[_selectedDay]!.map((task) {
                      return ListTile(
                        title: Text(task.description),
                        trailing: Checkbox(
                          value: task.isCompleted,
                          onChanged: (bool? value) {
                            setState(() {
                              task.isCompleted = value ?? false;
                            });
                          },
                        ),
                      );
                    }).toList(),
                    ElevatedButton(
                      onPressed: () => _addTaskDialog(_selectedDay!),
                      child: const Text('Add Task'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Function to show the dialog for adding notes and tasks
  void _showNoteAndTaskDialog(DateTime selectedDate) {
    TextEditingController noteController = TextEditingController();
    // Fetch current note
    String currentNote = _notes[selectedDate] ?? '';
    noteController.text = currentNote;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add a Note & Tasks"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TextField for the note
              TextField(
                controller: noteController,
                decoration: const InputDecoration(hintText: "Write your note here..."),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              // Tasks section
              ElevatedButton(
                onPressed: () => _addTaskDialog(selectedDate),
                child: const Text("Add Task"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _notes[selectedDate] = noteController.text; // Save the note
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Function to show a dialog for adding tasks
  void _addTaskDialog(DateTime selectedDate) {
    TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Task"),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(hintText: "Enter task description..."),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (_tasks[selectedDate] == null) {
                    _tasks[selectedDate] = [];
                  }
                  _tasks[selectedDate]?.add(Task(description: taskController.text));
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Add Task"),
            ),
          ],
        );
      },
    );
  }
}
