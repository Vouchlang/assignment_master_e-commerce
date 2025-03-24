import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_commerce/screen/Account/acc_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildLabelText(
  String text,
) {
  return Text(
    text,
    style: GoogleFonts.nunito(
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget buildTextBox({
  required TextEditingController textController,
  required String text,
}) {
  return SizedBox(
    height: 45,
    child: TextFormField(
      textAlign: TextAlign.start,
      cursorColor: Colors.black54,
      controller: textController,
      style: GoogleFonts.nunito(),
      onChanged: (value) => text = value,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.black54,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.black54,
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
        bottom: BorderSide(color: Colors.black54),
      ),
    ),
    height: 45,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
          ),
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
        color: Colors.black54,
        width: 1,
      ),
    ),
    child: DropdownButton2(
      dropdownStyleData: DropdownStyleData(
        elevation: 1,
        width: width,
        direction: DropdownDirection.textDirection,
      ),
      buttonStyleData: const ButtonStyleData(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
      ),
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      isExpanded: true,
      isDense: true,
      style: GoogleFonts.nunito(color: Colors.black),
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
