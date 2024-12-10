import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArchivePage extends StatefulWidget {
  final Map<DateTime, List<Map<String, dynamic>>> finishedTasks;
  final Map<DateTime, List<Map<String, dynamic>>> deletedTasks; // Accept deleted tasks

  ArchivePage({required this.finishedTasks, required this.deletedTasks});

  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  late Map<DateTime, List<Map<String, dynamic>>> _finishedTasks;
  late Map<DateTime,
      List<Map<String, dynamic>>> _deletedTasks; // Store deleted tasks

  @override
  void initState() {
    super.initState();
    _finishedTasks = Map.from(widget.finishedTasks); // Create a local copy
    _deletedTasks =
        Map.from(widget.deletedTasks); // Create a local copy for deleted tasks
    _cleanupOldTasks(); // Perform automatic cleanup of old tasks
  }

  void _cleanupOldTasks() {
    final retentionDuration = Duration(days: 30); // Set the retention period
    final now = DateTime.now();

    setState(() {
      _finishedTasks.removeWhere((date, tasks) {
        tasks.removeWhere((task) {
          DateTime completionTime = DateTime.parse(task['completedAt']);
          return now.difference(completionTime) >
              retentionDuration; // Check task age
        });
        return tasks.isEmpty; // Remove the date if no tasks remain
      });

      _deletedTasks.removeWhere((date, tasks) {
        tasks.removeWhere((task) {
          DateTime deletionTime = DateTime.parse(task['deletedAt']);
          return now.difference(deletionTime) >
              retentionDuration; // Check task age
        });
        return tasks.isEmpty; // Remove the date if no tasks remain
      });
    });
  }

  void _moveTaskToTrash(DateTime date, int taskIndex) {
    setState(() {
      Map<String, dynamic> deletedTask = _finishedTasks[date]!.removeAt(
          taskIndex);

      // Add deletion timestamp
      deletedTask['deletedAt'] = DateTime.now().toIso8601String();

      // Add to deleted tasks
      _deletedTasks.putIfAbsent(date, () => []).add(deletedTask);

      // Remove the date entry if no tasks remain
      if (_finishedTasks[date]!.isEmpty) {
        _finishedTasks.remove(date);
      }
    });
  }

  Widget _buildTaskList(Map<DateTime, List<Map<String, dynamic>>> taskMap,
      {bool isDeleted = false}) {
    return taskMap.isEmpty
        ? Center(
      child: Text(
        isDeleted
            ? 'No deleted tasks available.'
            : 'No finished tasks available.',
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    )
        : ListView(
      children: taskMap.entries.map((entry) {
        DateTime date = entry.key;
        List<Map<String, dynamic>> tasks = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${DateFormat('yMMMd').format(date)}", // Format the date
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...tasks.asMap().entries.map((taskEntry) {
              int index = taskEntry.key;
              Map<String, dynamic> task = taskEntry.value;

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
                    _restoreDeletedTask(date, index);
                  },
                )
                    : IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Show confirmation dialog
                    _showDeleteConfirmationDialog(
                      context,
                          () => _moveTaskToTrash(date, index),
                    );
                  },
                ),
              );
            }).toList(),
            const Divider(),
          ],
        );
      }).toList(),
    );
  }
  void _restoreDeletedTask(DateTime date, int index) {
    setState(() {
      // Retrieve the task from the deleted list
      Map<String, dynamic> restoredTask = _deletedTasks[date]!.removeAt(index);

      // Remove the date if no tasks remain under it
      if (_deletedTasks[date]!.isEmpty) {
        _deletedTasks.remove(date);
      }

      // Add the restored task back to finished tasks
      _finishedTasks.putIfAbsent(date, () => []).add(restoredTask);
    });

    // Show a Snackbar to notify the user
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
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(); // Call the function to delete the task
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Active Archive and Deleted Tasks
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Archive', style: TextStyle(color: Colors.white, fontSize: 20),),
          backgroundColor: const Color(0xff28658a),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active Archive'),
              Tab(text: 'Deleted Tasks'),
            ],
            labelColor: Colors.white, // Color for the active tab text
            unselectedLabelColor: Colors
                .grey, // Color for the inactive tab text
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
