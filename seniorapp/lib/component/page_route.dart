import 'package:flutter/material.dart';
import 'package:seniorapp/auth-component/login.dart';
import 'package:seniorapp/auth-component/register.dart';
import 'package:seniorapp/component/language.dart';
import 'package:seniorapp/component/page/home.dart';
import 'package:seniorapp/component/page_choosing.dart';

final Map<String, WidgetBuilder> map = {
  '/login': (BuildContext context) => Login(),
  '/register': (BuildContext context) => Register(),
  '/pageChoosing': (BuildContext context) => PageChoosing(),
  '/language': (BuildContext context) => LanguageSign(),
  '/home': (BuildContext context) => HomePage(),
};
