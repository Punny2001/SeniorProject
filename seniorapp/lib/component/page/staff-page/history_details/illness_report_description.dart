import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/decoration/format_date.dart';
import 'package:seniorapp/component/page/staff-page/record/illness_record.dart';
import 'package:seniorapp/component/page/staff-page/staff_history.dart';

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
        automaticallyImplyLeading: false,
        primary: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
      body: Container(
        height: h,
        width: w,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Icon(
                      Icons.assignment_turned_in_rounded,
                      color: Colors.green,
                      size: h * 0.1,
                    ),
                  ),
                  Text(
                    'Record Successfully',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Nunito',
                      fontSize: h * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(
                  left: w * 0.1,
                  right: w * 0.1,
                  top: h * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.report_id}\n',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Nunito',
                        fontSize: h * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Summary\n',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Nunito',
                        fontSize: h * 0.025,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 17.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Main symptom(s): ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          for (int i = 0; i < widget.mainSymptoms.length; i++)
                            TextSpan(
                                text:
                                    '${widget.mainSymptomsCode[i]} | ${widget.mainSymptoms[i]}\n'),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 17.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Illness cause: ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  '${widget.illness_cause_code} | ${widget.illness_cause}\n'),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 17.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Date of injury: ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: '${formatDate(widget.occured_date)}\n',
                          ),
                        ],
                      ),
                    ),
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
                              text: 'Time of injury: ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text:
                                '${DateFormat.Hms().format(widget.occured_date)}\n',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
