import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/history-details/health_report_detail.dart';
import 'package:seniorapp/component/page/athlete-page/history-details/physical_report_detail.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/health_questionnaire.dart';
import 'package:seniorapp/component/result-data/health_result_data.dart';
import 'package:seniorapp/component/result-data/physical_result_data.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/decoration/format_date.dart';

import 'dart:async' show Stream, StreamController, Timer;
import 'package:async/async.dart' show StreamZip;
import 'package:seniorapp/decoration/padding.dart';

class AthleteHistory extends StatefulWidget {
  const AthleteHistory({Key key}) : super(key: key);

  @override
  _AthleteHistoryState createState() => _AthleteHistoryState();
}

class _AthleteHistoryState extends State<AthleteHistory> {
  List<bool> _selectedOrder = <bool>[true, false];
  List<bool> _selectedQuestionnaire = <bool>[true, true];
  List<bool> _selectedOrderType = <bool>[true, false];
  final List<bool> isDefault = <bool>[true];
  RangeValues _currentRangeValues = const RangeValues(0, 100);
  Timer _timer;
  String uid = FirebaseAuth.instance.currentUser.uid;
  String athlete_no;
  int healthSize;
  int physicalSize;
  bool isLoading = false;
  bool isFilter = false;
  int data_length = 10;

  void choose_filter() {
    setState(() {});
  }

  Stream<List<QuerySnapshot>> getData() {
    String athleteNo;

    Stream healthQuestionnaire = FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('athleteNo', isEqualTo: uid, isNull: false)
        .snapshots();
    Stream physicalQuestionnaire = FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .where('athleteNo', isEqualTo: uid, isNull: false)
        .snapshots();

    return StreamZip([healthQuestionnaire, physicalQuestionnaire]);
  }

  getHealthSize() {
    FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('athleteNo', isEqualTo: uid, isNull: false)
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
        .where('athleteNo', isEqualTo: uid, isNull: false)
        .get()
        .then(
      (snapshot) {
        setState(() {
          physicalSize = snapshot.docs.length;
        });
      },
    );
  }

