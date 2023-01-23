import 'dart:async';
import 'package:async/async.dart' show StreamZip;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AthleteGraph extends StatefulWidget {
  const AthleteGraph({Key key}) : super(key: key);

  @override
  State<AthleteGraph> createState() => _AthleteGraphState();
}

class _AthleteGraphState extends State<AthleteGraph> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  List<Map<String, dynamic>> healthDatalist = [];
  List<Map<String, dynamic>> physicalDatalist = [];
  bool isLoading = true;
  Timer _timer;

  getHealthData() {
    FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('athleteUID', isEqualTo: uid)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        healthDatalist.add(element.data());
      });
    });
  }

  Stream<List<QuerySnapshot>> getData() {
    Stream healthQuestionnaire = FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('athleteUID', isEqualTo: uid, isNull: false)
        .snapshots();
    Stream physicalQuestionnaire = FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .where('athleteUID', isEqualTo: uid, isNull: false)
        .snapshots();

    return StreamZip([healthQuestionnaire, physicalQuestionnaire]);
  }

  getPhysicalData() {
    FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .where('athleteUID', isEqualTo: uid)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        physicalDatalist.add(element.data());
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
    _timer = Timer(Duration(seconds: 1), () {
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
    List<ChartData> chartData = [];
    return isLoading
        ? Center(
            child: CupertinoActivityIndicator(),
          )
        : StreamBuilder(builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              List<QuerySnapshot> querySnapshot = snapshot.data.toList();

              List<QueryDocumentSnapshot> documentSnapshot = [];
              querySnapshot.forEach((query) {
                documentSnapshot.addAll(query.docs);
              });

              List<Map<String, dynamic>> mappedData = [];
              for (QueryDocumentSnapshot doc in documentSnapshot) {
                mappedData.add(doc.data());
              }
              for (int index = 0; index < mappedData.length; index++) {
                Map<String, dynamic> data = mappedData[index];
                chartData.add(ChartData.fromMap(data));
              }
              return Container(
                child: Column(
                  children: [
                    SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        maximumLabelWidth: 30,
                      ),
                      primaryYAxis: CategoryAxis(
                        maximumLabelWidth: 300,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: const CircularProgressIndicator(),
              );
            }
          });
  }
}

class ChartData {
  final DateTime xValue;
  final int yValue;
  ChartData({this.xValue, this.yValue});
  ChartData.fromMap(Map<String, dynamic> dataMap)
      : xValue = DateTime.parse(dataMap['doDate'].toDate().toString()),
        yValue = dataMap['totalPoint'];
}
