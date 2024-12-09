import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArchivePage extends StatefulWidget {
  final Map<DateTime, List<Map<String, dynamic>>> finishedTasks;

  ArchivePage({required this.finishedTasks});

  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  late Map<DateTime, List<Map<String, dynamic>>> _finishedTasks;

  @override
  void initState() {
    super.initState();
    _finishedTasks = Map.from(widget.finishedTasks); // Create a local copy
    _cleanupOldTasks(); // Perform automatic cleanup of old tasks
  }

  void _cleanupOldTasks() {
    final retentionDuration = Duration(days: 30); // Set the retention period
    final now = DateTime.now();

    setState(() {
      _finishedTasks.removeWhere((date, tasks) {
        tasks.removeWhere((task) {
          DateTime completionTime = DateTime.parse(task['completedAt']);
          return now.difference(completionTime) > retentionDuration; // Check task age
        });
        return tasks.isEmpty; // Remove the date if no tasks remain
      });
    });
  }

  void _deleteTaskWithConfirmation(DateTime date, int taskIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  _finishedTasks[date]!.removeAt(taskIndex); // Remove the task
                  if (_finishedTasks[date]!.isEmpty) {
                    _finishedTasks.remove(date); // Remove the date entry if no tasks remain
                  }
                });
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
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
        title: const Text('Finished Tasks Archive'),
        backgroundColor: const Color(0xff28658a),
      ),
      body: _finishedTasks.isEmpty
          ? Center(
        child: const Text(
          'No finished tasks available.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView(
        children: _finishedTasks.entries.map((entry) {
          DateTime date = entry.key;
          List<Map<String, dynamic>> tasks = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${DateFormat('yMMMd').format(date)}", // Format the date
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ...tasks.asMap().entries.map((taskEntry) {
                int index = taskEntry.key;
                Map<String, dynamic> task = taskEntry.value;

                DateTime completionTime = DateTime.parse(task['completedAt']);
                return ListTile(
                  title: Text(task['text']),
                  subtitle: Text(
                    "Completed at: ${DateFormat('h:mm a').format(completionTime)}", // 12-hour format
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteTaskWithConfirmation(date, index);
                    },
                  ),
                );
              }).toList(),
              const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }
}
