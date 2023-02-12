import 'dart:async' show Stream, Timer;
import 'package:async/async.dart' show StreamZip;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/staff-page/graph-page/column-widget/fixed_column_widget.dart';
import 'package:seniorapp/component/page/staff-page/graph-page/column-widget/scrollable_column_widget.dart';
import 'package:seniorapp/component/page/staff-page/graph-page/staff_summary_table_graph.dart';
import 'package:seniorapp/decoration/format_datetime.dart';
import 'package:seniorapp/decoration/padding.dart';

class StaffGraph extends StatefulWidget {
  const StaffGraph({Key key}) : super(key: key);

  @override
  _StaffGraphState createState() => _StaffGraphState();
}

class _StaffGraphState extends State<StaffGraph> {
  bool isLoading = true;
  List<Map<String, dynamic>> latestData = [];
  Timer _timer;
  DateTime now = DateTime.now();
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now().add(const Duration(days: -7)),
    end: DateTime.now(),
  );

  final TextEditingController _healthSearch = TextEditingController();
  final TextEditingController _bodySearch = TextEditingController();
  final TextEditingController _bodyPartSearch = TextEditingController();

  bool inDateFormat = false;

  String bodyChoosing;
  String bodyPartChoosing;
  String healthChoosing;

  RangeValues _currentRangeValues = const RangeValues(0, 100);
  List<bool> _selectedQuestionnaire = <bool>[true, true];
  bool isDefault = true;

  bool isHealthCheck = false;
  bool isPhysicalCheck = false;
  bool isBodySelected = false;

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

  List<Map<String, dynamic>> athleteData = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  getAthleteData() {
    firestore.collection('Athlete').get().then((document) {
      int index = 0;
      document.docs.forEach((snapshot) {
        athleteData.add(snapshot.data());
        athleteData[index]['athleteUID'] = snapshot.reference.id;
        index += 1;
      });
    });
  }

  void choose_filter() {
    setState(() {});
  }

  getLatestHealthDataWeek() {
    FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
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
        .get()
        .then((snapshot) {
      setState(() {
        latestData.add(snapshot.docs.first.data());
      });
    });
  }

  List<Map<String, dynamic>> add_filter(List<Map<String, dynamic>> data) {
    data.retainWhere((element) =>
        element['doDate']
            .toDate()
            .isBefore(dateRange.end.add(const Duration(days: 1))) &&
        element['doDate'].toDate().isAfter(dateRange.start));
    data.sort((a, b) => ('${b['doDate']}').compareTo('${a['doDate']}'));

    if (_selectedQuestionnaire[0] == false) {
      data.removeWhere((element) => element['questionnaireType'] == 'Physical');
    }
    if (_selectedQuestionnaire[1] == false) {
      data.removeWhere((element) => element['questionnaireType'] == 'Health');
    }

    if (isHealthCheck == true) {
      data.removeWhere((element) => element['healthSymptom'] != healthChoosing);
    }

    if (isPhysicalCheck == true) {
      data.removeWhere((element) => element['bodyPart'] != bodyPartChoosing);
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
        .snapshots();
    Stream physicalQuestionnaire = FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .snapshots();

    return StreamZip([healthQuestionnaire, physicalQuestionnaire]);
  }

  Future pickDateRange() async {
    DateTimeRange newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 1),
    );
    // if (newDateRange == null) return;
    setState(() {
      dateRange = newDateRange;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getAthleteData();
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
    final pixRatio = MediaQuery.of(context).devicePixelRatio;

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
                  primary: Colors.blue[200],
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
                                    fillColor: Colors.blue[200],
                                    borderColor: Colors.grey,
                                    selectedBorderColor: Colors.blue[700],
                                    selectedColor: Colors.white,
                                    color: Colors.blue,
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
                                  ElevatedButton(
                                    onPressed: () async {
                                      DateTimeRange newDateRange =
                                          await showDateRangePicker(
                                        context: context,
                                        initialDateRange: dateRange,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(now.year + 1),
                                      );
                                      setState(() {
                                        dateRange = newDateRange;
                                        isDefault = false;
                                      });
                                    },
                                    child: Text(
                                        '${formatDate(dateRange.start, 'StaffShort')} - ${formatDate(dateRange.end, 'StaffShort')}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: Colors.blue[200],
                                      side: BorderSide(
                                        width: 1,
                                        color: Colors.blue[700],
                                      ),
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
                                    activeColor: Colors.blue[200],
                                    inactiveColor: Colors.grey[200],
                                    labels: RangeLabels(
                                      _currentRangeValues.start
                                          .round()
                                          .toString(),
                                      _currentRangeValues.end
                                          .round()
                                          .toString(),
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
                                        isDefault = false;
                                      });
                                    },
                                    title: const Text('ระบุปัญหาสุขภาพ'),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ),
                                  DropdownButtonFormField2(
                                    isExpanded: true,
                                    selectedItemHighlightColor:
                                        Colors.grey[300],
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
                                        isDefault = false;
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
                                    selectedItemHighlightColor:
                                        Colors.grey[300],
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
                                            onPressed: () =>
                                                _bodySearch.clear(),
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
                                  color: Colors.blue[200],
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
                      if (isDefault == false) {
                        _selectedQuestionnaire = <bool>[true, true];
                        _currentRangeValues = const RangeValues(0, 100);
                        isHealthCheck = false;
                        healthChoosing = null;
                        isPhysicalCheck = false;
                        isDefault = true;
                        bodyChoosing = null;
                        bodyPartChoosing = null;
                        isBodySelected = false;
                        dateRange = DateTimeRange(
                          start: DateTime.now().add(const Duration(days: -7)),
                          end: DateTime.now(),
                        );
                      }
                      isDefault = value;
                    });
                  },
                ),
              ],
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

                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          SizedBox(
                            height: h / pixRatio,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Row(
                                children: [
                                  FixedColumnTable(
                                    resultDataList: mappedData,
                                    athleteList: athleteData,
                                  ),
                                  ScrollableColumnTable(
                                    resultDataList: mappedData,
                                    athleteList: athleteData,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
