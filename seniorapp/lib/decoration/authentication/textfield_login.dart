import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

InputDecoration textdecorate_login(IconData icon, String hinttext) {
  return InputDecoration(
    fillColor: CupertinoColors.systemGrey5,
    filled: true,
    prefixIcon: Icon(
      icon,
      color: Colors.black,
    ),
    hintText: hinttext,
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
        color: CupertinoColors.systemGrey5,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: CupertinoColors.systemGrey5,
      ),
    ),
  );
}
