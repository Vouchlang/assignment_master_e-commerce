import 'package:e_commerce/form_model.dart';
import 'package:e_commerce/login_form.dart';
import 'package:flutter/material.dart';
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

  bool obscureText = true;
  bool _isLoading = false;
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  Future<void> _signup() async {
    if (!globalKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('${apiEndpoint}user_signup.php'),
      body: {
        "username": _usernameController.text,
        "email": _emailController.text,
        "password": _pswController.text,
        "gender": _genderController.text,
        "address": _addressController.text,
        "mobile": _mobileController.text,
      },
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (buildContext) => const SignUpForm(),
          ),
        );
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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: globalKey,
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
                  validator: (value) => value!.isEmpty ? "Enter Email" : null,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: buildSignUpTextFormField(
                        textController: _usernameController,
                        text: 'Username',
                        validator: (value) => value!.isEmpty ? "Enter Username" : null,
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
                        validator: (value) => value!.isEmpty ? "Enter Password" : null,
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
                        validator: (value) => value!.isEmpty ? "Enter Mobile Number" : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: buildSignUpTextFormField(
                        textController: _genderController,
                        text: 'Gender',
                        validator: (value) => value!.isEmpty ? "Enter Gender" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                buildSignUpTextFormField(
                  textController: _addressController,
                  text: 'Address',
                  validator: (value) => value!.isEmpty ? "Enter Address" : null,
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator()
                    : InkWell(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext) => const LoginForm(),
                          ),
                        );
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
