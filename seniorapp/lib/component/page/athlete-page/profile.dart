import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AthleteProfile extends StatefulWidget {
  const AthleteProfile({Key key}) : super(key: key);

  @override
  State<AthleteProfile> createState() => _AthleteProfileState();
}

class _AthleteProfileState extends State<AthleteProfile> {
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
