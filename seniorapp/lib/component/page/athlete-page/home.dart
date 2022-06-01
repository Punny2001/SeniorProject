import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/component/user-data/user.dart';

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
              Text(
                'Welcome back $username\n'
                'Your uid is "$uid"\n'
                'This is Athlete mode',
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
