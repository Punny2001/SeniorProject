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

  LineChartBarData get getHealthChart => LineChartBarData(
        isCurved: true,
        color: Colors.purple[200],
        belowBarData: BarAreaData(show: false),
        spots: [
          for (int i = 0; i < healthResultDataList.length; i++)
            FlSpot(
                i.toDouble(), healthResultDataList[i]['totalPoint'].toDouble()),
        ],
      );

  LineChartBarData get getPhysicalChart => LineChartBarData(
        isCurved: true,
        belowBarData: BarAreaData(show: false),
        spots: [
          for (int i = 0; i < physicalResultDataList.length; i++)
            FlSpot(i.toDouble(),
                physicalResultDataList[i]['totalPoint'].toDouble()),
        ],
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('SEPT', style: style);
        break;
      case 7:
        text = const Text('OCT', style: style);
        break;
      case 12:
        text = const Text('DEC', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    print(healthResultDataList[0]['doDate'].runtimeType);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Expanded(
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 12,
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
                getTitlesWidget: bottomTitleWidgets,
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
