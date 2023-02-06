import 'dart:async' show Stream, Timer;
import 'package:async/async.dart' show StreamZip;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/staff-page/graph-page/staff_table_graph.dart';

class StaffGraph extends StatefulWidget {
  const StaffGraph({Key key}) : super(key: key);

  @override
  _StaffGraphState createState() => _StaffGraphState();
}

class _StaffGraphState extends State<StaffGraph> {
  bool isLoading = true;
  List<Map<String, dynamic>> latestData = [];
  Timer _timer;

  void choose_filter() {
    setState(() {});
  }

  getLatestHealthDataWeek() {
    FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .get()
        .then((snapshot) {
      setState(() {
        latestData.add(snapshot.docs.last.data());
      });
    });
  }

  getLatestPhysicalDataWeek() {
    FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .get()
        .then((snapshot) {
      setState(() {
        latestData.add(snapshot.docs.first.data());
      });
    });
  }

  Stream<List<QuerySnapshot>> getData() {
    Stream healthQuestionnaire = FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .snapshots();
    Stream physicalQuestionnaire = FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .snapshots();

    return StreamZip([healthQuestionnaire, physicalQuestionnaire]);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getLatestHealthDataWeek();
    getLatestPhysicalDataWeek();
    latestData.sort((a, b) =>
        ('${a['doDate'].toDate()}').compareTo('${b['doDate'].toDate()}'));

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
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Column(
      children: [
        isLoading
            ? const Expanded(
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              )
            : StreamBuilder(
                stream: getData(),
                builder: (BuildContext context, snapshot) {
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

                    // mappedData = add_filter(mappedData);

                    List<Map<String, dynamic>> healthDataList = [];
                    List<Map<String, dynamic>> physicalDataList = [];

                    mappedData.forEach((element) {
                      if (element['questionnaireType'] == 'Health') {
                        healthDataList.add(element);
                      } else if (element['questionnaireType'] == 'Physical') {
                        physicalDataList.add(element);
                      }
                    });

                    return StaffTableGraph();
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
      ],
    );
  }
}
