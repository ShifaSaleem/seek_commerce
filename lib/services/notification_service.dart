import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notifications.dart';
import '../api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  ApiConfig config = ApiConfig();
  final String baseUrl = ApiConfig().baseUrl;
  final FlutterSecureStorage storage = FlutterSecureStorage();



  Future<void> initialize() async {
    // Request permission
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // Get the token
      String? token = await _fcm.getToken();
      print('FCM Token: $token');

      // Send the token to your server
      if (token != null) {
        await sendTokenToServer(token);
      }
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> sendTokenToServer(String token) async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id')!;
    final response = await http.post(
      Uri.parse('$baseUrl/save-token'),
      headers: await config.getHeaders2(),
      body: jsonEncode(<String, dynamic>{
        'token': token,
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      print('Token saved successfully');
    } else {
      print('Failed to save token');
    }
  }

  Future<List<Notifications>> getUserNotifications() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/notifications'),
      headers: await config.getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List notifications = data['notifications'];
      return notifications.map((json) => Notifications.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<void> markAsRead(int notificationId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/read-notification'),
      headers: await config.getHeaders(),
      body: json.encode({'id': notificationId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }

}
