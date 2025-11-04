class AppNotification {
  final String id;
  final String title;
  final String description;
  bool isRead;
  final DateTime timestamp;

  AppNotification({
    required this.id,
    required this.title,
    required this.description,
    this.isRead = false,
    required this.timestamp,
  });
}
