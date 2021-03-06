import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:seniorapp/component/format_date.dart';
import 'package:seniorapp/component/page/staff-page/report/illness_report.dart';
import 'package:seniorapp/component/page/staff-page/staff_report_page/staff_report.dart';

class ReportInjuryDescription extends StatefulWidget {
  const ReportInjuryDescription({
    Key key,
    @required this.report_id,
    @required this.injuryBody,
    @required this.injuryBodyCode,
    @required this.injuryCause,
    @required this.injuryCauseCode,
    @required this.injuryType,
    @required this.injuryTypeCode,
    @required this.round_heat_training,
    @required this.athlete_no,
    @required this.no_day,
    @required this.injuryDateTime,
    @required this.report_type,
    @required this.sport_event,
    @required this.staff_uid,
  }) : super(key: key);
  final String report_id;
  final String injuryBody;
  final int injuryBodyCode;
  final String injuryCause;
  final int injuryCauseCode;
  final String injuryType;
  final int injuryTypeCode;
  final String round_heat_training;
  final String athlete_no;
  final String no_day;
  final DateTime injuryDateTime;
  final String report_type;
  final String sport_event;
  final String staff_uid;

  @override
  State<ReportInjuryDescription> createState() =>
      _ReportInjuryDescriptionState();
}

class _ReportInjuryDescriptionState extends State<ReportInjuryDescription> {
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
                  'Injury Type: ${widget.injuryTypeCode} | ${widget.injuryType}'),
              Text(
                'Injury Body Part: ${widget.injuryBodyCode} | ${widget.injuryBody}',
              ),
              Text(
                formatDate((widget.injuryDateTime)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
