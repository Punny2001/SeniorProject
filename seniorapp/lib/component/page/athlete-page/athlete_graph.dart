import 'dart:async' show Timer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_page_choosing.dart';
import 'package:seniorapp/component/page/athlete-page/graph-page/line_graph.dart';
import 'package:seniorapp/decoration/padding.dart';

class AthleteGraph extends StatefulWidget {
  const AthleteGraph({Key key, this.uid, this.isStaff}) : super(key: key);

  final String uid;
  final bool isStaff;

  @override
  State<AthleteGraph> createState() => _AthleteGraphState();
}

class _AthleteGraphState extends State<AthleteGraph> {
  bool isLoading = true;
  Timer _timer;
  int _selectedWeek = 5;
  TextEditingController textController = TextEditingController();

  bool inDateFormat = false;
  FixedExtentScrollController scrollController;
  int selectedYearIndex;
  int selectYear = DateTime.now().year;

  String problemSearchText = '';
  List<String> specificProblemList = [];
  String specificProblem = 'ดูทั้งหมด';
  bool isPhysicalButtonActive = true;
  bool isHealthButtonActive = false;

  RangeValues _currentRangeValues = const RangeValues(0, 100);
  bool isDefault = true;

  List<Map<String, dynamic>> historyList = [];
  List<Map<String, dynamic>> healthGraphList = [];
  List<Map<String, dynamic>> physicalGraphList = [];

  List<int> year = [];

  void choose_filter() {
    setState(() {});
  }

  List<Map<String, dynamic>> add_filter(List<Map<String, dynamic>> data) {
    data.removeWhere((element) =>
        element['doDate'].toDate().year != year[selectedYearIndex]);

    data.sort((a, b) => ('${b['doDate']}').compareTo('${a['doDate']}'));

    if (isPhysicalButtonActive == true && isHealthButtonActive == false) {
      data.removeWhere((element) => element['questionnaireType'] == 'Health');
    }
    if (isHealthButtonActive == true && isPhysicalButtonActive == false) {
      data.removeWhere((element) => element['questionnaireType'] == 'Physical');
    }

    data.removeWhere(
        (element) => element['totalPoint'] < _currentRangeValues.start);
    data.removeWhere(
        (element) => element['totalPoint'] > _currentRangeValues.end);

    return data;
  }

  Color getColors(int shade) {
    Color colors;
    if (widget.isStaff == true) {
      colors = Colors.blue[shade];
    } else {
      colors = Colors.green[shade];
    }
    return colors;
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

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
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
                              isPhysicalButtonActive = true;
                              specificProblem = 'ดูทั้งหมด';
                              _currentRangeValues = const RangeValues(0, 100);
                              _selectedWeek = 5;
                              selectedYearIndex = year.length - 1;
                              selectYear = DateTime.now().year;
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'ช่วงเวลาที่ต้องการแสดงกราฟ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  CupertinoButton(
                                    child: Text(
                                      'ปี $selectYear',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: widget.isStaff
                                            ? Colors.blue[200]
                                            : Colors.green[300],
                                      ),
                                    ),
                                    onPressed: () {
                                      scrollController.dispose();
                                      scrollController =
                                          FixedExtentScrollController(
                                              initialItem: selectedYearIndex);
                                      _showDialog(
                                        CupertinoPicker(
                                          itemExtent: 32,
                                          scrollController: scrollController,
                                          onSelectedItemChanged: (int index) {
                                            setState(() {
                                              selectedYearIndex = index;
                                              selectYear =
                                                  year[selectedYearIndex];
                                            });
                                          },
                                          useMagnifier: true,
                                          children: List<Widget>.generate(
                                              year.length, (index) {
                                            return Center(
                                              child: Text('${year[index]}'),
                                            );
                                          }),
                                        ),
                                      );
                                    },
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.green,
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            width: w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CupertinoSlider(
                                  max: 52,
                                  min: 1,
                                  divisions: 52,
                                  activeColor: widget.isStaff
                                      ? getColors(200)
                                      : getColors(300),
                                  value: _selectedWeek.toDouble(),
                                  onChanged: (values) {
                                    setState(() {
                                      _selectedWeek = values.floor();
                                      // print(_selectedWeek.toString());
                                      isDefault = false;
                                    });
                                  },
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${_selectedWeek.toString()} ',
                                      ),
                                      const TextSpan(text: 'สัปดาห์ '),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                ),
                // Add a confirm button to apply the filter
                Container(
                  padding: EdgeInsets.only(
                    left: w * 0.05,
                    right: w * 0.05,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      physicalGraphList = [];
                      healthGraphList = [];
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

  void addData() {
    List<Map<String, dynamic>> combinedList =
        physicalHistoryList + healthHistoryList;
    historyList = combinedList;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    isProblemChooseList = List.filled(49, false);
    addData();
    for (int i = 1900; i <= DateTime.now().year; i++) {
      year.add(i);
    }
    selectedYearIndex = year.length - 1;
    scrollController =
        FixedExtentScrollController(initialItem: selectedYearIndex);

    _timer = Timer(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    historyList = add_filter(historyList);
    historyList.forEach((element) {
      if (element['questionnaireType'] == 'Physical') {
        physicalGraphList.add(element);
      } else if (element['questionnaireType'] == 'Health') {
        healthGraphList.add(element);
      }
    });

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
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
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  physicalGraphList = [];
                  healthGraphList = [];
                  addData();
                  setState(() {
                    isPhysicalButtonActive = true;
                    isHealthButtonActive = false;
                  });
                },
                icon: const Icon(
                  Icons.circle,
                  color: Colors.blue,
                ),
                label: const Text(
                  'อาการบาดเจ็บ',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  physicalGraphList = [];
                  healthGraphList = [];
                  addData();
                  setState(() {
                    isPhysicalButtonActive = false;
                    isHealthButtonActive = true;
                  });
                },
                icon: const Icon(
                  Icons.circle,
                  color: Colors.purple,
                ),
                label: const Text(
                  'อาการเจ็บป่วย',
                  style: TextStyle(
                    color: Colors.purple,
                  ),
                ),
              ),
            ],
          ),
          isLoading
              ? const Expanded(
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                )
              : AthleteLineGraph(
                  healthResultDataList: healthGraphList,
                  physicalResultDataList: physicalGraphList,
                  selectedWeek: _selectedWeek,
                ),
        ],
      );
    });
  }
}
