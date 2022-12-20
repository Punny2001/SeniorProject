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

InputDecoration textdecorateinday(String hinttext) {
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
    suffixText: 'days',
  );
}

Color score_color(int score) {
  if (score < 25) {
    return Colors.green[800];
  } else if (score < 50) {
    return Colors.yellow[700];
  } else if (score < 75) {
    return Colors.orange[700];
  } else {
    return Colors.red[800];
  }
}
