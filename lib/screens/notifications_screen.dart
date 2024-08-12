import 'package:flutter/material.dart';
import 'package:seek_commerce/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notifications.dart';
import '../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<Notifications>> _notificationsFuture;
  @override
  void initState() {
    super.initState();
    _notificationsFuture = NotificationService().getUserNotifications();
  }

  void _markAsRead(int notificationId) async {
    try {
      await NotificationService().markAsRead(notificationId);
      setState(() {
        _notificationsFuture = NotificationService().getUserNotifications();
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: headerText24(),),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed : (){
              Navigator.pop(context);
            }
        ),
      ),
      body: FutureBuilder<List<Notifications>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notifications'));
          } else {
            final notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 40,
                    backgroundColor: primaryColor.withOpacity(70),
                    child: const Center(child: Icon(Icons.notifications, color: Colors.white, size: 28,)),
                  ),
                  title: Text(notification.title),
                  subtitle: Text(notification.body),
                  onTap: () {
                    if (!notification.isRead) {
                      _markAsRead(notification.id);
                    }
                  },
                  tileColor: notification.isRead ? Colors.white : primaryColor.withOpacity(10),
                );
              },
            );
          }
        },
      ),
    );
  }
}
