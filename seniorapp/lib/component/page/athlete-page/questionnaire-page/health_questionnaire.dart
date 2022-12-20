import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/checking_questionnaire.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/more_questionnaire.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/result.dart';
import 'package:seniorapp/component/result-data/health_result_data.dart';
import 'questionnaire.dart';

class HealthQuestionnaire extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HealthQuestionnaire();
  }
}

class _HealthQuestionnaire extends State<HealthQuestionnaire> {
  GlobalKey updateState = GlobalKey();
  var _questionIndex = 0;
  int totalScore;
  Map<String, int> answer_list = {"Q1": 0};

  bool isResult = true;
  String _healthChoosing;
  bool answer_health = false;
  bool hasQuestion = false;
  bool hasProblem = true;

  int questionSize;

  void _resetQuestionnaire() {
    setState(() {
      hasQuestion = true;
      answer_health = false;
      _questionIndex = 0;
      isResult = true;
      hasProblem = true;
    });
  }

  void _answerHealthPart(String health) {
    setState(() {
      _healthChoosing = health.trimRight();
      answer_health = true;
    });
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

  final health_symp = [
    {
      'questionText': 'โปรดเลือกปัญหาสุขภาพที่สำคัญที่สุด',
      'answerText': [
        'คลื่นไส้',
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
        'มีอาการที่หู',
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
        'ไข้',
        'ไอ',
      ],
    }
  ];

  @override
  Widget build(BuildContext context) {
    final _questions = [
      {
        'questionNo': 'Q1',
        'questionText':
            'ใน 7 วันที่ผ่านมา อาการ${_healthChoosing}ของท่านทำให้การเข้าร่วมฝึกซ้อมหรือแข่งขันกีฬามีปัญหาหรือไม่',
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
            'ใน 7 วันที่ผ่านมา อาการ${_healthChoosing}ของท่านส่งผลกระทบต่อการฝึกซ้อมหรือแข่งขันมากน้อยเพียงใด',
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
            'ใน 7 วันที่ผ่านมา อาการ${_healthChoosing}ของท่านส่งผลกระทบต่อความสามารถในการเล่นกีฬามากน้อยเพียงใด',
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
            'ใน 7 วันที่ผ่านมา อาการ${_healthChoosing}ของท่านซึ่งเป็นผลมาจากการเข้าร่วมการแข่งขันหรือฝึกซ้อมกีฬาอยู่ในระดับใด',
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

    void _previousQuestion(String health) {
      setState(() {
        if (_questionIndex == 0) {
          _healthChoosing = health;
          answer_health = false;
        } else if (_questionIndex <= _questions.length) {
          _questionIndex--;
        }
      });
    }

    void _nextQuestion() {
      setState(() {
        if (_questionIndex == _questions.length) {
          isResult = true;
        } else if (_questionIndex >= 0) {
          _questionIndex++;
        }
      });
    }

    void _previousFromResult() {
      setState(() {
        _questionIndex = _questions.length - 1;
      });
    }

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
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
      backgroundColor: Colors.white,
      body: Container(
        padding: (isResult == true)
            ? EdgeInsets.only(
                top: h * 0.3,
              )
            : EdgeInsets.only(
                top: h / 3,
              ),
        child: hasQuestion
            ? answer_health
                ? _questionIndex < _questions.length
                    ? Questionnaire(
                        answerQuestion: _answerQuestion,
                        healthChoosing: _healthChoosing,
                        questionIndex: _questionIndex,
                        questions: _questions,
                        questionType: 'health',
                        nextPage: _nextQuestion,
                        previousPage: _previousQuestion,
                      )
                    : isResult
                        ? Result(
                            resultScore: _findTotalScore(),
                            resetHandler: _resetQuestionnaire,
                            insertHandler: saveHealthResult,
                            questionType: 'health',
                            healthPart: _healthChoosing,
                            previousPage: _previousFromResult,
                          )
                        : MoreQuestionnaire(
                            _resetQuestionnaire,
                            'health',
                          )
                : Questionnaire(
                    questions: health_symp,
                    answerQuestion: _answerHealthPart,
                    questionType: 'health',
                    healthChoosing: _healthChoosing,
                    previousPage: _previousCheckingQuestion,
                  )
            : hasProblem
                ? CheckingQuestionnaire(
                    'health',
                    _checkingQuestion,
                    _hasProblem,
                  )
                : Result(
                    resultScore: 0,
                    resetHandler: _resetQuestionnaire,
                    insertHandler: saveHealthResult,
                    questionType: 'health',
                    previousPage: _previousProblem,
                  ),
      ),
    );
  }

  Future<void> saveHealthResult() async {
    var uid = FirebaseAuth.instance.currentUser.uid;
    String questionnaireNo = 'HQ';
    String split;
    int latestID;
    NumberFormat format = NumberFormat('0000000000');
    await FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .orderBy('questionnaireNo', descending: true)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      print('size: ${querySnapshot.size}');
      if (querySnapshot.size == 0) {
        questionnaireNo += format.format(1);
      } else {
        querySnapshot.docs
            .forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
          Map data = queryDocumentSnapshot.data();
          split = data['questionnaireNo'].toString().split('HQ')[1];
          latestID = int.parse(split) + 1;
          questionnaireNo += format.format(latestID);
        });
      }
    });

    HealthResultData healthResultModel;
    if (hasProblem == true) {
      healthResultModel = HealthResultData(
          questionnaireNo: questionnaireNo,
          athleteNo: uid,
          doDate: DateTime.now(),
          questionnaireType: 'Health',
          totalPoint: totalScore,
          answerList: answer_list,
          healthSymptom: _healthChoosing,
          caseReceived: false,
          caseFinished: false);
    } else {
      for (int i = 0; i < questionSize; i++) {
        answer_list["Q${i + 1}"] = 0;
      }
      healthResultModel = HealthResultData(
          questionnaireNo: questionnaireNo,
          athleteNo: uid,
          doDate: DateTime.now(),
          questionnaireType: 'Health',
          totalPoint: 0,
          answerList: answer_list,
          healthSymptom: 'None',
          caseReceived: false,
          caseFinished: false);
    }
    Map<String, dynamic> data = healthResultModel.toMap();

    final collectionReference =
        FirebaseFirestore.instance.collection('HealthQuestionnaireResult');
    DocumentReference docReference = collectionReference.doc();
    docReference.set(data).then((value) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('รายงานผลเสร็จสิ้น'),
              content: hasProblem == true
                  ? Text('บันทึกข้อมูลอาการ${_healthChoosing}เรียบร้อย')
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
}
