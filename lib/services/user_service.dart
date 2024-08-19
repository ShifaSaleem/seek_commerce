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

  Future<http.StreamedResponse> completeProfile(User user, File profileImage) async {
    final url = Uri.parse('$baseUrl/complete-profile');
    final request = http.MultipartRequest('POST', url)
      ..headers.addAll(await config.getHeadersForMultipart())
      ..fields['name'] = user.name
      ..files.add(await http.MultipartFile.fromPath('profile_image', profileImage.path));

    return await request.send();
  }

  Future<http.StreamedResponse> updateProfile(String name, String email, File profileImage) async {
    final url = Uri.parse('$baseUrl/update-profile');
    final request = http.MultipartRequest('PUT', url)
      ..headers.addAll(await config.getHeadersForMultipart())
      ..fields['name'] = name
      ..fields['email'] = email
      ..files.add(await http.MultipartFile.fromPath('profile_image', profileImage.path));

    return await request.send();
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