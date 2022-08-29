import 'package:flutter/material.dart';
import './quiz.dart';
import './result.dart';

class MentalQuiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MentalQuiz();
  }
}

class _MentalQuiz extends State<MentalQuiz> {
  var _questionIndex = 0;
  var _totalScore = 0;

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;

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
      'questionText': 'Insomnia after going to bed for morethan 30 minutes.',
      'answerText': [
        {'text': 'Never had symptoms', 'score': 0},
        {'text': 'Less than 1 time/week', 'score': 1},
        {'text': 'Have problems 1-2 times/week', 'score': 2},
        {'text': 'More trouble 3 times/week or more', 'score': 3}
      ]
    },
    {
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
      'questionText': 'How often do you use sleeping pills?',
      'answerText': [
        {'text': 'Never used', 'score': 0},
        {'text': 'Use less than 1 time/week', 'score': 1},
        {'text': 'Use 1-2 times/week', 'score': 2},
        {'text': 'Use more than 3 times/week or more', 'score': 3}
      ]
    },
    {
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
          title: Text('Mental Questionare'),
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
            : Result(_totalScore, _resetQuiz),
      ),
    );
  }
}
