import 'dart:async' show Stream, Timer;
import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  String problemSearchText = '';
  TextEditingController textController = TextEditingController();

  List<String> sortList = [
    'Recently date',
    'Previous date',
  ];
  bool isInjuryButtonActive = false;
  bool isIllnessButtonActive = false;
  String selectedSort = 'Recently date';

  List<String> specificProblemList = [];
  String specificProblem = 'View all';

  List<Map<String, dynamic>> medicalRecordList = [];

  void choose_filter() {
    setState(() {});
  }

  List<Map<String, dynamic>> add_sort(List<Map<String, dynamic>> data) {
    if (selectedSort == sortList[0]) {
      data.sort(
        (a, b) => (b['doDate'].toDate()).compareTo(
          a['doDate'].toDate(),
        ),
      );
    } else if (selectedSort == sortList[1]) {
      data.sort(
        (a, b) => (a['doDate'].toDate()).compareTo(
          b['doDate'].toDate(),
        ),
      );
    }
    return data;
  }

  List<Map<String, dynamic>> add_filter(List<Map<String, dynamic>> data) {
    if (specificProblem != 'View all') {
      data = data
          .where((map) =>
              specificProblemList.any((value) => map.values.contains(value)))
          .toList();
    }

    if (isInjuryButtonActive == true) {
      data.retainWhere((element) => element['report_type'] == 'Injury');
    } else if (isIllnessButtonActive == true) {
      data.retainWhere((element) => element['report_type'] == 'Illness');
    }

    return data;
  }

  Future<String> _showProblemPage(double bodyHeight) async {
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final h = MediaQuery.of(context).size.height;
        final w = MediaQuery.of(context).size.width;

        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            height: bodyHeight,
            padding: EdgeInsets.only(
              bottom: bodyHeight * 0.02,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        int countProblem = isProblemChooseList
                            .where((element) => element == true)
                            .length;
                        String result;
                        if (countProblem == 0) {
                          result = 'View all';
                        } else if (countProblem == 1) {
                          for (int i = 0; i < isProblemChooseList.length; i++) {
                            if (isProblemChooseList[i] == true) {
                              result = problemList[i];
                            }
                          }
                        } else {
                          result = 'Multiple Selected';
                        }
                        Navigator.pop(context, result);
                      },
                      icon: const Icon(Icons.keyboard_arrow_left),
                    ),
                    const Text(
                      'All Problems',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isProblemChooseList = List.filled(49, false);
                        });
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: w * 0.02, right: w * 0.02),
                  child: CupertinoSearchTextField(
                    controller: textController,
                    suffixMode: OverlayVisibilityMode.editing,
                    suffixIcon: const Icon(
                      CupertinoIcons.clear_thick_circled,
                    ),
                    onSuffixTap: () {
                      setState(() {
                        textController.clear();
                        problemSearchText = '';
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        problemSearchText = value;
                      });
                    },
                    onSubmitted: (value) {
                      setState(() {
                        problemSearchText = value;
                        textController.text = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: problemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (problemList[index]
                          .toLowerCase()
                          .contains(problemSearchText.toLowerCase())) {
                        return CheckboxListTile(
                          value: isProblemChooseList[index],
                          onChanged: (bool value) {
                            setState(() {
                              isProblemChooseList[index] = value;
                              if (value == true) {
                                specificProblemList.add(problemList[index]);
                              } else if (value == false) {
                                specificProblemList.removeWhere(
                                    (element) => element == problemList[index]);
                              }
                            });
                          },
                          activeColor: Colors.blue[200],
                          title: Text(problemList[index]),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _showFilterPage(double bodyHeight) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final w = MediaQuery.of(context).size.width;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: bodyHeight,
            padding: EdgeInsets.only(
              bottom: bodyHeight * 0.02,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add your filter UI elements here
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'Filter',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isIllnessButtonActive = false;
                              isInjuryButtonActive = false;
                              specificProblem = 'View all';
                            });
                          },
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.only(left: w * 0.05, right: w * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Type of case
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Type of case',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // Physical Button
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isInjuryButtonActive =
                                            !isInjuryButtonActive;
                                        isIllnessButtonActive = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      textStyle: const TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      elevation: 0,
                                      shape: const StadiumBorder(),
                                      side: BorderSide(color: Colors.blue[200]),
                                      onPrimary: isInjuryButtonActive == false
                                          ? Colors.blue
                                          : Colors.white,
                                      primary: isInjuryButtonActive == true
                                          ? Colors.blue[200]
                                          : Colors.white,
                                    ),
                                    child: const Text('Injury'),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  // Health Button
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isIllnessButtonActive =
                                            !isIllnessButtonActive;
                                        isInjuryButtonActive = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      textStyle: const TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      elevation: 0,
                                      shape: const StadiumBorder(),
                                      side: BorderSide(color: Colors.blue[200]),
                                      onPrimary: isIllnessButtonActive == false
                                          ? Colors.blue
                                          : Colors.white,
                                      primary: isIllnessButtonActive == true
                                          ? Colors.blue[200]
                                          : Colors.white,
                                    ),
                                    child: const Text('Illness'),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    )
                  ],
                ), // Add a confirm button to apply the filter
                Container(
                  padding: EdgeInsets.only(
                    left: w * 0.05,
                    right: w * 0.05,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      addData();
                      choose_filter();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Apply',
                      style: TextStyle(
                        color: Colors.blueGrey[50],
                        fontSize: bodyHeight * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(w, bodyHeight * 0.05),
                      elevation: 0,
                      primary: Colors.blue[400],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _showSortPage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final h = MediaQuery.of(context).size.height;
        final w = MediaQuery.of(context).size.width;

        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.only(
              top: h * 0.02,
              bottom: h * 0.02,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Add your filter UI elements here
                    const Text(
                      'Sort by',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RadioListTile(
                        activeColor: Colors.blue,
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: sortList[0],
                        groupValue: selectedSort,
                        title: Text(sortList[0].toString()),
                        onChanged: (value) {
                          setState(() {
                            selectedSort = value;
                          });
                        }),
                    const Divider(
                      thickness: 1,
                    ),
                    RadioListTile(
                        activeColor: Colors.blue,
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: sortList[1],
                        groupValue: selectedSort,
                        title: Text(sortList[1].toString()),
                        onChanged: (value) {
                          setState(() {
                            selectedSort = value;
                          });
                        }),
                    const Divider(
                      thickness: 1,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: w * 0.05,
                    right: w * 0.05,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      choose_filter();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Apply',
                      style: TextStyle(
                        color: Colors.blueGrey[50],
                        fontSize: h * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(w, h * 0.05),
                      elevation: 0,
                      primary: Colors.blue[400],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
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
    medicalRecordList = add_sort(medicalRecordList);

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              right: 10,
              left: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.filter_list,
                      color: Colors.black,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[200],
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    label: Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: h * 0.02,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () => _showFilterPage(constraints.maxHeight),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      FontAwesomeIcons.sort,
                      size: 20,
                      color: Colors.black,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[200],
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    label: Text(
                      'Sort by',
                      style: TextStyle(
                        fontSize: h * 0.02,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: _showSortPage,
                  ),
                ),
              ],
            ),
          ),
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
      );
    });
  }
}
