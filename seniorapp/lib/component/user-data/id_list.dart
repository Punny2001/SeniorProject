import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

String latestAthNo;
String latestStfNo;

String get_athleteID() {
  getLatestAthID();
  print(latestAthNo);
  latestAthNo = latestAthNo.split('A')[1];
  int latestAthId = int.parse(latestAthNo) + 1;

  NumberFormat format = new NumberFormat('0000000000');

  return format.format(latestAthId);
}

String get_staffID() {
  getLatestStfID();
  latestStfNo = latestStfNo.split('S')[1];
  int latestStfId = int.parse(latestStfNo) + 1;

  NumberFormat format = new NumberFormat('0000000000');

  return format.format(latestStfId);
}

getLatestAthID() async {
  QuerySnapshot<Map<String, dynamic>> athleteData =
      await FirebaseFirestore.instance.collection('Athlete').get();
  if (athleteData.docs.isEmpty) {
    latestAthNo = 'A0000000000';
  } else {
    athleteData.docs.forEach((element) {
      print(element.data()['athlete_no']);
    });

    // FirebaseFirestore.instance
    //     .collection('Athlete')
    //     .orderBy('athlete_no', descending: true)
    //     .limit(1)
    //     .get()
    //     .then((snapshot) {
    //   if (snapshot.docs.isEmpty) {
    //     latestAthNo = 'A0000000000';
    //   } else {
    //     snapshot.docs.map((data) {
    //       print(data['athlete_no']);
    //       latestAthNo = data['athlete_no'];
    //     });
    //   }
    // });
  }
}

getLatestStfID() {
  FirebaseFirestore.instance
      .collection('Staff')
      .orderBy('staff_no', descending: true)
      .limit(1)
      .get()
      .then((snapshot) {
    snapshot.docs.map((data) {
      if (data['staff_no'] == null) {
        latestStfNo = 'S0000000000';
      } else {
        latestStfNo = data['staff_no'];
      }
    });
  });
}
