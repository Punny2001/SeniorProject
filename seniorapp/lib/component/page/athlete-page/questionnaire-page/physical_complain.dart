import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/checking_questionnaire.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/more_questionnaire.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/result.dart';
import 'package:seniorapp/component/result-data/physical_result_data.dart';
import 'questionnaire.dart';

class PhysicalQuestionnaire extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PhysicalQuestionnaire();
  }
}

class _PhysicalQuestionnaire extends State<PhysicalQuestionnaire> {
  var _questionIndex = 0;
  var _totalScore = 0;
  var _bodyPartRound = 0;
  Map<String, int> answer_list = {"Q1": 0};

  bool isResult = true;
  bool hasQuestion = false;
  bool hasProblem = true;

  String _bodyChoosing;
  String insertedBody;

  int questionSize;

  void _resetQuestionnaire() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _bodyPartRound = 0;
      isResult = true;
      hasProblem = true;
    });
  }

  void _answerBodyPart(String body) {
    if (_bodyPartRound == 1) {
      insertedBody = body;
      print('round: $_bodyPartRound');
    }
    setState(() {
      _bodyPartRound += 1;
      _bodyChoosing = body;
    });
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

  final body_part = const [
    {
      'questionText': 'โปรดเลือกอวัยวะที่ได้รับการบาดเจ็บมากที่สุด',
      'answerText': [
        {
          'text': 'ส่วนหัวและลำตัว',
        },
        {
          'text': 'ร่างกายส่วนบน',
        },
        {
          'text': 'ร่างกายส่วนล่าง',
        },
      ]
    }
  ];

  final body_injured = [
    {
      'questionText': 'โปรดเลือกอวัยวะที่ได้รับการบาดเจ็บมากที่สุด',
      'ส่วนหัวและลำตัว': [
        'ใบหน้า',
        'ศีรษะ',
        'คอ / กระดูกสันหลังส่วนคอ',
        'กระดูกสันหลังทรวงอก / หลังส่วนบน',
        'กระดูกอก / ซี่โครง',
        'กระดูกสันหลังส่วนเอว / หลังส่วนล่าง',
        'หน้าท้อง',
        'กระดูกเชิงกราน / กระดูกสันหลังส่วนกระเบ็นเหน็บ / ก้น',
      ],
      'ร่างกายส่วนบน': [
        'ไหล่ / กระดูกไหปลาร้า',
        'ต้นแขน',
        'ข้อศอก',
        'ปลายแขน',
        'ข้อมือ',
        'มือ',
        'นิ้ว',
        'นิ้วหัวแม่มือ',
      ],
      'ร่างกายส่วนล่าง': [
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
            'ใน 7 วันที่ผ่านมา ปัญหา${_bodyChoosing}ของท่านทำให้การเข้าร่วมฝึกซ้อมหรือแข่งขันกีฬามีปัญหาหรือไม่',
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
            'ใน 7 วันที่ผ่านมา ปัญหา${_bodyChoosing}ของท่านส่งผลกระทบต่อการฝึกซ้อมหรือแข่งขันมากน้อยเพียงใด',
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
            'ใน 7 วันที่ผ่านมา ปัญหา${_bodyChoosing}ของท่านส่งผลกระทบต่อความสามารถในการเล่นกีฬามากน้อยเพียงใด',
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
            'ใน 7 วันที่ผ่านมา อาการเจ็บปวดของ${_bodyChoosing}ของท่านซึ่งเป็นผลมาจากการเข้าร่วมการแข่งขันหรือฝึกซ้อมกีฬาอยู่ในระดับใด',
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

    void _answerQuestion(int score) {
      _totalScore += score;
      answer_list["Q${_questionIndex + 1}"] = score;
      setState(() {
        _questionIndex += 1;
      });
      print('Index: $_questionIndex');
      if (_questionIndex < _questions.length) {
        print('We have more question');
      }
    }
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        backgroundColor: Colors.white,
        body: SizedBox(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Background_question.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 150.0),
                child: hasQuestion
                    ? _bodyPartRound < 2
                    ? _questionnaireDisplay(_bodyPartRound)
                    : _questionIndex < _questions.length
                    ? Questionnaire(
                  answerQuestion: _answerQuestion,
                  questionIndex: _questionIndex,
                  questions: _questions,
                  questionType: 'physical',
                )
                    : isResult
                    ? Result(
                  resultScore: _totalScore,
                  resetHandler: _resetQuestionnaire,
                  insertHandler: savePhysicalResult,
                  questionType: 'physical',
                  bodyPart: _bodyChoosing,
                )
                    : MoreQuestionnaire(_resetQuestionnaire, 'physical')
                    : hasProblem
                    ? CheckingQuestionnaire(
                    'physical', _checkingQuestion, _hasProblem)
                    : isResult
                    ? Result(
                    resultScore: 0,
                    resetHandler: _resetQuestionnaire,
                    insertHandler: savePhysicalResult,
                    questionType: 'physical')
                    : MoreQuestionnaire(_resetQuestionnaire, 'physical'),
              ),
            ],
          ),
        ),
      ),
      // : Result(_totalScore, _resetQuiz, saveHealthResult)),
    );
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('รายงานอาการบาดเจ็บ'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: hasQuestion
            ? _bodyPartRound < 2
                ? _questionnaireDisplay(_bodyPartRound)
                : _questionIndex < _questions.length
                    ? Questionnaire(
                        answerQuestion: _answerQuestion,
                        questionIndex: _questionIndex,
                        questions: _questions,
                        questionType: 'physical',
                      )
                    : isResult
                        ? Result(
                            resultScore: _totalScore,
                            resetHandler: _resetQuestionnaire,
                            insertHandler: savePhysicalResult,
                            questionType: 'physical',
                            bodyPart: _bodyChoosing,
                          )
                        : MoreQuestionnaire(_resetQuestionnaire, 'physical')
            : hasProblem
                ? CheckingQuestionnaire(
                    'physical', _checkingQuestion, _hasProblem)
                : isResult
                    ? Result(
                        resultScore: 0,
                        resetHandler: _resetQuestionnaire,
                        insertHandler: savePhysicalResult,
                        questionType: 'physical')
                    : MoreQuestionnaire(_resetQuestionnaire, 'physical'),
      ),
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
        .collection('PhysicalQuestionnareResult')
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
          athleteNo: uid,
          doDate: DateTime.now(),
          questionnaireType: 'Physical',
          totalPoint: _totalScore,
          answerList: answer_list,
          bodyPart: insertedBody,
          caseReceived: false);
    } else {
      for (int i = 0; i < questionSize; i++) {
        answer_list["Q${i + 1}"] = 0;
      }
      physicalResultModel = PhysicalResultData(
          questionnaireNo: questionnaireNo,
          athleteNo: uid,
          doDate: DateTime.now(),
          questionnaireType: 'Physical',
          totalPoint: _totalScore,
          answerList: answer_list,
          bodyPart: 'None',
          caseReceived: false);
    }
    Map<String, dynamic> data = physicalResultModel.toMap();

    final collectionReference =
        FirebaseFirestore.instance.collection('PhysicalQuestionnaireResult');
    DocumentReference docReference = collectionReference.doc();
    docReference.set(data).then((value) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('รายงานผลเสร็จสิ้น'),
              content: Text('บันทึกข้อมูลอาการ${_bodyChoosing}เรียบร้อย'),
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
          );
        }
        break;
      default:
    }
  }
}
