import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/staff-page/staff_personal.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';

class StaffProfile extends StatefulWidget {
  const StaffProfile({Key key}) : super(key: key);

  @override
  State<StaffProfile> createState() => _StaffProfileState();
}

class _StaffProfileState extends State<StaffProfile> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  Staff stfData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    getStfData();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        primary: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Ink(
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: Colors.blue.shade200,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  alignment: Alignment.centerRight,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          GestureDetector(
            child: Card(
              elevation: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: w * 0.05),
                width: w,
                height: h / 10,
                child: Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            //   onTap: () => Navigator.of(context).push(
            //     MaterialPageRoute(
            //       builder: (context) => StaffPersonal(
            //         email: stfData.email,
            //         firstname: stfData.firstname,
            //         lastname: stfData.lastname,
            //         staff_no: stfData.staff_no,
            //       ),
            //     ),
            //   ),
          ),
          GestureDetector(
            child: Card(
              elevation: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: w * 0.05),
                width: w,
                height: h / 10,
                child: Text(
                  'Delete Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete Account'),
                      content: Container(
                        height: h / 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Center(
                              child: Text(
                                'Are you sure to delete this account?',
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    FirebaseAuth.instance.currentUser
                                        .delete()
                                        .then((value) {
                                      FirebaseAuth.instance.signOut();
                                      FirebaseFirestore.instance
                                          .collection('Staff')
                                          .doc(uid)
                                          .delete();
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                        '/login',
                                        (route) => false,
                                      );
                                    });
                                  },
                                  icon: Icon(Icons.check_rounded),
                                  label: Text('Accept'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green[900],
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.close_rounded),
                                  label: Text('Decline'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red[900],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
          GestureDetector(
            child: Card(
              elevation: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: w * 0.05),
                width: w,
                height: h / 10,
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            onTap: () {
              FirebaseMessaging.instance.deleteToken();
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
          ),
        ],
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
