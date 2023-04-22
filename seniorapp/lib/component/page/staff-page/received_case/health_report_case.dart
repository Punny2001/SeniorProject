import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/result.dart';
import 'package:seniorapp/component/page/staff-page/received_case/appointment.dart';
import 'package:seniorapp/component/page/staff-page/record/illness_record.dart';
import 'package:seniorapp/component/result-data/health_result_data.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/decoration/format_datetime.dart';
import 'package:seniorapp/decoration/padding.dart';
import 'package:seniorapp/decoration/textfield_normal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HealthReportCase extends StatefulWidget {
  Map<String, dynamic> data;

  HealthReportCase({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  State<HealthReportCase> createState() => _HealthReportCaseState();
}

class _HealthReportCaseState extends State<HealthReportCase> {
  bool isTexting = false;
  Athlete athlete;
  Timer _timer;
  bool isLoading = false;
  Map<String, dynamic> latestAppointment;

  void _getAppointmentData() {
    FirebaseFirestore.instance
        .collection('AppointmentRecord')
        .where('caseID', isEqualTo: widget.data['questionnaireID'])
        .get()
        .then((snapshot) {
      setState(() {
        if (snapshot.docs.isNotEmpty) {
          latestAppointment = snapshot.docs.first.data();
        } else {
          print("This case doesn't have any appointment");
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    _getAppointmentData();
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

  Result result = const Result();

  @override
  Widget build(BuildContext context) {
    String resultPhrase =
        result.resultPhrase('Health', widget.data['totalPoint']);
    resultPhrase =
        resultPhrase.replaceAll('null', widget.data['healthSymptom']);
    final _questions = [
      {
        'questionNo': 'Q1',
        'questionText':
            'ใน 7 วันที่ผ่านมา อาการ${widget.data['healthSymptom']}ของท่านทำให้การเข้าร่วมฝึกซ้อมหรือแข่งขันกีฬามีปัญหาหรือไม่',
        'answerText': [
          {
            'text':
                'เข้าร่วมการฝึกซ้อมหรือแข่งขันกีฬาได้เต็มที่ โดยไม่มีปัญหาสุขภาพ',
            'score': 0
          },
          {
            'text':
                'เข้าร่วมการฝึกซ้อมหรือแข่งขันกีฬาได้เต็มที่ แต่มีปัญหาสุขภาพ',
            'score': 8
          },
          {
            'text':
                'เข้าร่วมการฝึกซ้อมหรือแข่งขันกีฬาได้ไม่เต็มที่ เพราะมีปัญหาสุขภาพ',
            'score': 17
          },
          {
            'text':
                'ไม่สามารถเข้าร่วมการฝึกซ้อมหรือแข่งขันกีฬาได้เลย เพราะมีปัญหาสุขภาพ',
            'score': 25
          }
        ]
      },
      {
        'questionNo': 'Q2',
        'questionText':
            'ใน 7 วันที่ผ่านมา อาการ${widget.data['healthSymptom']}ของท่านส่งผลกระทบต่อการฝึกซ้อมหรือแข่งขันมากน้อยเพียงใด',
        'answerText': [
          {'text': 'ไม่ส่งผลกระทบต่อการฝึกซ้อมหรือแข่งขันเลย', 'score': 0},
          {'text': 'การฝึกซ้อมหรือแข่งขันลดลงเล็กน้อย', 'score': 6},
          {'text': 'การฝึกซ้อมหรือแข่งขันลดลงปานกลาง', 'score': 13},
          {'text': 'การฝึกซ้อมหรือแข่งขันลดลงอย่างมาก', 'score': 19},
          {'text': 'ไม่สามารถเข้าร่วมการฝึกซ้อมหรือแข่งขันได้เลย', 'score': 25}
        ]
      },
      {
        'questionNo': 'Q3',
        'questionText':
            'ใน 7 วันที่ผ่านมา อาการ${widget.data['healthSymptom']}ของท่านส่งผลกระทบต่อความสามารถในการเล่นกีฬามากน้อยเพียงใด',
        'answerText': [
          {'text': 'ไม่ส่งผลกระทบต่อความสามารถในการเล่นกีฬาเลย', 'score': 0},
          {'text': 'ความสามารถในการเล่นกีฬาลดลงเล็กน้อย', 'score': 6},
          {'text': 'ความสามารถในการเล่นกีฬาลดลงปานกลาง', 'score': 13},
          {'text': 'ความสามารถในการเล่นกีฬาลดลงอย่างมาก', 'score': 19},
          {'text': 'ไม่สามารถเข้าร่วมการฝึกซ้อมหรือแข่งขันได้เลย', 'score': 25}
        ]
      },
      {
        'questionNo': 'Q4',
        'questionText':
            'ใน 7 วันที่ผ่านมา อาการ${widget.data['healthSymptom']}ของท่านซึ่งเป็นผลมาจากการเข้าร่วมการแข่งขันหรือฝึกซ้อมกีฬาอยู่ในระดับใด',
        'answerText': [
          {'text': 'ไม่เจ็บเลย', 'score': 0},
          {'text': 'เจ็บเล็กน้อย', 'score': 6},
          {'text': 'เจ็บพอประมาณ', 'score': 13},
          {'text': 'เจ็บมาก', 'score': 19},
          {'text': 'ไม่สามารถเข้าร่วมการฝึกซ้อมหรือแข่งขันได้เลย', 'score': 25}
        ]
      },
    ];

    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    List<String> find_answer(List<Map<String, Object>> question) {
      List<String> answerText = [];
      int i = 1;
      question.forEach((map) {
        (map['answerText'] as List<Map<String, Object>>).forEach((answer) {
          // print('${answerList['Q$i']} and ${answer['score']}');
          if (widget.data['answerList']['Q$i'] == answer['score']) {
            answerText.add(answer['text'].toString());
            i++;
          }
        });
      });
      return answerText;
    }

    const String ucepUrl =
        'https://www.nhso.go.th/page/coverage_rights_emergency_patients';
    List<String> answerTextList = find_answer(_questions);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        primary: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Ink(
              decoration: ShapeDecoration(
                shape: const CircleBorder(),
                color: Colors.blue[200],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                alignment: Alignment.centerRight,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : Container(
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
              ),
              height: h,
              width: w,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Text(
                      'Case: ${widget.data['questionnaireNo']}',
                      style: TextStyle(
                        fontSize: h * 0.03,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    PaddingDecorate(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Athlete name: ',
                            style: TextStyle(
                              fontSize: h * 0.02,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                                text:
                                    '${athlete.firstname + ' ' + athlete.lastname} ',
                              ),
                            ],
                          ),
                        ),
                        PaddingDecorate(5),
                        RichText(
                          text: TextSpan(
                            text: 'Phone No: ',
                            style: TextStyle(
                              fontSize: h * 0.02,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                text: athlete.phoneNo,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrlString('tel:${athlete.phoneNo}');
                                  },
                              ),
                            ],
                          ),
                        ),
                        PaddingDecorate(5),
                        RichText(
                          text: TextSpan(
                            text: 'Gender: ',
                            style: TextStyle(
                              fontSize: h * 0.02,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                                text: '${athlete.gender} ',
                              ),
                            ],
                          ),
                        ),
                        PaddingDecorate(5),
                        RichText(
                          text: TextSpan(
                            text: 'Age: ',
                            style: TextStyle(
                              fontSize: h * 0.02,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                                text: '${athlete.age} years',
                              ),
                            ],
                          ),
                        ),
                        PaddingDecorate(5),
                        RichText(
                          text: TextSpan(
                            text: 'Sports: ',
                            style: TextStyle(
                              fontSize: h * 0.02,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                                text: athlete.sportType,
                              ),
                            ],
                          ),
                        ),
                        PaddingDecorate(5),
                        RichText(
                          text: TextSpan(
                            text: 'Total score: ',
                            style: TextStyle(
                              fontSize: h * 0.02,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                style: TextStyle(
                                  color: score_color(widget.data['totalPoint']),
                                ),
                                text: '${widget.data['totalPoint']} ',
                              ),
                              const TextSpan(
                                text: 'points',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PaddingDecorate(5),
                        RichText(
                          text: TextSpan(
                            text: 'Preliminary message: ',
                            style: TextStyle(
                              fontSize: h * 0.02,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: resultPhrase,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              widget.data['totalPoint'] >= 75
                                  ? TextSpan(
                                      text: 'คลิกที่นี่',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launch(ucepUrl);
                                        },
                                    )
                                  : const TextSpan(),
                            ],
                          ),
                        ),
                        PaddingDecorate(5),
                        RichText(
                          text: TextSpan(
                            text: 'Done date: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: h * 0.02,
                            ),
                            children: [
                              TextSpan(
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                                text:
                                    '${formatDate(widget.data['doDate'], 'Staff')} | ${formatTime(widget.data['doDate'])} ',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    PaddingDecorate(10),
                    for (int i = 0; i < widget.data['answerList'].length; i++)
                      Column(
                        children: [
                          Text(
                            'Q${i + 1} : ${_questions[i]['questionText']}\n',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                              fontSize: h * 0.02,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: w * 0.5,
                                child: Text(
                                  answerTextList[i],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: h * 0.02,
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    'คะแนน',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: h * 0.02,
                                    ),
                                  ),
                                  Text(
                                    '${widget.data['answerList']['Q${i + 1}']}',
                                    style: TextStyle(
                                      fontSize: h * 0.02,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 2,
                            height: h * 0.05,
                            indent: 0,
                          ),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: widget.data['caseFinished'] == false,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue[300],
                              fixedSize: Size.infinite,
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      IllnessReport(widget.data),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.create,
                            ),
                            label: const Text('Record new illness'),
                          ),
                        ),
                        Visibility(
                          visible: latestAppointment == null ||
                              latestAppointment['appointStatus'] != true,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size.infinite,
                              primary: Colors.white,
                              elevation: 0,
                              side: BorderSide(
                                width: 1,
                                color: latestAppointment == null ||
                                        latestAppointment['appointStatus'] !=
                                            true
                                    ? Colors.blue[200]
                                    : Colors.grey[800],
                              ),
                            ),
                            onPressed: latestAppointment == null ||
                                    latestAppointment['appointStatus'] != true
                                ? () {
                                    showCupertinoDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AppointmentPage(
                                            data: widget.data,
                                          );
                                        });
                                  }
                                : null,
                            icon: Icon(
                              Icons.calendar_month,
                              color: latestAppointment == null ||
                                      latestAppointment['appointStatus'] != true
                                  ? Colors.blue[200]
                                  : Colors.grey[800],
                            ),
                            label: Text(
                              'Appointment',
                              style: TextStyle(
                                color: Colors.blue[200],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    PaddingDecorate(10),
                  ],
                ),
              ),
            ),
    );
  }
}

Future<void> updateData(String docID) async {
  await FirebaseFirestore.instance
      .collection('HealthQuestionnaireResult')
      .doc(docID)
      .update({'caseFinished': true}).then((value) {
    print('Updated data successfully');
  });
}
