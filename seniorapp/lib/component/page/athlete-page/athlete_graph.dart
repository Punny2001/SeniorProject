import 'dart:async' show Stream, Timer;
import 'package:async/async.dart' show StreamZip;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/graph-page/line_graph.dart';

class AthleteGraph extends StatefulWidget {
  const AthleteGraph({Key key}) : super(key: key);

  @override
  State<AthleteGraph> createState() => _AthleteGraphState();
}

class _AthleteGraphState extends State<AthleteGraph> {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  bool isLoading = true;
  Timer _timer;

  List<bool> _selectedQuestionnaire = <bool>[true, true];
  final List<bool> isDefault = <bool>[true];

  List<Map<String, dynamic>> healthResultDataList = [];
  List<Map<String, dynamic>> physicalResultDataList = [];
  List<Map<String, dynamic>> cleanedHealthDataList = [];
  List<Map<String, dynamic>> cleanedPhysicalDataList = [];

  void choose_filter() {
    setState(() {});
  }

  List<Map<String, dynamic>> add_filter(List<Map<String, dynamic>> data) {
    data.sort((a, b) =>
        ('${a['doDate'].toDate()}').compareTo('${b['doDate'].toDate()}'));
    if (_selectedQuestionnaire[0] == false) {
      data.removeWhere((element) => element['questionnaireType'] == 'Physical');
    }
    if (_selectedQuestionnaire[1] == false) {
      data.removeWhere((element) => element['questionnaireType'] == 'Health');
    }

    return data;
  }

  Stream<List<QuerySnapshot>> getData() {
    Stream healthQuestionnaire = FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('athleteUID', isEqualTo: uid, isNull: false)
        .snapshots();
    Stream physicalQuestionnaire = FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .where('athleteUID', isEqualTo: uid, isNull: false)
        .snapshots();

    return StreamZip([healthQuestionnaire, physicalQuestionnaire]);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    _timer = Timer(const Duration(seconds: 1), () {
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
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
                                const Text('ประเภทของแบบสอบถาม'),
                                const Padding(
                                  padding: const EdgeInsets.all(5),
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
                                  children: [
                                    const Text('การบาดเจ็บ'),
                                    const Text('การเจ็บป่วย')
                                  ],
                                  isSelected: _selectedQuestionnaire,
                                  onPressed: (int index) {
                                    // All buttons are selectable.
                                    setState(() {
                                      _selectedQuestionnaire[index] =
                                          !_selectedQuestionnaire[index];
                                      isDefault[0] = false;
                                    });
                                  },
                                ),
                                const Padding(
                                  padding: const EdgeInsets.all(10),
                                ),
                                Text('ช่วงเวลาที่ต้องการแสดงกราฟ'),
                                cupertino
                              ],
                            ),
                            actions: [
                              SizedBox(
                                width: w,
                                child: RaisedButton(
                                  color: Colors.green[300],
                                  child: const Text(
                                    'ใช้งาน',
                                    style: const TextStyle(
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
            ToggleButtons(
              children: [const Text('ค่าเริ่มต้น')],
              isSelected: isDefault,
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: h * 0.02,
              ),
              fillColor: Colors.green[300],
              borderColor: Colors.grey,
              selectedBorderColor: Colors.green[800],
              selectedColor: Colors.black,
              color: Colors.green,
              constraints: BoxConstraints(
                minHeight: h * 0.05,
                minWidth: w * 0.3,
              ),
              onPressed: (int index) {
                setState(() {
                  if (isDefault[0] == true) {
                    isDefault[0] = false;
                  } else {
                    isDefault[0] = true;
                    _selectedQuestionnaire = <bool>[true, true];
                  }
                });
              },
            ),
          ],
        ),
        isLoading
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : StreamBuilder(
                stream: getData(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    List<QuerySnapshot> querySnapshot = snapshot.data.toList();

                    List<QueryDocumentSnapshot> documentSnapshot = [];
                    querySnapshot.forEach((query) {
                      documentSnapshot.addAll(query.docs);
                    });

                    List<Map<String, dynamic>> mappedData = [];
                    for (QueryDocumentSnapshot doc in documentSnapshot) {
                      mappedData.add(doc.data());
                    }

                    mappedData = add_filter(mappedData);

                    List<Map<String, dynamic>> healthDataList = [];
                    List<Map<String, dynamic>> physicalDataList = [];

                    mappedData.forEach((element) {
                      if (element['questionnaireType'] == 'Health') {
                        healthDataList.add(element);
                      } else if (element['questionnaireType'] == 'Physical') {
                        physicalDataList.add(element);
                      }
                    });

                    return AthleteLineGraph(
                      healthResultDataList: healthDataList,
                      physicalResultDataList: physicalDataList,
                    );
                  } else {
                    return const Center(
                      child: const CircularProgressIndicator(),
                    );
                  }
                },
              ),
        // AthleteLineGraph(
        //   healthResultDataList: cleanedHealthDataList,
        //   physicalResultDataList: cleanedPhysicalDataList,
        // ),
      ],
    );
  }
}
