import 'dart:async' show Stream, Timer;
import 'package:async/async.dart' show StreamZip;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/graph-page/line_graph.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/physical_complain.dart';
import 'package:seniorapp/decoration/padding.dart';

class AthleteGraph extends StatefulWidget {
  const AthleteGraph({Key key}) : super(key: key);

  @override
  State<AthleteGraph> createState() => _AthleteGraphState();
}

class _AthleteGraphState extends State<AthleteGraph> {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  bool isLoading = true;
  Timer _timer;
  int _selectedWeek = 5;
  final TextEditingController _healthSearch = TextEditingController();

  String bodyChosing;
  String healthChoosing;

  RangeValues _currentRangeValues = const RangeValues(0, 100);
  List<bool> _selectedQuestionnaire = <bool>[true, true];
  final List<bool> isDefault = <bool>[true];

  bool isHealthCheck = false;
  bool isPhysicalCheck = false;

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
        .where('athleteUID', isEqualTo: uid)
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
        .where('athleteUID', isEqualTo: uid)
        .get()
        .then((snapshot) {
      setState(() {
        latestData.add(snapshot.docs.first.data());
      });
    });
  }

  // List<Map<String, dynamic>> findMax(List<Map<String, dynamic>> dataList) {
  //   DateTime currentDate;
  //   int currentWeek;
  //   int nextWeek;
  //   int nextScore;
  //   int maxScore;
  //   List<Map<String, dynamic>> tempList;
  //   for (int i = 0; i < (dataList.length) - 1; i++) {
  //     maxScore = dataList[i]['totalPoint'];
  //     nextScore = dataList[i + 1]['totalPoint'];
  //     currentWeek = AthleteLineGraph.getWeekDay(
  //             AthleteLineGraph.firstJan, dataList[i]['doDate'].toDate())
  //         .toInt();
  //     nextWeek = AthleteLineGraph.getWeekDay(
  //             AthleteLineGraph.firstJan, dataList[i + 1]['doDate'].toDate())
  //         .toInt();
  //     if (currentWeek == nextWeek && maxScore <= nextScore) {
  //       maxScore = nextScore;
  //     } else if (currentWeek != nextWeek) {
  //       dataList.where((element) => element['totalPoint'] == maxScore);
  //       print(
  //           'Data: ${dataList.where((element) => element['totalPoint'] == maxScore && AthleteLineGraph.getWeekDay(AthleteLineGraph.firstJan, dataList[i]['doDate'].toDate()).toInt() == currentWeek)}');
  //     }
  //   }
  //   return tempList;
  // }

  List<Map<String, dynamic>> add_filter(List<Map<String, dynamic>> data) {
    data.sort((a, b) => ('${b['doDate']}').compareTo('${a['doDate']}'));
    data.forEach((element) {
      print(element['doDate'].toDate());
    });
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

    data.removeWhere(
        (element) => element['totalPoint'] < _currentRangeValues.start);
    data.removeWhere(
        (element) => element['totalPoint'] > _currentRangeValues.end);

    return data;
  }

  Stream<List<QuerySnapshot>> getData() {
    Stream healthQuestionnaire = FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('athleteUID', isEqualTo: uid, isNull: false)
        .snapshots();
    Stream physicalQuestionnaire = FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .where('athleteUID', isEqualTo: uid, isNull: false)
        .snapshots();

    return StreamZip([healthQuestionnaire, physicalQuestionnaire]);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getLatestHealthDataWeek();
    getLatestPhysicalDataWeek();
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: w * 0.05, right: w * 0.05),
              width: w * 0.65,
              height: h * 0.052,
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.filter_list,
                  color: Colors.black,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green.shade300,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    side: BorderSide(color: Colors.green[800]),
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
                            content: Column(
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
                                  fillColor: Colors.green[300],
                                  borderColor: Colors.grey,
                                  selectedBorderColor: Colors.green[800],
                                  selectedColor: Colors.white,
                                  color: Colors.green,
                                  constraints: BoxConstraints(
                                    minHeight: h * 0.05,
                                    minWidth: w * 0.3,
                                  ),
                                  children: const [
                                    Text('การบาดเจ็บ'),
                                    Text('การเจ็บป่วย')
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
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                                const Text(
                                  'ช่วงเวลาที่ต้องการแสดงกราฟ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CupertinoSlider(
                                  max: 52,
                                  min: 1,
                                  divisions: 52,
                                  activeColor: Colors.green[300],
                                  value: _selectedWeek.toDouble(),
                                  onChanged: (values) {
                                    setState(() {
                                      _selectedWeek = values.floor();
                                      // print(_selectedWeek.toString());
                                      isDefault[0] = false;
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
                                  activeColor: Colors.green[300],
                                  inactiveColor: Colors.green[100],
                                  labels: RangeLabels(
                                    _currentRangeValues.start
                                        .round()
                                        .toString(),
                                    _currentRangeValues.end.round().toString(),
                                  ),
                                  onChanged: (RangeValues values) {
                                    setState(() {
                                      _currentRangeValues = values;
                                      isDefault[0] = false;
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
                                CheckboxListTile(
                                  value: isHealthCheck,
                                  onChanged: (value) {
                                    setState(() {
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
                                      isPhysicalCheck = value;
                                    });
                                  },
                                  title: const Text('ระบุอาการบาดเจ็บ'),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                                DropdownButtonFormField2(
                                  
                                  isExpanded: true,
                                  selectedItemHighlightColor: Colors.grey[300],
                                  value: bodyChosing,
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
                              ],
                            ),
                            actions: [
                              SizedBox(
                                width: w,
                                child: RaisedButton(
                                  color: Colors.green[300],
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
                      });
                },
              ),
            ),
            ToggleButtons(
              children: const [Text('ค่าเริ่มต้น')],
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
                    _selectedQuestionnaire = <bool>[true, true];
                    _currentRangeValues = const RangeValues(0, 100);
                    _selectedWeek = 5;
                  }
                });
              },
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
