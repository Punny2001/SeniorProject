import 'package:flutter/material.dart';
import 'package:seniorapp/auth-component/forgot_password.dart';
import 'package:seniorapp/auth-component/login.dart';
import 'package:seniorapp/auth-component/register.dart';
import 'package:seniorapp/component/language.dart';
import 'package:seniorapp/component/page/athlete-page/notify-page/athlete_notify.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_page_choosing.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_profile.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/health_questionnaire.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/mental_questionnaire.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/physical_complain.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/result.dart';
import 'package:seniorapp/component/page/staff-page/notify-page/staff_notify.dart';
import 'package:seniorapp/component/page/staff-page/staff_page_choosing.dart';
import 'package:seniorapp/component/page/staff-page/staff_profile.dart';

final Map<String, WidgetBuilder> map = {
  '/login': (BuildContext context) => const Login(),
  '/register': (BuildContext context) => const Register(),
  '/athletePageChoosing': (BuildContext context) => const AthletePageChoosing(),
  '/staffPageChoosing': (BuildContext context) => const StaffPageChoosing(),
  '/language': (BuildContext context) => LanguageSign(),
  '/forgotPassword': (BuildContext context) => const ForgotPassword(),
  '/mentalQuestionnaire': (BuildContext context) => const MentalQuestionnaire(),
  '/healthQuestionnaire': (BuildContext context) => HealthQuestionnaire(),
  '/physicalQuestionnaire': (BuildContext context) => PhysicalQuestionnaire(),
  '/staffProfile': (BuildContext context) => const StaffProfile(),
  '/staffNotification': (BuildContext context) => const StaffNotify(),
  '/athleteProfile': (BuildContext context) => const AthleteProfile(),
  '/resultPage': (BuildContext context) => Result(),
  '/athleteNotification': (BuildContext context) => const AthleteCaseNotify(),
};
