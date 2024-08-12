import 'package:flutter/material.dart';
import 'package:seek_commerce/components/button.dart';
import 'package:seek_commerce/input_validators/input_validators.dart';
import 'package:seek_commerce/provider/auth_provider.dart';
import 'package:seek_commerce/screens/signup_screen.dart';
import 'package:seek_commerce/screens/home_screen.dart';
import 'package:seek_commerce/theme/app_theme.dart';
import '../components/input_fields.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthProvider _authProvider = AuthProvider();
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
                'Login',
                style: headerText28(),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
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
                SizedBox(height: 16),
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                    },
                    child: Text(
                      'Forgot Password? Reset',
                      style: headerText14().copyWith(color: primaryColor),
                    )),
              ],
            ),
            SizedBox(height: 24),
            DefaultButton(
                labelText: 'Login',
                textStyle: headerText16().copyWith(color: textLightColor),
                onPressed: () {
                  _authProvider.login(context, _emailController.text, _passController.text);
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
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                    },
                    child: Text(
                      "Don't have an account? Signup",
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
