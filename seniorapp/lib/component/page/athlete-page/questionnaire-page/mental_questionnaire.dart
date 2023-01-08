import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/result.dart';
import 'package:seniorapp/component/result-data/mental_result_data.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'questionnaire.dart';

class MentalQuestionnaire extends StatefulWidget {
  const MentalQuestionnaire({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MentalQuestionnaire();
  }
}

class _MentalQuestionnaire extends State<MentalQuestionnaire> {
  GlobalKey updateState = GlobalKey();
  var _questionIndexPart1 = 0;
  var _questionIndexPart2 = 0;
  var _questionIndexPart3 = 0;
  int totalScore;
  Map<String, int> answer_list = {"Q1": 0};
  String uid = FirebaseAuth.instance.currentUser.uid;
  Athlete athData;
  bool isResult = false;

  int questionSize;

  void _resetQuestionnaire() {
    setState(() {
      _questionIndexPart1 = 0;
      _questionIndexPart2 = 0;
      _questionIndexPart3 = 0;
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
          {'text': 'น้อยกว่า 1 ครั้ง/สัปดาห์ ', 'score': 1},
          {'text': 'มีปัญหา 1-2 ครั้ง/สัปดาห์ ', 'score': 2},
          {'text': 'มีปัญหามากกว่า 3 ครั้ง/สัปดาห์หรือมากกว่า', 'score': 3}
        ]
      },
      {
        'questionNo': 'Q2',
        'questionText': 'ตื่นกลางดึกหรือตื่นช้ากว่าปกติ',
        'answerText': [
          {'text': 'ไม่เคยมีอาการ', 'score': 0},
          {'text': 'น้อยกว่า 1 ครั้ง/สัปดาห์ ', 'score': 1},
          {'text': 'มีปัญหา 1-2 ครั้ง/สัปดาห์ ', 'score': 2},
          {'text': 'มีปัญหามากกว่า 3 ครั้ง/สัปดาห์หรือมากกว่า', 'score': 3}
        ]
      },
      {
        'questionNo': 'Q3',
        'questionText': 'ท่านใช้ยานอนหลับบ่อยครั้งเพียงใด',
        'answerText': [
          {'text': 'ไม่เคยมีอาการ', 'score': 0},
          {'text': 'น้อยกว่า 1 ครั้ง/สัปดาห์ ', 'score': 1},
          {'text': 'มีปัญหา 1-2 ครั้ง/สัปดาห์ ', 'score': 2},
          {'text': 'มีปัญหามากกว่า 3 ครั้ง/สัปดาห์หรือมากกว่า', 'score': 3}
        ]
      },
      {
        'questionNo': 'Q4',
        'questionText':
            'ในระยะ 1 เดือนที่ผ่านมา คุณภาพการนอนโดยรวมของท่านเป็นอย่างไร',
        'answerText': [
          {'text': 'ดีมาก', 'score': 0},
          {'text': 'ดี', 'score': 1},
          {'text': 'ไม่ค่อยดี', 'score': 2},
          {'text': 'ไม่ดีเลย', 'score': 3}
        ]
      },
    ];

    final _questionsPart2 = [
      {
        'questionNo': 'Q1',
        'questionText': 'คุณมีความมั่นใจโดยรวมมากแค่ไหน?',
      },
      {
        'questionNo': 'Q2',
        'questionText': 'คุณมีความมั่นใจในการเล่นโดยที่ไม่รู้สึกเจ็บแค่ไหน?',
      },
      {
        'questionNo': 'Q3',
        'questionText': 'คุณมีความมั่นใจที่จะออกแรงมากน้อยแค่ไหน?',
      },
      {
        'questionNo': 'Q4',
        'questionText':
            'คุณคิดว่าคุณมีความมั่นใจมากแค่ไหนในการแสดงทักษะทางกีฬา?',
      },
      {
        'questionNo': 'Q5',
        'questionText':
            'คุณคิดว่าคุณมีความมั่นใจมากแค่ไหนในการที่จะไม่สนใจส่วนที่บาดเจ็บ?',
      },
    ];

