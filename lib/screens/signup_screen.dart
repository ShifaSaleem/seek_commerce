import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/input_fields.dart';
import '../input_validators/input_validators.dart';
import '../provider/auth_provider.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthProvider _authProvider= AuthProvider();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
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
              child: Text(
                'Signup',
                style: headerText28(),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DefaultTextField(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Full Name',
                  hintText: 'Enter Full Name',
                  textInputType: TextInputType.name,
                  controller: _nameController,
                  validator: validateName,
                ),
                SizedBox(height: 16),
                DefaultTextField(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                  hintText: 'username@gmail.com',
                  textInputType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: validateEmail,
                ),
                SizedBox(height: 16),
                PasswordTextField(
                  prefixIcon: Icon(Icons.password),
                  labelText: 'Password',
                  hintText: 'Enter Password',
                  textInputType: TextInputType.visiblePassword,
                  controller: _passController,
                  validator: validatePassword,
                ),
              ],
            ),
            SizedBox(height: 24),
            DefaultButton(
                labelText: 'Signup',
                textStyle: headerText16().copyWith(color: textLightColor),
                onPressed: () {
                  _authProvider.register(context, _nameController.text, _emailController.text, _passController.text, 2);
                  _nameController.clear();
                  _emailController.clear();
                  _passController.clear();
                },
                backgroundColor: primaryColor),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      "Already have an account? Login",
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


