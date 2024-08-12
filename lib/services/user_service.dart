import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/users.dart';
import '../api_config.dart';
import '../screens/login_screen.dart';

class UserService {
  ApiConfig config = ApiConfig();
  final String baseUrl = ApiConfig().baseUrl;

  Future<http.Response> register(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/register');
    return await http.post(url, body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
  }

  Future<http.Response> login(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/login');
    return await http.post(url, body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
  }

  Future<http.Response> logout() async {
    final url = Uri.parse('$baseUrl/logout');
    return await http.post(url, headers: await config.getHeaders());
  }

  Future<http.Response> completeProfile(User user, File profileImage) async {
    //Uint8List imageBytes = await File(user.profileImage!).readAsBytes();
   // String base64Image = base64Encode(imageBytes);

    final response = await http.post(
      Uri.parse('$baseUrl/complete-profile'),
      body: jsonEncode({
        'name': user.name,
        'profile_image': profileImage,
      }),
      headers: await config.getHeaders(),
    );

    return response;
  }

  Future<http.Response> updateProfile(String name, String email, File profileImage) async {
    //Uint8List imageBytes = await File(profileImage as String).readAsBytes();
    //String base64Image = base64Encode(imageBytes);

    final response = await http.put(
      Uri.parse('$baseUrl/update-profile'),
      body: jsonEncode({
        'name': name,
        'email': email,
        'profile_image': profileImage,
      }),
      headers: await config.getHeaders(),
    );

    return response;
  }

  Future<User?> getProfile(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile/$id'),
      headers: await config.getHeaders(),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return User.fromJson(responseData);
    } else {
      // Handle profile retrieval error
      return null;
    }
  }

  Future<void> verifyEmail(BuildContext context, String token) async {
    final response = await http.get(Uri.parse('$baseUrl/verify-email/$token'));
    if (response.statusCode == 200) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Email verified successfully'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to verify email'),
      ));
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    return jsonDecode(response.body);
  }

  Future<void> resetPassword(BuildContext context, String token, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'token': token,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password reset successfully'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to reset password'),
      ));
    }
  }

  Future<Map<String, dynamic>> changePassword(String currentPassword, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/change-password'),
      headers: await config.getHeaders(),
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
      }),
    );

    return jsonDecode(response.body);
  }


  Future<Uint8List> base64ToImage(String base64String) async {
    return base64Decode(base64String);
  }
}