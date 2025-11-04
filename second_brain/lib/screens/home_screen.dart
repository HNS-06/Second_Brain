import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Task> tasks;
  final String? userName;
  final Function(Task) onTaskAdded;
  final VoidCallback onClearTasks;

  const HomeScreen({
    Key? key,
    required this.tasks,
    required this.userName,
    required this.onTaskAdded,
    required this.onClearTasks,
  }) : super(key: key);

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Clear All Tasks"),
          content: const Text("Are you sure you want to delete all tasks? This cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onClearTasks(); // Call the clear function
                Navigator.pop(context);
              },
              child: const Text("Clear All", style: TextStyle(color: Colors.red)),
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
        title: Text(userName != null ? "Hi, $userName 👋" : "Task List"),
        actions: [
          if (tasks.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => _showClearConfirmation(context),
              tooltip: "Clear All Tasks",
            ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                "No tasks yet!\nTap the + button to add a task.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(task: tasks[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(onTaskAdded: onTaskAdded),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}