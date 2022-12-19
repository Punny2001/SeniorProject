import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import './question.dart';
import './answer.dart';

class Questionnaire extends StatefulWidget {
  final List<Map<String, Object>> questions;
  final questionIndex;
  final Function answerQuestion;
  final String questionType;
  final String bodyChoosing;
  final Function previousPage;

  Questionnaire({
    this.questions,
    this.answerQuestion,
    this.questionIndex,
    this.questionType,
    this.bodyChoosing,
    this.previousPage,
  });

  @override
  State<Questionnaire> createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  bool isQuestionnaire = false;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    checkQuestionnaire(widget.questionType);
    return Container(
      padding: EdgeInsets.only(
        left: w * 0.03,
        right: w * 0.03,
        bottom: h * 0.01,
      ),
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: _questionType(widget.questionType, h),
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
                    widget.questions[widget.questionIndex]['questionText']
                        as String,
                  ),
                  // ... makes separating list into a value of a list, then take it into child list.
                  ...(widget.questions[widget.questionIndex]['answerText']
                          as List<Map<String, Object>>)
                      .map((answer) {
                    print(answer);
                    return Answer(
                      () => widget.answerQuestion(answer['score']),
                      answer['text'],
                    );
                  }).toList()
                  // : Text(questions[0].keys.last)
                ],
              )
            : widget.questionIndex < 1
                ? Column(
                    children: [
                      Question(
                        widget.questions[0]['questionText'] as String,
                      ),
                      // ... makes separating list into a value of a list, then take it into child list.
                      ...(widget.questions[0]['answerText']
                              as List<Map<String, Object>>)
                          .map((answer) {
                        print(answer);
                        return Answer(
                            () => widget.answerQuestion(answer['text']),
                            answer['text']);
                      }).toList()
                      // : Text(questions[0].keys.last)
                    ],
                  )
                : Column(
                    children: <Widget>[
                      Question(
                        widget.questions[0]['questionText'] as String,
                      ),
                      bodyType(widget.bodyChoosing, h),
                    ],
                  );
        break;
      case 'health':
        bool canNext = false;
        String healthChoosing;
        final _keyForm = GlobalKey<FormState>();
        return isQuestionnaire
            ? Column(
                children: [
                  Question(
                    widget.questions[widget.questionIndex]['questionText']
                        as String,
                  ),
                  // ... makes separating list into a value of a list, then take it into child list.
                  ...(widget.questions[widget.questionIndex]['answerText']
                          as List<Map<String, Object>>)
                      .map((answer) {
                    print(answer);
                    return Answer(() => widget.answerQuestion(answer['score']),
                        answer['text']);
                  }).toList()
                  // : Text(questions[0].keys.last)
                ],
              )
            : Form(
                key: _keyForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Question(
                          widget.questions[0]['questionText'] as String,
                        ),
                        DropdownButtonFormField2(
                          value: healthChoosing,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null) {
                              return 'โปรดเลือกปัญหาสุขภาพ 1 อย่าง';
                            } else {
                              return null;
                            }
                          },
                          items: (widget.questions[0]['answerText']
                                  as List<String>)
                              .map(
                                (health) => DropdownMenuItem(
                                  child: Text(
                                    health,
                                  ),
                                  value: health,
                                ),
                              )
                              .toList(),
                          decoration: InputDecoration(
                            fillColor: Colors.blueGrey[50],
                            filled: true,
                            hintText: 'โปรดเลือกปัญหาสุขภาพ',
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueGrey[100],
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueGrey[100],
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            healthChoosing = value;
                            canNext = true;
                          },
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
                      ],
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: widget.previousPage,
                            icon: Icon(Icons.arrow_back_ios),
                          ),
                          IconButton(
                            onPressed: () {
                              if (_keyForm.currentState.validate()) {
                                widget.answerQuestion(healthChoosing);
                              }
                            },
                            icon: Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
        break;
      case 'mental':
        return isQuestionnaire
            ? Column(
                children: [
                  Question(
                    widget.questions[widget.questionIndex]['questionText']
                        as String,
                  ),
                  // ... makes separating list into a value of a list, then take it into child list.

                  ...(widget.questions[widget.questionIndex]['answerText']
                          as List<Map<String, Object>>)
                      .map((answer) {
                    print(answer);
                    return Answer(() => widget.answerQuestion(answer['score']),
                        answer['text']);
                  }).toList()

                  // : Text(questions[0].keys.last)
                ],
              )
            : Column(
                children: [
                  Question(
                    widget.questions[widget.questionIndex]['questionText']
                        as String,
                  ),
                  // ... makes separating list into a value of a list, then take it into child list.
                  ...(widget.questions[widget.questionIndex]['answerText']
                          as List<Map<String, Object>>)
                      .map((answer) {
                    print(answer);
                    return Answer(() => widget.answerQuestion(answer['text']),
                        answer['text']);
                  }).toList()
                  // : Text(questions[0].keys.last)
                ],
              );
        break;
      default:
    }
  }

  Widget bodyType(String _bodyChoosing, double h) {
    final w = MediaQuery.of(context).size.width;
    TextEditingController _bodyHeadSearch = TextEditingController();
    bool canNext = false;
    String partChoosing;
    final _keyForm = GlobalKey<FormState>();
    switch (_bodyChoosing) {
      case 'ส่วนหัวและลำตัว':
        return Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _keyForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: DropdownButtonFormField2(
                  isExpanded: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return 'โปรดเลือกร่างกายส่วนหัวและลำตัว 1 อย่าง';
                    } else {
                      return null;
                    }
                  },
                  items:
                      (widget.questions[0]['ส่วนหัวและลำตัว'] as List<String>)
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
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    border: Border(),
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.blueGrey[50],
                    filled: true,
                    hintText: 'โปรดเลือกร่างกายที่ได้รับบาดเจ็บ',
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey[100],
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey[100],
                      ),
                    ),
                  ),
                  onChanged: (body) {
                    canNext = true;
                    partChoosing = body;
                  },
                  value: partChoosing,
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
              ),
              SizedBox(
                height: h * 0.3,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: widget.previousPage,
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_keyForm.currentState.validate()) {
                          widget.answerQuestion(partChoosing);
                        }
                      },
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        break;

      case 'ร่างกายส่วนบน':
        return Form(
          key: _keyForm,
          child: Column(
            children: [
              Container(
                child: DropdownButtonFormField2(
                  isExpanded: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return 'โปรดเลือกร่างกายส่วนบน 1 อย่าง';
                    } else {
                      return null;
                    }
                  },
                  items: (widget.questions[0]['ร่างกายส่วนบน'] as List<String>)
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
                      Radius.circular(25),
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
                    hintText: 'โปรดเลือกอวัยวะที่ได้รับบาดเจ็บ',
                  ),
                  onChanged: (body) {
                    canNext = true;
                    partChoosing = body;
                  },
                  value: partChoosing,
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
              ),
              SizedBox(
                height: h * 0.3,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: widget.previousPage,
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_keyForm.currentState.validate()) {
                          widget.answerQuestion(partChoosing);
                        }
                      },
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        break;

      case 'ร่างกายส่วนล่าง':
        return Column(
          children: [
            Container(
              child: DropdownButtonFormField2(
                isExpanded: true,
                items: (widget.questions[0]['ร่างกายส่วนล่าง'] as List<String>)
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
                    Radius.circular(25),
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
                  hintText: 'โปรดเลือกอวัยวะที่ได้รับบาดเจ็บ',
                ),
                onChanged: (body) {
                  canNext = true;
                  partChoosing = body;
                },
                value: partChoosing,
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
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: widget.previousPage,
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_keyForm.currentState.validate()) {
                        widget.answerQuestion(partChoosing);
                      }
                    },
                    icon: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
          ],
        );
        break;

      default:
    }
  }

  void checkQuestionnaire(String type) {
    switch (type) {
      case 'physical':
        if (widget.questions[0]['questionText'] !=
            'โปรดเลือกอวัยวะที่ได้รับการบาดเจ็บมากที่สุด') {
          isQuestionnaire = true;
        } else {
          isQuestionnaire = false;
        }
        break;

      case 'health':
        if (widget.questions[0]['questionText'] !=
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
