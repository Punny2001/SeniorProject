import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';

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
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(top: 50),
        margin: const EdgeInsets.all(30),
        width: w,
        height: h,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // PageView.builder(
              //     itemCount: images.length,
              //     physics: const ClampingScrollPhysics(),
              //     itemBuilder: (context,index){
              //       return Container(
              //         margin: const EdgeInsets.symmetric(horizontal: 16.0),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(20.0),
              //           image:
              //         ),
              //       );
              //     }),
              CarouselSlider(
                options: CarouselOptions(
                  height: 190,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  enableInfiniteScroll: false,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                ),
                items: [
                  GestureDetector(
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://www.qusoft.com/wp-content/uploads/2020/05/quick-reportsa.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Coming soon",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                    ),

                    // onTap: () => Navigator.of(context).pushNamed('/injuryReport'),
                  ),
                  GestureDetector(
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://www.qusoft.com/wp-content/uploads/2020/05/quick-reportsa.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Coming soon",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                    ),

                    // onTap: () => Navigator.of(context).pushNamed('/injuryReport'),
                  ),
                  GestureDetector(
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://www.qusoft.com/wp-content/uploads/2020/05/quick-reportsa.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Coming soon",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                    ),

                    // onTap: () => Navigator.of(context).pushNamed('/injuryReport'),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(10),
              ),
              Center(
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
                  onTap: () => Navigator.of(context).pushNamed('/mentalQuiz'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(4),
              ),
              const Text(
                'Mental Questionnaire',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
              ),
              Center(
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
                  onTap: () =>
                      Navigator.of(context).pushNamed('/physicalQuiz'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(4),
              ),
              const Text(
                'Physical Questionnaire',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
