import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import './question.dart';
import './answer.dart';

class Questionnaire extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final questionIndex;
  final Function answerQuestion;
  final String questionType;
  final String bodyChoosing;
  bool isQuestionnaire = false;

  Questionnaire(
      {this.questions,
      this.answerQuestion,
      this.questionIndex,
      this.questionType,
      this.bodyChoosing});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    checkQuestionnaire(questionType);
    return Container(
      padding: EdgeInsets.only(
        left: w * 0.03,
        right: w * 0.03,
      ),
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: _questionType(questionType, h),
    );
  }

  Widget _questionType(String type, double h) {
    TextEditingController _healthSearch = TextEditingController();
    switch (type) {
      case 'physical':
        return isQuestionnaire
            ? Column(
                children: [
                  Question(
                    questions[questionIndex]['questionText'] as String,
                  ),
                  // ... makes separating list into a value of a list, then take it into child list.
                  ...(questions[questionIndex]['answerText']
                          as List<Map<String, Object>>)
                      .map((answer) {
                    print(answer);
                    return Answer(
                        () => answerQuestion(answer['score']), answer['text']);
                  }).toList()
                  // : Text(questions[0].keys.last)
                ],
              )
            : questionIndex < 1
                ? Column(
                    children: [
                      Question(
                        questions[0]['questionText'] as String,
                      ),
                      // ... makes separating list into a value of a list, then take it into child list.
                      ...(questions[0]['answerText']
                              as List<Map<String, Object>>)
                          .map((answer) {
                        print(answer);
                        return Answer(() => answerQuestion(answer['text']),
                            answer['text']);
                      }).toList()
                      // : Text(questions[0].keys.last)
                    ],
                  )
                : Column(
                    children: <Widget>[
                      Question(
                        questions[0]['questionText'] as String,
                      ),
                      bodyType(bodyChoosing, h)
                    ],
                  );
        break;
      case 'health':
        return isQuestionnaire
            ? Column(
                children: [
                  Question(
                    questions[questionIndex]['questionText'] as String,
                  ),
                  // ... makes separating list into a value of a list, then take it into child list.
                  ...(questions[questionIndex]['answerText']
                          as List<Map<String, Object>>)
                      .map((answer) {
                    print(answer);
                    return Answer(
                        () => answerQuestion(answer['score']), answer['text']);
                  }).toList()
                  // : Text(questions[0].keys.last)
                ],
              )
            : Column(
                children: [
                  Question(
                    questions[0]['questionText'] as String,
                  ),
                  Container(
                    child: DropdownButtonFormField2(
                      items: (questions[0]['answerText'] as List<String>)
                          .map(
                            (health) => DropdownMenuItem(
                              child: Text(
                                health,
                              ),
                              value: health,
                            ),
                          )
                          .toList(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 50.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'โปรดเลือกปัญหาสุขภาพ',
                      ),
                      onChanged: (health) => answerQuestion(health),
                      searchController: _healthSearch,
                      searchInnerWidget: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 10,
                          top: 10,
                        ),
                        child: TextFormField(
                          controller: _healthSearch,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => _healthSearch.clear(),
                              icon: const Icon(Icons.close),
                            ),
                            hintText: 'Search ...',
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return (item.value.toString().contains(
                              searchValue,
                            ));
                      },
                    ),
                  ),
                ],
              );
        break;
      case 'mental':
        return isQuestionnaire
            ? Column(
                children: [
                  Question(
                    questions[questionIndex]['questionText'] as String,
                  ),
                  // ... makes separating list into a value of a list, then take it into child list.

                  ...(questions[questionIndex]['answerText']
                          as List<Map<String, Object>>)
                      .map((answer) {
                    print(answer);
                    return Answer(
                        () => answerQuestion(answer['score']), answer['text']);
                  }).toList()

                  // : Text(questions[0].keys.last)
                ],
              )
            : Column(
                children: [
                  Question(
                    questions[questionIndex]['questionText'] as String,
                  ),
                  // ... makes separating list into a value of a list, then take it into child list.
                  ...(questions[questionIndex]['answerText']
                          as List<Map<String, Object>>)
                      .map((answer) {
                    print(answer);
                    return Answer(
                        () => answerQuestion(answer['text']), answer['text']);
                  }).toList()
                  // : Text(questions[0].keys.last)
                ],
              );
        break;
      default:
    }
  }

  Widget bodyType(String _bodyChoosing, double h) {
    TextEditingController _bodyHeadSearch = TextEditingController();
    switch (_bodyChoosing) {
      case 'ส่วนหัวและลำตัว':
        return Container(
          child: DropdownButtonFormField2(
            isExpanded: true,
            items: (questions[0]['ส่วนหัวและลำตัว'] as List<String>)
                .map(
                  (body) => DropdownMenuItem(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        body,
                      ),
                    ),
                    value: body,
                  ),
                )
                .toList(),
            dropdownMaxHeight: h / 3,
            dropdownFullScreen: true,
            dropdownElevation: 1,
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
              border: Border(),
            ),
            
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.black,
                    width: double.infinity,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              fillColor: Colors.white,
              filled: true,
              hintText: '',
            ),
            onChanged: (body) => answerQuestion(body),
            searchController: _bodyHeadSearch,
            searchInnerWidget: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 10,
                top: 10,
              ),
              child: TextFormField(
                controller: _bodyHeadSearch,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => _bodyHeadSearch.clear(),
                    icon: const Icon(Icons.close),
                  ),
                  hintText: 'ค้นหา ...',
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return (item.value.toString().contains(
                    searchValue,
                  ));
            },
          ),
        );
        break;

      case 'ร่างกายส่วนบน':
        return Column(
          children: [
            // ... makes separating list into a value of a list, then take it into child list.
            ...(questions[0]['ร่างกายส่วนบน'] as List<String>).map((body) {
              print(body);
              return Answer(() => answerQuestion(body), body);
            }).toList()
          ],
        );
        break;

      case 'ร่างกายส่วนล่าง':
        return Column(
          children: [
            // ... makes separating list into a value of a list, then take it into child list.
            ...(questions[0]['ร่างกายส่วนล่าง'] as List<String>).map((body) {
              print(body);
              return Answer(() => answerQuestion(body), body);
            }).toList()
          ],
        );
        break;

      default:
    }
  }

  void checkQuestionnaire(String type) {
    switch (type) {
      case 'physical':
        if (questions[0]['questionText'] !=
            'โปรดเลือกอวัยวะที่ได้รับการบาดเจ็บมากที่สุด') {
          isQuestionnaire = true;
        } else {
          isQuestionnaire = false;
        }
        break;

      case 'health':
        if (questions[0]['questionText'] !=
            'โปรดเลือกปัญหาสุขภาพที่สำคัญที่สุด') {
          // โปรดเลือกปัญหาสุขภาพที่สำคัญที่สุด
          isQuestionnaire = true;
        } else {
          isQuestionnaire = false;
        }
        break;
      default:
    }
  }
}
