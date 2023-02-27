// ignore_for_file: missing_return

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/staff-page/received_case/health_report_case.dart';
import 'package:seniorapp/component/page/staff-page/received_case/physical_report_case.dart';
import 'package:seniorapp/component/result-data/health_result_data.dart';
import 'package:seniorapp/component/result-data/physical_result_data.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/decoration/format_datetime.dart';
import 'package:seniorapp/component/page/staff-page/record/illness_record.dart';
import 'package:seniorapp/component/page/staff-page/record/injury_record.dart';

import 'dart:async' show Stream, StreamController, Timer;
import 'package:async/async.dart' show StreamZip;
import 'package:seniorapp/decoration/padding.dart';
import 'package:seniorapp/decoration/textfield_normal.dart';

class StaffCase extends StatefulWidget {
  const StaffCase({Key key}) : super(key: key);

  @override
  _StaffCaseState createState() => _StaffCaseState();
}

class _StaffCaseState extends State<StaffCase> {
  Timer _timer;
  String uid = FirebaseAuth.instance.currentUser.uid;
  String staff_no;
  int healthSize = 0;
  int physicalSize = 0;
  bool isLoading = false;
  bool caseFinished = false;
  List<bool> _selectedOrder = <bool>[true, false];
  List<bool> _selectedQuestionnaire = <bool>[true, true];
  List<bool> _selectedOrderType = <bool>[true, false];
  bool isDefault = true;
  RangeValues _currentRangeValues = const RangeValues(0, 100);
  int data_length = 10;

  Map<String, String> typeToThai = {
    'Health': 'อาการเจ็บป่วย',
    'Physical': 'อาการบาดเจ็บ'
  };

  void choose_filter() {
    setState(() {});
  }

  List<Map<String, dynamic>> add_filter(List<Map<String, dynamic>> data) {
    data.removeWhere((element) => element['caseFinished'] == true);

    if (_selectedOrder[0] == true) {
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
    } else if (_selectedOrder[1] == true) {
      if (_selectedOrderType[0] == true) {
        data.sort(
          (a, b) => (b['totalPoint']).compareTo(
            a['totalPoint'],
          ),
        );
      } else {
        data.sort(
          (a, b) => (a['totalPoint']).compareTo(
            b['totalPoint'],
          ),
        );
      }
    }

    if (_selectedQuestionnaire[0] == false) {
      data.removeWhere((element) => element['questionnaireType'] == 'Physical');
    }
    if (_selectedQuestionnaire[1] == false) {
      data.removeWhere((element) => element['questionnaireType'] == 'Health');
    }

    data.removeWhere(
        (element) => element['totalPoint'] < _currentRangeValues.start);
    data.removeWhere(
        (element) => element['totalPoint'] > _currentRangeValues.end);

    return data;
  }

  Stream<List<QuerySnapshot>> getData() {
    Stream healthQuestionnaire = FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('staff_uid_received', isEqualTo: uid, isNull: false)
        .snapshots();
    Stream physicalQuestionnaire = FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .where('staff_uid_received', isEqualTo: uid, isNull: false)
        .snapshots();

    return StreamZip([healthQuestionnaire, physicalQuestionnaire]);
  }

  getHealthSize() {
    FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('staff_uid_received', isEqualTo: uid, isNull: false)
        .get()
        .then(
      (snapshot) {
        List<QueryDocumentSnapshot<Map<String, dynamic>>> list = snapshot.docs;
        list.retainWhere((element) => element['caseFinished'] == false);
        setState(() {
          healthSize = list.length;
        });
      },
    );
  }

  getPhysicalSize() {
    FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .where('staff_uid_received', isEqualTo: uid, isNull: false)
        .get()
        .then(
      (snapshot) {
        List<QueryDocumentSnapshot<Map<String, dynamic>>> list = snapshot.docs;
        list.retainWhere((element) => element['caseFinished'] == false);
        setState(() {
          physicalSize = list.length;
        });
      },
    );
  }

