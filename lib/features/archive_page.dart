import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArchivePage extends StatefulWidget {
  final Map<DateTime, List<Map<String, dynamic>>> finishedTasks;
  final Map<DateTime, List<Map<String, dynamic>>> deletedTasks;
  final Function(Map<DateTime, List<Map<String, dynamic>>>) onUpdateFinishedTasks;
  final Function(Map<DateTime, List<Map<String, dynamic>>>) onUpdateDeletedTasks;

  ArchivePage({
    required this.finishedTasks,
    required this.deletedTasks,
    required this.onUpdateFinishedTasks,
    required this.onUpdateDeletedTasks,
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
    _cleanupOldTasks();
  }

  void _cleanupOldTasks() {
    final retentionDuration = Duration(days: 30);
    final now = DateTime.now();

    // Defer the cleanup logic to the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _finishedTasks.removeWhere((date, tasks) {
          tasks.removeWhere((task) {
            DateTime completionTime = DateTime.parse(task['completedAt']);
            return now.difference(completionTime) > retentionDuration;
          });
          return tasks.isEmpty;
        });

        _deletedTasks.removeWhere((date, tasks) {
          tasks.removeWhere((task) {
            DateTime deletionTime = DateTime.parse(task['deletedAt']);
            return now.difference(deletionTime) > retentionDuration;
          });
          return tasks.isEmpty;
        });

        widget.onUpdateFinishedTasks(_finishedTasks);
        widget.onUpdateDeletedTasks(_deletedTasks);
      });
    });
  }

  void _moveTaskToTrash(DateTime date, int taskIndex) {
    setState(() {
      Map<String, dynamic> deletedTask = _finishedTasks[date]!.removeAt(taskIndex);

      // Add deletedAt timestamp
      deletedTask['deletedAt'] = DateTime.now().toIso8601String();

      // Move task to _deletedTasks
      _deletedTasks.putIfAbsent(date, () => []).add(deletedTask);

      // Remove the date entry if no tasks are left
      if (_finishedTasks[date]!.isEmpty) {
        _finishedTasks.remove(date);
      }

      // Notify the parent widget about the changes
      widget.onUpdateFinishedTasks(Map.from(_finishedTasks));
      widget.onUpdateDeletedTasks(Map.from(_deletedTasks));
    });
  }


  void _restoreDeletedTask(DateTime date, int index) {
    setState(() {
      Map<String, dynamic> restoredTask = _deletedTasks[date]!.removeAt(index);

      // Remove the date entry if no tasks are left
      if (_deletedTasks[date]!.isEmpty) {
        _deletedTasks.remove(date);
      }

      // Add the restored task back to _finishedTasks
      _finishedTasks.putIfAbsent(date, () => []).add(restoredTask);

      // Notify the parent widget about the changes
      widget.onUpdateFinishedTasks(Map.from(_finishedTasks));
      widget.onUpdateDeletedTasks(Map.from(_deletedTasks));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task restored successfully!')),
    );
  }


  void _showDeleteConfirmationDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text("Are you sure you want to delete this task?"),
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
  void _updateDeletedTasks(Map<DateTime, List<Map<String, dynamic>>> updatedDeletedTasks) {
    setState(() {
      // Store the updated deleted tasks in local storage or database
      _deletedTasks = updatedDeletedTasks;

      // Optionally save to persistent storage (e.g., SharedPreferences, or a database)
      _saveDeletedTasksToStorage(_deletedTasks);
    });
  }

  Future<void> _saveDeletedTasksToStorage(Map<DateTime, List<Map<String, dynamic>>> deletedTasks) async {
    // Convert the tasks to a JSON string and save using SharedPreferences, or a database
    // Example for SharedPreferences:
    final prefs = await SharedPreferences.getInstance();
    String deletedTasksJson = jsonEncode(deletedTasks);
    prefs.setString('deleted_tasks', deletedTasksJson);
  }

  Future<void> _loadTasksFromStorage() async {
    final prefs = await SharedPreferences.getInstance();

    // Load finished tasks
    String? finishedTasksJson = prefs.getString('finished_tasks');
    if (finishedTasksJson != null) {
      setState(() {
        _finishedTasks = Map<DateTime, List<Map<String, dynamic>>>.from(
          jsonDecode(finishedTasksJson),
        );
      });
    }

    // Load deleted tasks
    String? deletedTasksJson = prefs.getString('deleted_tasks');
    if (deletedTasksJson != null) {
      setState(() {
        _deletedTasks = Map<DateTime, List<Map<String, dynamic>>>.from(
          jsonDecode(deletedTasksJson),
        );
      });
    }
  }


  Widget _buildTaskList(Map<DateTime, List<Map<String, dynamic>>> taskMap, {bool isDeleted = false}) {
    if (taskMap.isEmpty) {
      return Center(
        child: Text(
          isDeleted ? 'No deleted tasks available.' : 'No finished tasks available.',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: taskMap.length,
      itemBuilder: (context, index) {
        DateTime date = taskMap.keys.elementAt(index);
        List<Map<String, dynamic>> tasks = taskMap[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${DateFormat('yMMMd').format(date)}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...tasks.asMap().entries.map((taskEntry) {
              int taskIndex = taskEntry.key;
              Map<String, dynamic> task = taskEntry.value;

              DateTime actionTime = DateTime.parse(
                isDeleted ? task['deletedAt'] : task['completedAt'],
              );

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
                    );
                  },
                ),
              );
            }).toList(),
            const Divider(),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Task Archive',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          backgroundColor: const Color(0xff28658a),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active Archive'),
              Tab(text: 'Deleted Tasks'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
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
}
