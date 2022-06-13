import 'package:flutter/material.dart';

class StaffHomePage extends StatefulWidget {
  const StaffHomePage({Key key}) : super(key: key);

  @override
  State<StaffHomePage> createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  // FirebaseAuth auth = FirebaseAuth.instance;
  // final String uid = FirebaseAuth.instance.currentUser.uid;
  // final String username = FirebaseAuth.instance.currentUser.displayName;

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
                child: ElevatedButton(
                  child: Text('Injury Report'),
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/injuryReport'),
                ),
              ),
              Center(
                child: ElevatedButton(
                  child: Text('Illness Report'),
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/illnessReport'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
