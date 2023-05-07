import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressBar extends StatelessWidget {
  final int scores;

  const ProgressBar({Key key, @required this.scores}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      leading: Text(
        '0',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.green[800],
        ),
      ),
      lineHeight: 20.0,
      barRadius: const Radius.circular(10),
      trailing: Text(
        '100',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red[800],
        ),
      ),
      animation: true,
      percent: scores / 100,
      progressColor: getColor(scores),
    );
  }
}

Color getColor(int scores) {
  if (scores <= 25) {
    return Colors.green[800];
  } else if (scores <= 50) {
    return Colors.yellow[600];
  } else if (scores <= 75) {
    return Colors.orange[800];
  } else if (scores <= 100) {
    return Colors.red[800];
  }
}
