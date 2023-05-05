import 'dart:collection';
import 'dart:ffi';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/staff-page/received_case/health_report_case.dart';
import 'package:seniorapp/component/page/staff-page/received_case/physical_report_case.dart';
import 'package:seniorapp/component/page/staff-page/staff_page_choosing.dart';
import 'package:seniorapp/decoration/format_datetime.dart';

import 'dart:async' show Timer;

import 'package:seniorapp/main.dart';

class StaffAppointmentNotify extends StatefulWidget {
  const StaffAppointmentNotify({Key key, this.refreshNotification})
      : super(key: key);
  final Void refreshNotification;

  @override
  _StaffCaseState createState() => _StaffCaseState();
}

class _StaffCaseState extends State<StaffAppointmentNotify> {
  bool isLoading = false;
  int appointmentSize = 0;
  Timer _timer;

  Map<String, dynamic> unfinishedCaseList;

  List<Map<String, dynamic>> appointmentCaseList = [];

  String _getDetail(bool appointStatus) {
    String detail;
    if (appointStatus == false) {
      detail =
          'Athlete declined your appointment, please re-appoint for this case.';
    } else if (appointStatus == true) {
      detail = 'Athlete accepted your appointment.';
    }
    return detail;
  }

  addAthleteData() {
    print('Combined List Case: ${appointmentRecordList.length}');

    Map<String, Map<String, dynamic>> athleteMap =
        athleteList.fold({}, (Map<String, Map<String, dynamic>> map, athlete) {
      String athleteId = athlete['athleteUID'];
      map[athleteId] = athlete;
      return map;
    });

    Map<String, List<Map<String, dynamic>>> appointmentMap =
        appointmentRecordList.fold({},
            (Map<String, List<Map<String, dynamic>>> map, appointment) {
      String athleteId = appointment['athleteUID'];
      if (!map.containsKey(athleteId)) {
        map[athleteId] = [];
      }
      map[athleteId].add(appointment);
      return map;
    });

    List<Map<String, dynamic>> resultAsList = [];
    for (var athlete in athleteList) {
      String athleteId = athlete['athleteUID'];
      if (appointmentMap.containsKey(athleteId)) {
        for (var appointment in appointmentMap[athleteId]) {
          Map<String, dynamic> combined = LinkedHashMap.of({
            ...athlete,
            ...appointment,
          });
          resultAsList.add(combined);
        }
      }
    }

    appointmentCaseList = resultAsList;
  }

  addCaseData() {
    List<Map<String, dynamic>> combinedList = physicalCaseList + healthCaseList;
    print('Combined List Case: ${appointmentRecordList.length}');

    Map<String, List<Map<String, dynamic>>> questionnaireMap = combinedList
        .fold({}, (Map<String, List<Map<String, dynamic>>> map, questionnaire) {
      String questionnaireID = questionnaire['questionnaireID'];
      if (!map.containsKey(questionnaireID)) {
        map[questionnaireID] = [];
      }
      map[questionnaireID].add(questionnaire);
      return map;
    });

    Map<String, List<Map<String, dynamic>>> appointmentMap =
        appointmentRecordList.fold({},
            (Map<String, List<Map<String, dynamic>>> map, appointment) {
      String caseID = appointment['caseID'];
      if (!map.containsKey(caseID)) {
        map[caseID] = [];
      }
      map[caseID].add(appointment);
      return map;
    });

    List<Map<String, dynamic>> resultAsList = [];
    for (var appointment in appointmentCaseList) {
      String caseID = appointment['caseID'];
      if (questionnaireMap.containsKey(caseID)) {
        for (var questionnaire in questionnaireMap[caseID]) {
          Map<String, dynamic> combined = LinkedHashMap.of({
            ...appointment,
            ...questionnaire,
          });
          resultAsList.add(combined);
        }
      }
    }

    resultAsList.forEach((element) {
      print(element['questionnaireID']);
    });
    appointmentCaseList = resultAsList;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    addAthleteData();
    addCaseData();
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
    return isLoading
        ? const Center(
            child: CupertinoActivityIndicator(),
          )
        : appointmentCaseList.isNotEmpty
            ? ListView.builder(
                itemCount: appointmentCaseList.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = appointmentCaseList[index];

                  return GestureDetector(
                    onTap: () {
                      updateData(data['appointmentID'], data['caseID'], data);
                    },
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: 'Athlete: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            '${data['firstname']} ${data['lastname']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: 'Appointed Date: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: formatDate(
                                            // data['appointDate'].toDate(),
                                            DateTime.now(),
                                            'Staff'),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: 'Appointed Time: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: formatTime(
                                            data['appointDate'].toDate(),
                                            'Staff'),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: 'Detail: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: _getDetail(data['appointStatus']),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 2.0,
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text(
                  'Empty notification',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
  }

  addData(Map<String, dynamic> data, Map<String, dynamic> appointmentData) {
    String joinKey = 'athleteUID';
    Map<String, dynamic> result = {};

    if (data.containsKey(joinKey) &&
        appointmentData.containsKey(joinKey) &&
        data[joinKey] == appointmentData[joinKey]) {
      result.addAll(data);
      result.addAll(appointmentData);
    }
    return result;
  }

  void updateData(String docID, String caseID, Map<String, dynamic> data) {
    if (data['questionnaireType'] == 'Health') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return HealthReportCase(data: data);
          },
        ),
      ).then((value) {
        appointmentCollection.doc(docID).update({
          'staffReadStatus': true,
          'staffReadDate': DateTime.now(),
        });
      });
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return PhysicalReportCase(data: data);
          },
        ),
      ).then((value) {
        appointmentCollection.doc(docID).update({
          'staffReadStatus': true,
          'staffReadDate': DateTime.now(),
        });
      });
    }
  }
}
