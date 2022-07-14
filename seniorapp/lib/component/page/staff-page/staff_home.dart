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
                child: ElevatedButton(
                  child: const Text('Injury Report'),
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/injuryReport'),
                ),
              ),
              Center(
                child: ElevatedButton(
                  child: const Text('Illness Report'),
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
