import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';

Widget buildSignUpTextFormField({
  required TextEditingController textController,
  required String text,
  required Function(String) onChanged,
  required dynamic validator,
}) {
  return TextFormField(
    controller: textController,
    style: GoogleFonts.merriweather(),
    cursorColor: cSecondary,
    decoration: InputDecoration(
      label: Text(
        text,
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
    onChanged: onChanged,
    validator: validator,
  );
}
