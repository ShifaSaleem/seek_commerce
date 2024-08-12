import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../components/button.dart';
import '../components/input_fields.dart';
import '../input_validators/input_validators.dart';
import '../models/users.dart';
import '../provider/auth_provider.dart';
import '../theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthProvider _authProvider = AuthProvider();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  File? _image;


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
        title: Text('Edit Profile', style: headerText24()),
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
                          backgroundImage: NetworkImage(widget.user.profileImage!),
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
                labelText: 'Save Changes',
                textStyle: headerText16().copyWith(color: textLightColor),
                onPressed: () {
                  _authProvider.updateProfile(context,_nameController.text, _emailController.text, _image!);

                },
                backgroundColor: primaryColor),
          ],
        ),
      ),
    );
  }
}
