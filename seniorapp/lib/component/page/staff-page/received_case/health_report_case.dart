import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/decoration/format_date.dart';

class HealthReportCase extends StatefulWidget {
  String docID;
  String questionnaireNo;
  String athleteNo;
  String questionnaireType;
  DateTime doDate;
  int totalPoint;
  Map<String, int> answerList;
  String healthSymptom;
  bool caseFinished;
  VoidCallback finishCaseHandler;

  HealthReportCase(
      {@required this.docID,
      @required this.questionnaireNo,
      @required this.answerList,
      @required this.athleteNo,
      @required this.doDate,
      @required this.healthSymptom,
      @required this.questionnaireType,
      @required this.totalPoint,
      @required this.caseFinished,
      this.finishCaseHandler});

  @override
  State<HealthReportCase> createState() => _HealthReportCaseState();
}

class _HealthReportCaseState extends State<HealthReportCase> {
  Athlete athlete;
  Timer _timer;
  bool isLoading = false;
  void _getAthleteData() {
    FirebaseFirestore.instance
        .collection('Athlete')
        .doc(widget.athleteNo)
        .get()
        .then((snapshot) {
      Map data = snapshot.data();

      setState(() {
        athlete = Athlete.fromMap(data);
      });
    });
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    _getAthleteData();
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
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    print(widget.docID);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        primary: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Ink(
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: Colors.blue.shade200,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  alignment: Alignment.centerRight,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
      body: isLoading == true
          ? Center(
              child: Text('Loading...'),
            )
          : Container(
              width: w,
              padding: EdgeInsets.only(
                left: w * 0.1,
                right: w * 0.1,
                top: h * 0.1,
                bottom: h * 0.1,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Text(
                        widget.questionnaireNo,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Nunito',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Summary',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Nunito',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: const TextStyle(
                            fontSize: 17.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Questionnaire type: ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(text: '${widget.questionnaireType}'),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: const TextStyle(
                            fontSize: 17.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Athlete Number: ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(text: '${athlete.athlete_no}'),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: const TextStyle(
                            fontSize: 17.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Athlete Name: ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    '${athlete.firstname} ${athlete.lastname}'),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: const TextStyle(
                            fontSize: 17.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Health symptom: ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(text: '${widget.healthSymptom}  '),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: const TextStyle(
                            fontSize: 17.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Done date: ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: formatDate((widget.doDate)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Visibility(
                    visible: widget.caseFinished == false,
                    child: Container(
                      height: h * 0.1,
                      child: RaisedButton(
                        color: Colors.green[300],
                        child: Text(
                          'Finish this case',
                          style: TextStyle(
                            fontSize: h * 0.02,
                          ),
                        ),
                        onPressed: () {
                          updateData(widget.docID);
                          widget.finishCaseHandler;
                          setState(() {
                            widget.caseFinished = true;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> updateData(String docID) async {
    await FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .doc(docID)
        .update({'caseFinished': true}).then((value) {
      print('Updated data successfully');
    });
  }
}
