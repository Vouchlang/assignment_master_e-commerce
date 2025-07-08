import 'package:e_commerce/screen/bottom_bar.dart';
import 'package:e_commerce/sign_up_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'build_widget.dart';
import 'screen/Account/acc_class.dart';
import 'theme.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _pswController = TextEditingController();
  String _email = '';
  String _password = '';

  bool obscureText = true;
  bool isChanged = false;
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _login() async {
    if (!globalKey.currentState!.validate()) {
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${apiEndpoint}user_login.php'),
        body: {
          'email': _email,
          'password': _password,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          final userData = data['user'];
          List<UserAcc> dataUser = [];
          for (var item in userData) {
            UserAcc userModel = UserAcc(
              userId: int.parse(item['id'].toString()),
              username: item['username'],
              email: item['email'],
              password: item['password'],
              gender: item['gender'],
              address: item['address'],
              mobile: item['mobile'],
            );
            dataUser.add(userModel);
          }
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (isChanged) {
            await prefs.setBool('isLoggedIn', true);
            await prefs.setString('email', _email);
            await prefs.setString('password', _password);
          } else {
            await prefs.clear();
          }

          Get.off(() => BottomBar(dataUserAcc: dataUser));
        } else {
          return;
        }
      } else {
        _showErrorDialog('Invalid credentials');
      }
    } catch (error) {
      _showErrorDialog('Failed to connect to the server');
    }
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      String savedEmail = prefs.getString('email') ?? '';
      String savedPassword = prefs.getString('password') ?? '';

      // Auto-login
      final response = await http.post(
        Uri.parse('${apiEndpoint}user_login.php'),
        body: {
          'email': savedEmail,
          'password': savedPassword,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          final userData = data['user'];
          List<UserAcc> dataUser = [];
          for (var item in userData) {
            UserAcc userModel = UserAcc(
              userId: int.parse(item['id'].toString()),
              username: item['username'],
              email: item['email'],
              password: item['password'],
              gender: item['gender'],
              address: item['address'],
              mobile: item['mobile'],
            );
            dataUser.add(userModel);
          }
          Get.off(() => BottomBar(dataUserAcc: dataUser));
        }
      }
    }
  }

  void _showErrorDialog(String message) {
    setState(() {
      _emailController.clear();
      _pswController.clear();
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
      backgroundColor: Colors.white,
      body: Form(
        key: globalKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 75),
                Image.asset(
                  'assets/logo_amazon.jpg',
                  fit: BoxFit.cover,
                  width: 125,
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: _emailController,
                  style: GoogleFonts.merriweather(),
                  cursorColor: cSecondary,
                  decoration: InputDecoration(
                    label: Text(
                      'Email',
                      style: GoogleFonts.merriweather(color: cSecondary),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: cSecondary),
                    ),
                  ),
                  onChanged: (value) => _email = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
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
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Remember',
                      style: GoogleFonts.merriweather(fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    FlutterSwitch(
                      width: 45,
                      height: 27,
                      value: isChanged,
                      onToggle: ((val) {
                        setState(() {
                          isChanged = val;
                        });
                      }),
                      activeColor: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    _login();
                  },
                  child: Card(
                    color: cPrimary,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 45,
                      child: Text(
                        'Sign In',
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
                      'Dont have an Account ?',
                      style: GoogleFonts.merriweather(
                        color: cSecondary,
                        fontSize: 14,
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Get.to(() => const SignUpForm());
                      },
                      child: Text(
                        'Sign Up',
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
