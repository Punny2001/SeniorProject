import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/auth-component/register.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:seniorapp/component/page/staff-page/record/illness_record.dart';
import 'package:seniorapp/component/page/staff-page/record/injury_record.dart';

class StaffHomePage extends StatefulWidget {
  const StaffHomePage({Key key}) : super(key: key);

  @override
  State<StaffHomePage> createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: h * 0.01),
      width: w,
      height: h,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
            //     ),
            //   ],
            // ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: w * 0.05),
                    child: Text(
                      'Record athlete\'s problem',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: h * 0.05,
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
                              'assets/images/staff_badge.jpg',
                              height: h / 4,
                              fit: BoxFit.fitWidth,
                            ),
                            Container(
                              height: h * 0.05,
                              alignment: Alignment.center,
                              child: Text(
                                'Injury record',
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
                              InjuryReport(null, null, null),
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
                              'assets/images/staff_badge.jpg',
                              height: h / 4,
                              fit: BoxFit.fitWidth,
                            ),
                            Container(
                              height: h * 0.05,
                              alignment: Alignment.center,
                              child: Text(
                                'Illness record',
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
                              const IllnessReport(null),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
