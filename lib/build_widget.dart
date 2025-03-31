import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  required Color bgColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: GoogleFonts.merriweather(color: cWhite, fontSize: 13),
      ),
      backgroundColor: bgColor,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
