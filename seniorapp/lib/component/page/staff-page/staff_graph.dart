import 'dart:async' show Timer;
import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/staff-page/graph-page/column-widget/fixed_column_widget.dart';
import 'package:seniorapp/component/page/staff-page/graph-page/column-widget/scrollable_column_widget.dart';
import 'package:seniorapp/component/page/staff-page/graph-page/find_athlete_graph.dart';
import 'package:seniorapp/component/page/staff-page/graph-page/staff_summary_table_graph.dart';
import 'package:seniorapp/component/page/staff-page/staff_page_choosing.dart';
import 'package:seniorapp/decoration/format_datetime.dart';
import 'package:seniorapp/decoration/padding.dart';

class StaffGraph extends StatefulWidget {
  const StaffGraph({Key key}) : super(key: key);

  @override
  _StaffGraphState createState() => _StaffGraphState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _StaffGraphState extends State<StaffGraph> {
  bool isLoading = true;
  Timer _timer;
  DateTime now = DateTime.now();
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now().add(const Duration(days: -6)),
    end: DateTime.now(),
  );
  TextEditingController textController = TextEditingController();
  String problemSearchText = '';

  bool inDateFormat = false;

  String bodyChoosing;
  String bodyPartChoosing;
  String healthChoosing;

  RangeValues _currentRangeValues = const RangeValues(0, 100);

  List<String> specificProblemList = [];

  bool isDefault = true;

  bool isPhysicalButtonActive = false;
  bool isHealthButtonActive = false;
  bool isSpecificSelect = false;
  String specificProblem = 'View all';

  List<Map<String, dynamic>> allCaseList = [];

  void choose_filter() {
    setState(() {});
  }

  Future pickDateRange() async {
    DateTimeRange newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 1),
    );

    setState(() {
      dateRange = newDateRange;
    });
  }

  addData() {
    List<Map<String, dynamic>> combinedList = healthCaseList + physicalCaseList;
    //print('Combined List Case: ${combinedList.length}');

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

    allCaseList = resultAsList;
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

    data.retainWhere((element) =>
        element['doDate']
            .toDate()
            .isBefore(dateRange.end.add(const Duration(days: 1))) &&
        element['doDate'].toDate().isAfter(dateRange.start));

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
                              isHealthButtonActive = false;
                              isPhysicalButtonActive = false;
                              specificProblem = 'View all';
                              dateRange = DateTimeRange(
                                  start: DateTime.now()
                                      .add(const Duration(days: -6)),
                                  end: DateTime.now());
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Range of date',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  DateTimeRange newDateRange =
                                      await showDateRangePicker(
                                    context: context,
                                    initialDateRange: dateRange,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(now.year + 1),
                                  );
                                  if (newDateRange == null) {
                                    return;
                                  }
                                  setState(() {
                                    dateRange = newDateRange;
                                    isDefault = false;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      '${formatDate(dateRange.start, 'StaffShort')} - ${formatDate(dateRange.end, 'StaffShort')}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    allCaseList = add_filter(allCaseList);
    List<Map<String, dynamic>> healthDataList = [];
    List<Map<String, dynamic>> physicalDataList = [];

    allCaseList.forEach((element) {
      if (element['questionnaireType'] == 'Health') {
        healthDataList.add(element);
      } else if (element['questionnaireType'] == 'Physical') {
        physicalDataList.add(element);
      }
    });

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
                // Expanded(
                //   child: ElevatedButton.icon(
                //     icon: const Icon(
                //       FontAwesomeIcons.sort,
                //       size: 20,
                //       color: Colors.black,
                //     ),
                //     style: ElevatedButton.styleFrom(
                //       primary: Colors.blue[200],
                //       elevation: 0,
                //       shape: const RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(
                //           Radius.circular(8),
                //         ),
                //       ),
                //     ),
                //     label: Text(
                //       'Sort by',
                //       style: TextStyle(
                //         fontSize: h * 0.02,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.black,
                //       ),
                //     ),
                //     onPressed: _showSortPage,
                //   ),
                // ),
              ],
            ),
          ),
          PaddingDecorate(5),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CupertinoActivityIndicator(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Summary Data Between \n${formatDate(dateRange.start, 'StaffShort')} - ${formatDate(dateRange.end, 'StaffShort')}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: h * 0.03,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      StaffSummaryTableGraph(
                        healthResultDataList: healthDataList,
                        physicalResultDataList: physicalDataList,
                      ),
                      CupertinoButton(
                        alignment: Alignment.centerRight,
                        child: const Text(
                          'View Specific Athlete Graph',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const FindAthleteGraph(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Row(
                            children: [
                              FixedColumnTable(
                                resultDataList: allCaseList,
                              ),
                              ScrollableColumnTable(
                                resultDataList: allCaseList,
                                athleteList: allCaseList,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      );
    });
  }
}
