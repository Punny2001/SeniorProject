import 'package:flutter/material.dart';
import 'package:seniorapp/component/result-data/mental_result_data.dart';
import 'package:seniorapp/decoration/format_datetime.dart';
import 'package:seniorapp/decoration/padding.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/result.dart';

class MentalReportDetail extends StatelessWidget {
  final MentalResultData mentalResultData;

  MentalReportDetail({Key key, @required this.mentalResultData})
      : super(key: key);

  Result result = Result();
  final _questionsPart1 = [
    {
      'questionNo': 'Q1',
      'questionText': 'นอนไม่หลับหลังจากเข้านอนไปแล้วนานกว่า 30 นาที',
      'answerText': [
        {'text': 'ไม่เคยมีอาการ', 'score': 0},
        {'text': 'น้อยกว่า 1 ครั้ง/สัปดาห์ ', 'score': 1},
        {'text': 'มีปัญหา 1-2 ครั้ง/สัปดาห์ ', 'score': 2},
        {'text': 'มีปัญหามากกว่า 3 ครั้ง/สัปดาห์หรือมากกว่า', 'score': 3}
      ]
    },
    {
      'questionNo': 'Q2',
      'questionText': 'ตื่นกลางดึกหรือตื่นช้ากว่าปกติ',
      'answerText': [
        {'text': 'ไม่เคยมีอาการ', 'score': 0},
        {'text': 'น้อยกว่า 1 ครั้ง/สัปดาห์ ', 'score': 1},
        {'text': 'มีปัญหา 1-2 ครั้ง/สัปดาห์ ', 'score': 2},
        {'text': 'มีปัญหามากกว่า 3 ครั้ง/สัปดาห์หรือมากกว่า', 'score': 3}
      ]
    },
    {
      'questionNo': 'Q3',
      'questionText': 'ท่านใช้ยานอนหลับบ่อยครั้งเพียงใด',
      'answerText': [
        {'text': 'ไม่เคยมีอาการ', 'score': 0},
        {'text': 'น้อยกว่า 1 ครั้ง/สัปดาห์ ', 'score': 1},
        {'text': 'มีปัญหา 1-2 ครั้ง/สัปดาห์ ', 'score': 2},
        {'text': 'มีปัญหามากกว่า 3 ครั้ง/สัปดาห์หรือมากกว่า', 'score': 3}
      ]
    },
    {
      'questionNo': 'Q4',
      'questionText':
          'ในระยะ 1 เดือนที่ผ่านมา คุณภาพการนอนโดยรวมของท่านเป็นอย่างไร',
      'answerText': [
        {'text': 'ดีมาก', 'score': 0},
        {'text': 'ดี', 'score': 1},
        {'text': 'ไม่ค่อยดี', 'score': 2},
        {'text': 'ไม่ดีเลย', 'score': 3}
      ]
    },
  ];

  final _questionsPart2 = [
    {
      'questionNo': 'Q1',
      'questionText': 'คุณมีความมั่นใจโดยรวมมากแค่ไหน?',
    },
    {
      'questionNo': 'Q2',
      'questionText': 'คุณมีความมั่นใจในการเล่นโดยที่ไม่รู้สึกเจ็บแค่ไหน?',
    },
    {
      'questionNo': 'Q3',
      'questionText': 'คุณมีความมั่นใจที่จะออกแรงมากน้อยแค่ไหน?',
    },
    {
      'questionNo': 'Q4',
      'questionText': 'คุณคิดว่าคุณมีความมั่นใจมากแค่ไหนในการแสดงทักษะทางกีฬา?',
    },
    {
      'questionNo': 'Q5',
      'questionText':
          'คุณคิดว่าคุณมีความมั่นใจมากแค่ไหนในการที่จะไม่สนใจส่วนที่บาดเจ็บ?',
    },
  ];

