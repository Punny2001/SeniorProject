import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/auth-component/register.dart';

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
}
