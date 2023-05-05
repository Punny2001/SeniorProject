import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_graph.dart';

class StaffPersonnelGraph extends StatefulWidget {
  final Map<String, dynamic> athleteData;
  const StaffPersonnelGraph({
    Key key,
    this.athleteData,
  }) : super(key: key);
  @override
  _StaffPersonnelGraphState createState() => _StaffPersonnelGraphState();
}

class _StaffPersonnelGraphState extends State<StaffPersonnelGraph> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        primary: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.athleteData['firstname'] +
              ' ' +
              widget.athleteData['lastname'],
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.of(context).pop();
            });
          },
          alignment: Alignment.centerRight,
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.blue[200],
          ),
        ),
      ),
      body: AthleteGraph(
        isStaff: true,
        uid: widget.athleteData['athleteUID'],
      ),
    );
  }
}
