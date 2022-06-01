import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StaffProfile extends StatefulWidget {
  const StaffProfile({Key key}) : super(key: key);

  @override
  State<StaffProfile> createState() => _StaffProfileState();
}

class _StaffProfileState extends State<StaffProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Log Out'),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            );
          },
        ),
      ),
    );
  }
}
