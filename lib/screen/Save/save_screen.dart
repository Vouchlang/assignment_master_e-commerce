import 'package:flutter/material.dart';
import '../../theme.dart';

class SaveScreen extends StatelessWidget {
  const SaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  cBGColor,
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
        title: const Text(
          'Save',
          style: TextStyle(
            color: cWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: cPrimary,
      ),
    );
  }
}
