import 'dart:async' show Stream, StreamController, Timer;

import 'package:async/async.dart' show StreamZip;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/staff-page/history/history_details/illness_report_description.dart';
import 'package:seniorapp/component/page/staff-page/history/history_details/injury_report_description.dart';
import 'package:seniorapp/component/report-data/illness_report_data.dart';
import 'package:seniorapp/component/report-data/injury_report_data.dart';
import 'package:seniorapp/decoration/format_datetime.dart';

class StaffHistory extends StatefulWidget {
  const StaffHistory({Key key}) : super(key: key);

  @override
  State<StaffHistory> createState() => _StaffReportState();
}

class _StaffReportState extends State<StaffHistory> {
  Timer _timer;
  String uid = FirebaseAuth.instance.currentUser.uid;
  int illnessSize;
  int injurySize;
  bool isLoading = false;
  List<bool> isDefault = [true];
  List<bool> _selectedOrder = <bool>[true, false];
  List<bool> _selectedReport = <bool>[true, true];
  List<bool> _selectedOrderType = <bool>[true, false];

  void choose_filter() {
    setState(() {});
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

    if (_selectedReport[0] == false) {
      data.removeWhere((element) => element['report_type'] == 'Injury');
    }
    if (_selectedReport[1] == false) {
      data.removeWhere((element) => element['report_type'] == 'Illness');
    }

    return data;
  }

  Stream<List<QuerySnapshot>> getData() {
    Stream illnessStream = FirebaseFirestore.instance
        .collection('IllnessRecord')
        .where('staff_uid', isEqualTo: uid)
        .snapshots();
    Stream injuryStream = FirebaseFirestore.instance
        .collection('InjuryRecord')
        .where('staff_uid', isEqualTo: uid)
        .snapshots();
    return StreamZip([injuryStream, illnessStream]);
  }

  getIllnessSize() {
    FirebaseFirestore.instance
        .collection('IllnessRecord')
        .where('staff_uid', isEqualTo: uid)
        .get()
        .then(
      (snapshot) {
        setState(() {
          illnessSize = snapshot.docs.length;
        });
      },
    );
  }

