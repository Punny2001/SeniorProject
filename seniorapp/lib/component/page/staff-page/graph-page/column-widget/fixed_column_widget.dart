import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_graph.dart';
import 'package:seniorapp/component/page/staff-page/graph-page/staff_personnel_graph.dart';

class FixedColumnTable extends StatelessWidget {
  final List<Map<String, dynamic>> resultDataList;
  final List<Map<String, dynamic>> athleteList;
  const FixedColumnTable({
    Key key,
    @required this.resultDataList,
    @required this.athleteList,
  }) : super(key: key);

  String getAthleteName(Map<String, dynamic> resultData) {
    String name;
    athleteList.forEach((element) {
      if (element['athleteUID'] == resultData['athleteUID']) {
        name = element['firstname'] + '\n' + element['lastname'];
      }
    });
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 10,
      headingRowColor: MaterialStateProperty.all(Colors.blue[200]),
      dataRowColor: MaterialStateProperty.all(Colors.blue[50]),
      showBottomBorder: true,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
      ),
      columns: const [
        DataColumn(
          label: Text(
            'Athlete Name',
          ),
        ),
      ],
      rows: [
        for (int i = 0; i < resultDataList.length; i++)
          DataRow(
            cells: [
              DataCell(
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => StaffPersonnelGraph(
                          athleteUID: resultDataList[i]['athleteUID'],
                        ),
                      ),
                    );
                  },
                  child: Text(
                    getAthleteName(resultDataList[i]),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
