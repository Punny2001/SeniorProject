import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/format_date.dart';
import 'package:seniorapp/component/page/staff-page/report/illness_report.dart';
import 'package:seniorapp/component/page/staff-page/staff_report_page/staff_report.dart';

class ReportIllnessDescription extends StatefulWidget {
  const ReportIllnessDescription({
    Key key,
    @required this.report_id,
    @required this.affected_system,
    @required this.affected_system_code,
    @required this.athlete_no,
    @required this.diagnosis,
    @required this.illness_cause,
    @required this.illness_cause_code,
    @required this.mainSymptoms,
    @required this.mainSymptomsCode,
    @required this.no_day,
    @required this.occured_date,
    @required this.report_type,
    @required this.sport_event,
    @required this.staff_uid,
  }) : super(key: key);
  final String report_id;
  final String affected_system;
  final int affected_system_code;
  final String athlete_no;
  final String diagnosis;
  final String illness_cause;
  final int illness_cause_code;
  final List<String> mainSymptoms;
  final List<int> mainSymptomsCode;
  final String no_day;
  final DateTime occured_date;
  final String report_type;
  final String sport_event;
  final String staff_uid;

  @override
  State<ReportIllnessDescription> createState() =>
      _ReportIllnessDescriptionState();
}

class _ReportIllnessDescriptionState extends State<ReportIllnessDescription> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.report_id),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          height: h,
          width: w,
          child: Column(
            children: [
              Text(
                'Affected System: ${widget.affected_system_code} | ${widget.affected_system}',
              ),
              const Text(
                'Main Symptoms:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              for (int i = 0; i < widget.mainSymptoms.length; i++)
                Text(
                  '${widget.mainSymptomsCode[i]} | ${widget.mainSymptoms[i]}',
                ),
              Text(
                formatDate((widget.occured_date)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
