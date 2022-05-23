import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserData {
  final String _username;
  final String _firstname;
  final String _lastname;
  final String _sportType;
  final DateTime _date;

  UserData(this._username, this._firstname, this._lastname, this._sportType,
      this._date);

  final String _uid = FirebaseAuth.instance.currentUser.uid.toString();
  final String _email = FirebaseAuth.instance.currentUser.email.toString();

  Future<void> userSetup() {
    FirebaseFirestore.instance.collection('UserData').add(
      {
        'uid': _uid,
        'email': _email,
        'username': _username,
        'firstname': _firstname,
        'lastname': _lastname,
        'birthdate': _date,
        'sportType': _sportType
      },
    );
  }

  Future<void> userUpdate() {}
}

Container getUserData() {
  final _userData = FirebaseFirestore.instance
      .collection('UserData')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
      .snapshots();
  Container(
    child: Text(_userData.toString()),
  );
}
