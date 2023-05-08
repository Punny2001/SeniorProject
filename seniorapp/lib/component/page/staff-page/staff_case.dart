import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:seniorapp/component/page/staff-page/received_case/health_report_case.dart';
import 'package:seniorapp/component/page/staff-page/received_case/physical_report_case.dart';
import 'package:seniorapp/component/page/staff-page/record/illness_record.dart';
import 'package:seniorapp/component/page/staff-page/record/injury_record.dart';
import 'package:seniorapp/component/page/staff-page/staff_page_choosing.dart';
import 'dart:async' show Timer;
import 'package:seniorapp/decoration/format_datetime.dart';
import 'package:seniorapp/decoration/padding.dart';
import 'package:seniorapp/decoration/textfield_normal.dart';

Map<String, String> typeToThai = {
  'Health': 'อาการเจ็บป่วย',
  'Physical': 'อาการบาดเจ็บ'
};

class StaffCase extends StatefulWidget {
  const StaffCase({Key key}) : super(key: key);

  @override
  _StaffCaseState createState() => _StaffCaseState();
}

class _StaffCaseState extends State<StaffCase> {
  Timer _timer;

  List<Map<String, dynamic>> unfinishedCaseList = [];

  bool isLoading = false;
  bool caseFinished = false;
  bool isDefault = true;
  RangeValues _currentRangeValues = const RangeValues(0, 100);

  String problemSearchText = '';
  List<String> specificProblemList = [];
  String specificProblem = 'View all';
  TextEditingController textController = TextEditingController();

  List<String> sortList = [
    'Recently date',
    'Previous date',
    'Low score -> High score',
    'High score -> Low score'
  ];

  DateTime now = DateTime.now();

  bool inDateFormat = false;

