import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_commerce/screen/Account/acc_screen.dart';
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
  String text,
) {
  return Container(
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
  );
}

Widget buildDropDown({
  required double width,
  required String value,
  required List<String> valueList,
  required dynamic function,
}) {
  return Container(
    padding: const EdgeInsets.all(5),
    alignment: Alignment.centerLeft,
    height: 45,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: cSecondary,
        width: 1,
      ),
      color: cWhite,
    ),
    child: DropdownButton2(
      dropdownStyleData: DropdownStyleData(
        elevation: 1,
        width: width,
        direction: DropdownDirection.textDirection,
        decoration: const BoxDecoration(
          color: cWhite,
        ),
      ),
      buttonStyleData: const ButtonStyleData(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
      ),
      barrierColor: Colors.transparent,
      isExpanded: true,
      isDense: true,
      style: GoogleFonts.merriweather(color: cSecondary),
      value: value,
      autofocus: false,
      enableFeedback: true,
      underline: const SizedBox(),
      alignment: Alignment.topLeft,
      items: dropDown(valueList),
      onChanged: function,
    ),
  );
}