  final _questionsPart3 = [
    {
      'questionNo': 'Q1',
      'questionText': 'คุณมีอาการเหนื่อยบ้างไหม?',
    },
    {
      'questionNo': 'Q2',
      'questionText': 'คุณได้หลับเพียงพอแล้วหรือยัง?',
    },
    {
      'questionNo': 'Q3',
      'questionText': 'คุณมีอาการง่วงนอนหรือไม่?',
    },
    {
      'questionNo': 'Q4',
      'questionText': 'คุณมีอาการเหนื่อยล้าหรือไม่?',
    },
    {
      'questionNo': 'Q5',
      'questionText': 'คุณมีอาการหมดแรงหรือไม่?',
    },
    {
      'questionNo': 'Q6',
      'questionText': 'คุณมีความกระฉับกระเฉงว่องไวหรือไม่?',
    },
    {
      'questionNo': 'Q7',
      'questionText': 'คุณมีความคล่องแคล่วหรือไม่?',
    },
    {
      'questionNo': 'Q8',
      'questionText': 'คุณแข็งแรงดีหรือไม่?',
    },
    {
      'questionNo': 'Q9',
      'questionText': 'คุณในตอนนี้มีสมรรถภาพดีเยี่ยมหรือไม่?',
    },
    {
      'questionNo': 'Q10',
      'questionText': 'ตอนนี้คุณมีสภาพจิดใจที่ร่าเริงหรือไม่?',
    },
    {
      'questionNo': 'Q11',
      'questionText': 'คุณมีอาการเหนืื่อยหรือเปล่า?',
    },
    {
      'questionNo': 'Q12',
      'questionText': 'คุณในตอนนี้ยังสามารถมองเห็นได้ปกติหรือเปล่า?',
    },
    {
      'questionNo': 'Q13',
      'questionText': 'คุณยังสามารถขยับส่วนของร่างกายได้ปกใช่หรือไม่?',
    },
    {
      'questionNo': 'Q14',
      'questionText': 'คุณยังสามารถมีสมาธิจดจ่อกับการเล่นกีฬาได้หรือไม่?',
    },
    {
      'questionNo': 'Q15',
      'questionText': 'คุณยังสามารถโต้ตอบบทสนทนาได้แบบปกติใช่หรือไม่?',
    },
    {
      'questionNo': 'Q16',
      'questionText': 'คุณอยากที่จะนอนพักหรือไม่?',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    List<String> find_answer(
        List<Map<String, Object>> question, Map<String, int> answerList) {
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

    List<String> answerTextListPart1 =
        find_answer(_questionsPart1, mentalResultData.answerListPart1);

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
                'ข้อมูล ${mentalResultData.questionnaireNo}',
                style: TextStyle(
                    fontSize: h * 0.03,
                    fontWeight: FontWeight.bold,
                    fontFamily: ''),
              ),
              PaddingDecorate(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              '${formatDate(mentalResultData.doDate, 'Athlete')} | ${formatTime(mentalResultData.doDate, 'Athlete')} น.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              PaddingDecorate(10),
              Text(
                'ส่วนที่ 1',
                style: TextStyle(
                  fontSize: h * 0.025,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PaddingDecorate(5),
              for (int i = 0; i < mentalResultData.answerListPart1.length; i++)
                Column(
                  children: [
                    Text(
                      'ข้อ${i + 1} : ${_questionsPart1[i]['questionText']}\n',
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
                            answerTextListPart1[i],
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
                            Text(
                                '${mentalResultData.answerListPart1['Q${i + 1}']}')
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
                'ส่วนที่ 2',
                style: TextStyle(
                  fontSize: h * 0.025,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PaddingDecorate(5),
              for (int i = 0; i < mentalResultData.answerListPart2.length; i++)
                Column(
                  children: [
                    Text(
                      'ข้อ${i + 1} : ${_questionsPart2[i]['questionText']}\n',
                      style: TextStyle(
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
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
                        Text('${mentalResultData.answerListPart2['Q${i + 1}']}')
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
                'ส่วนที่ 3',
                style: TextStyle(
                  fontSize: h * 0.025,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PaddingDecorate(5),
              for (int i = 0; i < mentalResultData.answerListPart3.length; i++)
                Column(
                  children: [
                    Text(
                      'ข้อ${i + 1} : ${_questionsPart3[i]['questionText']}\n',
                      style: TextStyle(
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
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
                        Text('${mentalResultData.answerListPart3['Q${i + 1}']}')
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