  bool isPhysicalButtonActive = false;
  bool isHealthButtonActive = false;
  String selectedSort = 'Recently date';

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
    } else if (selectedSort == sortList[2]) {
      data.sort(
        (a, b) => (a['totalPoint']).compareTo(
          b['totalPoint'],
        ),
      );
    } else if (selectedSort == sortList[3]) {
      data.sort(
        (a, b) => (b['totalPoint']).compareTo(
          a['totalPoint'],
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

    print(data);

    if (isPhysicalButtonActive == true) {
      data.retainWhere((element) => element['questionnaireType'] == 'Physical');
    } else if (isHealthButtonActive == true) {
      data.retainWhere((element) => element['questionnaireType'] == 'Health');
    }

    data.removeWhere(
        (element) => element['totalPoint'] < _currentRangeValues.start);
    data.removeWhere(
        (element) => element['totalPoint'] > _currentRangeValues.end);

    return data;
  }

  addData() {
    List<Map<String, dynamic>> combinedList =
        unfinishedHealthCaseList + unfinishedPhysicalCaseList;
    print('Combined List Case: ${combinedList.length}');

    Map<String, Map<String, dynamic>> athleteMap =
        athleteList.fold({}, (Map<String, Map<String, dynamic>> map, athlete) {
      String athleteId = athlete['athleteUID'];
      map[athleteId] = athlete;
      return map;
    });

    Map<String, List<Map<String, dynamic>>> questionnaireMap = combinedList
        .fold({}, (Map<String, List<Map<String, dynamic>>> map, questionnaire) {
      String athleteId = questionnaire['athleteUID'];
      if (!map.containsKey(athleteId)) {
        map[athleteId] = [];
      }
      map[athleteId].add(questionnaire);
      return map;
    });

    List<Map<String, dynamic>> resultAsList = [];
    for (var athlete in athleteList) {
      String athleteId = athlete['athleteUID'];
      if (questionnaireMap.containsKey(athleteId)) {
        for (var questionnaire in questionnaireMap[athleteId]) {
          Map<String, dynamic> combined = LinkedHashMap.of({
            ...athlete,
            ...questionnaire,
          });
          resultAsList.add(combined);
        }
      }
    }

    unfinishedCaseList = resultAsList;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    isProblemChooseList = List.filled(49, false);
    addData();
    _timer = Timer(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
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
                              isHealthButtonActive = false;
                              isPhysicalButtonActive = false;
                              specificProblem = 'View all';

                              _currentRangeValues = const RangeValues(0, 100);
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
                                        isPhysicalButtonActive =
                                            !isPhysicalButtonActive;
                                        isHealthButtonActive = false;
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
                                      onPrimary: isPhysicalButtonActive == false
                                          ? Colors.blue
                                          : Colors.white,
                                      primary: isPhysicalButtonActive == true
                                          ? Colors.blue[200]
                                          : Colors.white,
                                    ),
                                    child: const Text('Physical'),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  // Health Button
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isHealthButtonActive =
                                            !isHealthButtonActive;
                                        isPhysicalButtonActive = false;
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
                                      onPrimary: isHealthButtonActive == false
                                          ? Colors.blue
                                          : Colors.white,
                                      primary: isHealthButtonActive == true
                                          ? Colors.blue[200]
                                          : Colors.white,
                                    ),
                                    child: const Text('Health'),
                                  ),
                                ],
                              )
                            ],
                          ),
                          PaddingDecorate(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Specify problem',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final result =
                                      await _showProblemPage(bodyHeight);
                                  if (result != null) {
                                    setState(() {
                                      specificProblem = result;
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      specificProblem,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          PaddingDecorate(15),
                          // Range of score
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Range of score',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${_currentRangeValues.start.ceil().toString()} - ${_currentRangeValues.end.ceil().toString()} Points',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          RangeSlider(
                            values: _currentRangeValues,
                            min: 0,
                            max: 100,
                            activeColor: Colors.blue[200],
                            inactiveColor: Colors.blue[50],
                            labels: RangeLabels(
                              _currentRangeValues.start.round().toString(),
                              _currentRangeValues.end.round().toString(),
                            ),
                            onChanged: (values) {
                              setState(() {
                                _currentRangeValues = values;
                              });
                            },
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
                    RadioListTile(
                        activeColor: Colors.blue,
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: sortList[2],
                        groupValue: selectedSort,
                        title: Text(sortList[2].toString()),
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
                        value: sortList[3],
                        groupValue: selectedSort,
                        title: Text(sortList[3].toString()),
                        onChanged: (value) {
                          setState(() {
                            selectedSort = value;
                          });
                        }),

                    // Add a confirm button to apply the filter
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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    unfinishedCaseList = add_filter(unfinishedCaseList);
    unfinishedCaseList = add_sort(unfinishedCaseList);

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
              child: isLoading == true
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : unfinishedCaseList.isNotEmpty
                      ? ListView.builder(
                          itemCount: unfinishedCaseList.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> data =
                                unfinishedCaseList[index];
                            switch (data['questionnaireType']) {
                              case 'Health':
                                {
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
                                            padding:
                                                EdgeInsets.only(left: w * 0.03),
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
                                                    text: 'นักกีฬา: ',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: data[
                                                                'firstname'] +
                                                            ' ' +
                                                            data['lastname'],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                PaddingDecorate(5),
                                                Text.rich(
                                                  TextSpan(
                                                    text: 'ประเภทแบบสอบถาม: ',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: typeToThai[data[
                                                            'questionnaireType']],
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
                                                        text: data[
                                                            'healthSymptom'],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
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
                                                          data['doDate']
                                                              .toDate(),
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
                                                          data['doDate']
                                                              .toDate(),
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
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                HealthReportCase(
                                                              data: data,
                                                            ),
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
                                                    data['caseFinished'] ==
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
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          IllnessReport(
                                                                    data,
                                                                  ),
                                                                ),
                                                              );
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
                                                  '${data['totalPoint']}',
                                                  style: TextStyle(
                                                      color: score_color(
                                                          data['totalPoint']),
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
                                            padding:
                                                EdgeInsets.only(left: w * 0.03),
                                            width: w * 0.7,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: <Widget>[
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 15),
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    text: 'นักกีฬา: ',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: data[
                                                                'firstname'] +
                                                            ' ' +
                                                            data['lastname'],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                PaddingDecorate(5),
                                                Text.rich(
                                                  TextSpan(
                                                    text: 'ประเภทแบบสอบถาม: ',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: typeToThai[data[
                                                            'questionnaireType']],
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
                                                        text: data['bodyPart'],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
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
                                                          data['doDate']
                                                              .toDate(),
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
                                                          data['doDate']
                                                              .toDate(),
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
                                                        formatDate(
                                                          data['doDate']
                                                              .toDate(),
                                                          'Staff',
                                                        );
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                PhysicalReportCase(
                                                              data: data,
                                                            ),
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
                                                    data['caseFinished'] ==
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
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          InjuryReport(
                                                                    data,
                                                                  ),
                                                                ),
                                                              );
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
                                                  '${data['totalPoint']}',
                                                  style: TextStyle(
                                                      color: score_color(
                                                          data['totalPoint']),
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
                              default:
                                return const SizedBox();
                                break;
                            }
                          })
                      : const Center(
                          child: Text(
                            'Empty received case',
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
      },
    );
  }
}
