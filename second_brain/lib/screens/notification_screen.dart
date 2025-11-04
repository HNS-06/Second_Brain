// screens/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationService = Provider.of<NotificationService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              notificationService.markAllAsRead();
            },
            tooltip: "Mark all as read",
          ),
        ],
      ),
      body: notificationService.notifications.isEmpty
          ? const Center(child: Text("No notifications yet!"))
          : ListView.builder(
              itemCount: notificationService.notifications.length,
              itemBuilder: (context, index) {
                final AppNotification notif =
                    notificationService.notifications[index];
                return Card(
                  color: notif.isRead ? Colors.grey[200] : Colors.white,
                  child: ListTile(
                    leading: Icon(
                      notif.isRead ? Icons.notifications_off : Icons.notifications,
                      color: notif.isRead ? Colors.grey : Colors.blue,
                    ),
                    title: Text(
                      notif.title,
                      style: TextStyle(
                        fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      notif.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        notificationService.markAsRead(notif.id);
                      },
                      tooltip: "Mark as read",
                    ),
                  ),
                );
              },
            ),
    );
  }
}