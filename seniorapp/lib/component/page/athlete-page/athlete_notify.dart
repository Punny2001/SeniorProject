import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/message_data.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:seniorapp/decoration/format_date.dart';

import 'dart:async' show Stream, StreamController, Timer;
import 'package:async/async.dart' show StreamZip;

class AthleteNotify extends StatefulWidget {
  const AthleteNotify({Key key, this.refreshNotification}) : super(key: key);
  final Void refreshNotification;

  @override
  _AthleteNotifyState createState() => _AthleteNotifyState();
}

class _AthleteNotifyState extends State<AthleteNotify> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference staff = FirebaseFirestore.instance.collection('Staff');
  bool isLoading = false;
  int messageSize;
  int healthSize = 0;
  int physicalSize = 0;
  Timer _timer;
  MessageData messageData;
  String athleteNo;
  List<Map<String, dynamic>> staffData = [];

  getAthleteData() {
    firestore.collection('Athlete').doc(uid).get().then((snapshot) {
      Map data = snapshot.data();
      athleteNo = data['athlete_no'];
    });
  }

  getStaffData() {
    firestore.collection('Staff').get().then((document) {
      int index = 0;
      document.docs.forEach((snapshot) {
        staffData.add(snapshot.data());
        staffData[index]['staffUID'] = snapshot.reference.id;
        index += 1;
      });
    });
  }

  getMessageSize() {
    firestore
        .collection('Message')
        .where('athleteNo', isEqualTo: athleteNo)
        .get()
        .then((document) {
      messageSize = document.docs.length;
    });
  }

  Stream<List<QuerySnapshot>> getStreamData() {
    Stream message = FirebaseFirestore.instance
        .collection('Message')
        .where('athleteNo', isEqualTo: athleteNo)
        .snapshots();
    return StreamZip([message]);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getAthleteData();
    getStaffData();
    getMessageSize();
    _timer = Timer(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    print('data size: ${healthSize + physicalSize}');
    print(staffData);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          primary: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(context),
                  ),
                ),
              ),
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.refresh,
                  ),
                  onPressed: () {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
        body: Container(
          height: h,
          width: w,
          child: isLoading
              ? Center(child: CupertinoActivityIndicator())
              : messageSize != 0
                  ? Container(
                      child: StreamBuilder(
                        stream: getStreamData(),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasData) {
                            List<QuerySnapshot> querySnapshot =
                                snapshot.data.toList();

                            List<QueryDocumentSnapshot> documentSnapshot = [];
                            querySnapshot.forEach((query) {
                              documentSnapshot.addAll(query.docs);
                            });

                            int index = 0;
                            List<Map<String, dynamic>> mappedData = [];
                            for (QueryDocumentSnapshot doc
                                in documentSnapshot) {
                              mappedData.add(doc.data());
                              mappedData[index]['docID'] = doc.reference.id;
                              // getStaffData(mappedData[index]['staffUID']);
                              index += 1;
                            }

                            switch (snapshot.connectionState) {
                              case (ConnectionState.waiting):
                                {
                                  return Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                }
                                break;
                              default:
                                {
                                  return ListView.builder(
                                    itemCount: mappedData.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> data =
                                          mappedData[index];
                                      messageData = MessageData.fromMap(data);
                                      Map<String, dynamic> currentStaff;
                                      staffData.retainWhere((element) =>
                                          element['staffUID'] ==
                                          messageData.staffUID);
                                      return Card(
                                        child: Column(
                                          children: [
                                            Container(
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  height: h * 0.2,
                                                  padding: EdgeInsets.only(
                                                    left: w * 0.05,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: w * 0.03),
                                                        width: w * 0.7,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          children: <Widget>[
                                                            Text.rich(
                                                              TextSpan(
                                                                text: 'Staff: ',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                children: [
                                                                  TextSpan(
                                                                    text: staffData[0]
                                                                            [
                                                                            'firstname'] +
                                                                        ' ' +
                                                                        staffData[0]
                                                                            [
                                                                            'lastname'],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Text.rich(
                                                              TextSpan(
                                                                text:
                                                                    'Description: ',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                children: [
                                                                  TextSpan(
                                                                    text: messageData
                                                                        .messageDescription,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Text.rich(
                                                              TextSpan(
                                                                text:
                                                                    'Sent on: ',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                children: [
                                                                  TextSpan(
                                                                    text: formatDate(
                                                                        messageData
                                                                            .messageDateTime),
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Text.rich(
                                                              TextSpan(
                                                                text: DateFormat
                                                                        .Hms()
                                                                    .format(
                                                                  messageData
                                                                      .messageDateTime,
                                                                ),
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                            }
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    )
                  : Center(
                      child: Text(
                        'Empty notification',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(height: h * 0.03),
          elevation: 1,
        ));
  }

  Future<void> updateData(String type, String docID) async {
    switch (type) {
      case 'Health':
        {
          await FirebaseFirestore.instance
              .collection('HealthQuestionnaireResult')
              .doc(docID)
              .update({'caseReceived': true, 'staff_no_received': uid}).then(
                  (value) {
            print('Updated data successfully');
          });
        }
        break;
      case 'Physical':
        {
          await FirebaseFirestore.instance
              .collection('PhysicalQuestionnaireResult')
              .doc(docID)
              .update({'caseReceived': true, 'staff_no_received': uid}).then(
                  (value) {
            print('Updated data successfully');
          });
        }
        break;
      default:
        break;
    }
  }
}
