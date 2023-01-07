import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/result.dart';
import 'package:seniorapp/component/result-data/mental_result_data.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'questionnaire.dart';

class MentalQuestionnaire extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MentalQuestionnaire();
  }
}

class _MentalQuestionnaire extends State<MentalQuestionnaire> {
  GlobalKey updateState = GlobalKey();
  var _questionIndex = 0;
  int totalScore;
  Map<String, int> answer_list = {"Q1": 0};
  String uid = FirebaseAuth.instance.currentUser.uid;
  Athlete athData;

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

  void _answerMentalPart(String health) {
    setState(() {
      _healthChoosing = health;
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

  @override
  Widget build(BuildContext context) {
    void getAthData() {
      FirebaseFirestore.instance.collection('Athlete').doc(uid).get().then(
        (snapshot) {
          Map data = snapshot.data();
          athData = Athlete.fromMap(data);
          print(athData.athlete_no);
        },
      );
    }

    final _questionsPart1 = [
      {
        'questionNo': 'Q1',
        'questionText': 'นอนไม่หลับหลังจากเข้านอนไปแล้วนานกว่า 30 นาที',
        'answerText': [
          {'text': 'ไม่เคยมีอาการ', 'score': 0},
          {'text': 'น้อยกว่า 1 ครั้ง/สัปดาห์ ', 'score': 8},
          {'text': 'มีปัญหา 1-2 ครั้ง/สัปดาห์ ', 'score': 17},
          {'text': 'มีปัญหามากกว่า 3 ครั้ง/สัปดาห์หรือมากกว่า', 'score': 25}
        ]
      },
      {
        'questionNo': 'Q2',
        'questionText': 'ตื่นกลางดึกหรือตื่นช้ากว่าปกติ',
        'answerText': [
          {'text': 'ไม่เคยมีอาการ', 'score': 0},
          {'text': 'น้อยกว่า 1 ครั้ง/สัปดาห์ ', 'score': 8},
          {'text': 'มีปัญหา 1-2 ครั้ง/สัปดาห์ ', 'score': 17},
          {'text': 'มีปัญหามากกว่า 3 ครั้ง/สัปดาห์หรือมากกว่า', 'score': 25}
        ]
      },
      {
        'questionNo': 'Q3',
        'questionText': 'ท่านใช้ยานอนหลับบ่อยครั้งเพียงใด',
        'answerText': [
          {'text': 'ไม่เคยมีอาการ', 'score': 0},
          {'text': 'น้อยกว่า 1 ครั้ง/สัปดาห์ ', 'score': 8},
          {'text': 'มีปัญหา 1-2 ครั้ง/สัปดาห์ ', 'score': 17},
          {'text': 'มีปัญหามากกว่า 3 ครั้ง/สัปดาห์หรือมากกว่า', 'score': 25}
        ]
      },
      {
        'questionNo': 'Q4',
        'questionText':
            'ในระยะ 1 เดือนที่ผ่านมา คุณภาพการนอนโดยรวมของท่านเป็นอย่างไร',
        'answerText': [
          {'text': 'ดีมาก', 'score': 0},
          {'text': 'ดี', 'score': 8},
          {'text': 'ไม่ค่อยดี', 'score': 17},
          {'text': 'ไม่ดีเลย', 'score': 25}
        ]
      },
    ];

    questionSize = _questionsPart1.length;

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
      if (_questionIndex < _questionsPart1.length) {
        print('We have more question');
      }
    }

    void _previousQuestion(String health) {
      setState(() {
        if (_questionIndex == 0) {
          _healthChoosing = health;
          answer_health = false;
        } else if (_questionIndex <= _questionsPart1.length) {
          _questionIndex--;
        }
      });
    }

    void _nextQuestion() {
      setState(() {
        if (_questionIndex == _questionsPart1.length) {
          isResult = true;
        } else if (_questionIndex >= 0) {
          _questionIndex++;
        }
      });
    }

    void _previousFromResult() {
      setState(() {
        _questionIndex = _questionsPart1.length - 1;
      });
    }

    getAthData();

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
      backgroundColor: Colors.white,
      body: Container(
        padding: (isResult == true && _questionIndex == _questionsPart1.length)
            ? EdgeInsets.only(
                top: h * 0.3,
              )
            : EdgeInsets.only(
                top: h / 3,
              ),
        child: _questionIndex < _questionsPart1.length
            ? Questionnaire(
                answerQuestion: _answerQuestion,
                questionIndex: _questionIndex,
                questions: _questionsPart1,
                questionType: 'Mental',
                nextPage: _nextQuestion,
                previousPage: _previousQuestion,
              )
            : Result(
                resultScore: _findTotalScore(),
                resetHandler: _resetQuestionnaire,
                insertHandler: saveMentalResult,
                questionType: 'Mental',
                previousPage: _previousFromResult,
              ),
      ),
    );
  }

  Future<void> saveMentalResult() async {
    var uid = FirebaseAuth.instance.currentUser.uid;
    String questionnaireNo = 'HQ';
    String split;
    int latestID;
    NumberFormat format = NumberFormat('0000000000');
    await FirebaseFirestore.instance
        .collection('MentalQuestionnaireResult')
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

    MentalResultData mentalResultModel;
    if (hasProblem == true) {
      mentalResultModel = MentalResultData(
          questionnaireNo: questionnaireNo,
          athleteNo: athData.athlete_no,
          athleteUID: uid,
          doDate: DateTime.now(),
          questionnaireType: 'Mental',
          totalPoint: totalScore,
          answerList: answer_list,
          caseReceived: false,
          caseFinished: false);
    } else {
      for (int i = 0; i < questionSize; i++) {
        answer_list["Q${i + 1}"] = 0;
      }
      mentalResultModel = MentalResultData(
          questionnaireNo: questionnaireNo,
          athleteNo: athData.athlete_no,
          athleteUID: uid,
          doDate: DateTime.now(),
          questionnaireType: 'Mental',
          totalPoint: 0,
          answerList: answer_list,
          caseReceived: false,
          caseFinished: false);
    }
    Map<String, dynamic> data = mentalResultModel.toMap();

    final collectionReference =
        FirebaseFirestore.instance.collection('MentalQuestionnaireResult');
    DocumentReference docReference = collectionReference.doc();
    docReference.set(data).then((value) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('รายงานผลเสร็จสิ้น'),
              content: const Text('บันทึกข้อมูลปัญหารการนอนหลับเรียบร้อย'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      isResult = false;
                    });
                  },
                  child: const Text('โอเค'),
                ),
              ],
            );
          }).then((value) => print('Insert data to Firestore successfully'));
    });
  }
}
