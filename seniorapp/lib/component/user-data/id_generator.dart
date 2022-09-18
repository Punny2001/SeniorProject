import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';

String latestAthNo;
String latestStfNo;
int latestAthId;
String latestAthSplt;

String get_athleteID() {
  NumberFormat format = NumberFormat('0000000000');

  print(latestAthNo);
  latestAthSplt = latestAthNo.split('A')[1];
  latestAthId = int.parse(latestAthSplt) + 1;
  return format.format(latestAthId);
}

String get_staffID() {
  latestStfNo = latestStfNo.split('S')[1];
  int latestStfId = int.parse(latestStfNo) + 1;

  NumberFormat format = new NumberFormat('0000000000');

  return format.format(latestStfId);
}

Future<String> getLatestAthNo() async {
  CollectionReference athleteCollection =
      FirebaseFirestore.instance.collection('Athlete');
  String athleteNo;
  await athleteCollection.get().then((snapshot) {
    if (snapshot.size == 0) {
      athleteNo = 'A0000000000';
    } else {
      Map data = snapshot.docs.last.data();
      athleteNo = data['athlete_no'];
    }
  });
  return athleteNo;
}
