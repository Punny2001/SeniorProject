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

  ScatterSpot getHealthChart(Map<String, dynamic> healthResultDataList) {
    ScatterSpot spot;

    spot = ScatterSpot(
      getWeekDay(firstJan, (healthResultDataList['doDate']).toDate()),
      healthResultDataList['totalPoint'].toDouble(),
      show: true,
      color: Colors.purple,
    );

    return spot;
  }

  ScatterSpot getPhysicalChart(Map<String, dynamic> physicalResultDataList) {
    ScatterSpot spot;

    spot = ScatterSpot(
      getWeekDay(firstJan, (physicalResultDataList['doDate']).toDate()),
      physicalResultDataList['totalPoint'].toDouble(),
      show: true,
      color: Colors.blue,
    );

    return spot;
  }

  double getMinX() {
    return getWeekDay(firstJan, now) - selectedWeek.toDouble() > 0.0
        ? getWeekDay(firstJan, now) - selectedWeek.toDouble()
        : 1.0;
  }

  double getMaxX() {
    return getWeekDay(firstJan, now);
  }

  @override
  Widget build(BuildContext context) {
    print(healthResultDataList);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Expanded(
      child: Container(
        padding:
            EdgeInsets.only(top: h * 0.05, right: w * 0.05, bottom: h * 0.03),
        child: ScatterChart(
          ScatterChartData(
            scatterLabelSettings: ScatterLabelSettings(
              getLabelFunction: (spotIndex, spot) {},
            ),
            gridData: FlGridData(verticalInterval: 1, horizontalInterval: 10),
            minX: getMinX(),
            maxX: getMaxX(),
            minY: 0.0,
            maxY: 100.0,
            scatterSpots: [
              if (healthResultDataList != null)
                for (int i = (healthResultDataList.length) - 1; i >= 0; i--)
                  if (getWeekDay(firstJan,
                          healthResultDataList[i]['doDate'].toDate()) >=
                      getWeekDay(firstJan, now) - selectedWeek.toDouble())
                    getHealthChart(healthResultDataList[i]),
              if (physicalResultDataList != null)
                for (int i = (physicalResultDataList.length) - 1; i >= 0; i--)
                  if (getWeekDay(firstJan,
                          physicalResultDataList[i]['doDate'].toDate()) >=
                      getWeekDay(firstJan, now) - selectedWeek.toDouble())
                    getPhysicalChart(physicalResultDataList[i]),
            ],
            titlesData: FlTitlesData(
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
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
                  interval: 1,
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
                  interval: 10,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
