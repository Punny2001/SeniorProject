import 'package:flutter/material.dart';
import 'package:seniorapp/decoration/format_datetime.dart';

class ScrollableColumnTable extends StatelessWidget {
  final List<Map<String, dynamic>> resultDataList;
  final List<Map<String, dynamic>> athleteList;
  const ScrollableColumnTable({
    Key key,
    @required this.resultDataList,
    @required this.athleteList,
  }) : super(key: key);

  String getAthleteDepartment(Map<String, dynamic> resultData) {
    String sportType;
    athleteList.forEach((element) {
      if (element['athleteUID'] == resultData['athleteUID']) {
        sportType = element['sportType'];
      }
    });
    return sportType;
  }

  String getProblem(Map<String, dynamic> resultData) {
    String problem;
    if (resultData['questionnaireType'] == 'Health') {
      problem = resultData['healthSymptom'];
    } else {
      problem = resultData['bodyPart'];
    }
    return problem;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showBottomBorder: true,
          headingRowColor: MaterialStateProperty.all(Colors.blue[200]),
          columns: const [
            DataColumn(label: Text('Sport Type')),
            DataColumn(label: Text('Problem Type')),
            DataColumn(label: Text('Score')),
            DataColumn(label: Text('Date')),
          ],
          rows: [
            for (int i = 0; i < resultDataList.length; i++)
              DataRow(cells: [
                DataCell(Text(getAthleteDepartment(resultDataList[i]))),
                DataCell(Text(
                    '${resultDataList[i]['questionnaireType']} | ${getProblem(resultDataList[i])}')),
                DataCell(Text(resultDataList[i]['totalPoint'].toString())),
                DataCell(Text(
                    formatDate(resultDataList[i]['doDate'].toDate(), 'Staff'))),
              ])
          ],
        ),
      ),
    );
  }
}
