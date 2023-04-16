import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/checking_questionnaire.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/more_questionnaire.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/result.dart';
import 'package:seniorapp/component/result-data/physical_result_data.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/decoration/format_datetime.dart';
import 'questionnaire.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PhysicalQuestionnaire extends StatefulWidget {
  static List physicalList;

  @override
  State<StatefulWidget> createState() {
    return _PhysicalQuestionnaire();
  }
}

class _PhysicalQuestionnaire extends State<PhysicalQuestionnaire> {
  var _questionIndex = 0;
  var _bodyPartRound = 0;
  Map<String, int> answer_list = {"Q1": null};

  String uid = FirebaseAuth.instance.currentUser.uid;
  Athlete athData;

  bool isResult = true;
  bool hasQuestion = false;
  bool hasProblem = true;
  int totalScore;
  String _partChoosing;

  String _bodyChoosing;
  String insertedBody;

  int questionSize;

  void _resetQuestionnaire() {
    setState(() {
      _questionIndex = 0;
      _bodyPartRound = 0;
      isResult = true;
      hasProblem = true;
    });
  }

  void _answerBodyPart(String body) {
    if (_bodyPartRound == 1) {
      insertedBody = body;
      print('round: $_bodyPartRound');
    } else {
      _bodyChoosing = body;
    }
    setState(() {
      _bodyPartRound += 1;
    });
  }

  void _previousBodyPart() {
    if (_bodyPartRound == 0) {
      setState(() {
        hasQuestion = false;
      });
    } else {
      setState(() {
        _bodyPartRound--;
      });
    }
  }

  void _checkingQuestion() {
    setState(() {
      hasQuestion = true;
    });
  }

  void _hasProblem() {
    setState(() {
      hasProblem = false;
    });
  }

  void _previousProblem() {
    setState(() {
      hasProblem = true;
    });
  }

  static const body_part = [
    {
      'questionText': 'โปรดเลือกอวัยวะที่ได้รับการบาดเจ็บมากที่สุด',
      'answerText': [
        {
          'text': 'ร่างกายส่วนหัวถึงลำตัว',
        },
        {
          'text': 'ร่างกายส่วนแขนถึงนิ้วมือ',
        },
        {
          'text': 'ร่างกายส่วนสะโพกถึงนิ้วเท้า',
        },
      ]
    }
  ];

  static final body_injured = [
    {
      'questionText': 'โปรดเลือกอวัยวะที่ได้รับการบาดเจ็บมากที่สุด',
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
    }
  ];

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final _questions = [
      {
        'questionNo': 'Q1',
        'questionText':
            'ใน 7 วันที่ผ่านมา ปัญหา${insertedBody}ของท่านทำให้การเข้าร่วมฝึกซ้อมหรือแข่งขันกีฬามีปัญหาหรือไม่',
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
            'ใน 7 วันที่ผ่านมา ปัญหา${insertedBody}ของท่านส่งผลกระทบต่อการฝึกซ้อมหรือแข่งขันมากน้อยเพียงใด',
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
            'ใน 7 วันที่ผ่านมา ปัญหา${insertedBody}ของท่านส่งผลกระทบต่อความสามารถในการเล่นกีฬามากน้อยเพียงใด',
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
            'ใน 7 วันที่ผ่านมา อาการเจ็บปวดของ${insertedBody}ของท่านซึ่งเป็นผลมาจากการเข้าร่วมการแข่งขันหรือฝึกซ้อมกีฬาอยู่ในระดับใด',
        'answerText': [
          {'text': 'ไม่เจ็บเลย', 'score': 0},
          {'text': 'เจ็บเล็กน้อย', 'score': 6},
          {'text': 'เจ็บพอประมาณ', 'score': 13},
          {'text': 'เจ็บมาก', 'score': 19},
          {'text': 'ไม่สามารถเข้าร่วมการฝึกซ้อมหรือแข่งขันได้เลย', 'score': 25}
        ]
      },
    ];

    questionSize = _questions.length;

    int _findTotalScore() {
      int _totalScore = 0;
      answer_list.forEach((key, value) {
        _totalScore += value;
      });
      totalScore = _totalScore;
      return _totalScore;
    }

