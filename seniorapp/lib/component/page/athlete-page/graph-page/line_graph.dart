import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AthleteLineGraph extends StatelessWidget {
  final List<Map<String, dynamic>> healthResultDataList;
  final List<Map<String, dynamic>> physicalResultDataList;

  const AthleteLineGraph({
    Key key,
    @required this.healthResultDataList,
    @required this.physicalResultDataList,
  }) : super(key: key);

  static double getWeekDay(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    int week_days;

    if (dateTime.month == 12 && dateTime.day == 31) {
      week_days = 52;
    } else {
      int days = dateTime.month * dateTime.day;
      week_days = (days / 7).floor() + 1;
    }

    return week_days.toDouble();
  }

  LineChartBarData get getHealthChart => LineChartBarData(
        isCurved: true,
        color: Colors.purple[200],
        belowBarData: BarAreaData(show: false),
        spots: [
          for (int i = 0; i < healthResultDataList.length; i++)
            FlSpot(getWeekDay(healthResultDataList[i]['doDate']),
                healthResultDataList[i]['totalPoint'].toDouble()),
        ],
      );

  LineChartBarData get getPhysicalChart => LineChartBarData(
        isCurved: true,
        belowBarData: BarAreaData(show: false),
        spots: [
          for (int i = 0; i < physicalResultDataList.length; i++)
            FlSpot(getWeekDay(physicalResultDataList[i]['doDate']),
                physicalResultDataList[i]['totalPoint'].toDouble()),
        ],
      );

  // Widget bottomTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     color: Color(0xff72719b),
  //     fontWeight: FontWeight.bold,
  //     fontSize: 16,
  //   );
  //   Widget text;
  //   switch (value.toInt()) {
  //     case 2:
  //       text = const Text('SEPT', style: style);
  //       break;
  //     case 7:
  //       text = const Text('OCT', style: style);
  //       break;
  //     case 12:
  //       text = const Text('DEC', style: style);
  //       break;
  //     default:
  //       text = const Text('');
  //       break;
  //   }

  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     space: 10,
  //     child: text,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Expanded(
      child: LineChart(
        LineChartData(
          minX: getWeekDay(Timestamp.now()) - 12 < 0
              ? getWeekDay(Timestamp.now()) - getWeekDay(Timestamp.now())
              : getWeekDay(Timestamp.now()) - 12,
          maxX: getWeekDay(Timestamp.now()),
          minY: 0,
          maxY: 100,
          lineBarsData: [
            getHealthChart,
            getPhysicalChart,
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              axisNameSize: w * 0.1,
              axisNameWidget: Text(
                'วันที่',
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
