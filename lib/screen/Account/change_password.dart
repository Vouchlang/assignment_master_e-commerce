import 'package:e_commerce/login_form.dart';
import 'package:e_commerce/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../build_widget.dart';
import 'acc_class.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'account_model.dart';

class ChangePasswordScreen extends StatefulWidget {
  final List<UserAcc> dataUserAcc;
  const ChangePasswordScreen({super.key, required this.dataUserAcc});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  List<UserAcc> dataUser = [];

  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool obscureText2 = true;
  bool obscureText3 = true;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final current = _currentPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (newPass != confirm) {
      _showErrorDialog('New password and confirm password do not match');
      return;
    }

    final response = await http.post(
      Uri.parse('${apiEndpoint}user_change_password.php'),
      body: {
        'email': widget.dataUserAcc[0].email,
        'currentPassword': current,
        'newPassword': newPass,
        'confirmPassword': confirm,
      },
    );

    try {
      final result = jsonDecode(response.body);
      if (result['status'] == 'success') {
        if (mounted) {
          showCustomSnackBar(
            context: context,
            message: 'Password updated successfully',
            bgColor: Colors.green,
          );
        }
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Get.off(() => const LoginForm());
      } else {
        _showErrorDialog('Incorrect Current Password');
      }
    } catch (e) {
      _showErrorDialog('Failed to connect to the server');
    }
  }

  void _showErrorDialog(String message) {
    setState(() {
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    });
    showCustomSnackBar(
      context: context,
      message: message,
      bgColor: Colors.red,
    );
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
          'Change Password',
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 15),
                  buildLabelText('Current Password'),
                  buildChangePsw(
                    controller: _currentPasswordController,
                    obscureText: obscureText,
                    psw: widget.dataUserAcc[0].password,
                    txtValidator: 'Please Enter Your Current Password',
                    onTap: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  buildLabelText('New Password'),
                  buildChangePsw(
                    controller: _newPasswordController,
                    obscureText: obscureText2,
                    psw: widget.dataUserAcc[0].password,
                    txtValidator: 'Please Enter Your New Password',
                    onTap: () {
                      setState(() {
                        obscureText2 = !obscureText2;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  buildLabelText('Verify New Password'),
                  buildChangePsw(
                    controller: _confirmPasswordController,
                    obscureText: obscureText3,
                    psw: widget.dataUserAcc[0].password,
                    txtValidator: 'Please Verify Your New Password',
                    onTap: () {
                      setState(() {
                        obscureText3 = !obscureText3;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  _changePassword();
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 45),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black87,
                    border: Border.all(color: cWhite),
                  ),
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Text(
                    'Update Password',
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
    );
  }
}
