import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AthleteLineGraph extends StatefulWidget {
  final List<Map<String, dynamic>> healthResultDataList;
  final List<Map<String, dynamic>> physicalResultDataList;
  final int selectedWeek;

  const AthleteLineGraph({
    Key key,
    this.healthResultDataList,
    this.physicalResultDataList,
    this.selectedWeek,
  }) : super(key: key);

  static final DateTime firstJan = DateTime(DateTime.now().year, 1, 1);

  // get week between first date and now
  static double getWeekDay(DateTime from, DateTime to) {
    from = DateTime.utc(from.year, from.month, from.day);
    to = DateTime.utc(to.year, to.month, to.day);
    return (to.difference(from).inDays / 7).ceil().toDouble();
  }

  @override
  State<AthleteLineGraph> createState() => _AthleteLineGraphState();
}

class _AthleteLineGraphState extends State<AthleteLineGraph> {
  final DateTime now = DateTime.now();
  List<int> selectedSpots = [];

  ScatterSpot getHealthChart(Map<String, dynamic> healthResultDataList) {
    ScatterSpot spot;

    spot = ScatterSpot(
      AthleteLineGraph.getWeekDay(
          AthleteLineGraph.firstJan, (healthResultDataList['doDate']).toDate()),
      healthResultDataList['totalPoint'].toDouble(),
      show: true,
      color: Colors.purple,
    );

    return spot;
  }

  ScatterSpot getPhysicalChart(Map<String, dynamic> physicalResultDataList) {
    ScatterSpot spot;

    spot = ScatterSpot(
      AthleteLineGraph.getWeekDay(AthleteLineGraph.firstJan,
          (physicalResultDataList['doDate']).toDate()),
      physicalResultDataList['totalPoint'].toDouble(),
      show: true,
      color: Colors.blue,
    );

    return spot;
  }

  double getMinX() {
    return AthleteLineGraph.getWeekDay(AthleteLineGraph.firstJan, now) -
                widget.selectedWeek.toDouble() >
            0.0
        ? AthleteLineGraph.getWeekDay(AthleteLineGraph.firstJan, now) -
            widget.selectedWeek.toDouble()
        : 1.0;
  }

  double getMaxX() {
    return AthleteLineGraph.getWeekDay(AthleteLineGraph.firstJan, now);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.healthResultDataList);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Expanded(
      child: Container(
        padding:
            EdgeInsets.only(top: h * 0.05, right: w * 0.05, bottom: h * 0.03),
        child: ScatterChart(
          ScatterChartData(
            scatterTouchData: ScatterTouchData(
              enabled: true,
              handleBuiltInTouches: false,
              touchCallback:
                  (FlTouchEvent event, ScatterTouchResponse touchResponse) {
                if (touchResponse == null ||
                    touchResponse.touchedSpot == null) {
                  return;
                }
                // Show tooltip if tap down detected
                if (event is FlTapUpEvent) {
                  final sectionIndex = touchResponse.touchedSpot.spotIndex;
                  setState(() {
                    if (selectedSpots.contains(sectionIndex)) {
                      selectedSpots.remove(sectionIndex);
                    } else {
                      selectedSpots.add(sectionIndex);
                    }
                  });
                  // Hide/clear tooltip if long press was ended or tap up detected
                }
              },
              touchTooltipData: ScatterTouchTooltipData(
                tooltipBgColor: Colors.black,
                getTooltipItems: (ScatterSpot touchedBarSpot) {
                  return ScatterTooltipItem(
                    'สัปดาห์: ',
                    textStyle: TextStyle(
                      height: 1.2,
                      color: Colors.grey[100],
                    ),
                    bottomMargin: 10,
                    children: [
                      TextSpan(
                        text: '${touchedBarSpot.x.toInt()} \n',
                        style: const TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      TextSpan(
                        text: 'คะแนน: ',
                        style: TextStyle(
                          height: 1.2,
                          color: Colors.grey[100],
                        ),
                      ),
                      TextSpan(
                        text: touchedBarSpot.y.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            showingTooltipIndicators: selectedSpots,
            gridData: FlGridData(verticalInterval: 1, horizontalInterval: 10),
            minX: getMinX(),
            maxX: getMaxX(),
            minY: 0.0,
            maxY: 100.0,
            scatterSpots: [
              if (widget.healthResultDataList != null)
                for (int i = (widget.healthResultDataList.length) - 1;
                    i >= 0;
                    i--)
                  if (AthleteLineGraph.getWeekDay(AthleteLineGraph.firstJan,
                          widget.healthResultDataList[i]['doDate'].toDate()) >=
                      AthleteLineGraph.getWeekDay(
                              AthleteLineGraph.firstJan, now) -
                          widget.selectedWeek.toDouble())
                    getHealthChart(widget.healthResultDataList[i]),
              if (widget.physicalResultDataList != null)
                for (int i = (widget.physicalResultDataList.length) - 1;
                    i >= 0;
                    i--)
                  if (AthleteLineGraph.getWeekDay(
                          AthleteLineGraph.firstJan,
                          widget.physicalResultDataList[i]['doDate']
                              .toDate()) >=
                      AthleteLineGraph.getWeekDay(
                              AthleteLineGraph.firstJan, now) -
                          widget.selectedWeek.toDouble())
                    getPhysicalChart(widget.physicalResultDataList[i]),
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
