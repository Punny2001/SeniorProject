import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AthleteGraph extends StatefulWidget {
  const AthleteGraph({Key key}) : super(key: key);

  @override
  State<AthleteGraph> createState() => _AthleteGraphState();
}

class _AthleteGraphState extends State<AthleteGraph> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 12,
          minY: 0,
          maxY: 100,
        ),
      ),
    );
  }
}
