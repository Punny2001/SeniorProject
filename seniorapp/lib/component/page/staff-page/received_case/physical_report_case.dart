import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/result.dart';
import 'package:seniorapp/component/page/staff-page/record/injury_record.dart';
import 'package:seniorapp/component/result-data/physical_result_data.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/decoration/format_datetime.dart';
import 'package:seniorapp/decoration/padding.dart';
import 'package:seniorapp/decoration/textfield_normal.dart';

class PhysicalReportCase extends StatefulWidget {
  PhysicalResultData physicalResultData;
  String docID;

  PhysicalReportCase({
    @required this.physicalResultData,
    @required this.docID,
  });

  @override
  State<PhysicalReportCase> createState() => _PhysicalReportCaseState();
}

class _PhysicalReportCaseState extends State<PhysicalReportCase> {
  Athlete athlete;
  Timer _timer;
  bool isLoading = false;
  void _getAthleteData() {
    FirebaseFirestore.instance
        .collection('Athlete')
        .doc(widget.physicalResultData.athleteUID)
        .get()
        .then((snapshot) {
      Map data = snapshot.data();

      setState(() {
        athlete = Athlete.fromMap(data);
      });
    });
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    _getAthleteData();
    _timer = Timer(Duration(seconds: 1), () {
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

  Result result = Result();

  @override
  Widget build(BuildContext context) {
    String resultPhrase =
        result.resultPhrase('physical', widget.physicalResultData.totalPoint);
    resultPhrase =
        resultPhrase.replaceAll('null', widget.physicalResultData.bodyPart);
    final _questions = [
      {
        'questionNo': 'Q1',
        'questionText':
            'ใน 7 วันที่ผ่านมา อาการ${widget.physicalResultData.bodyPart}ของท่านทำให้การเข้าร่วมฝึกซ้อมหรือแข่งขันกีฬามีปัญหาหรือไม่',
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
            'ใน 7 วันที่ผ่านมา อาการ${widget.physicalResultData.bodyPart}ของท่านส่งผลกระทบต่อการฝึกซ้อมหรือแข่งขันมากน้อยเพียงใด',
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
            'ใน 7 วันที่ผ่านมา อาการ${widget.physicalResultData.bodyPart}ของท่านส่งผลกระทบต่อความสามารถในการเล่นกีฬามากน้อยเพียงใด',
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
            'ใน 7 วันที่ผ่านมา อาการ${widget.physicalResultData.bodyPart}ของท่านซึ่งเป็นผลมาจากการเข้าร่วมการแข่งขันหรือฝึกซ้อมกีฬาอยู่ในระดับใด',
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
          if (widget.physicalResultData.answerList['Q$i'] == answer['score']) {
            answerText.add(answer['text'].toString());
            i++;
          }
        });
      });
      return answerText;
    }

    List<String> answerTextList = find_answer(_questions);
    print(answerTextList);

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
            Container(
              child: Ink(
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: Colors.blue[200],
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  alignment: Alignment.centerRight,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : Container(
              padding: EdgeInsets.only(
                left: 30,
                right: 30,
              ),
              height: h,
              width: w,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Text(
                      'Case: ${widget.physicalResultData.questionnaireNo}',
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
                                style: TextStyle(
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
                            text: 'Gender: ',
                            style: TextStyle(
                              fontSize: h * 0.02,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                style: TextStyle(
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
                                style: TextStyle(
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
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                                text: '${athlete.sportType}',
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
                                  color: score_color(
                                      widget.physicalResultData.totalPoint),
                                ),
                                text:
                                    '${widget.physicalResultData.totalPoint} ',
                              ),
                              TextSpan(
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
                                text: '${resultPhrase}',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
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
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                                text:
                                    '${formatDate(widget.physicalResultData.doDate, 'Staff')} | ${formatTime(widget.physicalResultData.doDate)}',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    PaddingDecorate(10),
                    for (int i = 0;
                        i < widget.physicalResultData.answerList.length;
                        i++)
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
                              Container(
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
                                    '${widget.physicalResultData.answerList['Q${i + 1}']}',
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
                    widget.physicalResultData.caseFinished == false
                        ? ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue[300],
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InjuryReport(
                                      widget.physicalResultData,
                                      widget.docID,
                                      athlete),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.create,
                            ),
                            label: Text('Record new injury'),
                          )
                        : SizedBox(),
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
      .collection('PhysicalQuestionnaireResult')
      .doc(docID)
      .update({'caseFinished': true}).then((value) {
    print('Updated data successfully');
  });
}
