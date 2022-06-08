import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StaffHomePage extends StatefulWidget {
  const StaffHomePage({Key key}) : super(key: key);

  @override
  State<StaffHomePage> createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
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
              Text(
                'Welcome back $username\n'
                'Your uid is "$uid"\n'
                'This is Staff Mode',
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
