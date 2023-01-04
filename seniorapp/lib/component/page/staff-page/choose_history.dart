import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/staff-page/history/finished_case.dart';
import 'package:seniorapp/component/page/staff-page/history/staff_history.dart';
import 'package:seniorapp/decoration/padding.dart';

class ChooseHistory extends StatefulWidget {
  const ChooseHistory({Key key}) : super(key: key);

  @override
  _ChooseHistoryState createState() => _ChooseHistoryState();
}

class _ChooseHistoryState extends State<ChooseHistory> {
  Map<String, Widget> _historyType = <String, Widget>{
    'finishedCase': StaffFinishedCase(),
    'medicalRecord': StaffHistory(),
  };
  String _selectedHist = 'finishedCase';

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            CupertinoSlidingSegmentedControl(
              backgroundColor: Colors.blue[200],
              thumbColor: Colors.blue[100],
              groupValue: _selectedHist,
              onValueChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedHist = value;
                  });
                }
              },
              children: const {
                'finishedCase': Text(
                  'Finished Cases',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                'medicalRecord': Text(
                  'Medical Records',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              },
            ),
            Expanded(
              child: _historyType[_selectedHist],
            )
          ],
        ),
      ),
    );
  }
}
