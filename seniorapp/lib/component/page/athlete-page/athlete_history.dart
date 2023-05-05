import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_page_choosing.dart';
import 'package:seniorapp/component/page/athlete-page/history-details/health_report_detail.dart';
import 'package:seniorapp/component/page/athlete-page/history-details/physical_report_detail.dart';
import 'package:seniorapp/component/result-data/health_result_data.dart';
import 'package:seniorapp/component/result-data/physical_result_data.dart';
import 'package:seniorapp/decoration/format_datetime.dart';

import 'dart:async' show Timer;
import 'package:seniorapp/decoration/padding.dart';
import 'package:seniorapp/decoration/textfield_normal.dart';

class AthleteHistory extends StatefulWidget {
  const AthleteHistory({Key key}) : super(key: key);

  @override
  _AthleteHistoryState createState() => _AthleteHistoryState();
}

class _AthleteHistoryState extends State<AthleteHistory> {
  bool isDefault = true;
  RangeValues _currentRangeValues = const RangeValues(0, 100);
  Timer _timer;
  bool isLoading = false;
  bool isFilter = false;

  String problemSearchText = '';
  List<String> specificProblemList = [];
  String specificProblem = 'ดูทั้งหมด';
  TextEditingController textController = TextEditingController();
  List<String> sortList = [
    'วันที่ล่าสุด',
    'วันที่ก่อนหน้า',
    'คะแนนน้อยสุด -> คะแนนมากสุด',
    'คะแนนมากสุด -> คะแนนน้อยสุด'
  ];

  bool isPhysicalButtonActive = false;
  bool isHealthButtonActive = false;
  String selectedSort = 'วันที่ล่าสุด';

  List<Map<String, dynamic>> historyList = [];

  void choose_filter() {
    setState(() {});
  }

  addData() {
    List<Map<String, dynamic>> combinedList =
        physicalHistoryList + healthHistoryList;
    print('Combined List Case: ${combinedList.length}');

    historyList = combinedList;
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
    if (specificProblem != 'ดูทั้งหมด') {
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
                          result = 'ดูทั้งหมด';
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
                      'ปัญหาทั้งหมด',
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
                        'รีเซ็ต',
                        style: TextStyle(
                          color: Colors.green,
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
                    placeholder: 'ระบุปัญหา',
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
                          activeColor: Colors.green[300],
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
                          'ตัวกรอง',
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
                              specificProblem = 'ดูทั้งหมด';
                            });
                          },
                          child: const Text(
                            'รีเซ็ต',
                            style: TextStyle(
                              color: Colors.green,
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
                                'ประเภทปัญหา',
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
                                      side:
                                          BorderSide(color: Colors.green[300]),
                                      onPrimary: isPhysicalButtonActive == false
                                          ? Colors.green
                                          : Colors.white,
                                      primary: isPhysicalButtonActive == true
                                          ? Colors.green[300]
                                          : Colors.white,
                                    ),
                                    child: const Text('อาการบาดเจ็บ'),
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
                                      side:
                                          BorderSide(color: Colors.green[300]),
                                      onPrimary: isHealthButtonActive == false
                                          ? Colors.green
                                          : Colors.white,
                                      primary: isHealthButtonActive == true
                                          ? Colors.green[300]
                                          : Colors.white,
                                    ),
                                    child: const Text('อาการเจ็บป่วย'),
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
                                'ระบุปัญหา',
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
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.green,
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
                                'ช่วงคะแนน',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${_currentRangeValues.start.ceil().toString()} - ${_currentRangeValues.end.ceil().toString()} คะแนน',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
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
                            activeColor: Colors.green[300],
                            inactiveColor: Colors.green[50],
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
                      'ใช้งาน',
                      style: TextStyle(
                        color: Colors.lightGreen[50],
                        fontSize: bodyHeight * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(w, bodyHeight * 0.05),
                      elevation: 0,
                      primary: Colors.green[400],
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
                      'จัดเรียงโดย',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RadioListTile(
                        activeColor: Colors.green,
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
                        activeColor: Colors.green,
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
                        activeColor: Colors.green,
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
                        activeColor: Colors.green,
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
                      'ใช้งาน',
                      style: TextStyle(
                        color: Colors.lightGreen[50],
                        fontSize: h * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(w, h * 0.05),
                      elevation: 0,
                      primary: Colors.green[400],
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

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    historyList = add_filter(historyList);
    historyList = add_sort(historyList);

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
                      primary: Colors.green[300],
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    label: Text(
                      'ตัวกรอง',
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
                      primary: Colors.green[300],
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    label: Text(
                      'จัดเรียงโดย',
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
            child: SizedBox(
              height: h,
              width: w,
              child: isLoading
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : historyList.isNotEmpty
                      ? ListView.builder(
                          itemCount: historyList.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> data = historyList[index];

                            return GestureDetector(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(
                                      width: 2, color: Colors.green[200]),
                                ),
                                elevation: 0,
                                child: Container(
                                  height: h * 0.2,
                                  padding: EdgeInsets.only(
                                    left: w * 0.05,
                                  ),
                                  child: data['questionnaireType'] == 'Health'
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
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: <Widget>[
                                                  Text.rich(
                                                    TextSpan(
                                                      text: 'ประเภทแบบสอบถาม: ',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: toThaiType(data[
                                                              'questionnaireType']),
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text.rich(
                                                    TextSpan(
                                                      text: 'ปัญหาสุขภาพ: ',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: toThaiNoneInfo(
                                                            data[
                                                                'healthSymptom'],
                                                          ),
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
                                                              '${formatTime(data['doDate'].toDate(), 'Athlete')} น.',
                                                          style: const TextStyle(
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
                                            SizedBox(
                                              width: w * 0.2,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${data['totalPoint']}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: score_color(
                                                            data['totalPoint']),
                                                        fontSize: h * 0.05),
                                                  ),
                                                  const Text(
                                                    'คะแนน',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
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
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: <Widget>[
                                                  Text.rich(
                                                    TextSpan(
                                                      text: 'ประเภทแบบสอบถาม: ',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: toThaiType(data[
                                                              'questionnaireType']),
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text.rich(
                                                    TextSpan(
                                                      text: 'ส่วนที่บาดเจ็บ: ',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: toThaiNoneInfo(
                                                              data['bodyPart']),
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
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
                                                              '${formatTime(data['doDate'].toDate(), 'Athlete')} น.',
                                                          style: const TextStyle(
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
                                            SizedBox(
                                              width: w * 0.2,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${data['totalPoint']}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: score_color(
                                                            data['totalPoint']),
                                                        fontSize: h * 0.05),
                                                  ),
                                                  const Text(
                                                    'คะแนน',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
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
                                          healthSymptom: health.healthSymptom,
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
                                        PhysicalResultData.fromMap(data);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PhysicalReportDetail(
                                          answerList: physical.answerList,
                                          athleteNo: physical.athleteNo,
                                          doDate: physical.doDate,
                                          bodyPart: physical.bodyPart,
                                          questionnaireType:
                                              physical.questionnaireType,
                                          questionnaireNo:
                                              physical.questionnaireNo,
                                          totalPoint: physical.totalPoint,
                                        ),
                                      ),
                                    );
                                    break;
                                  default:
                                }
                              },
                            );
                          },
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
      );
    });
  }
}
