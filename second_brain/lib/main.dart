import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/notification_screen.dart';
import 'models/task.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  await Permission.notification.request();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  List<Task> tasks = [];
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final savedTasks = await StorageService.loadTasks();
    final savedName = await StorageService.loadUserName();
    setState(() {
      tasks = savedTasks;
      userName = savedName;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _updateName(String name) {
    setState(() {
      userName = name;
    });
    StorageService.saveUserName(name);
  }

  void _addTask(Task task, NotificationService notificationService) {
    setState(() {
      tasks.add(task);
    });
    StorageService.saveTasks(tasks);
    notificationService.showNotification("Task Added", task.title);
    
    if (task.deadline != null) {
      final reminderTime = task.deadline!.subtract(const Duration(days: 1));
      if (reminderTime.isAfter(DateTime.now())) {
        notificationService.scheduleNotification(
          "Upcoming Task: ${task.title}",
          "Due on ${task.deadline!.toString().split(' ')[0]}",
          reminderTime,
        );
      }
    }
  }

  void _clearAllTasks(NotificationService notificationService) {
    setState(() {
      tasks.clear();
    });
    StorageService.saveTasks(tasks);
    notificationService.showNotification("Tasks Cleared", "All tasks have been deleted");
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationService(),
      child: Consumer<NotificationService>(
        builder: (context, notificationService, child) {
          final List<Widget> _screens = [
            HomeScreen(
              tasks: tasks,
              userName: userName,
              onTaskAdded: (task) => _addTask(task, notificationService),
              onClearTasks: () => _clearAllTasks(notificationService),
            ),
            ProfileScreen(
              onNameSaved: _updateName,
              savedName: userName,
            ),
            const NotificationScreen(),
          ];

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Task App with Notifications",
            theme: ThemeData(primarySwatch: Colors.blue),
            home: Scaffold(
              body: _screens[_selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),
                  BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
                  BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}