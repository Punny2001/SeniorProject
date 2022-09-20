import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';

String latestAthNo;
String latestStfNo;
int latestAthId;
String latestAthSplt;

Athlete athleteData;

String get_athleteID() {
  getLatestAthNo().then((value) {
    NumberFormat format = NumberFormat('0000000000');

    print(latestAthNo);
    latestAthSplt = latestAthNo.split('A')[1];
    latestAthId = int.parse(latestAthSplt) + 1;
    return format.format(latestAthId);
  });
}

String get_staffID() {
  latestStfNo = latestStfNo.split('S')[1];
  int latestStfId = int.parse(latestStfNo) + 1;

  NumberFormat format = new NumberFormat('0000000000');

  return format.format(latestStfId);
}

Future<void> getLatestAthNo() async {
  FirebaseFirestore.instance
      .collection('Athlete')
      .orderBy('athlete_no')
      .limit(1)
      .get()
      .then((doc) {
    if (doc.size == 0) {
      latestAthNo = 'A0000000000';
    } else {
      doc.docs.map((snapshot) {
        Map data = snapshot.data();
        athleteData = Athlete.fromMap(data);
      });
    }
  });
}

// CollectionReference athleteCollection =
//       FirebaseFirestore.instance.collection('Athlete');
//   String athleteNo;
//   athleteCollection.get().then((snapshot) {
//     if (snapshot.size == 0) {
//       athleteNo = 'A0000000000';
//       latestAthNo = athleteNo;
//     } else {
//       Map data = snapshot.docs.last.data();
//       athleteNo = data['athlete_no'];
//       latestAthNo = athleteNo;
//     }
//   });
