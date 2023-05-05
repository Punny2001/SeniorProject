import 'package:flutter/material.dart';
import 'package:seniorapp/decoration/format_datetime.dart';
import 'package:seniorapp/decoration/padding.dart';
import 'package:seniorapp/decoration/textfield_normal.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/result.dart';

class PhysicalReportDetail extends StatelessWidget {
  final Map<String, int> answerList;
  final String athleteNo;
  final DateTime doDate;
  final String bodyPart;
  final String questionnaireType;
  final String questionnaireNo;
  final int totalPoint;

  PhysicalReportDetail({
    Key key,
    @required this.answerList,
    @required this.athleteNo,
    @required this.doDate,
    @required this.bodyPart,
    @required this.questionnaireType,
    @required this.questionnaireNo,
    @required this.totalPoint,
  }) : super(key: key);

  Result result = Result();

  @override
  Widget build(BuildContext context) {
    String resultPhrase = result.resultPhrase('Physical', totalPoint);
    resultPhrase = resultPhrase.replaceAll('null', bodyPart);
    final _questions = [
      {
        'questionNo': 'Q1',
        'questionText':
            'ใน 7 วันที่ผ่านมา อาการ$bodyPartของท่านทำให้การเข้าร่วมฝึกซ้อมหรือแข่งขันกีฬามีปัญหาหรือไม่',
        'answerText': [
          {
            'text':
                'เข้าร่วมการฝึกซ้อมหรือแข่งขันกีฬาได้เต็มที่ โดยไม่มีปัญหาสุขภาพ',
            'score': 0
          },
          {
            'text':
                'เข้าร่วมการฝึกซ้อมหรือแข่งขันกีฬาได้เต็มที่ แต่มีปัญหาสุขภาพ',
            'score': 8
          },
          {
            'text':
                'เข้าร่วมการฝึกซ้อมหรือแข่งขันกีฬาได้ไม่เต็มที่ เพราะมีปัญหาสุขภาพ',
            'score': 17
          },
          {
            'text':
                'ไม่สามารถเข้าร่วมการฝึกซ้อมหรือแข่งขันกีฬาได้เลย เพราะมีปัญหาสุขภาพ',
            'score': 25
          }
        ]
      },
      {
        'questionNo': 'Q2',
        'questionText':
            'ใน 7 วันที่ผ่านมา อาการ$bodyPartของท่านส่งผลกระทบต่อการฝึกซ้อมหรือแข่งขันมากน้อยเพียงใด',
        'answerText': [
          {'text': 'ไม่ส่งผลกระทบต่อการฝึกซ้อมหรือแข่งขันเลย', 'score': 0},
          {'text': 'การฝึกซ้อมหรือแข่งขันลดลงเล็กน้อย', 'score': 6},
          {'text': 'การฝึกซ้อมหรือแข่งขันลดลงปานกลาง', 'score': 13},
          {'text': 'การฝึกซ้อมหรือแข่งขันลดลงอย่างมาก', 'score': 19},
          {'text': 'ไม่สามารถเข้าร่วมการฝึกซ้อมหรือแข่งขันได้เลย', 'score': 25}
        ]
      },
      {
        'questionNo': 'Q3',
        'questionText':
            'ใน 7 วันที่ผ่านมา อาการ$bodyPartของท่านส่งผลกระทบต่อความสามารถในการเล่นกีฬามากน้อยเพียงใด',
        'answerText': [
          {'text': 'ไม่ส่งผลกระทบต่อความสามารถในการเล่นกีฬาเลย', 'score': 0},
          {'text': 'ความสามารถในการเล่นกีฬาลดลงเล็กน้อย', 'score': 6},
          {'text': 'ความสามารถในการเล่นกีฬาลดลงปานกลาง', 'score': 13},
          {'text': 'ความสามารถในการเล่นกีฬาลดลงอย่างมาก', 'score': 19},
          {'text': 'ไม่สามารถเข้าร่วมการฝึกซ้อมหรือแข่งขันได้เลย', 'score': 25}
        ]
      },
      {
        'questionNo': 'Q4',
        'questionText':
            'ใน 7 วันที่ผ่านมา อาการ$bodyPartของท่านซึ่งเป็นผลมาจากการเข้าร่วมการแข่งขันหรือฝึกซ้อมกีฬาอยู่ในระดับใด',
        'answerText': [
          {'text': 'ไม่เจ็บเลย', 'score': 0},
          {'text': 'เจ็บเล็กน้อย', 'score': 6},
          {'text': 'เจ็บพอประมาณ', 'score': 13},
          {'text': 'เจ็บมาก', 'score': 19},
          {'text': 'ไม่สามารถเข้าร่วมการฝึกซ้อมหรือแข่งขันได้เลย', 'score': 25}
        ]
      },
    ];

    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    List<String> find_answer(List<Map<String, Object>> question) {
      List<String> answerText = [];
      int i = 1;
      question.forEach((map) {
        (map['answerText'] as List<Map<String, Object>>).forEach((answer) {
          // print('${answerList['Q$i']} and ${answer['score']}');
          if (answerList['Q$i'] == answer['score']) {
            answerText.add(answer['text'].toString());
          }
        });
        i++;
      });
      return answerText;
    }

    List<String> answerTextList = find_answer(_questions);
    print(answerTextList);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        primary: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: Colors.white, 
        foregroundColor: Colors.green[300],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          alignment: Alignment.centerRight,
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(
          left: 30,
          right: 30,
        ),
        height: h,
        width: w,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Text(
                'ข้อมูล $questionnaireNo',
                style: TextStyle(
                  fontSize: h * 0.03,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              PaddingDecorate(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'คะแนนรวม: ',
                      style: TextStyle(
                        fontSize: h * 0.02,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          style: TextStyle(
                            color: score_color(totalPoint),
                          ),
                          text: '$totalPoint ',
                        ),
                        const TextSpan(
                          text: 'คะแนน',
                          style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PaddingDecorate(5),
                  RichText(
                    text: TextSpan(
                      text: 'คำแนะนำเบื้องต้น: ',
                      style: TextStyle(
                        fontSize: h * 0.02,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: resultPhrase,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PaddingDecorate(5),
                  RichText(
                    text: TextSpan(
                      text: 'วันที่บันทึก: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: h * 0.02,
                      ),
                      children: [
                        TextSpan(
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                          text:
                              '${formatDate(doDate, 'Athlete')} | ${formatTime(doDate, 'Athlete')} น.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              PaddingDecorate(10),
              for (int i = 0; i < answerList.length; i++)
                Column(
                  children: [
                    Text(
                      'ข้อ${i + 1} : ${_questions[i]['questionText']}\n',
                      style: TextStyle(
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: w * 0.5,
                          child: Text(
                            answerTextList[i],
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Column(
                          children: [
                            const Text(
                              'คะแนน',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('${answerList['Q${i + 1}']}')
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                      height: h * 0.05,
                      indent: 0,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
