import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/result-data/mental_result_data.dart';
import 'questionnaire.dart';
import './result.dart';

class MentalQuestionnaire extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MentalQuestionnaire();
  }
}

class _MentalQuestionnaire extends State<MentalQuestionnaire> {
  var _questionIndex = 0;
  var _totalScore = 0;
  Map<String, int> answer_list = {
    "Q1" : 0
  };

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;
    answer_list["Q${_questionIndex+1}"] = score;
    setState(() {
      _questionIndex += 1;
    });
    print('Index: $_questionIndex');
    if (_questionIndex < _questions.length) {
      print('We have more question');
    }
  }

  final _questions = const [
    {
      'questionNo' : 'Q1',
      'questionText': 'ใน 7 วันที่ผ่านมา ปัญหาจิตใจของท่านทำให้การเข้าร่วมฝึกซ้อมหรือแข่งขันกีฬามีปัญหาหรือไม่',
      'answerText': [
        {'text': 'เข้าร่วมการฝึกซ้อมหรือแข่งขันกีฬาได้เต็มที่ โดยไม่มีปัญหาจิตใจ', 'score': 0},
        {'text': 'เข้าร่วมการฝึกซ้อมหรือแข่งขันกีฬาได้เต็มที่ แต่มีปัญหาจิตใจ', 'score': 8},
        {'text': 'เข้าร่วมการฝึกซ้อมหรือแข่งขันกีฬาได้ไม่เต็มที่ เพราะมีปัญหาจิตใจ', 'score': 17},
        {'text': 'ไม่สามารถเข้าร่วมการฝึกซ้อมหรือแข่งขันกีฬาได้เลย เพราะมีปัญหาจิตใจ', 'score': 25}
      ]
    },
    {
      'questionNo' : 'Q2',
      'questionText':
          'ใน 7 วันที่ผ่านมา ปัญหาจิตใจของท่านส่งผลกระทบต่อการฝึกซ้อมหรือแข่งขันมากน้อยเพียงใด',
      'answerText': [
        {'text': 'ไม่ส่งผลกระทบต่อการฝึกซ้อมหรือแข่งขันเลย', 'score': 0},
        {'text': 'การฝึกซ้อมหรือแข่งขันลดลงเล็กน้อย', 'score': 6},
        {'text': 'การฝึกซ้อมหรือแข่งขันลดลงปานกลาง', 'score': 13},
        {'text': 'การฝึกซ้อมหรือแข่งขันลดลงอย่างมาก', 'score': 19},
        {'text': 'ไม่สามารถเข้าร่วมการฝึกซ้อมหรือแข่งขันได้เลย', 'score': 25}
      ]
    },
    {
      'questionNo' : 'Q3',
      'questionText': 'ใน 7 วันที่ผ่านมา ปัญหาจิตใจของท่านส่งผลกระทบต่อความสามารถในการเล่นกีฬามากน้อยเพียงใด',
      'answerText': [
        {'text': 'ไม่ส่งผลกระทบต่อความสามารถในการเล่นกีฬาเลย', 'score': 0},
        {'text': 'ความสามารถในการเล่นกีฬาลดลงเล็กน้อย', 'score': 6},
        {'text': 'ความสามารถในการเล่นกีฬาลดลงปานกลาง', 'score': 13},
        {'text': 'ความสามารถในการเล่นกีฬาลดลงอย่างมาก', 'score': 19},
        {'text': 'ไม่สามารถเข้าร่วมการฝึกซ้อมหรือแข่งขันได้เลย', 'score': 25}
      ]
    },
    {
      'questionNo' : 'Q4',
      'questionText':
          'ใน 7 วันที่ผ่านมา อาการเจ็บปวดของจิตใจของท่านซึ่งเป็นผลมาจากการเข้าร่วมการแข่งขันหรือฝึกซ้อมกีฬาอยู่ในระดับใด',
      'answerText': [
        {'text': 'ไม่เจ็บเลย', 'score': 0},
        {'text': 'เจ็บเล็กน้อย', 'score': 6},
        {'text': 'เจ็บพอประมาณ', 'score': 13},
        {'text': 'เจ็บมาก', 'score': 19},
        {'text': 'ไม่สามารถเข้าร่วมการฝึกซ้อมหรือแข่งขันได้เลย', 'score': 25}
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Mental Questionare'),
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
            ),
          ),
          body: _questionIndex < _questions.length
              ? Questionnaire(
                  answerQuestion: _answerQuestion,
                  questionIndex: _questionIndex,
                  questions: _questions,
                )
              : Result(resultScore: _totalScore, resetHandler: _resetQuiz, insertHandler: saveMentalResult)),
    );
  }

  Future<void> saveMentalResult() async {
    var uid = FirebaseAuth.instance.currentUser.uid;

    MentalResultData mentalResultModel = MentalResultData(
      athlete_no: uid,
      DoDate: DateTime.now(),
      Questionaire_type: 'Mental',
      TotalPoint: _totalScore,
      answer_list: answer_list,
    );
    Map<String, dynamic> data = mentalResultModel.toMap();

    final collectionReference = FirebaseFirestore.instance.collection('Result');
    DocumentReference docReference = collectionReference.doc();
    docReference.set(data).then((value) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Insert data successfully'),
              content: Text(
                  'Your result ID ${docReference.id} is successfully inserted!!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          }).then((value) => print('Insert data to Firestore successfully'));
    });
  }
}
