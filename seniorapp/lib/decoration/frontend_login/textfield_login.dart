import 'package:flutter/material.dart';

InputDecoration textdecorate_login(IconData icon, String hinttext) {
  return InputDecoration(
    fillColor: const Color(0xFFCFD8DC),
    filled: true,
    prefixIcon: Icon(
      icon,
      color: Colors.black,
    ),
    hintText: hinttext,
    hintStyle: const TextStyle(fontFamily: 'OpenSans'),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFCFD8DC),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFCFD8DC),
      ),
    ),
  );
}
