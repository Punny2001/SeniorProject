import 'package:flutter/material.dart';

InputDecoration textdecorate(String hinttext) {
  return InputDecoration(
    fillColor: Color.fromRGBO(217, 217, 217, 100),
    filled: true,
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
        color: Color.fromRGBO(217, 217, 217, 100),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(217, 217, 217, 100),
      ),
    ),
  );
}
