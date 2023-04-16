import 'package:flutter/material.dart';

class Answer extends StatefulWidget {
  final VoidCallback selectHandler;
  final String answerText;
  final int answerScore;
  final int answerList;

  Answer(
    this.selectHandler,
    this.answerText,
    this.answerScore,
    this.answerList,
  );

  @override
  State<Answer> createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.width;
    print('Answer score: ${widget.answerScore}');
    print('Answer list: ${widget.answerList}');
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      width: w,
      child: RaisedButton(
        highlightColor: Colors.green[100],
        onPressed: widget.selectHandler,
        padding: EdgeInsets.zero,
        color: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Text(
          widget.answerText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            overflow: TextOverflow.clip,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
