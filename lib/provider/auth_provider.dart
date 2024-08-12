import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/complete_profile_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../services/user_service.dart';
import '../models/users.dart';


class AuthProvider with ChangeNotifier {
  final UserService _userService = UserService();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> register(BuildContext context, String name, String email, String password, int userTypeId) async {
    final response = await _userService.register({
      'name': name,
      'email': email,
      'password': password,
      'user_type_id': userTypeId,
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Signup Successful. Verify your email to continue.'),
      ));
      Navigator.pushNamed(context, '/login');

    } else {
      // Handle registration error
    }
  }

  Future<void> login(BuildContext context, String email, String password) async {
    final response = await _userService.login({
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      String token = responseData['access_token'];
      int userId = responseData['user_id']; // Assuming your API returns user_id
      await _saveLoginDetails(token, userId);
      _isAuthenticated = true;
      notifyListeners();
      User user= getProfile() as User;
      user.profileImage == null?
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CompleteProfileScreen(user: user)) ):
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()) );
    } else {
      // Handle login error
    }
  }

  Future<void> _saveLoginDetails(String token, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setInt('user_id', userId);
  }

  Future<void> logout(BuildContext context) async {
    await _userService.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_id');
    _isAuthenticated = false;
    notifyListeners();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()) );
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<void> completeProfile(BuildContext context, User user, File profileImage) async {
    final response = await _userService.completeProfile(user, profileImage);

    if (response.statusCode == 200) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()) );
    } else {
      // Handle profile update error
    }
  }

  Future<void> updateProfile(BuildContext context, String name, String email, File profileImage) async {
    final response = await _userService.updateProfile(name, email, profileImage);

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
    } else {
      // Handle profile update error
    }
  }

  Future<User?> getProfile() async {
    int? userId = await getUserId();
    if (userId != null) {
      return await _userService.getProfile(userId);
    }
    return null;
  }
}