import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/customer_support.dart';
import 'package:seniorapp/component/page/profile.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        primary: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green[300],
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.of(context).pop();
            });
          },
          alignment: Alignment.centerRight,
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          GestureDetector(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: w * 0.05),
              width: w,
              height: h / 10,
              child: const Text(
                'ข้อมูลส่วนตัว',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  athlete: athData,
                  userType: 'Athlete',
                ),
              ),
            ),
          ),
          const Divider(thickness: 2),
          GestureDetector(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: w * 0.05),
              width: w,
              height: h / 10,
              child: const Text(
                'ช่วยเหลือ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return const CustomerSupportPage(userType: 'Athlete');
              }));
            },
          ),
          const Divider(thickness: 2),
          GestureDetector(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: w * 0.05),
              width: w,
              height: h / 10,
              child: const Text(
                'ลบบัญชี',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('ลบบัญชี'),
                      content: Container(
                        height: h / 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Center(
                              child: Text(
                                'คุณแน่ใจจะลบบัญชีใช่หรือไม่?',
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
                                          .collection('Athlete')
                                          .doc(uid)
                                          .delete();
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                        '/login',
                                        (route) => false,
                                      );
                                    });
                                  },
                                  icon: const Icon(Icons.check_rounded),
                                  label: const Text('ตกลง'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green[900],
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                  label: const Text('ปฏิเสธ'),
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
          const Divider(thickness: 2),
          GestureDetector(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: w * 0.05),
              width: w,
              height: h / 10,
              child: const Text(
                'ลงชื่อออก',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              FirebaseMessaging.instance.unsubscribeFromTopic('Athlete');
              FirebaseMessaging.instance.deleteToken();
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
          ),
          const Divider(thickness: 2),
        ],
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
