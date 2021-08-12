import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


// custom input decoration for all input text boxes.
InputDecoration textInputDecoration(String hint) {
  return InputDecoration(
    labelStyle: TextStyle(fontSize: 13),
    hintText: (hint == 'name') ? "Make unique name, so that unknown people can't guess it." : hint,
    hintStyle: (hint == 'name') ? TextStyle(fontSize: 12, fontWeight: FontWeight.normal) : TextStyle(),
    labelText: (hint == 'name' || hint == 'bio') ? 'Edit ' + hint : hint,
    fillColor:
        (hint == 'Name' || hint == 'Bio') ? Colors.white10 : Colors.white,
    filled: true,
    contentPadding: EdgeInsets.all(12.0),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
          color: (hint == 'Name' || hint == 'Bio')
              ? Colors.white60 //grey[300]
              : Colors.white,
          width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pink, width: 2.0),
    ),
  );
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}