import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../build_widget.dart';
import '../../theme.dart';
import '../bottom_bar.dart';
import 'acc_class.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'account_model.dart';

class EditAccScreen extends StatefulWidget {
  final List<UserAcc> dataUserAcc;

  const EditAccScreen({super.key, required this.dataUserAcc});

  @override
  State<EditAccScreen> createState() => _EditAccScreenState();
}

class _EditAccScreenState extends State<EditAccScreen> {
  List<UserAcc> dataUser = [];

  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;

  late TextEditingController _userIdController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _emailController;
  late TextEditingController _genderController;
  late TextEditingController _addressController;
  late TextEditingController _mobileController;

  @override
  void initState() {
    super.initState();
    _userIdController = TextEditingController(text: widget.dataUserAcc[0].userId.toString());
    _usernameController = TextEditingController(text: widget.dataUserAcc[0].username);
    _passwordController = TextEditingController(text: widget.dataUserAcc[0].password);
    _emailController = TextEditingController(text: widget.dataUserAcc[0].email);
    _genderController = TextEditingController(text: widget.dataUserAcc[0].gender);
    _addressController = TextEditingController(text: widget.dataUserAcc[0].address);
    _mobileController = TextEditingController(text: widget.dataUserAcc[0].mobile);
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final response = await http.post(
        Uri.parse('${apiEndpoint}user_update.php'),
        body: {
          'username': _usernameController.text,
          'password': _passwordController.text,
          'email': _emailController.text,
          'gender': _genderController.text,
          'address': _addressController.text,
          'mobile': _mobileController.text,
        },
      );

      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody['status'] == 'success') {
        if (mounted) {
          showCustomSnackBar(
            context: context,
            message: responseBody['message'],
            bgColor: Colors.green,
          );
        }
      }
    } catch (error) {
      if (mounted) {
        showCustomSnackBar(
          context: context,
          message: 'Failed to update profile. Try again.',
          bgColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBGColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                cPrimary,
                cBGColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Text(
          'Edit Account',
          style: GoogleFonts.merriweather(
            color: cSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                buildLabelText('Username'),
                buildEditTextBox(
                  textController: _usernameController,
                  text: widget.dataUserAcc[0].username,
                ),
                const SizedBox(height: 15),
                buildLabelText('Password'),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: cWhite,
                  ),
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    cursorColor: cSecondary,
                    controller: _passwordController,
                    style: GoogleFonts.merriweather(),
                    onChanged: (value) => widget.dataUserAcc[0].password = value,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      fillColor: cWhite,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 5,
                      ),
                      suffix: InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        child: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                          color: cSecondary,
                          size: 18,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: cSecondary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: cSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                buildLabelText('Gender'),
                buildEditTextBox(
                  textController: _genderController,
                  text: widget.dataUserAcc[0].gender,
                ),
                const SizedBox(height: 15),
                buildLabelText('Address'),
                buildEditTextBox(
                  textController: _addressController,
                  text: widget.dataUserAcc[0].address,
                ),
                const SizedBox(height: 15),
                buildLabelText('Mobile Number'),
                buildEditTextBox(
                  textController: _mobileController,
                  text: widget.dataUserAcc[0].mobile,
                ),
                const SizedBox(height: 15),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () async {
                    await _updateProfile();

                    List<UserAcc> updatedUserData = [
                      UserAcc(
                        userId: int.parse(_userIdController.text),
                        username: _usernameController.text,
                        password: _passwordController.text,
                        email: _emailController.text,
                        gender: _genderController.text,
                        address: _addressController.text,
                        mobile: _mobileController.text,
                      ),
                    ];

                    Get.off(
                      () => BottomBar(
                        dataUserAcc: updatedUserData,
                        currentIndex: 3,
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black87,
                      border: Border.all(color: cWhite),
                    ),
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Text(
                      'Update Profile',
                      style: GoogleFonts.merriweather(
                        color: cWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
