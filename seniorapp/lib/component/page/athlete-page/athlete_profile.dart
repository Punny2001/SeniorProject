import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_personal.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: h / 10,
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
                  color: Colors.green.shade300,
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
                  'ข้อมูลส่วนตัว',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AthletePersonal(
                email: athData.email,
                firstname: athData.firstname,
                lastname: athData.lastname,
                ath_no: athData.athlete_no,
              ),
            )),
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
                  'ลบบัญชี',
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
                      title: Text('ลบบัญชี'),
                      content: Container(
                        height: h / 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Center(
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
                                  icon: Icon(Icons.check_rounded),
                                  label: Text('ตกลง'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green[900],
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.close_rounded),
                                  label: Text('ปฏิเสธ'),
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
                  'ลงชื่อออก',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            onTap: () {
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
