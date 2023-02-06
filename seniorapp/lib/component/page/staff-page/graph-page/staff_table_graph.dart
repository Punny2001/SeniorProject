import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StaffTableGraph extends StatelessWidget {
  const StaffTableGraph({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(
        top: h * 0.05,
        bottom: h * 0.05,
        right: w * 0.05,
        left: w * 0.05,
      ),
      child: Table(
        border: TableBorder(
          top: BorderSide(width: 1),
          bottom: BorderSide(width: 1),
          right: BorderSide(width: 1),
          left: BorderSide(width: 1),
          horizontalInside: BorderSide(width: 1),
          verticalInside: BorderSide(width: 1),
          borderRadius: BorderRadius.all(Radius.circular(1)),
        ),
        children: [
          TableRow(
            children: [
              Text('All Problems'),
              Text('Athlete Number'),
              Text('Number of Cases'),
            ],
          ),
          TableRow(
            children: [
              Text('Injury'),
              Text('1'),
              Text('1'),
            ],
          ),
          TableRow(children: [
            Text('Illness'),
            Text('1'),
            Text('1'),
          ])
        ],
      ),
    );
  }
}
