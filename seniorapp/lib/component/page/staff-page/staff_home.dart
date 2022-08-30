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
                options:
                CarouselOptions(
                  height: 190,
                  aspectRatio: 16/9,
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
                            image: NetworkImage('https://www.qusoft.com/wp-content/uploads/2020/05/quick-reportsa.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child:
                        const Center(
                          child: Text(
                              "Coming soon",
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red),
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
                            image: NetworkImage('https://www.qusoft.com/wp-content/uploads/2020/05/quick-reportsa.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child:
                        const Center(
                          child: Text(
                            "Coming soon",
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red),
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
                            image: NetworkImage('https://www.qusoft.com/wp-content/uploads/2020/05/quick-reportsa.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child:
                        const Center(
                          child: Text(
                            "Coming soon",
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red),
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
                  onTap: () => Navigator.of(context).pushNamed('/injuryReport'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(4),
              ),
              const Text(
                'Injury report',
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
                  onTap: () => Navigator.of(context).pushNamed('/illnessReport'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(4),
              ),
              const Text(
                'Illness report',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget carouselView(int index) {
    return Container();
  }
}
