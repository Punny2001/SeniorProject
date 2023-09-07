import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/customer_support.dart';
import 'package:seniorapp/component/page/profile.dart';
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
        foregroundColor: Colors.blue[200],
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
              color: Colors.white,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: w * 0.05),
              width: w,
              height: h / 10,
              child: const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  staff: stfData,
                  userType: 'Staff',
                ),
              ),
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          GestureDetector(
            child: Container(
              alignment: Alignment.centerLeft,
              color: Colors.white,
              padding: EdgeInsets.only(left: w * 0.05),
              width: w,
              height: h / 10,
              child: const Text(
                'Customer Support',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return const CustomerSupportPage(userType: 'Staff');
              }));
            },
          ),
          const Divider(
            thickness: 2,
          ),
          GestureDetector(
            child: Container(
              alignment: Alignment.centerLeft,
              color: Colors.white,
              padding: EdgeInsets.only(left: w * 0.05),
              width: w,
              height: h / 10,
              child: const Text(
                'Delete Account',
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
                      title: const Text('Delete Account'),
                      content: SizedBox(
                        height: h / 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Center(
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
                                  icon: const Icon(Icons.check_rounded),
                                  label: const Text('Accept'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green[900],
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                  label: const Text('Decline'),
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
          const Divider(
            thickness: 2,
          ),
          GestureDetector(
            child: Container(
              color: Colors.white,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: w * 0.05),
              width: w,
              height: h / 10,
              child: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              String associationType;
              switch (stfData.association) {
                case 'Mahidol University':
                  setState(() {
                    associationType = 'StaffMU';
                  });
                  break;
                case 'Physiotherapy Khun Nirinrat':
                  setState(() {
                    associationType = 'StaffPHNR';
                  });
                  break;
                case 'Rugby':
                  setState(() {
                    associationType = 'StaffRB';
                  });
                  break;
                case 'Sports Authority of Thailand':
                  setState(() {
                    associationType = 'StaffSAT';
                  });
                  break;
                case 'Taekwondo':
                  setState(() {
                    associationType = 'StaffTKD';
                  });
                  break;
                default:
              }
              FirebaseMessaging.instance.unsubscribeFromTopic(associationType);
              FirebaseMessaging.instance.deleteToken();
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
          ),
          const Divider(
            thickness: 2,
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
