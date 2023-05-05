import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_page_choosing.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/health_questionnaire.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/mental_questionnaire.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/physical_complain.dart';

class AthleteHomePage extends StatefulWidget {
  const AthleteHomePage({Key key}) : super(key: key);

  @override
  State<AthleteHomePage> createState() => _AthleteHomePageState();
}

class _AthleteHomePageState extends State<AthleteHomePage> {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final String username = FirebaseAuth.instance.currentUser.displayName;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Container(
          width: w,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: Colors.green[300],
          ),
          child: Padding(
            padding: EdgeInsets.only(left: w * 0.05, bottom: h * 0.02),
            child: Text(
              'ยินดีต้อนรับกลับ!! ${athlete.username}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: h * 0.04,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            width: w,
            height: h,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'รายงานปัญหา',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: h * 0.03,
                    ),
                  ),
                  SizedBox(
                    width: w,
                    child: GestureDetector(
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset(
                              'assets/images/physical.jpg',height: h / 4,
                              fit: BoxFit.fitWidth,
                            ),
                            Container(
                              height: h * 0.05,
                              alignment: Alignment.center,
                              child: Text(
                                'อาการบาดเจ็บทางร่างกาย (Physical)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: h * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              PhysicalQuestionnaire(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: w,
                    child: GestureDetector(
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset(
                              'assets/images/health.jpg',
                              height: h / 4,
                              fit: BoxFit.fitWidth,
                            ),
                            Container(
                              height: h * 0.05,
                              alignment: Alignment.center,
                              child: Text(
                                'ปัญหาสุขภาพ (Health)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: h * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              HealthQuestionnaire(),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: w,
                        child: GestureDetector(
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Image.asset(
                                  'assets/images/sleep.jpg',
                                  height: h / 4,
                                  fit: BoxFit.fitWidth,
                                ),
                                Container(
                                  height: h * 0.05,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'ปัญหาการนอนหลับ (Sleeping problem)',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: h * 0.02,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
                          ),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const MentalQuestionnaire(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
