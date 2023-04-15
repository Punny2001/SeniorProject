import 'package:flutter/material.dart';

InputDecoration textdecorate(String hinttext) {
  return InputDecoration(
    fillColor: const Color.fromRGBO(217, 217, 217, 100),
    filled: true,
    hintText: hinttext,
    hintStyle: const TextStyle(fontFamily: 'OpenSans'),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(217, 217, 217, 100),
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(217, 217, 217, 100),
      ),
    ),
  );
}

InputDecoration textdecorateinday(String hinttext) {
  return InputDecoration(
    fillColor: const Color.fromRGBO(217, 217, 217, 100),
    filled: true,
    hintText: hinttext,
    hintStyle: const TextStyle(fontFamily: 'OpenSans'),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(217, 217, 217, 100),
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(217, 217, 217, 100),
      ),
    ),
    suffixText: 'days',
  );
}

Color score_color(int score) {
  if (score < 25) {
    return Colors.green[800];
  } else if (score < 50) {
    return Colors.yellow[600];
  } else if (score < 75) {
    return Colors.orange[800];
  } else {
    return Colors.red[800];
  }
}
