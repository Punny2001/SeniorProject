import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:seniorapp/component/result-data/Illness_result_data.dart';
import 'questionnaire.dart';
import './result.dart';

class IllnessQuiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IllnessQuiz();
  }
}

class _IllnessQuiz extends State<IllnessQuiz> {
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
      'questionText': 'Insomnia after going to bed for morethan 30 minutes.',
      'answerText': [
        {'text': 'Never had symptoms', 'score': 0},
        {'text': 'Less than 1 time/week', 'score': 1},
        {'text': 'Have problems 1-2 times/week', 'score': 2},
        {'text': 'More trouble 3 times/week or more', 'score': 3}
      ]
    },
    {
      'questionNo' : 'Q2',
      'questionText':
          'Do you wake up at midnight or wake up late than normally?',
      'answerText': [
        {'text': 'Never had symptoms', 'score': 0},
        {'text': 'Less than 1 time/week', 'score': 1},
        {'text': 'Have problems 1-2 times/week', 'score': 2},
        {'text': 'More trouble 3 times/week or more', 'score': 3}
      ]
    },
    {
      'questionNo' : 'Q3',
      'questionText': 'How often do you use sleeping pills?',
      'answerText': [
        {'text': 'Never used', 'score': 0},
        {'text': 'Use less than 1 time/week', 'score': 1},
        {'text': 'Use 1-2 times/week', 'score': 2},
        {'text': 'Use more than 3 times/week or more', 'score': 3}
      ]
    },
    {
      'questionNo' : 'Q4',
      'questionText':
          'In the past 1 month, how good was your overall sleeping?',
      'answerText': [
        {'text': 'Very good', 'score': 0},
        {'text': 'Good', 'score': 1},
        {'text': 'Not very good', 'score': 2},
        {'text': 'not good at all', 'score': 3}
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Illness Questionare'),
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
            ),
          ),
          body: _questionIndex < _questions.length
              ? Quiz(
                  answerQuestion: _answerQuestion,
                  questionIndex: _questionIndex,
                  questions: _questions,
                )
              : Result(_totalScore, _resetQuiz, saveIllnessResult)),
    );
  }

  Future<void> saveIllnessResult() async {
    var uid = FirebaseAuth.instance.currentUser.uid;

  //   IllnessResultData IllnessResultModel = IllnessResultData(
  //     athlete_no: uid,
  //     DoDate: DateTime.now(),
  //     Questionaire_type: 'Illness',
  //     TotalPoint: _totalScore,
  //     answer_list: answer_list,
  //   );
  //   Map<String, dynamic> data = IllnessResultModel.toMap();

  //   final collectionReference = FirebaseFirestore.instance.collection('Result');
  //   DocumentReference docReference = collectionReference.doc();
  //   docReference.set(data).then((value) {
  //     showDialog<void>(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text('Insert data successfully'),
  //             content: Text(
  //                 'Your result ID ${docReference.id} is successfully inserted!!'),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: const Text('OK'),
  //               ),
  //             ],
  //           );
  //         }).then((value) => print('Insert data to Firestore successfully'));
  //   });
  }
}
