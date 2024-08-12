import 'package:flutter/material.dart';

import '../services/user_service.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String token;
  const EmailVerificationScreen({super.key, required this.token});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    _verifyEmail();
  }
  void _verifyEmail() async {
    await userService.verifyEmail(context, widget.token);
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
