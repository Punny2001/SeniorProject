import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/auth-component/register.dart';
import 'package:carousel_slider/carousel_slider.dart';

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

    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: h * 0.01),
        width: w,
        height: h,
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
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: GestureDetector(
                            child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Image.network(
                                'https://www.qusoft.com/wp-content/uploads/2020/05/quick-reportsa.png',
                                fit: BoxFit.fill,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              elevation: 5,
                              margin: const EdgeInsets.all(10),
                            ),
                            onTap: () => Navigator.of(context)
                                .pushNamed('/injuryReport'),
                          ),
                        ),
                        Text(
                          'Injury report',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: GestureDetector(
                            child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Image.network(
                                'https://www.qusoft.com/wp-content/uploads/2020/05/quick-reportsa.png',
                                fit: BoxFit.fill,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              elevation: 5,
                              margin: const EdgeInsets.all(10),
                            ),
                            onTap: () => Navigator.of(context)
                                .pushNamed('/illnessReport'),
                          ),
                        ),
                        const Text(
                          'Illness report',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget carouselView(int index) {
    return Container();
  }
}
