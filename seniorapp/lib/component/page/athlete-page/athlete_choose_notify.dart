import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/notify-page/athlete_appoint_notify.dart';
import 'package:seniorapp/component/page/athlete-page/notify-page/athlete_notify.dart';
import 'package:seniorapp/decoration/padding.dart';

class AthleteChooseNotify extends StatefulWidget {
  const AthleteChooseNotify({Key key}) : super(key: key);

  @override
  _AthleteChooseNotifyState createState() => _AthleteChooseNotifyState();
}

class _AthleteChooseNotifyState extends State<AthleteChooseNotify> {
  final Map<String, Widget> _notifyType = <String, Widget>{
    'caseNotify': const AthleteCaseNotify(),
    'appointmentNotify': const AthleteAppointmentNotify(),
  };
  String _selectedNotify = 'caseNotify';

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Column(
      children: [
        CupertinoSlidingSegmentedControl(
          backgroundColor: Colors.green[300],
          thumbColor: Colors.green[200],
          groupValue: _selectedNotify,
          onValueChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedNotify = value;
              });
            }
          },
          children: const {
            'caseNotify': Text(
              'เคสที่เสร็จสิ้น',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            'appointmentNotify': Text(
              'การนัดหมาย',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          },
        ),
        PaddingDecorate(5),
        Expanded(
          child: _notifyType[_selectedNotify],
        )
      ],
    );
  }
}
