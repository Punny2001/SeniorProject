import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/checking_questionnaire.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/health_questionnaire.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/mental_questionnaire.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/physical_complain.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/decoration/padding.dart';

class AthleteHomePage extends StatefulWidget {
  const AthleteHomePage({Key key}) : super(key: key);

  @override
  State<AthleteHomePage> createState() => _AthleteHomePageState();
}

class _AthleteHomePageState extends State<AthleteHomePage> {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final String username = FirebaseAuth.instance.currentUser.displayName;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Colors.white,
        // padding: EdgeInsets.only(bottom: h * 0.01),
        width: w,
        height: h,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // CarouselSlider(
              //   options: CarouselOptions(
              //     height: 190,
              //     aspectRatio: 16 / 9,
              //     viewportFraction: 0.8,
              //     enableInfiniteScroll: false,
              //     autoPlayAnimationDuration: const Duration(milliseconds: 800),
              //     autoPlayCurve: Curves.fastOutSlowIn,
              //     enlargeCenterPage: true,
              //   ),
              //   items: [
              //     GestureDetector(
              //       child: Card(
              //         semanticContainer: true,
              //         clipBehavior: Clip.antiAliasWithSaveLayer,
              //         child: Container(
              //           width: double.infinity,
              //           decoration: const BoxDecoration(
              //             image: DecorationImage(
              //               image: NetworkImage(
              //                   'https://www.qusoft.com/wp-content/uploads/2020/05/quick-reportsa.png'),
              //               fit: BoxFit.fill,
              //             ),
              //           ),
              //           child: const Center(
              //             child: Text(
              //               "Coming soon",
              //               style: TextStyle(
              //                   fontSize: 30,
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.red),
              //             ),
              //           ),
              //         ),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(30.0),
              //         ),
              //         elevation: 5,
              //         margin: const EdgeInsets.all(10),
              //       ),

              //       // onTap: () => Navigator.of(context).pushNamed('/injuryReport'),
              //     ),
              //     GestureDetector(
              //       child: Card(
              //         semanticContainer: true,
              //         clipBehavior: Clip.antiAliasWithSaveLayer,
              //         child: Container(
              //           width: double.infinity,
              //           decoration: const BoxDecoration(
              //             image: DecorationImage(
              //               image: NetworkImage(
              //                   'https://www.qusoft.com/wp-content/uploads/2020/05/quick-reportsa.png'),
              //               fit: BoxFit.fill,
              //             ),
              //           ),
              //           child: const Center(
              //             child: Text(
              //               "Coming soon",
              //               style: TextStyle(
              //                   fontSize: 30,
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.red),
              //             ),
              //           ),
              //         ),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(30.0),
              //         ),
              //         elevation: 5,
              //         margin: const EdgeInsets.all(10),
              //       ),

              //       // onTap: () => Navigator.of(context).pushNamed('/injuryReport'),
              //     ),
              //     GestureDetector(
              //       child: Card(
              //         semanticContainer: true,
              //         clipBehavior: Clip.antiAliasWithSaveLayer,
              //         child: Container(
              //           width: double.infinity,
              //           decoration: const BoxDecoration(
              //             image: DecorationImage(
              //               image: NetworkImage(
              //                   'https://www.qusoft.com/wp-content/uploads/2020/05/quick-reportsa.png'),
              //               fit: BoxFit.fill,
              //             ),
              //           ),
              //           child: const Center(
              //             child: Text(
              //               "Coming soon",
              //               style: TextStyle(
              //                   fontSize: 30,
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.red),
              //             ),
              //           ),
              //         ),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(30.0),
              //         ),
              //         elevation: 5,
              //         margin: const EdgeInsets.all(10),
              //       ),

              //       // onTap: () => Navigator.of(context).pushNamed('/injuryReport'),
              //     ),
              //   ],
              // ),
              // const Padding(
              //   padding: EdgeInsets.all(10),
              // ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: w * 0.05),
                child: Text(
                  'รายงานปัญหา',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: h * 0.05,
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    width: w,
                    child: GestureDetector(
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset(
                              'assets/images/athlete_badge.jpg',
                              height: h / 4,
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
                ],
              ),
              Column(
                children: [
                  Container(
                    width: w,
                    child: GestureDetector(
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset(
                              'assets/images/athlete_badge.jpg',
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
                ],
              ),
              Column(
                children: [
                  Container(
                    width: w,
                    child: GestureDetector(
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset(
                              'assets/images/athlete_badge.jpg',
                              height: h / 4,
                              fit: BoxFit.fitWidth,
                            ),
                            Container(
                              height: h * 0.05,
                              alignment: Alignment.center,
                              child: Text(
                                'ปัญหาการนอนหลับและจิตใจ (Mental)',
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
                              MentalQuestionnaire(),
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
    );
  }
}