    final _questionsPart3 = [
      {
        'questionNo': 'Q1',
        'questionText': 'คุณมีอาการเหนื่อยบ้างไหม?',
      },
      {
        'questionNo': 'Q2',
        'questionText': 'คุณได้หลับเพียงพอแล้วหรือยัง?',
      },
      {
        'questionNo': 'Q3',
        'questionText': 'คุณมีอาการง่วงนอนหรือไม่?',
      },
      {
        'questionNo': 'Q4',
        'questionText': 'คุณมีอาการเหนื่อยล้าหรือไม่?',
      },
      {
        'questionNo': 'Q5',
        'questionText': 'คุณมีอาการหมดแรงหรือไม่?',
      },
      {
        'questionNo': 'Q6',
        'questionText': 'คุณมีความกระฉับกระเฉงว่องไวหรือไม่?',
      },
      {
        'questionNo': 'Q7',
        'questionText': 'คุณมีความคล่องแคล่วหรือไม่?',
      },
      {
        'questionNo': 'Q8',
        'questionText': 'คุณแข็งแรงดีหรือไม่?',
      },
      {
        'questionNo': 'Q9',
        'questionText': 'คุณในตอนนี้มีสมรรถภาพดีเยี่ยมหรือไม่?',
      },
      {
        'questionNo': 'Q10',
        'questionText': 'ตอนนี้คุณมีสภาพจิดใจที่ร่าเริงหรือไม่?',
      },
      {
        'questionNo': 'Q11',
        'questionText': 'คุณมีอาการเหนืื่อยหรือเปล่า?',
      },
      {
        'questionNo': 'Q12',
        'questionText': 'คุณในตอนนี้ยังสามารถมองเห็นได้ปกติหรือเปล่า?',
      },
      {
        'questionNo': 'Q13',
        'questionText': 'คุณยังสามารถขยับส่วนของร่างกายได้ปกใช่หรือไม่?',
      },
      {
        'questionNo': 'Q14',
        'questionText': 'คุณยังสามารถมีสมาธิจดจ่อกับการเล่นกีฬาได้หรือไม่?',
      },
      {
        'questionNo': 'Q15',
        'questionText': 'คุณยังสามารถโต้ตอบบทสนทนาได้แบบปกติใช่หรือไม่?',
      },
      {
        'questionNo': 'Q16',
        'questionText': 'คุณอยากที่จะนอนพักหรือไม่?',
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
      answer_list["Q${_questionIndexPart1 + 1}"] = score;
      setState(() {
        _questionIndexPart1 += 1;
      });
      print('Index: $_questionIndexPart1');
      if (_questionIndexPart1 < _questionsPart1.length) {
        print('We have more question');
      }
    }

    void _previousQuestion(String health) {
      setState(() {
        _questionIndexPart1--;
      });
    }

    void _nextQuestion() {
      setState(() {
        if (_questionIndexPart1 == _questionsPart1.length) {
          isResult = true;
        } else if (_questionIndexPart1 >= 0) {
          _questionIndexPart1++;
        }
      });
    }

    void _previousFromResult() {
      setState(() {
        _questionIndexPart1 = _questionsPart1.length - 1;
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
        padding:
            (isResult == true && _questionIndexPart1 == _questionsPart1.length)
                ? EdgeInsets.only(
                    top: h * 0.3,
                  )
                : EdgeInsets.only(
                    top: h / 3,
                  ),
        child: _questionIndexPart1 < _questionsPart1.length
            ? Questionnaire(
                answerQuestion: _answerQuestion,
                questionIndex: _questionIndexPart1,
                questions: _questionsPart1,
                questionType: 'Mental',
                nextPage: _nextQuestion,
                previousPage: _previousQuestion,
              )
            : _questionIndexPart2 < _questionsPart2.length
                ? Questionnaire(
                    answerQuestion: _answerQuestion,
                    questionIndex: _questionIndexPart2,
                    questions: _questionsPart2,
                    questionType: 'Mental',
                    nextPage: _nextQuestion,
                    previousPage: _previousQuestion,
                  )
                : _questionIndexPart3 < _questionsPart3.length
                    ? Questionnaire(
                        answerQuestion: _answerQuestion,
                        questionIndex: _questionIndexPart3,
                        questions: _questionsPart3,
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
    String questionnaireNo = 'MQ';
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
          split = data['questionnaireNo'].toString().split('MQ')[1];
          latestID = int.parse(split) + 1;
          questionnaireNo += format.format(latestID);
        });
      }
    });

    MentalResultData mentalResultModel;

    mentalResultModel = MentalResultData(
      questionnaireNo: questionnaireNo,
      athleteNo: athData.athlete_no,
      athleteUID: uid,
      doDate: DateTime.now(),
      questionnaireType: 'Mental',
      totalPoint: totalScore,
      answerList: answer_list,
      caseReceived: false,
      caseFinished: false,
    );

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
