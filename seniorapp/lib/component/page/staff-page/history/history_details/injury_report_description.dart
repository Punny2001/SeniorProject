import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/decoration/format_datetime.dart';
import 'package:seniorapp/component/page/staff-page/record/illness_record.dart';
import 'package:seniorapp/component/page/staff-page/history/staff_history.dart';

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
                              text: 'Injury Type: ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  '${widget.injuryTypeCode} | ${widget.injuryType}\n'),
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
                              text: 'Injury Body Part: ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  '${widget.injuryBodyCode} | ${widget.injuryBody}\n'),
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
                            text: '${formatDate(
                              widget.injuryDateTime,
                              'Staff',
                            )}\n',
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
                                '${DateFormat.Hms().format(widget.injuryDateTime)}\n',
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
