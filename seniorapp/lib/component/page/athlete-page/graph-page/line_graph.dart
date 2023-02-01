import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AthleteLineGraph extends StatelessWidget {
  final List<Map<String, dynamic>> healthResultDataList;
  final List<Map<String, dynamic>> physicalResultDataList;
  final int selectedWeek;

  AthleteLineGraph({
    Key key,
    this.healthResultDataList,
    this.physicalResultDataList,
    this.selectedWeek,
  }) : super(key: key);

  final DateTime now = DateTime.now();
  static final DateTime firstJan = DateTime(DateTime.now().year, 1, 1);

  // get week between first date and now
  static double getWeekDay(DateTime from, DateTime to) {
    from = DateTime.utc(from.year, from.month, from.day);
    to = DateTime.utc(to.year, to.month, to.day);
    return (to.difference(from).inDays / 7).ceil().toDouble();
  }

  LineChartBarData get getHealthChart => LineChartBarData(
        isCurved: true,
        color: Colors.purple[200],
        belowBarData: BarAreaData(show: false),
        spots: [
          for (int i = 0; i < healthResultDataList.length; i++)
            FlSpot(
                getWeekDay(
                    firstJan, (healthResultDataList[i]['doDate']).toDate()),
                healthResultDataList[i]['totalPoint'].toDouble()),
        ],
      );

  LineChartBarData get getPhysicalChart => LineChartBarData(
        isCurved: true,
        belowBarData: BarAreaData(show: false),
        spots: [
          for (int i = 0; i < physicalResultDataList.length; i++)
            FlSpot(
                getWeekDay(
                    firstJan, (physicalResultDataList[i]['doDate']).toDate()),
                physicalResultDataList[i]['totalPoint'].toDouble()),
        ],
      );

  @override
  Widget build(BuildContext context) {
    print(healthResultDataList);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Expanded(
      child: LineChart(
        LineChartData(
          minX: getWeekDay(firstJan, now) - selectedWeek.toDouble() > 0
              ? getWeekDay(firstJan, now) - selectedWeek.toDouble()
              : 0,
          maxX: getWeekDay(firstJan, now),
          minY: 0,
          maxY: 100,
          lineBarsData: [
            if (healthResultDataList != null) getHealthChart,
            if (physicalResultDataList != null) getPhysicalChart,
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              axisNameSize: w * 0.1,
              axisNameWidget: Text(
                'สัปดาห์ ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: h * 0.025,
                ),
              ),
              sideTitles: SideTitles(
                // getTitlesWidget: bottomTitleWidgets,
                showTitles: true,
                reservedSize: w * 0.1,
              ),
            ),
            leftTitles: AxisTitles(
              axisNameSize: w * 0.1,
              axisNameWidget: Text(
                'คะแนน',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: h * 0.025,
                ),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: w * 0.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