  getInjurySize() {
    FirebaseFirestore.instance
        .collection('InjuryRecord')
        .where('staff_uid', isEqualTo: uid)
        .get()
        .then(
      (snapshot) {
        setState(() {
          injurySize = snapshot.docs.length;
        });
      },
    );
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    getInjurySize();
    getIllnessSize();
    _timer = Timer(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
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

    return Scaffold(
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
                    primary: Colors.blue.shade200,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
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
                                child: Text('Filter'),
                              ),
                              content: Column(
                                children: [
                                  Text('Order by date'),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                  ),
                                  // ToggleButtons(
                                  //   borderRadius: const BorderRadius.all(
                                  //     Radius.circular(8),
                                  //   ),
                                  //   textStyle: TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  //   fillColor: Colors.blue[200],
                                  //   borderColor: Colors.grey,
                                  //   selectedBorderColor: Colors.blue[700],
                                  //   selectedColor: Colors.white,
                                  //   color: Colors.blue,
                                  //   constraints: BoxConstraints(
                                  //     minHeight: h * 0.05,
                                  //     minWidth: w * 0.3,
                                  //   ),
                                  //   children: [Text('Date'), Text('Score')],
                                  //   isSelected: _selectedOrder,
                                  //   onPressed: (int index) {
                                  //     setState(() {
                                  //       // The button that is tapped is set to true, and the others to false.
                                  //       for (int i = 0;
                                  //           i < _selectedOrder.length;
                                  //           i++) {
                                  //         _selectedOrder[i] = i == index;
                                  //       }
                                  //       isDefault[0] = false;
                                  //     });
                                  //   },
                                  // ),
                                  // Padding(
                                  //   padding: EdgeInsets.all(5),
                                  // ),
                                  ToggleButtons(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    textStyle: TextStyle(
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
                                  Text('Type of report'),
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
                                    fillColor: Colors.blue[200],
                                    borderColor: Colors.grey,
                                    selectedBorderColor: Colors.blue[700],
                                    selectedColor: Colors.white,
                                    color: Colors.blue,
                                    constraints: BoxConstraints(
                                      minHeight: h * 0.05,
                                      minWidth: w * 0.3,
                                    ),
                                    children: [Text('Injury'), Text('Illness')],
                                    isSelected: _selectedReport,
                                    onPressed: (int index) {
                                      // All buttons are selectable.
                                      setState(() {
                                        _selectedReport[index] =
                                            !_selectedReport[index];
                                        isDefault[0] = false;
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                  ),
                                ],
                              ),
                              actions: [
                                Container(
                                  width: w,
                                  child: RaisedButton(
                                    color: Colors.blue[200],
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
                fillColor: Colors.blue[200],
                borderColor: Colors.grey,
                selectedBorderColor: Colors.blue[700],
                selectedColor: Colors.black,
                color: Colors.blue,
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
                      _selectedReport = <bool>[true, true];
                      _selectedOrderType = <bool>[true, false];
                    }
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CupertinoActivityIndicator(),
                  )
                : Container(
                    height: h,
                    width: w,
                    child: illnessSize + injurySize != 0
                        ? StreamBuilder(
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
                                  itemCount: mappedData.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> data =
                                        mappedData[index];
                                    return GestureDetector(
                                      child: Card(
                                        child: Container(
                                          height: h * 0.2,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text.rich(
                                                TextSpan(
                                                  text: 'Report type: ',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: data['report_type'],
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  text: 'Sport: ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: data['sport_event'],
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  text: 'Done on: ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: formatDate(
                                                        data['doDate'].toDate(),
                                                        'Staff',
                                                      ),
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  text: 'Time: ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: DateFormat.Hms()
                                                          .format(
                                                        data['doDate'].toDate(),
                                                      ),
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        if (data['report_type'] == 'Illness') {
                                          IllnessReportData illness =
                                              IllnessReportData.fromMap(data);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReportIllnessDescription(
                                                report_id: illness.report_no,
                                                affected_system:
                                                    illness.affected_system,
                                                affected_system_code: illness
                                                    .affected_system_code,
                                                athlete_no: illness.athlete_no,
                                                diagnosis: illness.diagnosis,
                                                illness_cause:
                                                    illness.illness_cause,
                                                illness_cause_code:
                                                    illness.illness_cause_code,
                                                mainSymptoms:
                                                    illness.mainSymptoms,
                                                mainSymptomsCode:
                                                    illness.mainSymptomsCode,
                                                no_day: illness.no_day,
                                                occured_date:
                                                    illness.occured_date,
                                                report_type:
                                                    illness.report_type,
                                                sport_event:
                                                    illness.sport_event,
                                                staff_uid: illness.staff_uid,
                                              ),
                                            ),
                                          );
                                        } else {
                                          InjuryReportData injury =
                                              InjuryReportData.fromMap(data);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReportInjuryDescription(
                                                report_id: injury.report_no,
                                                injuryBody: injury.injuryBody,
                                                injuryBodyCode:
                                                    injury.injuryBodyCode,
                                                injuryCause: injury.injuryCause,
                                                injuryCauseCode:
                                                    injury.injuryCauseCode,
                                                injuryType: injury.injuryType,
                                                injuryTypeCode:
                                                    injury.injuryTypeCode,
                                                round_heat_training:
                                                    injury.round_heat_training,
                                                athlete_no: injury.athlete_no,
                                                no_day: injury.no_day,
                                                injuryDateTime:
                                                    injury.injuryDateTime,
                                                report_type: injury.report_type,
                                                sport_event: injury.sport_event,
                                                staff_uid: injury.staff_uid,
                                              ),
                                            ),
                                          );
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
                          )
                        : Center(
                            child: Text(
                              'Empty medical record',
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
