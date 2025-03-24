import 'dart:ui';

import 'package:e_commerce/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screen/bottom_bar.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _email = '';
  String _password = '';
  bool isChanged = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
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
                cursorColor: Colors.black54,
                decoration: InputDecoration(
                  label: Text(
                    'Email',
                    style: GoogleFonts.nunito(),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black54),
                  ),
                ),
                onChanged: (value) => _email = value,
              ),
              const SizedBox(height: 15),
              TextFormField(
                cursorColor: Colors.black54,
                decoration: InputDecoration(
                  label: Text(
                    'Password',
                    style: GoogleFonts.nunito(),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black54),
                  ),
                ),
                obscureText: false,
                onChanged: (value) => _password = value,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  FlutterSwitch(
                    width: 50.0,
                    height: 30.0,
                    value: isChanged,
                    onToggle: ((val) {
                      setState(() {
                        isChanged = val;
                      });
                    }),
                    activeColor: Colors.green,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Remember',
                    style: GoogleFonts.nunito(),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  if (_email == 'admin' && _password == '123') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (buildContext) => const BottomBar(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Incorrect Email and Password",
                          style: GoogleFonts.nunito(color: cWhite),
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                },
                child: Card(
                  color: cPrimary,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 35,
                    child: Text(
                      'Login',
                      style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 16),
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
                    style: GoogleFonts.nunito(
                      color: cBaseA,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Sign Up!',
                    style: GoogleFonts.nunito(
                      color: cBaseB,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
