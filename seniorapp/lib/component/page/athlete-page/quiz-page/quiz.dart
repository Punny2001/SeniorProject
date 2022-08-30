import 'package:flutter/material.dart';
import './question.dart';
import './answer.dart';

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final questionIndex;
  final Function answerQuestion;

  Quiz({
    @required this.questions,
    @required this.answerQuestion,
    @required this.questionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Question(
            questions[questionIndex]['questionText'] as String,
          ),
          // ... makes separating list into a value of a list, then take it into child list.
          ...(questions[questionIndex]['answerText']
                  as List<Map<String, Object>>)
              .map((answer) {
                print(answer);
            return Answer(
                () => answerQuestion(answer['score']), answer['text']);
          }).toList()
        ],
      ),
    );
  }
}
