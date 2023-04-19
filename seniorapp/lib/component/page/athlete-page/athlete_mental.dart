import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/history-details/mental_report_detail.dart';
import 'package:seniorapp/component/result-data/mental_result_data.dart';
import 'package:seniorapp/decoration/format_datetime.dart';

import 'dart:async' show Stream, StreamController, Timer;
import 'package:async/async.dart' show StreamZip;
import 'package:seniorapp/decoration/padding.dart';

class AthleteMentalHistory extends StatefulWidget {
  const AthleteMentalHistory({Key key}) : super(key: key);

  @override
  _AthleteHistoryState createState() => _AthleteHistoryState();
}

class _AthleteHistoryState extends State<AthleteMentalHistory> {
  List<bool> _selectedOrderType = <bool>[true, false];
  bool isDefault = true;
  Timer _timer;
  String uid = FirebaseAuth.instance.currentUser.uid;
  String athlete_no;
  int mentalSize;
  bool isLoading = false;
  bool isFilter = false;

  void choose_filter() {
    setState(() {});
  }

  Stream<List<QuerySnapshot>> getData() {
    Stream mentalQuestionnaire = FirebaseFirestore.instance
        .collection('MentalQuestionnaireResult')
        .where('athleteUID', isEqualTo: uid, isNull: false)
        .snapshots();

    return StreamZip([mentalQuestionnaire]);
  }

  getMentalSize() {
    FirebaseFirestore.instance
        .collection('MentalQuestionnaireResult')
        .where('athleteUID', isEqualTo: uid, isNull: false)
        .get()
        .then(
      (snapshot) {
        if (mounted) {
          setState(() {
            mentalSize = snapshot.docs.length;
          });
        }
      },
    );
  }

  List<Map<String, dynamic>> add_filter(List<Map<String, dynamic>> data) {
    if (_selectedOrderType[0] == true) {
      data.sort(
        (a, b) => (b['doDate'].toDate()).compareTo(
          a['doDate'].toDate(),
        ),
      );
    } else {
      data.sort(
        (a, b) => (a['doDate'].toDate()).compareTo(
          b['doDate'].toDate(),
        ),
      );
    }

    return data;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getMentalSize();
    _timer = Timer(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  String find_questnaireNo(String docNo) {
    int docNoInt;
    docNo = docNo.split('MQ')[1];
    docNoInt = int.parse(docNo);
    return docNoInt.toString();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  MentalResultData mentalResultData;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(left: w * 0.05, right: w * 0.05),
                width: w * 0.65,
                height: h * 0.052,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.filter_list,
                    color: Colors.black,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade300,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      side: BorderSide(color: Colors.green[800]),
                    ),
                  ),
                  label: Text(
                    'ตัวกรอง',
                    style: TextStyle(
                      fontSize: h * 0.025,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              title: Container(
                                child: const Text('ตัวกรอง'),
                              ),
                              content: Column(
                                children: [
                                  const Text('จัดเรียงโดย'),
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                  ),
                                  ToggleButtons(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    fillColor: Colors.green[300],
                                    borderColor: Colors.grey,
                                    selectedBorderColor: Colors.green[800],
                                    selectedColor: Colors.white,
                                    color: Colors.green,
                                    constraints: BoxConstraints(
                                      minHeight: h * 0.05,
                                      minWidth: w * 0.3,
                                    ),
                                    children: const [
                                      Text('มาก => น้อย'),
                                      Text('น้อย => มาก')
                                    ],
                                    isSelected: _selectedOrderType,
                                    onPressed: (int index) {
                                      setState(() {
                                        // The button that is tapped is set to true, and the others to false.
                                        for (int i = 0;
                                            i < _selectedOrderType.length;
                                            i++) {
                                          _selectedOrderType[i] = i == index;
                                        }
                                        isDefault = false;
                                      });
                                    },
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(10),
                                  ),
                                ],
                              ),
                              actions: [
                                SizedBox(
                                  width: w,
                                  child: RaisedButton(
                                    color: Colors.green[300],
                                    child: const Text(
                                      'ใช้งาน',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      choose_filter();
                                    },
                                  ),
                                ),
                              ],
                            );
                          });
                        });
                  },
                ),
              ),
              Row(
                children: [
                  const Text(
                    'ค่าเริ่มต้น',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CupertinoSwitch(
                    value: isDefault,
                    activeColor: Colors.green[300],
                    onChanged: (bool value) {
                      setState(() {
                        if (isDefault == true) {
                          isDefault = false;
                        } else {
                          isDefault = true;

                          _selectedOrderType = <bool>[true, false];
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          PaddingDecorate(5),
          Expanded(
            child: SizedBox(
              height: h,
              width: w,
              child: isLoading
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : mentalSize != 0
                      ? StreamBuilder(
                          stream: getData(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasData) {
                              List<QuerySnapshot> querySnapshot =
                                  snapshot.data.toList();

                              List<QueryDocumentSnapshot> documentSnapshot = [];
                              querySnapshot.forEach((query) {
                                documentSnapshot.addAll(query.docs);
                              });

                              List<Map<String, dynamic>> mappedData = [];
                              for (QueryDocumentSnapshot doc
                                  in documentSnapshot) {
                                mappedData.add(doc.data());
                              }

                              mappedData = add_filter(mappedData);
                              if (mappedData.length >= 10) {
                                mappedData.removeRange(10, mappedData.length);
                              }

                              return ListView.builder(
                                itemCount: mappedData.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> data = mappedData[index];
                                  mentalResultData =
                                      MentalResultData.fromMap(data);
                                  return GestureDetector(
                                    child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        side: BorderSide(
                                            width: 2, color: Colors.green[200]),
                                      ),
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
                                                padding: EdgeInsets.only(
                                                    left: w * 0.03),
                                                width: w * 0.7,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: <Widget>[
                                                    Text.rich(
                                                      TextSpan(
                                                        text:
                                                            'รายงานปัญหารการนอนหลับครั้งที่: ',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text: (index + 1)
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text.rich(
                                                      TextSpan(
                                                        text: 'วันที่บันทึก: ',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text: formatDate(
                                                              mentalResultData
                                                                  .doDate,
                                                              'Athlete',
                                                            ),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text.rich(
                                                      TextSpan(
                                                        text: 'เวลาที่บันทึก: ',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                '${formatTime(mentalResultData.doDate)} น.',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                    onTap: () {
                                      MentalResultData mental =
                                          MentalResultData.fromMap(data);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MentalReportDetail(
                                                  mentalResultData: mental),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        )
                      : const Center(
                          child: Text(
                            'ไม่มีบันทึกที่คุณสร้างไว้',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
