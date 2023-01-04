import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/checking_questionnaire.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/more_questionnaire.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/result.dart';
import 'package:seniorapp/component/result-data/physical_result_data.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'questionnaire.dart';

class PhysicalQuestionnaire extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PhysicalQuestionnaire();
  }
}

class _PhysicalQuestionnaire extends State<PhysicalQuestionnaire> {
  var _questionIndex = 0;
  var _bodyPartRound = 0;
  Map<String, int> answer_list = {"Q1": 0};

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

  void _previousCheckingQuestion() {
    setState(() {
      hasQuestion = false;
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

  final body_part = const [
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

  final body_injured = [
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
      setState(() {
        _questionIndex += 1;
      });
      print('Index: $_questionIndex');
      if (_questionIndex < _questions.length) {
        print('We have more question');
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
      setState(() {
        if (_questionIndex == _questions.length) {
          isResult = true;
        } else if (_questionIndex < _questions.length) {
          _questionIndex++;
        }
      });
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

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

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
            Container(
              child: Ink(
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: Colors.green.shade300,
                ),
                child: IconButton(
                  icon: Icon(Icons.home),
                  alignment: Alignment.center,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('ยกเลิกการบันทึกข้อมูล'),
                            content: Container(
                              height: h * 0.2,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
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
                                        icon: Icon(Icons.check_rounded),
                                        label: Text('ตกลง'),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green[900],
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Icons.close_rounded),
                                        label: Text('ปฏิเสธ'),
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
            ),
          ],
        ),
      ),
      body: Container(
          padding: (isResult == true && _questionIndex == _questions.length)
              ? EdgeInsets.only(top: h * 0.3)
              : EdgeInsets.only(top: h / 3),
          child: hasQuestion
              ? _bodyPartRound < 2
                  ? _questionnaireDisplay(_bodyPartRound)
                  : _questionIndex < _questions.length
                      ? Questionnaire(
                          answerQuestion: _answerQuestion,
                          questionIndex: _questionIndex,
                          questions: _questions,
                          questionType: 'physical',
                          nextPage: _nextQuestion,
                          previousPage: _previousQuestion,
                          partChoosing: insertedBody,
                          bodyChoosing: _bodyChoosing,
                        )
                      : isResult
                          ? Result(
                              resultScore: _findTotalScore(),
                              resetHandler: _resetQuestionnaire,
                              insertHandler: savePhysicalResult,
                              questionType: 'physical',
                              bodyPart: _bodyChoosing,
                              previousPage: _previousFromResult,
                            )
                          : MoreQuestionnaire(
                              _resetQuestionnaire,
                              'physical',
                            )
              : hasProblem
                  ? CheckingQuestionnaire(
                      'physical',
                      _checkingQuestion,
                      _hasProblem,
                    )
                  : Result(
                      resultScore: 0,
                      resetHandler: _resetQuestionnaire,
                      insertHandler: savePhysicalResult,
                      questionType: 'physical',
                      previousPage: _previousProblem,
                    )),

      // : Result(_totalScore, _resetQuiz, savePhysicalResult)),
    );
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
          caseFinished: false);
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
          caseFinished: false);
    }
    Map<String, dynamic> data = physicalResultModel.toMap();

    final collectionReference =
        FirebaseFirestore.instance.collection('PhysicalQuestionnaireResult');
    DocumentReference docReference = collectionReference.doc();
    docReference.set(data).then((value) {
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
                  : Text('บันทึกข้อมูลอาการเรียบร้อย'),
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
            questionType: 'physical',
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
            questionType: 'physical',
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
