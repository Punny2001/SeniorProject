import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/history-details/health_report_detail.dart';
import 'package:seniorapp/component/page/athlete-page/history-details/physical_report_detail.dart';
import 'package:seniorapp/component/result-data/health_result_data.dart';
import 'package:seniorapp/component/result-data/physical_result_data.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:seniorapp/decoration/format_datetime.dart';

import 'dart:async' show Stream, StreamController, Timer;
import 'package:async/async.dart' show StreamZip;
import 'package:seniorapp/decoration/textfield_normal.dart';

class AthleteNotify extends StatefulWidget {
  const AthleteNotify({Key key}) : super(key: key);

  @override
  _AthleteNotifyState createState() => _AthleteNotifyState();
}

class _AthleteNotifyState extends State<AthleteNotify> {
  final firestore = FirebaseFirestore.instance;
  List<bool> _selectedOrder = <bool>[true, false];
  List<bool> _selectedQuestionnaire = <bool>[true, true];
  List<bool> _selectedOrderType = <bool>[true, false];
  final List<bool> isDefault = <bool>[true];
  RangeValues _currentRangeValues = const RangeValues(0, 100);
  Timer _timer;
  String uid = FirebaseAuth.instance.currentUser.uid;
  String athleteNo;
  int healthSize;
  int physicalSize;
  bool isLoading = false;
  bool isFilter = false;

  List<Map<String, dynamic>> staffData = [];

