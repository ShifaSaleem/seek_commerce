import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/input_fields.dart';
import '../input_validators/input_validators.dart';
import '../services/user_service.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final UserService _userService = UserService();
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  Future<void> _changePassword()async {
    final response =
    await _userService.changePassword(_currentPassController.text, _newPassController.text);
    if (response.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to change password.'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
        Text('Password changed successfully.'),
      ));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password', style: headerText24()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PasswordTextField(
                  prefixIcon: Icon(Icons.password),
                  labelText: 'Current Password',
                  hintText: 'Enter Current Password',
                  textInputType: TextInputType.visiblePassword,
                  controller: _currentPassController,
                  validator: validatePassword,
                ),
                SizedBox(height: 16),
                PasswordTextField(
                  prefixIcon: Icon(Icons.password),
                  labelText: 'New Password',
                  hintText: 'Enter New Password',
                  textInputType: TextInputType.visiblePassword,
                  controller: _newPassController,
                  validator: validatePassword,
                ),
                SizedBox(height: 16),
                PasswordTextField(
                  prefixIcon: Icon(Icons.password),
                  labelText: 'Confirm New Password',
                  hintText: 'Re-enter New Password',
                  textInputType: TextInputType.visiblePassword,
                  controller: _confirmPassController,
                  validator: validatePassword,
                ),
              ],
            ),
            SizedBox(height: 24),
            DefaultButton(
                labelText: 'Save Changes',
                textStyle: headerText16().copyWith(color: textLightColor),
                onPressed: () {
                  _changePassword();
                },
                backgroundColor: primaryColor),
          ],
        ),
      ),
    );
  }
}
