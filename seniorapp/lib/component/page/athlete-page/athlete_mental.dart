import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_page_choosing.dart';
import 'package:seniorapp/component/page/athlete-page/history-details/mental_report_detail.dart';
import 'package:seniorapp/component/result-data/mental_result_data.dart';
import 'package:seniorapp/decoration/format_datetime.dart';

import 'dart:async' show Stream, StreamController, Timer;
import 'package:async/async.dart' show StreamZip;
import 'package:seniorapp/decoration/padding.dart';

class AthleteMentalHistory extends StatefulWidget {
  const AthleteMentalHistory({Key key}) : super(key: key);

  @override
  _AthleteHistoryState createState() => _AthleteHistoryState();
}

class _AthleteHistoryState extends State<AthleteMentalHistory> {
  List<bool> _selectedOrderType = <bool>[true, false];
  bool isDefault = true;
  Timer _timer;
  int mentalSize;
  bool isLoading = false;
  bool isFilter = false;
  String selectedSort = 'วันที่ล่าสุด';

  List<String> sortList = [
    'วันที่ล่าสุด',
    'วันที่ก่อนหน้า',
  ];

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
    _timer = Timer(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  String find_questnaireNo(String docNo) {
    int docNoInt;
    docNo = docNo.split('MQ')[1];
    docNoInt = int.parse(docNo);
    return docNoInt.toString();
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

    mentalHistoryList = add_sort(mentalHistoryList);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
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
            ),
          ],
        ),
        Expanded(
          child: SizedBox(
            height: h,
            width: w,
            child: isLoading
                ? const Center(
                    child: CupertinoActivityIndicator(),
                  )
                : mentalHistoryList.isNotEmpty
                    ? ListView.builder(
                        itemCount: mentalHistoryList.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = mentalHistoryList[index];
                          return GestureDetector(
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: BorderSide(
                                    width: 2, color: Colors.green[200]),
                              ),
                              child: Container(
                                  height: h * 0.2,
                                  padding: EdgeInsets.only(
                                    left: w * 0.05,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.only(left: w * 0.03),
                                        width: w * 0.7,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Text.rich(
                                              TextSpan(
                                                text:
                                                    'รายงานปัญหารการนอนหลับครั้งที่: ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        (index + 1).toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                text: 'วันที่บันทึก: ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: formatDate(
                                                      data['doDate'].toDate(),
                                                      'Athlete',
                                                    ),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                text: 'เวลาที่บันทึก: ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${formatTime(data['doDate'].toDate(), 'Athlete')} น.',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            onTap: () {
                              MentalResultData mentalResultData =
                                  MentalResultData.fromMap(data);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MentalReportDetail(
                                    mentalResultData: mentalResultData,
                                  ),
                                ),
                              );
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
  }
}
