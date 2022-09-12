import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StaffStream extends StatelessWidget {
  final String _type;

  StaffStream(this._type);

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser.uid;
    Stream illnessStream = FirebaseFirestore.instance
        .collection('IllnessReport')
        .where('staff_uid', isEqualTo: uid)
        .snapshots();
    Stream injuryStream = FirebaseFirestore.instance
        .collection('InjuryReport')
        .where('staff_uid', isEqualTo: uid)
        .snapshots();
    if (_type == 'default') {
      
    }
  }
}
