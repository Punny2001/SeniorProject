import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/decoration/padding.dart';

class AthleteProfile extends StatefulWidget {
  const AthleteProfile({Key key}) : super(key: key);

  @override
  State<AthleteProfile> createState() => _AthleteProfileState();
}

class _AthleteProfileState extends State<AthleteProfile> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  Athlete athData;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    getAthData();

    return Scaffold(
      body: Container(
        height: h,
        width: w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('User Information'),
                        content: Container(
                          height: h / 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(athData.athlete_no),
                              Text(athData.email),
                              Text(athData.firstname + ' ' + athData.lastname)
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: Navigator.of(context).pop,
                            child: Text('Close window'),
                          ),
                        ],
                      );
                    });
              },
              child: Text('Show Info'),
            ),
            ElevatedButton(
              onPressed: () {
                int id = int.parse(athData.athlete_no.split('A')[1]);

                FirebaseAuth.instance.currentUser.delete().then((value) {
                  FirebaseAuth.instance.signOut();
                  FirebaseFirestore.instance
                      .collection('Athlete')
                      .doc(uid)
                      .delete();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                });
              },
              child: const Text('Delete account'),
            ),
            PaddingDecorate(10),
            ElevatedButton(
              child: Text('Log Out'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void getAthData() {
    FirebaseFirestore.instance.collection('Athlete').doc(uid).get().then(
      (snapshot) {
        Map data = snapshot.data();
        athData = Athlete.fromMap(data);
        print(athData.athlete_no);
      },
    );
  }
}