  void choose_filter() {
    setState(() {});
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

  getHealthSize() {
    FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('athleteUID', isEqualTo: uid, isNull: false)
        .get()
        .then(
      (snapshot) {
        setState(() {
          healthSize = snapshot.docs.length;
        });
      },
    );
  }

  getPhysicalSize() {
    FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .where('athleteUID', isEqualTo: uid, isNull: false)
        .get()
        .then(
      (snapshot) {
        setState(() {
          physicalSize = snapshot.docs.length;
        });
      },
    );
  }

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

  // List<Map<String, dynamic>> add_filter(List<Map<String, dynamic>> data) {
  //   if (_selectedOrder[0] == true) {
  //     if (_selectedOrderType[0] == true) {
  //       data.sort(
  //         (a, b) => (b['doDate'].toDate()).compareTo(
  //           a['doDate'].toDate(),
  //         ),
  //       );
  //     } else {
  //       data.sort(
  //         (a, b) => (a['doDate'].toDate()).compareTo(
  //           b['doDate'].toDate(),
  //         ),
  //       );
  //     }
  //   } else if (_selectedOrder[1] == true) {
  //     if (_selectedOrderType[0] == true) {
  //       data.sort(
  //         (a, b) => (b['totalPoint']).compareTo(
  //           a['totalPoint'],
  //         ),
  //       );
  //     } else {
  //       data.sort(
  //         (a, b) => (a['totalPoint']).compareTo(
  //           b['totalPoint'],
  //         ),
  //       );
  //     }
  //   }

  //   if (_selectedQuestionnaire[0] == false) {
  //     data.removeWhere((element) => element['questionnaireType'] == 'Physical');
  //   }
  //   if (_selectedQuestionnaire[1] == false) {
  //     data.removeWhere((element) => element['questionnaireType'] == 'Health');
  //   }

  //   data.removeWhere(
  //       (element) => element['totalPoint'] < _currentRangeValues.start);
  //   data.removeWhere(
  //       (element) => element['totalPoint'] > _currentRangeValues.end);

  //   return data;
  // }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getStaffData();
    getPhysicalSize();
    getHealthSize();
    _timer = Timer(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  String toThaiType(String type) {
    if (type == 'Health') {
      return 'อาการเจ็บป่วย';
    } else if (type == 'Physical') {
      return 'อาการบาดเจ็บ';
    }
  }

  String toThaiNoneInfo(String symptomOrbodypart) {
    if (symptomOrbodypart == 'None') {
      return 'ไม่มีอาการ';
    } else {
      return symptomOrbodypart;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  HealthResultData healthData;
  PhysicalResultData physicalData;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    print('health size: $healthSize');
    print('physical size: $physicalSize');

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Container(
          //       padding: EdgeInsets.only(left: w * 0.05, right: w * 0.05),
          //       width: w * 0.65,
          //       height: h * 0.052,
          //       child: ElevatedButton.icon(
          //         icon: const Icon(
          //           Icons.filter_list,
          //           color: Colors.black,
          //         ),
          //         style: ElevatedButton.styleFrom(
          //           primary: Colors.green.shade300,
          //           elevation: 0,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: const BorderRadius.all(
          //               Radius.circular(8),
          //             ),
          //             side: BorderSide(color: Colors.green[800]),
          //           ),
          //         ),
          //         label: Text(
          //           'ตัวกรอง',
          //           style: TextStyle(
          //             fontSize: h * 0.025,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.black,
          //           ),
          //         ),
          //         onPressed: () {
          //           showDialog(
          //               context: context,
          //               builder: (BuildContext context) {
          //                 return StatefulBuilder(builder: (context, setState) {
          //                   return AlertDialog(
          //                     title: Container(
          //                       child: const Text('ตัวกรอง'),
          //                     ),
          //                     content: Column(
          //                       children: [
          //                         const Text('จัดเรียงโดย'),
          //                         const Padding(
          //                           padding: const EdgeInsets.all(5),
          //                         ),
          //                         ToggleButtons(
          //                           borderRadius: const BorderRadius.all(
          //                             Radius.circular(8),
          //                           ),
          //                           textStyle: const TextStyle(
          //                             fontWeight: FontWeight.bold,
          //                           ),
          //                           fillColor: Colors.green[300],
          //                           borderColor: Colors.grey,
          //                           selectedBorderColor: Colors.green[800],
          //                           selectedColor: Colors.white,
          //                           color: Colors.green,
          //                           constraints: BoxConstraints(
          //                             minHeight: h * 0.05,
          //                             minWidth: w * 0.3,
          //                           ),
          //                           children: [
          //                             const Text('วันที่'),
          //                             const Text('คะแนน')
          //                           ],
          //                           isSelected: _selectedOrder,
          //                           onPressed: (int index) {
          //                             setState(() {
          //                               // The button that is tapped is set to true, and the others to false.
          //                               for (int i = 0;
          //                                   i < _selectedOrder.length;
          //                                   i++) {
          //                                 _selectedOrder[i] = i == index;
          //                               }
          //                               isDefault[0] = false;
          //                             });
          //                           },
          //                         ),
          //                         const Padding(
          //                           padding: const EdgeInsets.all(5),
          //                         ),
          //                         ToggleButtons(
          //                           borderRadius: const BorderRadius.all(
          //                             Radius.circular(8),
          //                           ),
          //                           textStyle: const TextStyle(
          //                             fontWeight: FontWeight.bold,
          //                           ),
          //                           fillColor: Colors.green[300],
          //                           borderColor: Colors.grey,
          //                           selectedBorderColor: Colors.green[800],
          //                           selectedColor: Colors.white,
          //                           color: Colors.green,
          //                           constraints: BoxConstraints(
          //                             minHeight: h * 0.05,
          //                             minWidth: w * 0.3,
          //                           ),
          //                           children: [
          //                             const Text('มาก => น้อย'),
          //                             const Text('น้อย => มาก')
          //                           ],
          //                           isSelected: _selectedOrderType,
          //                           onPressed: (int index) {
          //                             setState(() {
          //                               // The button that is tapped is set to true, and the others to false.
          //                               for (int i = 0;
          //                                   i < _selectedOrderType.length;
          //                                   i++) {
          //                                 _selectedOrderType[i] = i == index;
          //                               }
          //                               isDefault[0] = false;
          //                             });
          //                           },
          //                         ),
          //                         const Padding(
          //                           padding: EdgeInsets.all(10),
          //                         ),
          //                         const Text('ประเภทของแบบสอบถาม'),
          //                         const Padding(
          //                           padding: const EdgeInsets.all(5),
          //                         ),
          //                         ToggleButtons(
          //                           borderRadius: const BorderRadius.all(
          //                             Radius.circular(8),
          //                           ),
          //                           textStyle: const TextStyle(
          //                             fontWeight: FontWeight.bold,
          //                           ),
          //                           fillColor: Colors.green[300],
          //                           borderColor: Colors.grey,
          //                           selectedBorderColor: Colors.green[800],
          //                           selectedColor: Colors.white,
          //                           color: Colors.green,
          //                           constraints: BoxConstraints(
          //                             minHeight: h * 0.05,
          //                             minWidth: w * 0.3,
          //                           ),
          //                           children: [
          //                             const Text('การบาดเจ็บ'),
          //                             const Text('การเจ็บป่วย')
          //                           ],
          //                           isSelected: _selectedQuestionnaire,
          //                           onPressed: (int index) {
          //                             // All buttons are selectable.
          //                             setState(() {
          //                               _selectedQuestionnaire[index] =
          //                                   !_selectedQuestionnaire[index];
          //                               isDefault[0] = false;
          //                             });
          //                           },
          //                         ),
          //                         const Padding(
          //                           padding: const EdgeInsets.all(10),
          //                         ),
          //                         const Text('ช่วงคะแนน'),
          //                         const Padding(
          //                           padding: EdgeInsets.all(5),
          //                         ),
          //                         RangeSlider(
          //                           values: _currentRangeValues,
          //                           min: 0,
          //                           max: 100,
          //                           divisions: 5,
          //                           activeColor: Colors.green[300],
          //                           inactiveColor: Colors.green[100],
          //                           labels: RangeLabels(
          //                             _currentRangeValues.start
          //                                 .round()
          //                                 .toString(),
          //                             _currentRangeValues.end
          //                                 .round()
          //                                 .toString(),
          //                           ),
          //                           onChanged: (RangeValues values) {
          //                             setState(() {
          //                               _currentRangeValues = values;
          //                               isDefault[0] = false;
          //                             });
          //                           },
          //                         ),
          //                       ],
          //                     ),
          //                     actions: [
          //                       Container(
          //                         width: w xcode,
          //                         child: RaisedButton(
          //                           color: Colors.green[300],
          //                           child: const Text(
          //                             'ใช้งาน',
          //                             style: const TextStyle(
          //                                 fontWeight: FontWeight.bold,
          //                                 color: Colors.white),
          //                           ),
          //                           onPressed: () {
          //                             Navigator.of(context).pop();
          //                             choose_filter();
          //                           },
          //                         ),
          //                       ),
          //                     ],
          //                   );
          //                 });
          //               });
          //         },
          //       ),
          //     ),
          //     ToggleButtons(
          //       children: [const Text('ค่าเริ่มต้น')],
          //       isSelected: isDefault,
          //       borderRadius: const BorderRadius.all(
          //         Radius.circular(8),
          //       ),
          //       textStyle: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         fontSize: h * 0.02,
          //       ),
          //       fillColor: Colors.green[300],
          //       borderColor: Colors.grey,
          //       selectedBorderColor: Colors.green[800],
          //       selectedColor: Colors.black,
          //       color: Colors.green,
          //       constraints: BoxConstraints(
          //         minHeight: h * 0.05,
          //         minWidth: w * 0.3,
          //       ),
          //       onPressed: (int index) {
          //         setState(() {
          //           if (isDefault[0] == true) {
          //             isDefault[0] = false;
          //           } else {
          //             isDefault[0] = true;
          //             _selectedOrder = <bool>[true, false];
          //             _selectedQuestionnaire = <bool>[true, true];
          //             _selectedOrderType = <bool>[true, false];
          //             _currentRangeValues = const RangeValues(0, 100);
          //           }
          //         });
          //       },
          //     ),
          //   ],
          // ),
          // PaddingDecorate(1),
          Expanded(
            child: SizedBox(
              height: h,
              width: w,
              child: isLoading
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : healthSize + physicalSize != 0
                      ? Container(
                          child: StreamBuilder(
                            stream: getData(),
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.hasData) {
                                List<QuerySnapshot> querySnapshot =
                                    snapshot.data.toList();

                                List<QueryDocumentSnapshot> documentSnapshot =
                                    [];
                                querySnapshot.forEach((query) {
                                  documentSnapshot.addAll(query.docs);
                                });

                                int index = 0;
                                List<Map<String, dynamic>> mappedData = [];
                                for (QueryDocumentSnapshot doc
                                    in documentSnapshot) {
                                  mappedData.add(doc.data());
                                  mappedData[index]['docID'] = doc.reference.id;
                                  index += 1;
                                }

                                // mappedData = add_filter(mappedData);
                                if (mappedData.length >= 10) {
                                  mappedData.removeRange(10, mappedData.length);
                                }

                                return ListView.builder(
                                  itemCount: mappedData.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> data =
                                        mappedData[index];
                                    healthData = HealthResultData.fromMap(data);
                                    physicalData =
                                        PhysicalResultData.fromMap(data);
                                    if (data['caseFinished'] == true) {
                                      return _showFinishedHistory(data, h, w);
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
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

  Column _showFinishedHistory(Map<String, dynamic> data, double h, double w) {
    staffData.retainWhere(
        (element) => element['staffUID'] == data['staff_uid_received']);
    Staff _currentStaff = Staff.fromMap(staffData[0]);
    return Column(
      children: [
        GestureDetector(
          child: Card(
            elevation: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: w * 0.05,
              ),
              child: data['questionnaireType'] == 'Health'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: w * 0.03),
                          width: w * 0.7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                '${_currentStaff.firstname} ${_currentStaff.lastname}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: h * 0.023,
                                ),
                              ),
                              Text(
                                  'ข้อมูล ${healthData.questionnaireNo} รายงานเสร็จสิ้น'),
                              healthData.adviceMessage != '' ||
                                      healthData.adviceMessage != null
                                  ? Text.rich(
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'คำแนะนำจากทีมแพทย์: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: healthData.adviceMessage,
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        Badge(
                          badgeContent: const Text('  '),
                          showBadge:
                              data['messageReceived'] == false ? true : false,
                          child: SizedBox(
                            width: w * 0.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${healthData.totalPoint}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: score_color(healthData.totalPoint),
                                      fontSize: h * 0.05),
                                ),
                                const Text(
                                  'คะแนน',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: w * 0.03),
                          width: w * 0.7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                '${_currentStaff.firstname} ${_currentStaff.lastname}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: h * 0.023,
                                ),
                              ),
                              Text(
                                  'ข้อมูล ${physicalData.questionnaireNo} รายงานเสร็จสิ้น'),
                              physicalData.adviceMessage != '' ||
                                      physicalData.adviceMessage != null
                                  ? Text.rich(
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'คำแนะนำจากทีมแพทย์: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: physicalData.adviceMessage,
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        Badge(
                          badgeContent: const Text('  '),
                          showBadge:
                              data['messageReceived'] == false ? true : false,
                          child: SizedBox(
                            width: w * 0.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${physicalData.totalPoint}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          score_color(physicalData.totalPoint),
                                      fontSize: h * 0.05),
                                ),
                                const Text(
                                  'คะแนน',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
            ),
          ),
          onTap: () {
            switch (data['questionnaireType']) {
              case 'Health':
                HealthResultData health = HealthResultData.fromMap(data);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HealthReportDetail(
                      answerList: health.answerList,
                      athleteNo: health.athleteNo,
                      doDate: health.doDate,
                      healthSymptom: health.healthSymptom,
                      questionnaireType: health.questionnaireType,
                      questionnaireNo: health.questionnaireNo,
                      totalPoint: health.totalPoint,
                    ),
                  ),
                );
                setState(() {
                  updateReadMessage(data['docID'], 'HealthQuestionnaireResult');
                });
                break;
              case 'Physical':
                PhysicalResultData physical = PhysicalResultData.fromMap(data);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PhysicalReportDetail(
                      answerList: physical.answerList,
                      athleteNo: physical.athleteNo,
                      doDate: physical.doDate,
                      bodyPart: physical.bodyPart,
                      questionnaireType: physical.questionnaireType,
                      questionnaireNo: physical.questionnaireNo,
                      totalPoint: physical.totalPoint,
                    ),
                  ),
                );
                setState(() {
                  updateReadMessage(
                      data['docID'], 'PhysicalQuestionnaireResult');
                });
                break;
              default:
            }
          },
        ),
        Divider(
          thickness: 2,
          height: h * 0.01,
          indent: w * 0.05,
          endIndent: w * 0.05,
        ),
      ],
    );
  }

  Future<void> updateReadMessage(String docID, String collection) async {
    print('docID: $docID');
    print('collection: $collection');
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(docID)
        .update({'messageReceived': true});
  }
}
