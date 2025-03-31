import 'package:e_commerce/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: cPrimary,
        useMaterial3: true,
      ),
      home: const LoginForm(),
      debugShowCheckedModeBanner: false,
    );
  }
}
