import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/staff-page/history/finished_case.dart';

class ChooseHistory extends StatefulWidget {
  const ChooseHistory({Key key}) : super(key: key);

  @override
  _ChooseHistoryState createState() => _ChooseHistoryState();
}

class _ChooseHistoryState extends State<ChooseHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          
          children: [
            Text('Choose type of history'),
            ElevatedButton(
              onPressed: StaffFinishedCase(),
              child: Text('Finished case'),
            ),
          ],
        ),
      ),
    );
  }
}
