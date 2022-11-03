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
      padding: EdgeInsets.only(top: 5),
      width: w,
      child: RaisedButton(
        onPressed: selectHandler,
        padding: EdgeInsets.zero,
        color: Colors.teal[600],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 80),
          decoration: ShapeDecoration(
            color: Colors.teal[600],
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
          ),
          child: Text(
            answerText,
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
