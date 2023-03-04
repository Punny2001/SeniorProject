import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('Hello'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[300],
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                onPressed: () {},
                child: Text('Accept'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
