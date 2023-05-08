import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_graph.dart';
import 'package:seniorapp/main.dart';

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
  List<Map<String, dynamic>> physicalHistoryListForStaff = [];
  List<Map<String, dynamic>> healthHistoryListForStaff = [];
  bool isLoading = true;
  Timer _timer;

  void staffListenForPhysicalHistory() {
    physicalQuestionnaireCollection
        .where('athleteUID', isEqualTo: widget.athleteData['athleteUID'])
        .snapshots()
        .listen((snapshot) {
      List<Map<String, dynamic>> physicalQuestionnaire = [];
      int index = 0;
      snapshot.docs.forEach((doc) {
        physicalQuestionnaire.add(doc.data());
        physicalQuestionnaire[index]['questionnaireID'] = doc.reference.id;
        index += 1;
      });
      setState(() {
        physicalHistoryListForStaff = physicalQuestionnaire;
      });
    });
  }

  void staffListenForHealthHistory() {
    healthQuestionnaireCollection
        .where('athleteUID', isEqualTo: widget.athleteData['athleteUID'])
        .snapshots()
        .listen((snapshot) {
      List<Map<String, dynamic>> healthQuestionnaire = [];
      int index = 0;
      snapshot.docs.forEach((doc) {
        healthQuestionnaire.add(doc.data());
        healthQuestionnaire[index]['questionnaireID'] = doc.reference.id;
        index += 1;
      });
      setState(() {
        healthHistoryListForStaff = healthQuestionnaire;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    staffListenForHealthHistory();
    staffListenForPhysicalHistory();
    _timer = Timer(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.athleteData['athleteUID']);
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
      body: isLoading
          ? Center(
            child: CupertinoActivityIndicator(),
          )
          : AthleteGraph(
              isStaff: true,
              healthHistoryListForStaff: healthHistoryListForStaff,
              physicalHistoryListForStaff: physicalHistoryListForStaff,
            ),
    );
  }
}
