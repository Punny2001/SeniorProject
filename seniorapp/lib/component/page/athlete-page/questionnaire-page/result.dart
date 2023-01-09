import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:seniorapp/decoration/textfield_normal.dart';
import 'package:url_launcher/url_launcher.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final Function resetHandler;
  final VoidCallback insertHandler;
  final String questionType;
  final String bodyPart;
  final String healthPart;
  final Function previousPage;

  Result({
    this.resultScore,
    this.resetHandler,
    this.insertHandler,
    this.questionType,
    this.bodyPart,
    this.healthPart,
    this.previousPage,
  });

  String resultPhrase(String type, int resultScore) {
    var resultText = 'Hello';
    switch (type) {
      case 'Health':
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
      case 'Physical':
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
      case 'Mental':
        resultText = 'ระบบบันทึกข้อมูลเรียบร้อย ขอบคุณที่ให้ความร่วมมือ';
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              checkQuestionType(questionType, h),
              Container(
                padding: EdgeInsets.only(
                    left: w * 0.03, right: w * 0.03, top: h * 0.03),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: h * 0.03,
                      color: Colors.black,
                    ),
                    children: questionType == 'Health'
                        ? resultScore > 75
                            ? [
                                TextSpan(
                                  text: resultPhrase(questionType, resultScore),
                                ),
                                TextSpan(
                                  text: 'คลิกที่นี่',
                                  style: const TextStyle(
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
                                  text: resultPhrase(questionType, resultScore),
                                ),
                              ]
                        : [
                            TextSpan(
                              text: resultPhrase(questionType, resultScore),
                            ),
                          ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: h * 0.05),
              ),
              RaisedButton(
                onPressed: insertHandler,
                padding: EdgeInsets.zero,
                color: Colors.green.shade300,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: w,
                  height: h * 0.07,
                  child: const Text(
                    'บันทึก',
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
          IconButton(
            onPressed: previousPage,
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ],
      ),
    );
  }

  RichText checkQuestionType(String questionType, double h) {
    switch (questionType) {
      case 'Physical':
        if (resultScore == 0) {
          return RichText(
            text: TextSpan(
              text: 'ท่านไม่มีอาการบาดเจ็บ',
              style: TextStyle(
                color: Colors.black,
                fontSize: h * 0.03,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'อาการบาดเจ็บบริเวณ${bodyPart}ของท่านอยู่ในระดับ ',
                style: TextStyle(
                  fontSize: h * 0.03,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '$resultScore',
                    style: TextStyle(
                      color: score_color(resultScore),
                    ),
                  ),
                  const TextSpan(text: ' คะแนน')
                ]),
          );
        }
        break;
      case 'Health':
        if (resultScore == 0) {
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'ท่านไม่มีปัญหาสุขภาพ',
              style: TextStyle(
                fontSize: h * 0.03,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'ท่านมีปัญหาสุขภาพ${healthPart}อยู่ในระดับ ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: h * 0.03,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '$resultScore',
                    style: TextStyle(
                      color: score_color(resultScore),
                    ),
                  ),
                  const TextSpan(text: ' คะแนน')
                ]),
          );
        }
        break;
      case 'Mental':
        return RichText(text: TextSpan(text: ''));
        //   if (resultScore == 0) {
        //     return RichText(
        //       text: TextSpan(
        //         text: 'ท่านไม่มีปัญหาการนอนหลับ',
        //         style: TextStyle(
        //           color: Colors.black,
        //           fontSize: h * 0.03,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     );
        //   } else {
        //     return RichText(
        //       textAlign: TextAlign.center,
        //       text: TextSpan(
        //           text: 'ปัญหาการนอนหลับของท่านอยู่ในระดับ ',
        //           style: TextStyle(
        //             fontSize: h * 0.03,
        //             color: Colors.black,
        //             fontWeight: FontWeight.bold,
        //           ),
        //           children: [
        //             TextSpan(
        //               text: '$resultScore',
        //               style: TextStyle(
        //                 color: score_color(resultScore),
        //               ),
        //             ),
        //             const TextSpan(text: ' คะแนน')
        //           ]),
        //     );
        //   }
        break;
      default:
    }
  }
}
