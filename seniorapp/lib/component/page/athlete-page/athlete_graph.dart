import 'dart:async' show Stream, Timer;
import 'package:age_calculator/age_calculator.dart';
import 'package:async/async.dart' show StreamZip;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
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
  final TextEditingController _healthSearch = TextEditingController();
  final TextEditingController _bodySearch = TextEditingController();
  final TextEditingController _bodyPartSearch = TextEditingController();

  bool inDateFormat = false;
  FixedExtentScrollController scrollController;
  int selectedYearIndex;
  int selectYear = DateTime.now().year;

  String bodyChoosing;
  String bodyPartChoosing;
  String healthChoosing;

  RangeValues _currentRangeValues = const RangeValues(0, 100);
  List<bool> _selectedQuestionnaire = <bool>[true, true];
  bool isDefault = true;

  bool isHealthCheck = false;
  bool isPhysicalCheck = false;
  bool isBodySelected = false;

  List<int> year = [];

  List<Map<String, dynamic>> latestData = [];

  List<String> healthSymptom = [
    'คลื่นไส้ ',
    'ชา',
    'ต่อมอักเสบ',
    'ท้องผูก',
    'ท้องเสีย',
    'น้ำมูก จาม ขัดจมูก',
    'ปวดกล้ามเนื้อส่วนท้อง',
    'ปวดบริเวณอื่น',
    'ปวดหัว',
    'ผื่นคัน',
    'มีอาการที่ตา',
    'มีอาการที่หู ',
    'อ่อนล้า',
    'อาเจียน',
    'อาการที่ทางเดินปัสสาวะและอวัยวะเพศ',
    'หงุดหงิดง่าย',
    'หดหู่ เศร้า',
    'หายใจลำบาก',
    'หัวใจเต้นผิดจังหวะ',
    'เครียด',
    'เจ็บคอ',
    'เจ็บหน้าอก',
    'เป็นลม',
    'ไข้ ',
    'ไอ',
  ];

  var physicalList = {
    'ร่างกายส่วนหัวถึงลำตัว': [
      'ใบหน้า',
      'ศีรษะ',
      'คอ / กระดูกสันหลังส่วนคอ',
      'กระดูกสันหลังทรวงอก / หลังส่วนบน',
      'กระดูกอก / ซี่โครง',
      'กระดูกสันหลังส่วนเอว / หลังส่วนล่าง',
      'หน้าท้อง',
      'กระดูกเชิงกราน / กระดูกสันหลังส่วนกระเบ็นเหน็บ / ก้น',
    ],
    'ร่างกายส่วนแขนถึงนิ้วมือ': [
      'ไหล่ / กระดูกไหปลาร้า',
      'ต้นแขน',
      'ข้อศอก',
      'ปลายแขน',
      'ข้อมือ',
      'มือ',
      'นิ้ว',
      'นิ้วหัวแม่มือ',
    ],
    'ร่างกายส่วนสะโพกถึงนิ้วเท้า': [
      'สะโพก',
      'ขาหนีบ',
      'ต้นขา',
      'เข่า',
      'ขาส่วนล่าง',
      'เอ็นร้อยหวาย',
      'ข้อเท้า',
      'เท้า / นิ้วเท้า',
    ]
  };

  void choose_filter() {
    setState(() {});
  }

  getLatestHealthDataWeek() {
    FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('athleteUID', isEqualTo: widget.uid)
        .get()
        .then((snapshot) {
      setState(() {
        latestData.add(snapshot.docs.last.data());
      });
    });
  }

  getLatestPhysicalDataWeek() {
    FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .where('athleteUID', isEqualTo: widget.uid)
        .get()
        .then((snapshot) {
      setState(() {
        latestData.add(snapshot.docs.first.data());
      });
    });
  }

  List<Map<String, dynamic>> add_filter(List<Map<String, dynamic>> data) {
    data.retainWhere((element) =>
        element['doDate'].toDate().year == year[selectedYearIndex]);
    data.sort((a, b) => ('${b['doDate']}').compareTo('${a['doDate']}'));

    if (_selectedQuestionnaire[0] == false) {
      data.removeWhere((element) => element['questionnaireType'] == 'Physical');
    }
    if (_selectedQuestionnaire[1] == false) {
      data.removeWhere((element) => element['questionnaireType'] == 'Health');
    }

    if (isHealthCheck == true) {
      data.removeWhere((element) =>
          element['questionnaireType'] == 'Health' &&
          element['healthSymptom'] != healthChoosing);
    }

    if (isPhysicalCheck == true) {
      data.removeWhere((element) =>
          element['questionnaireType'] == 'Physical' &&
          element['bodyPart'] != bodyPartChoosing);
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
        .where('athleteUID', isEqualTo: widget.uid, isNull: false)
        .snapshots();
    Stream physicalQuestionnaire = FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .where('athleteUID', isEqualTo: widget.uid, isNull: false)
        .snapshots();

    return StreamZip([healthQuestionnaire, physicalQuestionnaire]);
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

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getLatestHealthDataWeek();
    getLatestPhysicalDataWeek();
    for (int i = 1900; i <= DateTime.now().year; i++) {
      year.add(i);
    }
    selectedYearIndex = year.length - 1;
    scrollController =
        FixedExtentScrollController(initialItem: selectedYearIndex);
    latestData.sort((a, b) =>
        ('${a['doDate'].toDate()}').compareTo('${b['doDate'].toDate()}'));

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

    return Column(
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
                  primary: widget.isStaff ? getColors(200) : getColors(300),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    side: BorderSide(
                      color: widget.isStaff ? getColors(700) : getColors(800),
                    ),
                  ),
                ),
                label: Text(
                  'ตัวกรอง',
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
                          title: const Text('ตัวกรอง'),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'ประเภทของแบบสอบถาม',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                  fillColor: widget.isStaff
                                      ? getColors(200)
                                      : getColors(300),
                                  borderColor: Colors.grey,
                                  selectedBorderColor: widget.isStaff
                                      ? getColors(700)
                                      : getColors(800),
                                  selectedColor: Colors.white,
                                  color: Colors.green,
                                  constraints: BoxConstraints(
                                    minHeight: h * 0.05,
                                    minWidth: w * 0.3,
                                  ),
                                  children: const [
                                    Text('อาการบาดเจ็บ'),
                                    Text('อาการเจ็บป่วย')
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
                                const Text(
                                  'ช่วงเวลาที่ต้องการแสดงกราฟ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CupertinoButton(
                                      child: Text(
                                        'ปี $selectYear',
                                        style: TextStyle(
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
                                              });
                                              selectYear =
                                                  year[selectedYearIndex];
                                              if (selectYear !=
                                                  DateTime.now().year) {
                                                isDefault = false;
                                              } else if (selectYear ==
                                                  DateTime.now().year) {
                                                isDefault = true;
                                              }
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
                                  ],
                                ),
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
                                PaddingDecorate(10),
                                const Text(
                                  'ช่วงคะแนน',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                RangeSlider(
                                  values: _currentRangeValues,
                                  min: 0,
                                  max: 100,
                                  divisions: 5,
                                  activeColor: widget.isStaff
                                      ? getColors(200)
                                      : getColors(300),
                                  inactiveColor: widget.isStaff
                                      ? getColors(50)
                                      : getColors(100),
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_currentRangeValues.start
                                        .toInt()
                                        .toString()),
                                    Text(_currentRangeValues.end
                                        .toInt()
                                        .toString()),
                                  ],
                                ),
                                PaddingDecorate(10),
                                Text(
                                  'เลือกปัญหาเฉพาะ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CheckboxListTile(
                                  value: isHealthCheck,
                                  onChanged: (value) {
                                    setState(() {
                                      if (isHealthCheck == true) {
                                        healthChoosing = null;
                                      }
                                      isHealthCheck = value;
                                    });
                                  },
                                  title: const Text('ระบุปัญหาสุขภาพ'),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                                DropdownButtonFormField2(
                                  isExpanded: true,
                                  selectedItemHighlightColor: Colors.grey[300],
                                  value: healthChoosing,
                                  items: healthSymptom
                                      .map(
                                        (health) => DropdownMenuItem(
                                          child: Text(
                                            health,
                                          ),
                                          value: health,
                                        ),
                                      )
                                      .toList(),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: isHealthCheck == true
                                        ? Colors.white
                                        : Colors.grey[350],
                                    hintText: 'โปรดเลือกปัญหาสุขภาพ',
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blueGrey[100],
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blueGrey[100],
                                      ),
                                    ),
                                  ),
                                  onChanged: isHealthCheck == true
                                      ? (value) {
                                          healthChoosing = value;
                                        }
                                      : null,
                                  searchController: _healthSearch,
                                  searchInnerWidget: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      bottom: 10,
                                      top: 10,
                                    ),
                                    child: TextFormField(
                                      controller: _healthSearch,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () =>
                                              _healthSearch.clear(),
                                          icon: const Icon(Icons.close),
                                        ),
                                        hintText: 'ค้นหา ...',
                                      ),
                                    ),
                                  ),
                                  searchMatchFn: (item, searchValue) {
                                    return (item.value.toString().contains(
                                          searchValue,
                                        ));
                                  },
                                ),
                                CheckboxListTile(
                                  value: isPhysicalCheck,
                                  onChanged: (value) {
                                    setState(() {
                                      if (isPhysicalCheck == true) {
                                        bodyChoosing = null;
                                        bodyPartChoosing = null;
                                        isBodySelected = false;
                                      }
                                      isPhysicalCheck = value;
                                    });
                                  },
                                  title: const Text('ระบุอาการบาดเจ็บ'),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                                DropdownButtonFormField2(
                                  dropdownPadding:
                                      EdgeInsets.only(bottom: h * 0.5),
                                  isExpanded: true,
                                  selectedItemHighlightColor: widget.isStaff
                                      ? getColors(200)
                                      : getColors(300),
                                  value: bodyChoosing,
                                  items: physicalList.keys
                                      .map(
                                        (body) => DropdownMenuItem(
                                          child: Text(
                                            body,
                                          ),
                                          value: body,
                                        ),
                                      )
                                      .toList(),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: isPhysicalCheck == true
                                        ? Colors.white
                                        : Colors.grey[350],
                                    hintText: 'โปรดเลือกอวัยวะ',
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blueGrey[100],
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blueGrey[100],
                                      ),
                                    ),
                                  ),
                                  onChanged: isPhysicalCheck == true
                                      ? (value) {
                                          setState(() {
                                            bodyChoosing = value;
                                            isBodySelected = true;
                                            bodyPartChoosing = null;
                                          });
                                        }
                                      : null,
                                  searchController: _bodySearch,
                                  searchInnerWidget: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      bottom: 10,
                                      top: 10,
                                    ),
                                    child: TextFormField(
                                      controller: _bodySearch,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () => _bodySearch.clear(),
                                          icon: const Icon(Icons.close),
                                        ),
                                        hintText: 'ค้นหา ...',
                                      ),
                                    ),
                                  ),
                                  searchMatchFn: (item, searchValue) {
                                    return (item.value.toString().contains(
                                          searchValue,
                                        ));
                                  },
                                ),
                                PaddingDecorate(10),
                                Visibility(
                                  visible: isBodySelected,
                                  child: DropdownButtonFormField2(
                                    dropdownPadding:
                                        EdgeInsets.only(bottom: h * 0.5),
                                    isExpanded: true,
                                    selectedItemHighlightColor:
                                        Colors.grey[300],
                                    value: bodyPartChoosing,
                                    items: isBodySelected == true
                                        ? physicalList[bodyChoosing]
                                            .map(
                                              (body) => DropdownMenuItem(
                                                child: Text(
                                                  body,
                                                ),
                                                value: body,
                                              ),
                                            )
                                            .toList()
                                        : null,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'โปรดเลือกส่วนของอวัยวะ',
                                      focusedErrorBorder:
                                          const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                      errorBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blueGrey[100],
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blueGrey[100],
                                        ),
                                      ),
                                    ),
                                    onChanged: isBodySelected == true
                                        ? (value) {
                                            setState(() {
                                              bodyPartChoosing = value;
                                            });
                                          }
                                        : null,
                                    searchController: _bodyPartSearch,
                                    searchInnerWidget: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        bottom: 10,
                                        top: 10,
                                      ),
                                      child: TextFormField(
                                        controller: _bodyPartSearch,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () =>
                                                _bodyPartSearch.clear(),
                                            icon: const Icon(Icons.close),
                                          ),
                                          hintText: 'ค้นหา ...',
                                        ),
                                      ),
                                    ),
                                    searchMatchFn: (item, searchValue) {
                                      return (item.value.toString().contains(
                                            searchValue,
                                          ));
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          actions: [
                            SizedBox(
                              width: w,
                              child: RaisedButton(
                                color: widget.isStaff
                                    ? getColors(200)
                                    : getColors(300),
                                child: const Text(
                                  'ใช้งาน',
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
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                const Text(
                  'ค่าเริ่มต้น',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CupertinoSwitch(
                  value: isDefault,
                  activeColor: widget.isStaff ? getColors(200) : getColors(300),
                  onChanged: (bool value) {
                    setState(() {
                      if (isDefault == false) {
                        _selectedQuestionnaire = <bool>[true, true];
                        _currentRangeValues = const RangeValues(0, 100);
                        _selectedWeek = 5;
                        isHealthCheck = false;
                        isPhysicalCheck = false;
                        isDefault = false;
                        selectedYearIndex = year.length - 1;
                        selectYear = DateTime.now().year;
                      }
                      isDefault = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedQuestionnaire = [true, false];
                  isDefault = false;
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
                setState(() {
                  _selectedQuestionnaire = [false, true];
                  isDefault = false;
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
            : StreamBuilder(
                stream: getData(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    List<QuerySnapshot> querySnapshot = snapshot.data.toList();

                    List<QueryDocumentSnapshot> documentSnapshot = [];
                    querySnapshot.forEach((query) {
                      documentSnapshot.addAll(query.docs);
                    });

                    List<Map<String, dynamic>> mappedData = [];
                    for (QueryDocumentSnapshot doc in documentSnapshot) {
                      mappedData.add(doc.data());
                    }

                    mappedData = add_filter(mappedData);

                    List<Map<String, dynamic>> healthDataList = [];
                    List<Map<String, dynamic>> physicalDataList = [];

                    mappedData.forEach((element) {
                      if (element['questionnaireType'] == 'Health') {
                        healthDataList.add(element);
                      } else if (element['questionnaireType'] == 'Physical') {
                        physicalDataList.add(element);
                      }
                    });

                    return AthleteLineGraph(
                      healthResultDataList: healthDataList,
                      physicalResultDataList: physicalDataList,
                      selectedWeek: _selectedWeek,
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
      ],
    );
  }
}
