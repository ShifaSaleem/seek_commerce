import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seek_commerce/provider/auth_provider.dart';

import '../components/button.dart';
import '../components/input_fields.dart';
import '../input_validators/input_validators.dart';
import '../models/users.dart';
import '../theme/app_theme.dart';
import 'cart_screen.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthProvider _authProvider = AuthProvider();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  late User user;
  File? _image;
  @override
  void initState() {
    super.initState();
    user = _authProvider.getProfile() as User;
  }
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Profile',
            style: headerText24().copyWith(color: textLightColor)),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationsScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Stack(
                    children: [
                      Center(
                        child: _image != null
                            ? CircleAvatar(
                          radius: 80,
                          backgroundImage: FileImage(_image!),
                        )
                            : CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(user.profileImage!),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.edit),
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
                labelText: 'Edit Profile',
                textStyle: headerText16().copyWith(color: textLightColor),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(user: user)));
                },
                backgroundColor: primaryColor),
            SizedBox(height: 16),
            OutlineButton(
                labelText: 'Change Password',
                textStyle: headerText16().copyWith(color: primaryColor),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen()));
                },
                borderColor: primaryColor),
            SizedBox(height: 16),
            DefaultButton(
                labelText: 'Logout',
                textStyle: headerText16().copyWith(color: textLightColor),
                onPressed: () {
                _authProvider.logout(context);
                },
                backgroundColor: primaryColor),
          ],
        ),
      ),
    );
  }
}