  void _finishCase() {
    setState(() {
      getHealthSize();
      getPhysicalSize();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance.collection('Staff').doc(uid).get().then(
      (snapshot) {
        Map data = snapshot.data();
        staff_no = data['staff_no'];
      },
    );
    getPhysicalSize();
    getHealthSize();
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

  HealthResultData healthData;
  PhysicalResultData physicalData;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Column(
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
                  primary: Colors.blue[200],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    side: BorderSide(color: Colors.blue[700]),
                  ),
                ),
                label: Text(
                  'Filter',
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
                              child: const Text('Filter'),
                            ),
                            content: Column(
                              children: [
                                const Text('Order by'),
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
                                  fillColor: Colors.blue[200],
                                  borderColor: Colors.grey,
                                  selectedBorderColor: Colors.blue[700],
                                  selectedColor: Colors.white,
                                  color: Colors.blue,
                                  constraints: BoxConstraints(
                                    minHeight: h * 0.05,
                                    minWidth: w * 0.3,
                                  ),
                                  children: const [Text('Date'), Text('Score')],
                                  isSelected: _selectedOrder,
                                  onPressed: (int index) {
                                    setState(() {
                                      // The button that is tapped is set to true, and the others to false.
                                      for (int i = 0;
                                          i < _selectedOrder.length;
                                          i++) {
                                        _selectedOrder[i] = i == index;
                                      }
                                      isDefault = false;
                                    });
                                  },
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
                                  fillColor: Colors.blue[200],
                                  borderColor: Colors.grey,
                                  selectedBorderColor: Colors.blue[700],
                                  selectedColor: Colors.white,
                                  color: Colors.blue,
                                  constraints: BoxConstraints(
                                    minHeight: h * 0.05,
                                    minWidth: w * 0.3,
                                  ),
                                  children: const [
                                    Text('Descending'),
                                    Text('Ascending')
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
                                const Text('Type of problem'),
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
                                  fillColor: Colors.blue[200],
                                  borderColor: Colors.grey,
                                  selectedBorderColor: Colors.blue[700],
                                  selectedColor: Colors.white,
                                  color: Colors.blue,
                                  constraints: BoxConstraints(
                                    minHeight: h * 0.05,
                                    minWidth: w * 0.3,
                                  ),
                                  children: const [
                                    Text('Physical'),
                                    Text('Health')
                                  ],
                                  isSelected: _selectedQuestionnaire,
                                  onPressed: (int index) {
                                    // All buttons are selectable.
                                    setState(() {
                                      _selectedQuestionnaire[index] =
                                          !_selectedQuestionnaire[index];
                                      isDefault = false;
                                    });
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                                const Text('Range of score'),
                                const Padding(
                                  padding: EdgeInsets.all(5),
                                ),
                                RangeSlider(
                                  values: _currentRangeValues,
                                  min: 0,
                                  max: 100,
                                  divisions: 5,
                                  activeColor: Colors.blue[200],
                                  inactiveColor: Colors.blue[50],
                                  labels: RangeLabels(
                                    _currentRangeValues.start
                                        .round()
                                        .toString(),
                                    _currentRangeValues.end.round().toString(),
                                  ),
                                  onChanged: (RangeValues values) {
                                    setState(() {
                                      _currentRangeValues = values;
                                      isDefault = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              SizedBox(
                                width: w,
                                child: RaisedButton(
                                  color: Colors.blue[200],
                                  child: const Text(
                                    'Accept',
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
                  'Default',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CupertinoSwitch(
                  value: isDefault,
                  activeColor: Colors.blue[200],
                  onChanged: (bool value) {
                    setState(() {
                      if (isDefault == true) {
                        isDefault = false;
                      } else {
                        isDefault = true;
                        _selectedOrder = <bool>[true, false];
                        _selectedQuestionnaire = <bool>[true, true];
                        _selectedOrderType = <bool>[true, false];
                        _currentRangeValues = const RangeValues(0, 100);
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
          child: isLoading == true
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : healthSize + physicalSize > 0
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

                          int index = 0;
                          List<Map<String, dynamic>> mappedData = [];
                          for (QueryDocumentSnapshot doc in documentSnapshot) {
                            mappedData.add(doc.data());
                            mappedData[index]['docID'] = doc.reference.id;

                            index += 1;
                          }
                          mappedData = add_filter(mappedData);
                          return ListView.builder(
                            itemCount: mappedData.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data = mappedData[index];
                              switch (data['questionnaireType']) {
                                case 'Health':
                                  {
                                    healthData = HealthResultData.fromMap(data);
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        side: BorderSide(
                                            width: 2, color: Colors.blue[200]),
                                      ),
                                      elevation: 0,
                                      child: SizedBox(
                                        // height: h * 0.25,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: w * 0.03),
                                              width: w * 0.7,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: <Widget>[
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                      top: 15,
                                                    ),
                                                  ),
                                                  Text.rich(
                                                    TextSpan(
                                                      text: 'ประเภทแบบสอบถาม: ',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: typeToThai[
                                                              healthData
                                                                  .questionnaireType],
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  PaddingDecorate(5),
                                                  Text.rich(
                                                    TextSpan(
                                                      text: 'ปัญหาสุขภาพ: ',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: healthData
                                                              .healthSymptom,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  PaddingDecorate(5),
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
                                                            healthData.doDate,
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
                                                  PaddingDecorate(5),
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
                                                              '${DateFormat.Hms().format(
                                                            healthData.doDate,
                                                          )} น.',
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  PaddingDecorate(5),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      ElevatedButton.icon(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: Colors.white,
                                                          elevation: 0,
                                                        ),
                                                        onPressed: () {
                                                          HealthResultData
                                                              healthResultData =
                                                              HealthResultData
                                                                  .fromMap(
                                                                      data);
                                                          formatDate(
                                                            healthResultData
                                                                .doDate,
                                                            'Staff',
                                                          );
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  HealthReportCase(
                                                                      healthResultData:
                                                                          healthResultData,
                                                                      docID: data[
                                                                          'docID']),
                                                            ),
                                                          );
                                                        },
                                                        icon: const Icon(
                                                          Icons.article_rounded,
                                                          color: Colors.black,
                                                        ),
                                                        label: const Text(
                                                          'Details',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      healthData.caseFinished ==
                                                              false
                                                          ? ElevatedButton.icon(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Colors
                                                                    .blue[400],
                                                                elevation: 0,
                                                              ),
                                                              onPressed: () {
                                                                healthData =
                                                                    HealthResultData
                                                                        .fromMap(
                                                                            data);
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Athlete')
                                                                    .doc(healthData
                                                                        .athleteUID)
                                                                    .get()
                                                                    .then(
                                                                        (snapshot) {
                                                                  Map athleteData =
                                                                      snapshot
                                                                          .data();
                                                                  Athlete
                                                                      athlete =
                                                                      Athlete.fromMap(
                                                                          athleteData);
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              IllnessReport(
                                                                        healthData,
                                                                        data[
                                                                            'docID'],
                                                                        athlete,
                                                                      ),
                                                                    ),
                                                                  );
                                                                });
                                                              },
                                                              icon: const Icon(
                                                                Icons.add_box,
                                                              ),
                                                              label: const Text(
                                                                'Record',
                                                              ),
                                                            )
                                                          : Container()
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: w * 0.2,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${healthData.totalPoint}',
                                                    style: TextStyle(
                                                        color: score_color(
                                                            healthData
                                                                .totalPoint),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: h * 0.05),
                                                  ),
                                                  Text(
                                                    'คะแนน',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: h * 0.02),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  break;
                                case 'Physical':
                                  {
                                    physicalData =
                                        PhysicalResultData.fromMap(data);
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        side: BorderSide(
                                            width: 2, color: Colors.blue[200]),
                                      ),
                                      elevation: 0,
                                      child: SizedBox(
                                        // height: h * 0.25,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: w * 0.03),
                                              width: w * 0.7,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: <Widget>[
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 15),
                                                  ),
                                                  Text.rich(
                                                    TextSpan(
                                                      text: 'ประเภทแบบสอบถาม: ',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: typeToThai[
                                                              physicalData
                                                                  .questionnaireType],
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  PaddingDecorate(5),
                                                  Text.rich(
                                                    TextSpan(
                                                      text: 'ส่วนที่บาดเจ็บ: ',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: physicalData
                                                              .bodyPart,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  PaddingDecorate(5),
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
                                                            physicalData.doDate,
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
                                                  PaddingDecorate(5),
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
                                                              '${DateFormat.Hms().format(
                                                            physicalData.doDate,
                                                          )} น.',
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  PaddingDecorate(5),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      ElevatedButton.icon(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: Colors.white,
                                                          elevation: 0,
                                                        ),
                                                        onPressed: () {
                                                          PhysicalResultData
                                                              physicalResultData =
                                                              PhysicalResultData
                                                                  .fromMap(
                                                                      data);
                                                          formatDate(
                                                            physicalResultData
                                                                .doDate,
                                                            'Staff',
                                                          );
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PhysicalReportCase(
                                                                      physicalResultData:
                                                                          physicalResultData,
                                                                      docID: data[
                                                                          'docID']),
                                                            ),
                                                          );
                                                        },
                                                        icon: const Icon(
                                                          Icons.article_rounded,
                                                          color: Colors.black,
                                                        ),
                                                        label: const Text(
                                                          'Details',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      physicalData.caseFinished ==
                                                              false
                                                          ? ElevatedButton.icon(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Colors
                                                                    .blue[400],
                                                                elevation: 0,
                                                              ),
                                                              onPressed: () {
                                                                physicalData =
                                                                    PhysicalResultData
                                                                        .fromMap(
                                                                            data);
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Athlete')
                                                                    .doc(physicalData
                                                                        .athleteUID)
                                                                    .get()
                                                                    .then(
                                                                        (snapshot) {
                                                                  Map athleteData =
                                                                      snapshot
                                                                          .data();
                                                                  Athlete
                                                                      athlete =
                                                                      Athlete.fromMap(
                                                                          athleteData);
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(
                                                                    MaterialPageRoute(
                                                                      builder: (context) => InjuryReport(
                                                                          physicalData,
                                                                          data[
                                                                              'docID'],
                                                                          athlete),
                                                                    ),
                                                                  );
                                                                });
                                                              },
                                                              icon: const Icon(
                                                                Icons.add_box,
                                                              ),
                                                              label: const Text(
                                                                'Record',
                                                              ),
                                                            )
                                                          : Container()
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: w * 0.2,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${physicalData.totalPoint}',
                                                    style: TextStyle(
                                                        color: score_color(
                                                            physicalData
                                                                .totalPoint),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: h * 0.05),
                                                  ),
                                                  Text(
                                                    'คะแนน',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: h * 0.02),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  break;
                                default:
                              }
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
                        'Empty athlete case received',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
        ),
      ],
    );
  }
}
