import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:seniorapp/component/page/athlete-page/graph-page/line_graph.dart';
import 'package:seniorapp/component/result-data/health_result_data.dart';
import 'package:seniorapp/component/result-data/physical_result_data.dart';

class AthleteGraph extends StatefulWidget {
  const AthleteGraph({Key key}) : super(key: key);

  @override
  State<AthleteGraph> createState() => _AthleteGraphState();
}

class _AthleteGraphState extends State<AthleteGraph> {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  bool isLoading = true;
  Timer _timer;

  List<Map<String, dynamic>> healthResultDataList = [];
  List<Map<String, dynamic>> physicalResultDataList = [];

  getHealthData() {
    FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('athleteUID', isEqualTo: uid)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        healthResultDataList.add(element.data());
      });
    });
  }

  getPhysicalData() {
    FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .where('athleteUID', isEqualTo: uid)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        physicalResultDataList.add(element.data());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getHealthData();
    getPhysicalData();
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
    healthResultDataList.sort(
      (a, b) => (b['doDate'].toDate()).compareTo(
        a['doDate'].toDate(),
      ),
    );
    physicalResultDataList.sort(
      (a, b) => (b['doDate'].toDate()).compareTo(
        a['doDate'].toDate(),
      ),
    );
    return isLoading
        ? Center(
            child: CupertinoActivityIndicator(),
          )
        : Column(
            children: [
              ElevatedButton(onPressed: () {}, child: Text('Hello')),
              AthleteLineGraph(
                healthResultDataList: healthResultDataList,
                physicalResultDataList: physicalResultDataList,
              ),
            ],
          );
  }
}