    void _answerQuestion(int score) {
      answer_list["Q${_questionIndex + 1}"] = score;
      if (_questionIndex == _questions.length - 1) {
        if (answer_list.length != 4 || answer_list['Q1'] == null) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('ข้อมูลไม่ครบ'),
                  content: const Text('โปรดเลือกคำตอบให้ครบทุกข้อ'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      },
                      child: const Text('ตกลง'),
                    ),
                  ],
                );
              });
        } else {
          setState(() {
            _questionIndex++;
            isResult = true;
          });
        }
      } else if (_questionIndex < _questions.length) {
        print('We have more question');
        setState(() {
          _questionIndex++;
        });
      }
    }

    void _previousQuestion(String body, String bodyPart) {
      setState(() {
        if (_questionIndex == 0) {
          _bodyChoosing = body;
          _partChoosing = bodyPart;
          _bodyPartRound = 1;
        } else if (_questionIndex > 0) {
          _questionIndex--;
        }
      });
    }

    void _nextQuestion() {
      print('Result: $isResult');
      print('Answer list: $answer_list');
      print('Answer list length: ${answer_list.length}');
      print('Question index: $_questionIndex');
      print('Question length: ${_questions.length - 1}');
      if (_questionIndex == _questions.length - 1) {
        print(answer_list['Q1']);
        if (answer_list.length != 4 || answer_list['Q1'] == null) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('ข้อมูลไม่ครบ'),
                  content: const Text('โปรดเลือกคำตอบให้ครบทุกข้อ'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      },
                      child: const Text('ตกลง'),
                    ),
                  ],
                );
              });
        } else {
          setState(() {
            _questionIndex++;
            isResult = true;
          });
        }
      } else if (_questionIndex < _questions.length) {
        setState(() {
          _questionIndex++;
        });
      }
    }

    void _previousFromResult() {
      setState(() {
        _questionIndex = _questions.length - 1;
      });
    }

    void getAthData() {
      FirebaseFirestore.instance.collection('Athlete').doc(uid).get().then(
        (snapshot) {
          Map data = snapshot.data();
          athData = Athlete.fromMap(data);
          print(athData.athlete_no);
        },
      );
    }

    getAthData();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
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
                color: Colors.green.shade300,
              ),
              child: IconButton(
                icon: const Icon(Icons.home),
                alignment: Alignment.center,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('ยกเลิกการบันทึกข้อมูล'),
                          content: SizedBox(
                            height: h * 0.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                    'คุณแน่ใจจะยกเลิกการบันทึกข้อมูลใช่หรือไม่?'),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.popUntil(
                                            context,
                                            ModalRoute.withName(
                                                '/athletePageChoosing'));
                                      },
                                      icon: const Icon(Icons.check_rounded),
                                      label: const Text('ตกลง'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green[900],
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(Icons.close_rounded),
                                      label: const Text('ปฏิเสธ'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red[900],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: (isResult == true && _questionIndex == _questions.length)
            ? EdgeInsets.only(
                top: h * 0.3,
              )
            : EdgeInsets.only(
                top: h / 3,
              ),
        child: hasQuestion
            ? _bodyPartRound < 2
                ? _questionnaireDisplay(_bodyPartRound)
                : _questionIndex < _questions.length
                    ? Questionnaire(
                        answerQuestion: _answerQuestion,
                        questionIndex: _questionIndex,
                        questions: _questions,
                        questionType: 'Physical',
                        nextPage: _nextQuestion,
                        previousPage: _previousQuestion,
                        partChoosing: insertedBody,
                        bodyChoosing: _bodyChoosing,
                        answerList: answer_list,
                      )
                    : isResult
                        ? Result(
                            resultScore: _findTotalScore(),
                            resetHandler: _resetQuestionnaire,
                            insertHandler: savePhysicalResult,
                            questionType: 'Physical',
                            bodyPart: _bodyChoosing,
                            previousPage: _previousFromResult,
                          )
                        : MoreQuestionnaire(
                            _resetQuestionnaire,
                            'Physical',
                          )
            : hasProblem
                ? CheckingQuestionnaire(
                    'Physical',
                    _checkingQuestion,
                    _hasProblem,
                  )
                : Result(
                    resultScore: 0,
                    resetHandler: _resetQuestionnaire,
                    insertHandler: savePhysicalResult,
                    questionType: 'Physical',
                    previousPage: _previousProblem,
                  ),
      ),
    );
  }

  void sendPushMessage(
      Athlete athlete, PhysicalResultData physicalResultData) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAOmXVBT0:APA91bFonAMAsnJl3UDp2LQHXvThSOQd2j7q01EL1afdZI13TP7VEZxRa7q_Odj3wUL_urjyfS7e0wbgEbwKbUKPkm8p5LFLAVE498z3X4VgNaR5iMF4M9JMpv8s14YsGqI2plf_lCBK',
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'title': 'ปัญหาอาการบาดเจ็บถูกรายงาน',
            'body':
                'ข้อมูล ${physicalResultData.questionnaireNo} ถูกรายงานโดยนักกีฬา ${athlete.firstname} ${athlete.lastname} ณ วันที่ ${formatDate(DateTime.now(), 'Athlete')} เวลา ${formatTime(DateTime.now())} น.',
          },
          'notification': {
            'title': 'ปัญหาอาการบาดเจ็บถูกรายงาน',
            'body':
                'ข้อมูล ${physicalResultData.questionnaireNo} ถูกรายงานโดยนักกีฬา ${athlete.firstname} ${athlete.lastname} ณ วันที่ ${formatDate(DateTime.now(), 'Athlete')} เวลา ${formatTime(DateTime.now())} น.',
          },
          'to': '/topics/Staff',
        }),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> savePhysicalResult() async {
    var uid = FirebaseAuth.instance.currentUser.uid;
    String questionnaireNo = 'PQ';
    String split;
    int latestID;
    NumberFormat format = NumberFormat('0000000000');
    await FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .orderBy('questionnaireNo', descending: true)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size == 0) {
        questionnaireNo += format.format(1);
      } else {
        querySnapshot.docs
            .forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
          Map data = queryDocumentSnapshot.data();
          split = data['questionnaireNo'].toString().split('PQ')[1];
          latestID = int.parse(split) + 1;
          questionnaireNo += format.format(latestID);
        });
      }
    });

    DateTime defaultDate = DateTime(1950);

    PhysicalResultData physicalResultModel;
    if (hasProblem == true) {
      physicalResultModel = PhysicalResultData(
        questionnaireNo: questionnaireNo,
        athleteNo: athData.athlete_no,
        athleteUID: uid,
        doDate: DateTime.now(),
        questionnaireType: 'Physical',
        totalPoint: totalScore,
        answerList: answer_list,
        bodyPart: insertedBody,
        caseReceived: false,
        caseFinished: false,
        caseFinishedDateTime: defaultDate,
        caseReceivedDateTime: defaultDate,
        messageReceivedDateTime: defaultDate,
      );
    } else {
      for (int i = 0; i < questionSize; i++) {
        answer_list["Q${i + 1}"] = 0;
      }
      physicalResultModel = PhysicalResultData(
          questionnaireNo: questionnaireNo,
          athleteNo: athData.athlete_no,
          athleteUID: uid,
          doDate: DateTime.now(),
          questionnaireType: 'Physical',
          totalPoint: 0,
          answerList: answer_list,
          bodyPart: 'None',
          caseReceived: false,
          caseFinished: false,
          caseFinishedDateTime: defaultDate,
          caseReceivedDateTime: defaultDate,
          messageReceivedDateTime: defaultDate);
    }
    Map<String, dynamic> data = physicalResultModel.toMap();

    final collectionReference =
        FirebaseFirestore.instance.collection('PhysicalQuestionnaireResult');
    DocumentReference docReference = collectionReference.doc();
    docReference.set(data).then((value) {
      sendPushMessage(athData, physicalResultModel);
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            print(_bodyChoosing);
            return AlertDialog(
              title: const Text(
                'รายงานผลเสร็จสิ้น',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: hasProblem == true
                  ? Text('บันทึกข้อมูลอาการ${_bodyChoosing}เรียบร้อย')
                  : const Text('บันทึกข้อมูลอาการเรียบร้อย'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (hasProblem == true) {
                      Navigator.pop(context);
                      setState(() {
                        isResult = false;
                      });
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/athletePageChoosing', (route) => false);
                      setState(() {
                        isResult = false;
                      });
                    }
                  },
                  child: const Text('โอเค'),
                ),
              ],
            );
          }).then((value) => print('Insert data to Firestore successfully'));
    });
  }

  Widget _questionnaireDisplay(int bodyPartRound) {
    switch (bodyPartRound) {
      case 0:
        {
          return Questionnaire(
            questions: body_part,
            answerQuestion: _answerBodyPart,
            questionIndex: _bodyPartRound,
            questionType: 'Physical',
            bodyChoosing: _bodyChoosing,
            previousPage: _previousBodyPart,
          );
        }
        break;
      case 1:
        {
          return Questionnaire(
            questions: body_injured,
            answerQuestion: _answerBodyPart,
            questionIndex: _bodyPartRound,
            questionType: 'Physical',
            bodyChoosing: _bodyChoosing,
            previousPage: _previousBodyPart,
            partChoosing: _partChoosing,
          );
        }
        break;
      default:
    }
  }
}
