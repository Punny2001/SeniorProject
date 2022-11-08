import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final Function resetHandler;
  final VoidCallback insertHandler;
  final String questionType;
  final String bodyPart;
  final String healthPart;

  Result(
      {this.resultScore,
      this.resetHandler,
      this.insertHandler,
      this.questionType,
      this.bodyPart,
      this.healthPart});

  String resultPhrase(String type) {
    var resultText = 'Hello';
    switch (type) {
      case 'health':
        {
          if (resultScore <= 25) {
            resultText = 'ระบบบันทึกข้อมูลเรียบร้อย ขอบคุณที่ให้ความร่วมมือ';
          } else if (resultScore <= 50) {
            resultText =
                'ระบบจะทำการนัดหมายแพทย์ให้ท่าน ในขณะเดียวกัน ท่านควรเฝ้าระวังอาการ${healthPart}เป็นระยะเวลา 3-5 วัน หากอาการรุนแรงขึ้นให้รีบแจ้งกลับมาทางทีมแพทย์เป็นการเร่งด่วน';
          } else if (resultScore <= 75) {
            resultText =
                'ระบบจะทำการนัดหมายแพทย์ให้ท่าน ในขณะเดียวกัน ท่านควรเฝ้าดูอาการ${healthPart}เป็นระยะเวลา 3-5 วัน  โดยมีการใช้ยาสามัญประจำบ้านร่วมด้วย หากอาการรุนแรงขึ้นให้รีบแจ้งกลับมาทางทีมแพทย์เป็นการเร่งด่วน';
          } else {
            resultText =
                'ระบบจะทำการรีบนัดหมายแพทย์ให้ท่านหรือให้ท่านนัดหมายแพทย์เพื่อทำการรักษาโดยด่วน ในขณะเดียวกัน หากท่านมีอาการอยู่ใน UCEP ท่านควรทำตามในส่วนนี้ ';
          }
          print('result text: $resultText');
        }
        break;
      case 'physical':
        {
          if (resultScore <= 25) {
            resultText = 'ระบบบันทึกข้อมูลเรียบร้อย ขอบคุณที่ให้ความร่วมมือ';
          } else if (resultScore <= 50) {
            resultText =
                'ระบบจะทำการนัดหมายแพทย์ให้ท่าน ในขณะเดียวกัน ท่านควรลดการใช้งานในบริเวณ${bodyPart}เป็นระยะเวลา 3-5 วัน';
          } else if (resultScore <= 75) {
            resultText =
                'ระบบจะทำการนัดหมายแพทย์ให้ท่าน ในขณะเดียวกัน ให้ท่านประคบเย็นพร้อมทั้งพันกระชับในส่วน${bodyPart}และลดการใช้งานในบริเวณ${bodyPart}เป็นระยะเวลา 5-7 วัน';
          } else {
            resultText =
                'ระบบจะทำการรีบนัดหมายแพทย์ให้ท่านหรือให้ท่านนัดหมายแพทย์เพื่อทำการรักษาโดยด่วน ในขณะเดียวกัน ให้ท่านประคบเย็นพร้อมทั้งพันกระชับในส่วน${bodyPart}และลดการใช้งานในบริเวณ${bodyPart}ไม่ต่ำกว่า 7 วัน';
          }
          print('result text: $resultText');
        }
        break;
      default:
        break;
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final String ucepUrl =
        'https://www.nhso.go.th/page/coverage_rights_emergency_patients';

    return Container(
      padding: EdgeInsets.only(left: w * 0.03, right: w * 0.03),
      
      child: Column(
        children: [
          Text(
            checkQuestionType(questionType),
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Container(
            padding:
                EdgeInsets.only(left: w * 0.03, right: w * 0.03, top: h * 0.03),
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: questionType == 'health'
                    ? resultScore > 75
                        ? [
                            TextSpan(
                              text: resultPhrase(questionType),
                            ),
                            TextSpan(
                              text: 'คลิกที่นี่',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launch(ucepUrl);
                                },
                            ),
                          ]
                        : [
                            TextSpan(
                              text: resultPhrase(questionType),
                            ),
                          ]
                    : resultScore > 75
                        ? [
                            TextSpan(
                              text: resultPhrase(questionType),
                            ),
                          ]
                        : [
                            TextSpan(
                              text: resultPhrase(questionType),
                            ),
                          ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: h * 0.03),
          ),
          RaisedButton(
            onPressed: insertHandler,
            padding: EdgeInsets.zero,
            color: Colors.green.shade300,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Container(
              alignment: Alignment.center,
              width: w,
              height: h * 0.07,
              child: Text(
                'ถัดไป',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String checkQuestionType(String questionType) {
    switch (questionType) {
      case 'physical':
        if (resultScore == 0) {
          return 'ท่านไม่มีอาการเจ็บป่วยทางกาย';
        } else {
          return 'ท่านมีอาการทางกาย ณ บริเวณ ${bodyPart} อยู่ที่ระดับ ${resultScore} คะแนน';
        }
        break;
      case 'health':
        if (resultScore == 0) {
          return 'ท่านไม่มีปัญหาสุขภาพ';
        } else {
          return 'ท่านมีปัญหาสุขภาพ ${healthPart} อยู่ที่ระดับ ${resultScore} คะแนน';
        }
        break;
      default:
    }
  }
}
