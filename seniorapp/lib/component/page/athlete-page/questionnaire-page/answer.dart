import 'package:flutter/material.dart';

class Answer extends StatefulWidget {
  final VoidCallback selectHandler;
  final String answerText;

  Answer(this.selectHandler, this.answerText);

  @override
  State<Answer> createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      width: w,
      child: RaisedButton(
        onPressed: () {
          setState(() {
            if (_isSelected == false) {
              _isSelected = true;
            } else {
              _isSelected = false;
            }
          });
        },
        padding: EdgeInsets.zero,
        color: _isSelected == true ? Colors.green[100] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Text(
          widget.answerText,
          style: TextStyle(
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
