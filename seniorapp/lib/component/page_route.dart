import 'package:flutter/material.dart';
import 'package:seniorapp/auth-component/forgot_password.dart';
import 'package:seniorapp/auth-component/login.dart';
import 'package:seniorapp/auth-component/register.dart';
import 'package:seniorapp/component/language.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_notify.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_page_choosing.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_profile.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/checking_questionnaire.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/health_questionnaire.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/mental_questionnaire.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/physical_complain.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/result.dart';
import 'package:seniorapp/component/page/staff-page/record/illness_record.dart';
import 'package:seniorapp/component/page/staff-page/record/injury_record.dart';
import 'package:seniorapp/component/page/staff-page/staff_notify.dart';
import 'package:seniorapp/component/page/staff-page/staff_page_choosing.dart';
import 'package:seniorapp/component/page/staff-page/history_details/illness_report_description.dart';
import 'package:seniorapp/component/page/staff-page/staff_profile.dart';

final Map<String, WidgetBuilder> map = {
  '/login': (BuildContext context) => Login(),
  '/register': (BuildContext context) => Register(),
  '/athletePageChoosing': (BuildContext context) => AthletePageChoosing(),
  '/staffPageChoosing': (BuildContext context) => StaffPageChoosing(),
  '/language': (BuildContext context) => LanguageSign(),
  '/forgotPassword': (BuildContext context) => ForgotPassword(),
  '/mentalQuestionnaire': (BuildContext context) => MentalQuestionnaire(),
  '/healthQuestionnaire': (BuildContext context) => HealthQuestionnaire(),
  '/physicalQuestionnaire': (BuildContext context) => PhysicalQuestionnaire(),
  '/injuryReport': (BuildContext context) => InjuryReport(),
  '/illnessReport': (BuildContext context) => IllnessReport(),
  '/staffProfile': (BuildContext context) => StaffProfile(),
  '/staffNotification': (BuildContext context) => StaffNotify(),
  '/athleteProfile': (BuildContext context) => AthleteProfile(),
  '/resultPage': (BuildContext context) => Result(),
  '/athleteNotification': (BuildContext context) => AthleteNotify(),
};
