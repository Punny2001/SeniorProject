import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/health_questionnaire.dart';
import 'package:seniorapp/decoration/format_date.dart';
import 'package:seniorapp/decoration/padding.dart';

class HealthReportDetail extends StatelessWidget {
  final Map<String, int> answerList;
  final String athleteNo;
  final DateTime doDate;
  final String healthSymptom;
  final String questionnaireType;
  final String questionnaireNo;
  final int totalPoint;

  const HealthReportDetail({
    Key key,
    @required this.answerList,
    @required this.athleteNo,
    @required this.doDate,
    @required this.healthSymptom,
    @required this.questionnaireType,
    @required this.questionnaireNo,
    @required this.totalPoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _questions = [
      {
        'questionNo': 'Q1',
        'questionText':
            'ใน 7 วันที่ผ่านมา อาการ${healthSymptom}ของท่านทำให้การเข้าร่วมฝึกซ้อมหรือแข่งขันกีฬามีปัญหาหรือไม่',
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
            'ใน 7 วันที่ผ่านมา อาการ${healthSymptom}ของท่านส่งผลกระทบต่อการฝึกซ้อมหรือแข่งขันมากน้อยเพียงใด',
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
            'ใน 7 วันที่ผ่านมา อาการ${healthSymptom}ของท่านส่งผลกระทบต่อความสามารถในการเล่นกีฬามากน้อยเพียงใด',
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
            'ใน 7 วันที่ผ่านมา อาการ${healthSymptom}ของท่านซึ่งเป็นผลมาจากการเข้าร่วมการแข่งขันหรือฝึกซ้อมกีฬาอยู่ในระดับใด',
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
            i++;
          }
        });
      });
      return answerText;
    }

    List<String> answerTextList = find_answer(_questions);
    print(answerTextList);

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
                  color: Colors.green.shade300,
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
        padding: EdgeInsets.only(
          left: 30,
          right: 30,
        ),
        height: h,
        width: w,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Text(
                'Answer List',
                style: TextStyle(
                  fontSize: h * 0.04,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
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
                        Container(
                          width: w * 0.5,
                          child: Text(
                            answerTextList[i],
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
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
              PaddingDecorate(10),
              Text(
                formatDate(
                  doDate,
                  'Athlete',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
