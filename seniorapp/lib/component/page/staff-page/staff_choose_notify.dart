import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/staff-page/notify-page/staff_appointment_notify.dart';
import 'package:seniorapp/component/page/staff-page/notify-page/staff_notify.dart';
import 'package:seniorapp/decoration/padding.dart';

class StaffChooseNotifyPage extends StatefulWidget {
  const StaffChooseNotifyPage({Key key}) : super(key: key);

  @override
  _StaffChooseNotifyPageState createState() => _StaffChooseNotifyPageState();
}

class _StaffChooseNotifyPageState extends State<StaffChooseNotifyPage> {
  final Map<String, Widget> _notifyPage = <String, Widget>{
    'unreceivedCase': const StaffNotify(),
    'appointmentNotify': const StaffAppointmentNotify(),
  };
  String _selectedNotifyPage = 'unreceivedCase';

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            CupertinoSlidingSegmentedControl(
              backgroundColor: Colors.blue[200],
              thumbColor: Colors.blue[100],
              groupValue: _selectedNotifyPage,
              onValueChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedNotifyPage = value;
                  });
                }
              },
              children: const {
                'unreceivedCase': Text(
                  'Unreceived Case',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                'appointmentNotify': Text(
                  'Appointment',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              },
            ),
            PaddingDecorate(5),
            Expanded(
              child: _notifyPage[_selectedNotifyPage],
            )
          ],
        ),
      ),
    );
  }
}
