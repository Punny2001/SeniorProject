import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final Function resetHandler;
  final VoidCallback insertHandler;

  Result(this.resultScore, this.resetHandler, this.insertHandler);

  String get resultPhrase {
    var resultText = 'You did it!';
    if (resultScore <= 8)
      resultText = 'You are awesome and innocent!!';
    else if (resultScore <= 12)
      resultText = 'Pretty likeable!!';
    else if (resultScore <= 16)
      resultText = 'You are ... Strange!!';
    else
      resultText = 'You are so bad!!';
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Your Score: $resultScore',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          FlatButton(
            child: Text(
              'Save questionaire',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
            textColor: Color.fromARGB(255, 18, 92, 153),
            onPressed: insertHandler,
          ),
          // FlatButton(
          //   child: Text(
          //     'Restart Quiz!!!',
          //     style: TextStyle(decoration: TextDecoration.underline),
          //   ),
          //   textColor: Color.fromARGB(255, 18, 92, 153),
          //   onPressed: resetHandler,
          // )
        ],
      ),
    );
  }
}
