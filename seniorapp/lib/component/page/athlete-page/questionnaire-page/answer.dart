import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final VoidCallback selectHandler;
  final String answerText;

  Answer(this.selectHandler, this.answerText);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      width: w,
      child: RaisedButton(
        onPressed: selectHandler,
        padding: EdgeInsets.zero,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Text(
          answerText,
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
