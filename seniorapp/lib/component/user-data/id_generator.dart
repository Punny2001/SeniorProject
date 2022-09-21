import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';

String latestStfNo;
int latestAthId;

String get_athleteID() {
  NumberFormat format = NumberFormat('0000000000');
  getLatestAthNo();
  return format.format(latestAthId);
}

String get_staffID() {
  latestStfNo = latestStfNo.split('S')[1];
  int latestStfId = int.parse(latestStfNo) + 1;

  NumberFormat format = new NumberFormat('0000000000');

  return format.format(latestStfId);
}

Future<void> getLatestAthNo() async {
  String latestAthNo;
  await FirebaseFirestore.instance
      .collection('Athlete')
      .orderBy('athlete_no', descending: true)
      .limit(1)
      .get()
      .then((QuerySnapshot querySnapshot) {
    print('doc: ' + querySnapshot.size.toString());
    if (querySnapshot.size == 0 || querySnapshot == null) {
      latestAthNo = 'A0000000000';
    } else {
      querySnapshot.docs.forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
        Map data = queryDocumentSnapshot.data();
        Athlete athleteData = Athlete.fromMap(data);
        print(athleteData.athlete_no);
        latestAthNo = athleteData.athlete_no;
      });
    }
    String latestAthSplt;
    latestAthSplt = latestAthNo.split('A')[1];
    latestAthId = int.parse(latestAthSplt) + 1;
    print(latestAthId);
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
