import 'package:cloud_firestore/cloud_firestore.dart';
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
          toolbarHeight: MediaQuery.of(context).size.height / 10,
          elevation: 0,
          scrolledUnderElevation: 1,
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
        padding: EdgeInsets.all(25.0),
        height: h,
        width: w,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/images/success.png', width: 70, height: 70),
                  const Text(
                    'Record Successfully',
                    style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Nunito',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ],
              ),
              SizedBox(height: 30),
               Text(
                    widget.report_id,
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
                    TextSpan(text: 'Affected System: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: '${widget.affected_system_code} | ${widget.affected_system}'),
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
                    TextSpan(text: 'Illness cause: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: '${widget.illness_cause_code} | ${widget.illness_cause}'),
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
                    TextSpan(text: 'Main Symptoms: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                    for (int i = 0; i < widget.mainSymptoms.length; i++)
                      TextSpan(text: '${widget.mainSymptomsCode[i]} | ${widget.mainSymptoms[i]}  '),
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
                    TextSpan(text: 'Date of illness: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: formatDate((widget.occured_date)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
   
  }
}
