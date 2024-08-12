import 'package:flutter/material.dart';
import 'package:seek_commerce/components/button.dart';
import 'package:seek_commerce/input_validators/input_validators.dart';
import 'package:seek_commerce/provider/auth_provider.dart';
import 'package:seek_commerce/screens/reset_password_screen.dart';
import 'package:seek_commerce/screens/signup_screen.dart';
import 'package:seek_commerce/screens/home_screen.dart';
import 'package:seek_commerce/theme/app_theme.dart';
import '../components/input_fields.dart';
import '../services/user_service.dart';
import 'forgot_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final UserService _userService = UserService();
  final _emailController = TextEditingController();

  Future<void> _forgotPassword()async {
    final response =
    await _userService.forgotPassword(_emailController.text);
    if (response.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Verification Failed.'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
        Text('Email sent. Check your email to continue.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Forgot Password?',
                    style: headerText28(),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Confirm your email, we will send you a password reset link.',
                    style: bodyText14(),
                  ),
                ],
              ),
            ),
            DefaultTextField(
              prefixIcon: Icon(Icons.email),
              labelText: 'Email',
              hintText: 'username@gmail.com',
              textInputType: TextInputType.emailAddress,
              controller: _emailController,
              validator: validateEmail,
            ),
            SizedBox(height: 24),
            DefaultButton(
                labelText: 'Get Reset Email',
                textStyle: headerText16().copyWith(color: textLightColor),
                onPressed: ()  {
                _forgotPassword();
                },
                backgroundColor: primaryColor),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                    onPressed: () {
                      _forgotPassword();
                    },
                    child: Text(
                      "Didn't receive email? Resend",
                      style: headerText14().copyWith(color: primaryColor),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
