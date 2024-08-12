class Notifications {
  final int id;
  final String title;
  final String body;
  final bool isRead;

  Notifications({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      isRead: json['is_read'],
    );
  }
}