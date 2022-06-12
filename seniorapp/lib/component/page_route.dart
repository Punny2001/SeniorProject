import 'package:flutter/material.dart';
import 'package:seniorapp/auth-component/forgot_password.dart';
import 'package:seniorapp/auth-component/login.dart';
import 'package:seniorapp/auth-component/register.dart';
import 'package:seniorapp/auth-component/verify_email.dart';
import 'package:seniorapp/component/language.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_page_choosing.dart';
import 'package:seniorapp/component/page/quiz-page/mental_quiz.dart';
import 'package:seniorapp/component/page/staff-page/injury_report.dart';
import 'package:seniorapp/component/page/staff-page/staff_page_choosing.dart';

final Map<String, WidgetBuilder> map = {
  '/login': (BuildContext context) => Login(),
  '/register': (BuildContext context) => Register(),
  '/athletePageChoosing': (BuildContext context) => AthletePageChoosing(),
  '/staffPageChoosing': (BuildContext context) => StaffPageChoosing(),
  '/language': (BuildContext context) => LanguageSign(),
  '/forgotPassword': (BuildContext context) => ForgotPassword(),
  '/verifyEmail': (BuildContext context) => VerifyEmail(),
  '/mentalQuiz': (BuildContext context) => MentalQuiz(),
  '/injuryReport': (BuildContext context) => InjuryReport(),
};
