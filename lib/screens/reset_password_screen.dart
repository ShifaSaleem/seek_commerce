import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/input_fields.dart';
import '../input_validators/input_validators.dart';
import '../provider/auth_provider.dart';
import '../services/user_service.dart';
import '../theme/app_theme.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;
  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final AuthProvider _authProvider = AuthProvider();
  final UserService _userService = UserService();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
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
                    'Reset Password',
                    style: headerText28(),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Set a new password now.',
                    style: bodyText14(),
                  ),
                ],
              ),
            ),
            PasswordTextField(
              prefixIcon: Icon(Icons.password),
              labelText: 'Password',
              hintText: 'Enter Password',
              textInputType: TextInputType.visiblePassword,
              controller: _passController,
              validator: validatePassword,
            ),
            SizedBox(height: 16),
            PasswordTextField(
              prefixIcon: Icon(Icons.password),
              labelText: 'Confirm Password',
              hintText: 'Enter Password',
              textInputType: TextInputType.visiblePassword,
              controller: _confirmPassController,
              validator: validatePassword,
            ),
            SizedBox(height: 24),
            DefaultButton(
                labelText: 'Reset Now',
                textStyle: headerText16().copyWith(color: textLightColor),
                onPressed: ()  {
                  if (_passController.text == _confirmPassController.text){
                    _userService.resetPassword(context, widget.token, _passController.text);
                    _passController.clear();
                    _confirmPassController.clear();
                   } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Passwords don't match."),
                    ));
                  }
                },
                backgroundColor: primaryColor),
          ],
        ),
      ),
    );
  }
}
