import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorapp/auth-component/login.dart';
import 'package:seniorapp/auth-component/userdata.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final String _uid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    String _sportType;
    String _firstname;
    String _lastname;
    String _username;
    DateTime _date;

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: 50),
        margin: EdgeInsets.all(30),
        width: w,
        height: h,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Your uid is "$_uid"',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(),
    );
  }
}
