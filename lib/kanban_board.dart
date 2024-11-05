import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class KanbanBoard extends StatefulWidget {
  @override
  _KanbanBoardState createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  // Task lists with color management
  List<Map<String, dynamic>> upcomingTasks = [
    {'name': 'Task 1', 'color': Colors.blue},
    {'name': 'Task 2', 'color': Colors.blue}
  ];
  List<Map<String, dynamic>> doingTasks = [
    {'name': 'Task 3', 'color': Colors.orange}
  ];
  List<Map<String, dynamic>> finishedTasks = [
    {'name': 'Task 4', 'color': Colors.green}
  ];

  // Method to move tasks between columns
  void moveTask(Map<String, dynamic> task, List<Map<String, dynamic>> fromList,
      List<Map<String, dynamic>> toList) {
    setState(() {
      fromList.remove(task);
      toList.add(task);
    });
  }

  // Method to rename a task
  void renameTask(Map<String, dynamic> task) {
    TextEditingController controller =
        TextEditingController(text: task['name']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Task name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  task['name'] = controller.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Method to add a new task
  void addTask(List<Map<String, dynamic>> taskList, Color color) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Task name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  taskList.add({'name': controller.text, 'color': color});
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Method to delete a task
  void deleteTask(
      Map<String, dynamic> task, List<Map<String, dynamic>> taskList) {
    setState(() {
      taskList.remove(task);
    });
  }

  // Method to change the color of a task
  void changeTaskColor(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Task Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: task['color'],
              onColorChanged: (color) {
                setState(() {
                  task['color'] = color;
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  // Widget to create a single Kanban column
  Widget buildKanbanColumn(String title, List<Map<String, dynamic>> tasks,
      Color defaultColor, List<Map<String, dynamic>> Function() nextColumn) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: defaultColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => addTask(tasks, defaultColor),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    color: task['color'],
                    child: ListTile(
                      title: Text(task['name']),
                      onTap: () => renameTask(task),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.color_lens),
                            onPressed: () => changeTaskColor(task),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteTask(task, tasks),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              moveTask(task, tasks, nextColumn());
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanban Board'),
      ),
      body: Row(
        children: [
          // Upcoming Column
          buildKanbanColumn(
              'Upcoming', upcomingTasks, Colors.blue, () => doingTasks),
          // Doing Column
          buildKanbanColumn(
              'Doing', doingTasks, Colors.orange, () => finishedTasks),
          // Finished Column
          buildKanbanColumn(
              'Finished', finishedTasks, Colors.green, () => finishedTasks),
        ],
      ),
    );
  }
}