  List<Map<String, dynamic>> add_filter(List<Map<String, dynamic>> data) {
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

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getPhysicalSize();
    getHealthSize();
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

  HealthResultData healthData;
  PhysicalResultData physicalData;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    print('health size: $healthSize');
    print('physical size: $physicalSize');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: w * 0.05, right: w * 0.05),
                width: w * 0.65,
                height: h * 0.052,
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.filter_list,
                    color: Colors.black,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade300,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      side: BorderSide(color: Colors.green[800]),
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
                                child: Text('Filter'),
                              ),
                              content: Column(
                                children: [
                                  Text('Order by'),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                  ),
                                  ToggleButtons(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    textStyle: TextStyle(
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
                                    children: [Text('Date'), Text('Score')],
                                    isSelected: _selectedOrder,
                                    onPressed: (int index) {
                                      setState(() {
                                        // The button that is tapped is set to true, and the others to false.
                                        for (int i = 0;
                                            i < _selectedOrder.length;
                                            i++) {
                                          _selectedOrder[i] = i == index;
                                        }
                                        isDefault[0] = false;
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                  ),
                                  ToggleButtons(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    textStyle: TextStyle(
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
                                        isDefault[0] = false;
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                  ),
                                  Text('Type of questionnaire'),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                  ),
                                  ToggleButtons(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    textStyle: TextStyle(
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
                                      Text('Physical'),
                                      Text('Health')
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
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                  ),
                                  Text('Range of score'),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                  ),
                                  RangeSlider(
                                    values: _currentRangeValues,
                                    min: 0,
                                    max: 100,
                                    divisions: 5,
                                    activeColor: Colors.green[300],
                                    inactiveColor: Colors.green[100],
                                    labels: RangeLabels(
                                      _currentRangeValues.start
                                          .round()
                                          .toString(),
                                      _currentRangeValues.end
                                          .round()
                                          .toString(),
                                    ),
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        _currentRangeValues = values;
                                        isDefault[0] = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              actions: [
                                Container(
                                  width: w,
                                  child: RaisedButton(
                                    color: Colors.green[300],
                                    child: Text(
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
              ToggleButtons(
                children: [Text('Default')],
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
                      _selectedOrder = <bool>[true, false];
                      _selectedQuestionnaire = <bool>[true, true];
                      _selectedOrderType = <bool>[true, false];
                      _currentRangeValues = RangeValues(0, 100);
                    }
                  });
                },
              ),
            ],
          ),
          PaddingDecorate(5),
          Expanded(
            child: Container(
              height: h,
              width: w,
              child: isLoading
                  ? Center(
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

                                List<Map<String, dynamic>> mappedData = [];
                                for (QueryDocumentSnapshot doc
                                    in documentSnapshot) {
                                  mappedData.add(doc.data());
                                }

                                mappedData = add_filter(mappedData);

                                return ListView.builder(
                                  itemCount: data_length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> data =
                                        mappedData[index];
                                    healthData = HealthResultData.fromMap(data);
                                    physicalData =
                                        PhysicalResultData.fromMap(data);
                                    return GestureDetector(
                                      child: Card(
                                        child: Container(
                                          height: h * 0.2,
                                          padding: EdgeInsets.only(
                                            left: w * 0.05,
                                          ),
                                          child: data['questionnaireType'] ==
                                                  'Health'
                                              ? Row(
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
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: <Widget>[
                                                          Text.rich(
                                                            TextSpan(
                                                              text:
                                                                  'Problem type: ',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: healthData
                                                                      .questionnaireType,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Text.rich(
                                                            TextSpan(
                                                              text:
                                                                  'Health Symptom: ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: healthData
                                                                      .healthSymptom,
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
                                                              text: 'Done on: ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: formatDate(
                                                                      healthData
                                                                          .doDate),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Text.rich(
                                                            TextSpan(
                                                              text: 'Time: ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: DateFormat
                                                                          .Hms()
                                                                      .format(
                                                                    healthData
                                                                        .doDate,
                                                                  ),
                                                                  style: TextStyle(
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
                                                    Container(
                                                      width: w * 0.2,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '${healthData.totalPoint}',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    h * 0.05),
                                                          ),
                                                          Text('score'),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Container(
                                                      width: w * 0.7,
                                                      padding: EdgeInsets.only(
                                                          left: w * 0.03),
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
                                                              text:
                                                                  'Problem type: ',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: physicalData
                                                                      .questionnaireType,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Text.rich(
                                                            TextSpan(
                                                              text:
                                                                  'Injured body: ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: physicalData
                                                                      .bodyPart,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Text.rich(
                                                            TextSpan(
                                                              text: 'Done on: ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      formatDate(
                                                                    physicalData
                                                                        .doDate,
                                                                  ),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Text.rich(
                                                            TextSpan(
                                                              text: 'Time: ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: DateFormat
                                                                          .Hms()
                                                                      .format(
                                                                    physicalData
                                                                        .doDate,
                                                                  ),
                                                                  style: TextStyle(
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
                                                    Container(
                                                      width: w * 0.2,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '${healthData.totalPoint}',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    h * 0.05),
                                                          ),
                                                          Text('score'),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                        ),
                                      ),
                                      onTap: () {
                                        switch (data['questionnaireType']) {
                                          case 'Health':
                                            HealthResultData health =
                                                HealthResultData.fromMap(data);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HealthReportDetail(
                                                  answerList: health.answerList,
                                                  athleteNo: health.athleteNo,
                                                  doDate: health.doDate,
                                                  healthSymptom:
                                                      health.healthSymptom,
                                                  questionnaireType:
                                                      health.questionnaireType,
                                                  questionnaireNo:
                                                      health.questionnaireNo,
                                                  totalPoint: health.totalPoint,
                                                ),
                                              ),
                                            );
                                            break;
                                          case 'Physical':
                                            PhysicalResultData physical =
                                                PhysicalResultData.fromMap(
                                                    data);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PhysicalReportDetail(
                                                  answerList:
                                                      physical.answerList,
                                                  athleteNo: physical.athleteNo,
                                                  doDate: physical.doDate,
                                                  bodyPart: physical.bodyPart,
                                                  questionnaireType: physical
                                                      .questionnaireType,
                                                  questionnaireNo:
                                                      physical.questionnaireNo,
                                                  totalPoint:
                                                      physical.totalPoint,
                                                ),
                                              ),
                                            );
                                            break;
                                          default:
                                        }
                                      },
                                    );
                                  },
                                );
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
