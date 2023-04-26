import 'dart:async' show Stream, Timer;
import 'dart:collection';

import 'package:async/async.dart' show StreamZip;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/staff-page/history/history_details/illness_report_description.dart';
import 'package:seniorapp/component/page/staff-page/history/history_details/injury_report_description.dart';
import 'package:seniorapp/component/page/staff-page/staff_page_choosing.dart';
import 'package:seniorapp/component/report-data/illness_report_data.dart';
import 'package:seniorapp/component/report-data/injury_report_data.dart';
import 'package:seniorapp/decoration/format_datetime.dart';
import 'package:seniorapp/decoration/padding.dart';

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
  bool isDefault = true;
  List<bool> _selectedReport = <bool>[true, true];
  List<bool> _selectedOrderType = <bool>[true, false];

  List<Map<String, dynamic>> medicalRecordList = [];

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

  addData() {
    List<Map<String, dynamic>> combinedList =
        illnessRecordList + injuryRecordList;
    print('Combined List Case: ${combinedList.length}');

    Map<String, Map<String, dynamic>> athleteMap =
        athleteList.fold({}, (Map<String, Map<String, dynamic>> map, athlete) {
      String athleteId = athlete['athlete_no'];
      map[athleteId] = athlete;
      return map;
    });

    Map<String, List<Map<String, dynamic>>> recordMap = combinedList.fold({},
        (Map<String, List<Map<String, dynamic>>> map, record) {
      String athleteNo = record['athlete_no'];
      if (!map.containsKey(athleteNo)) {
        map[athleteNo] = [];
      }
      map[athleteNo].add(record);
      return map;
    });

    List<Map<String, dynamic>> resultAsList = [];
    for (var athlete in athleteList) {
      String athleteNo = athlete['athlete_no'];
      if (recordMap.containsKey(athleteNo)) {
        for (var record in recordMap[athleteNo]) {
          Map<String, dynamic> combined = LinkedHashMap.of({
            ...athlete,
            ...record,
          });
          resultAsList.add(combined);
        }
      }
    }

    medicalRecordList = resultAsList;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    addData();
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
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    medicalRecordList = add_filter(medicalRecordList);

    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: w * 0.05,
                  right: w * 0.05,
                ),
                width: w * 0.65,
                height: h * 0.052,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.filter_list,
                    color: Colors.black,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue.shade200,
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
                                  const Text('Order by date'),
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
                                    children: [
                                      const Text('Descending'),
                                      const Text('Ascending')
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
                                  const Text('Type of report'),
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
                                    children: [
                                      const Text('Injury'),
                                      const Text('Illness')
                                    ],
                                    isSelected: _selectedReport,
                                    onPressed: (int index) {
                                      // All buttons are selectable.
                                      setState(() {
                                        _selectedReport[index] =
                                            !_selectedReport[index];
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
                          _selectedReport = <bool>[true, true];
                          _selectedOrderType = <bool>[true, false];
                          addData();
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
            child: isLoading
                ? const Center(
                    child: CupertinoActivityIndicator(),
                  )
                : medicalRecordList.isNotEmpty
                    ? ListView.builder(
                        itemCount: medicalRecordList.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = medicalRecordList[index];
                          return GestureDetector(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: BorderSide(
                                    width: 2, color: Colors.blue[200]),
                              ),
                              elevation: 0,
                              child: SizedBox(
                                height: h * 0.2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text.rich(
                                      TextSpan(
                                        text: 'Athlete name: ',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: data['firstname'] +
                                                ' ' +
                                                data['lastname'],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: 'Report type: ',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: data['report_type'],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: 'Sport: ',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: data['sport_event'],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: 'Done on: ',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: formatDate(
                                              data['doDate'].toDate(),
                                              'Staff',
                                            ),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: 'Time: ',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: DateFormat.Hms().format(
                                              data['doDate'].toDate(),
                                            ),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal),
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
                                      affected_system: illness.affected_system,
                                      affected_system_code:
                                          illness.affected_system_code,
                                      athlete_no: illness.athlete_no,
                                      diagnosis: illness.diagnosis,
                                      illness_cause: illness.illness_cause,
                                      illness_cause_code:
                                          illness.illness_cause_code,
                                      mainSymptoms: illness.mainSymptoms,
                                      mainSymptomsCode:
                                          illness.mainSymptomsCode,
                                      no_day: illness.no_day,
                                      occured_date: illness.occured_date,
                                      report_type: illness.report_type,
                                      sport_event: illness.sport_event,
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
                                      injuryBodyCode: injury.injuryBodyCode,
                                      injuryCause: injury.injuryCause,
                                      injuryCauseCode: injury.injuryCauseCode,
                                      injuryType: injury.injuryType,
                                      injuryTypeCode: injury.injuryTypeCode,
                                      round_heat_training:
                                          injury.round_heat_training,
                                      athlete_no: injury.athlete_no,
                                      no_day: injury.no_day,
                                      injuryDateTime: injury.injuryDateTime,
                                      report_type: injury.report_type,
                                      sport_event: injury.sport_event,
                                      staff_uid: injury.staff_uid,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        })
                    : const Center(
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
        ],
      ),
    );
  }
}
