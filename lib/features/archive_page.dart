import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ArchivePage extends StatefulWidget {
  final Map<DateTime, List<Map<String, dynamic>>> finishedTasks;
  final Map<DateTime, List<Map<String, dynamic>>> deletedTasks;
  final Function(DateTime, Map<String, dynamic>, bool) onTaskChanged;

  ArchivePage({
    required this.finishedTasks,
    required this.deletedTasks,
    required this.onTaskChanged,
  });

  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  late Map<DateTime, List<Map<String, dynamic>>> _finishedTasks;
  late Map<DateTime, List<Map<String, dynamic>>> _deletedTasks;

  @override
  void initState() {
    super.initState();
    _finishedTasks = Map.from(widget.finishedTasks);
    _deletedTasks = Map.from(widget.deletedTasks);
    _loadTasks();  // Load both tasks
  }

  // Load finished and deleted tasks from SharedPreferences
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();

    String? savedFinishedTasks = prefs.getString('finishedTasks');
    String? savedDeletedTasks = prefs.getString('deletedTasks');

    if (savedFinishedTasks != null) {
      Map<String, dynamic> finishedTasksMap = jsonDecode(savedFinishedTasks);
      setState(() {
        _finishedTasks = finishedTasksMap.map((key, value) {
          return MapEntry(DateTime.parse(key), List<Map<String, dynamic>>.from(value));
        });
      });
    }

    if (savedDeletedTasks != null) {
      Map<String, dynamic> deletedTasksMap = jsonDecode(savedDeletedTasks);
      setState(() {
        _deletedTasks = deletedTasksMap.map((key, value) {
          return MapEntry(DateTime.parse(key), List<Map<String, dynamic>>.from(value));
        });
      });
    }
  }

  // Save finished and deleted tasks to SharedPreferences
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();

    // Save finished tasks
    Map<String, dynamic> finishedTasksToSave = _finishedTasks.map((key, value) {
      return MapEntry(key.toIso8601String(), value);
    });
    prefs.setString('finishedTasks', jsonEncode(finishedTasksToSave));

    // Save deleted tasks
    Map<String, dynamic> deletedTasksToSave = _deletedTasks.map((key, value) {
      return MapEntry(key.toIso8601String(), value);
    });
    prefs.setString('deletedTasks', jsonEncode(deletedTasksToSave));
  }

  // Move task from finished tasks to deleted tasks
  void _moveTaskToTrash(DateTime date, int taskIndex) {
    setState(() {
      Map<String, dynamic> deletedTask = _finishedTasks[date]!.removeAt(taskIndex);

      // Add task to deleted tasks
      deletedTask['deletedAt'] = DateTime.now().toIso8601String();
      _deletedTasks.putIfAbsent(date, () => []).add(deletedTask);

      // Remove the date entry from finished tasks if no tasks are left for that date
      if (_finishedTasks[date]!.isEmpty) {
        _finishedTasks.remove(date);
      }

      // Notify the calendar page that the task was deleted
      widget.onTaskChanged(date, deletedTask, false);

      // Save updated tasks to SharedPreferences
      _saveTasks();
    });
  }

  // Restore a task from deleted tasks
  void _restoreDeletedTask(DateTime date, int index) {
    setState(() {
      Map<String, dynamic> restoredTask = _deletedTasks[date]!.removeAt(index);

      // Remove the date entry from deleted tasks if no tasks are left for that date
      if (_deletedTasks[date]!.isEmpty) {
        _deletedTasks.remove(date);
      }

      // Add task back to finished tasks
      _finishedTasks.putIfAbsent(date, () => []).add(restoredTask);

      // Notify the calendar page that the task was restored
      widget.onTaskChanged(date, restoredTask, true);

      // Save updated tasks to SharedPreferences
      _saveTasks();
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task restored successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Archive'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active Archive'),
              Tab(text: 'Deleted Tasks'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaskList(_finishedTasks),
            _buildTaskList(_deletedTasks, isDeleted: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(Map<DateTime, List<Map<String, dynamic>>> taskMap, {bool isDeleted = false}) {
    return taskMap.isEmpty
        ? Center(child: Text(isDeleted ? 'No deleted tasks available.' : 'No finished tasks available.'))
        : ListView.builder(
      itemCount: taskMap.entries.length,
      itemBuilder: (context, index) {
        final entry = taskMap.entries.elementAt(index);
        DateTime date = entry.key;
        List<Map<String, dynamic>> tasks = entry.value;

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${DateFormat('yMMMd').format(date)}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, taskIndex) {
                  Map<String, dynamic> task = tasks[taskIndex];
                  DateTime actionTime = isDeleted
                      ? DateTime.parse(task['deletedAt'])
                      : DateTime.parse(task['completedAt']);
                  return ListTile(
                    title: Text(task['text']),
                    subtitle: Text(
                      isDeleted
                          ? "Deleted at: ${DateFormat('h:mm a').format(actionTime)}"
                          : "Completed at: ${DateFormat('h:mm a').format(actionTime)}",
                    ),
                    trailing: isDeleted
                        ? IconButton(
                      icon: Icon(Icons.undo, color: Colors.green),
                      onPressed: () {
                        _restoreDeletedTask(date, taskIndex);
                      },
                    )
                        : IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteConfirmationDialog(
                            context,
                                () => _moveTaskToTrash(date, taskIndex),
                            task['text']
                        );
                      },
                    ),
                  );
                },
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }

  // Show confirmation dialog before deleting a task
  void _showDeleteConfirmationDialog(BuildContext context, VoidCallback onConfirm, String taskText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: Text("Are you sure you want to delete the task: '$taskText'?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }
}
