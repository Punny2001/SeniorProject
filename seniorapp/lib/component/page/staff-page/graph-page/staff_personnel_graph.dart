import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_graph.dart';

class StaffPersonnelGraph extends StatefulWidget {
  final String athleteUID;
  const StaffPersonnelGraph({
    Key key,
    this.athleteUID,
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
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Ink(
              decoration: ShapeDecoration(
                shape: const CircleBorder(),
                color: Colors.blue.shade200,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                alignment: Alignment.centerRight,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
      body: AthleteGraph(
        isStaff: true,
        uid: widget.athleteUID,
      ),
    );
  }
}
