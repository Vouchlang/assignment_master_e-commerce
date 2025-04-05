import 'package:e_commerce/form_model.dart';
import 'package:e_commerce/login_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'build_widget.dart';
import 'theme.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _pswController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileController = TextEditingController();

  String _username = '';
  String _email = '';
  String _password = '';
  String _gender = '';
  String _address = '';
  String _mobile = '';

  bool obscureText = true;
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  Future<void> _signup() async {
    if (!globalKey.currentState!.validate()) {
      return;
    }

    final response = await http.post(
      Uri.parse('${apiEndpoint}user_signup.php'),
      body: {
        "username": _username,
        "email": _email,
        "password": _password,
        "gender": _gender,
        "address": _address,
        "mobile": _mobile,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        Get.to(() => const LoginForm());
        showCustomSnackBar(
          context: context,
          message: 'Sign Up Successfully',
          bgColor: Colors.green,
        );
      } else if (responseData["message"] == "Email already exists") {
        showCustomSnackBar(
          context: context,
          message: "This email is already registered. Try another one.",
          bgColor: Colors.red,
        );
      } else {
        showCustomSnackBar(
          context: context,
          message: "Signup failed. Try again.",
          bgColor: Colors.red,
        );
      }
    } else {
      showCustomSnackBar(
        context: context,
        message: "Error connecting to server. Please try again.",
        bgColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: globalKey,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Text(
                  'Sign Up',
                  style: GoogleFonts.merriweather(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: cPrimary,
                  ),
                ),
                const SizedBox(height: 30),
                buildSignUpTextFormField(
                  textController: _emailController,
                  text: 'Email',
                  onChanged: (value) => _email = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: buildSignUpTextFormField(
                        textController: _usernameController,
                        text: 'Username',
                        onChanged: (value) => _username = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _pswController,
                        style: GoogleFonts.merriweather(),
                        cursorColor: cSecondary,
                        decoration: InputDecoration(
                          label: Text(
                            'Password',
                            style: GoogleFonts.merriweather(color: cSecondary),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: cSecondary),
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
                        ),
                        obscureText: obscureText,
                        onChanged: (value) => _password = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: buildSignUpTextFormField(
                        textController: _mobileController,
                        text: 'Mobile',
                        onChanged: (value) => _mobile = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: buildSignUpTextFormField(
                        textController: _genderController,
                        text: 'Gender',
                        onChanged: (value) => _gender = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your gender';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                buildSignUpTextFormField(
                  textController: _addressController,
                  text: 'Address',
                  onChanged: (value) => _address = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    _signup();
                  },
                  child: Card(
                    color: cPrimary,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 45,
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.merriweather(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: cWhite,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Already have an Account ?',
                      style: GoogleFonts.merriweather(
                        color: cSecondary,
                        fontSize: 14,
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Get.to(() => const LoginForm());
                      },
                      child: Text(
                        'Log In',
                        style: GoogleFonts.merriweather(
                          color: cPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
