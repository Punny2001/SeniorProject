import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/user-data/id_generator.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:seniorapp/decoration/padding.dart';

class StaffProfile extends StatefulWidget {
  const StaffProfile({Key key}) : super(key: key);

  @override
  State<StaffProfile> createState() => _StaffProfileState();
}

class _StaffProfileState extends State<StaffProfile> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  Staff stfData;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

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
                              Text(stfData.staff_no),
                              Text(stfData.email),
                              Text(stfData.firstname + ' ' + stfData.lastname)
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
                int id = int.parse(stfData.staff_no.split('S')[1]);

                FirebaseAuth.instance.currentUser.delete().then((value) {
                  FirebaseAuth.instance.signOut();
                  FirebaseFirestore.instance
                      .collection('Staff')
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
              child: const Text('Log Out'),
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

  void getStfData() {
    FirebaseFirestore.instance.collection('Staff').doc(uid).get().then(
      (snapshot) {
        Map data = snapshot.data();
        stfData = Staff.fromMap(data);
      },
    );
  }
}
