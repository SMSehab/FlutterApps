import 'package:flutter/material.dart';

InputDecoration textInputDecoration(String hint) {
  return InputDecoration(
      hintText: hint,
      fillColor: Colors.white,
      filled: true,
      contentPadding: EdgeInsets.all(12.0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pink, width: 2.0),),);
}
