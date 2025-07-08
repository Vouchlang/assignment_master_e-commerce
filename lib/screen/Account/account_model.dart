import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';

Widget buildLabelText(
  String text,
) {
  return Text(
    text,
    style: GoogleFonts.merriweather(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    ),
  );
}

Widget buildTextBox({
  required String text,
}) {
  return Container(
    height: 45,
    padding: const EdgeInsets.symmetric(horizontal: 5),
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: cWhite,
      border: Border.all(color: cSecondary),
    ),
    child: Text(
      text,
      style: GoogleFonts.merriweather(fontWeight: FontWeight.w500),
    ),
  );
}

Widget buildEditTextBox({
  required TextEditingController textController,
  required String text,
}) {
  return Container(
    height: 45,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: cWhite,
    ),
    child: TextFormField(
      textAlign: TextAlign.start,
      cursorColor: cSecondary,
      controller: textController,
      style: GoogleFonts.merriweather(),
      onChanged: (value) => text = value,
      decoration: InputDecoration(
        fillColor: cWhite,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
  );
}

Widget buildSpp(
  Function() customDialog,
  String text,
) {
  return InkWell(
    onTap: customDialog,
    child: Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: cSecondary),
        ),
      ),
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: GoogleFonts.merriweather(),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),
        ],
      ),
    ),
  );
}

Widget buildChangePsw({
  required final TextEditingController controller,
  required final bool obscureText,
  required String psw,
  required final String txtValidator,
  required Function() onTap,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: cWhite,
    ),
    child: TextFormField(
      textAlign: TextAlign.start,
      cursorColor: cSecondary,
      controller: controller,
      style: GoogleFonts.merriweather(),
      onChanged: (value) => psw = value,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return txtValidator;
        }
        return null;
      },
      decoration: InputDecoration(
        fillColor: cWhite,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 5,
        ),
        suffix: InkWell(
          splashColor: Colors.transparent,
          onTap: onTap,
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
  );
}
