import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import '../components/button.dart';
import '../components/input_fields.dart';
import '../input_validators/input_validators.dart';
import '../models/users.dart';
import '../provider/auth_provider.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  final User user;
  const CompleteProfileScreen({super.key, required this.user});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final AuthProvider _authProvider = AuthProvider();
  late final User user;

  File? _profileImage;
  final _imagePicker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _emailController.text = widget.user.email;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
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
              child: Text(
                'Complete Profile',
                style: headerText28(),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Icon(Icons.person, size: 80)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: _pickImage,
                        ),
                      ),
                    ],
                  ),
                ),
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
              ],
            ),
            SizedBox(height: 24),
            DefaultButton(
                labelText: 'Complete Profile',
                textStyle: headerText16().copyWith(color: textLightColor),
                onPressed: () {
                  _authProvider.completeProfile(context, user, _profileImage!);
                },
                backgroundColor: primaryColor),
          ],
        ),
      ),
    );
  }
}
