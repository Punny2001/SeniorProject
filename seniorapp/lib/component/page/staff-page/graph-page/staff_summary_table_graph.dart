import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StaffSummaryTableGraph extends StatelessWidget {
  final List<Map<String, dynamic>> healthResultDataList;
  final List<Map<String, dynamic>> physicalResultDataList;
  const StaffSummaryTableGraph({
    Key key,
    this.healthResultDataList,
    this.physicalResultDataList,
  }) : super(key: key);

  int countNumberOfAthlete(List<Map<String, dynamic>> inputList) {
    Set targetSet = Set<String>();
    inputList.forEach((element) {
      targetSet.add(element['athleteUID']);
    });
    return targetSet.length;
  }

  int countNumberOfAllAthlete() {
    Set targetSet = Set<String>();

    healthResultDataList.forEach((element) {
      targetSet.add(element['athleteUID']);
    });
    physicalResultDataList.forEach((element) {
      targetSet.add(element['athleteUID']);
    });

    return targetSet.length;
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(
        top: h * 0.03,
        bottom: h * 0.05,
        right: w * 0.05,
        left: w * 0.03,
      ),
      child: Table(
        border: const TableBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          top: BorderSide(width: 1),
          bottom: BorderSide(width: 1),
          right: BorderSide(width: 1),
          left: BorderSide(width: 1),
          horizontalInside: BorderSide(width: 1),
          verticalInside: BorderSide(width: 1),
        ),
        children: [
          TableRow(
            children: [
              SizedBox(
                child: get_text(h: h, stringText: '', isBold: true),
              ),
              Container(
                alignment: Alignment.center,
                height: h * 0.075,
                child: get_text(
                    h: h, stringText: 'Number of Athletes', isBold: true),
                color: Colors.blue[200],
              ),
              Container(
                height: h * 0.075,
                alignment: Alignment.center,
                child:
                    get_text(h: h, stringText: 'Number of Cases', isBold: true),
                color: Colors.blue[200],
              ),
            ],
          ),
          TableRow(
            children: [
              Container(
                alignment: Alignment.center,
                height: h * 0.05,
                child: get_text(h: h, stringText: 'All Problems', isBold: true),
                color: Colors.blue[200],
              ),
              Container(
                alignment: Alignment.center,
                height: h * 0.05,
                child: get_text(
                    h: h,
                    stringText: (countNumberOfAllAthlete()).toString(),
                    isBold: false),
                color: Colors.blue[50],
              ),
              Container(
                alignment: Alignment.center,
                height: h * 0.05,
                child: get_text(
                  h: h,
                  stringText: (healthResultDataList.length +
                          physicalResultDataList.length)
                      .toString(),
                  isBold: false,
                ),
                color: Colors.blue[50],
              ),
            ],
          ),
          TableRow(
            children: [
              Container(
                alignment: Alignment.center,
                height: h * 0.05,
                child: get_text(h: h, stringText: 'Injury', isBold: true),
                color: Colors.blue[200],
              ),
              Container(
                alignment: Alignment.center,
                height: h * 0.05,
                child: get_text(
                    h: h,
                    stringText:
                        countNumberOfAthlete(physicalResultDataList).toString(),
                    isBold: false),
                color: Colors.blue[50],
              ),
              Container(
                alignment: Alignment.center,
                height: h * 0.05,
                child: get_text(
                  h: h,
                  stringText: physicalResultDataList.length.toString(),
                  isBold: false,
                ),
                color: Colors.blue[50],
              ),
            ],
          ),
          TableRow(
            children: [
              Container(
                alignment: Alignment.center,
                height: h * 0.05,
                child: get_text(h: h, stringText: 'Illness', isBold: true),
                color: Colors.blue[200],
              ),
              Container(
                alignment: Alignment.center,
                height: h * 0.05,
                child: get_text(
                    h: h,
                    stringText:
                        countNumberOfAthlete(healthResultDataList).toString(),
                    isBold: false),
                color: Colors.blue[50],
              ),
              Container(
                alignment: Alignment.center,
                height: h * 0.05,
                child: get_text(
                  h: h,
                  stringText: healthResultDataList.length.toString(),
                  isBold: false,
                ),
                color: Colors.blue[50],
              ),
            ],
          )
        ],
      ),
    );
  }
}

Text get_text({double h, String stringText, bool isBold}) {
  Text text = Text(
    stringText,
    textAlign: TextAlign.center,
    style: TextStyle(
      height: 1.5,
      wordSpacing: 1.0,
      fontSize: h * 0.02,
      fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
    ),
  );
  return text;
}
