import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './question.dart';
import './answer.dart';

class Questionnaire extends StatefulWidget {
  final List<Map<String, Object>> questions;
  final int questionIndex;
  final Function answerQuestion;
  final String questionType;
  final String bodyChoosing;
  final String healthChoosing;
  final Function nextPage;
  final Function previousPage;
  final String partChoosing;
  final Function sendBodyChoosing;
  final Map answerPart2;
  final Map answerPart3;
  final Map answerList;

  const Questionnaire({
    Key key,
    this.questions,
    this.answerQuestion,
    this.questionIndex,
    this.questionType,
    this.bodyChoosing,
    this.healthChoosing,
    this.nextPage,
    this.previousPage,
    this.partChoosing,
    this.sendBodyChoosing,
    this.answerPart2,
    this.answerPart3,
    this.answerList,
  }) : super(key: key);

  @override
  State<Questionnaire> createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  bool isQuestionnaire = false;
  double _currentSliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    checkQuestionnaire(widget.questionType);
    return Container(
      padding: EdgeInsets.only(
        left: w * 0.02,
        right: w * 0.02,
        bottom: h * 0.01,
      ),
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: _questionType(widget.questionType, h, w),
    );
  }

  Widget _questionType(String type, double h, double w) {
    TextEditingController _healthSearch = TextEditingController();
    String _partChoosing;
    switch (type) {
      case 'Physical':
        void _getPartChoosing(String bodypart) {
          _partChoosing = bodypart;
        }
        // print(widget.bodyChoosing);
        // print(widget.partChoosing);
        final _keyForm = GlobalKey<FormState>();
        return isQuestionnaire
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Question(
                        widget.questions[widget.questionIndex]['questionText']
                            as String,
                      ),
                      // ... makes separating list into a value of a list, then take it into child list.
                      ...(widget.questions[widget.questionIndex]['answerText']
                              as List<Map<String, Object>>)
                          .map((answer) {
                        return Answer(
                          () => widget.answerQuestion(answer['score']),
                          answer['text'],
                          answer['score'],
                          widget.questions[widget.questionIndex]['questionNo'],
                          widget.answerList,
                        );
                      }).toList()
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => widget.previousPage(
                            widget.bodyChoosing, widget.partChoosing),
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: h * 0.02),
                        child: Text(
                          '${widget.questionIndex + 1}/${widget.questions.length}',
                          style: TextStyle(
                            fontSize: h * 0.03,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: widget.nextPage,
                        icon: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ],
              )
            : widget.questionIndex < 1
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Question(
                            widget.questions[0]['questionText'] as String,
                          ),
                          // ... makes separating list into a value of a list, then take it into child list.
                          ...(widget.questions[0]['answerText']
                                  as List<Map<String, Object>>)
                              .map((answer) {
                            return Answer(
                              () => widget.answerQuestion(answer['text']),
                              answer['text'],
                              answer['score'],
                              widget.questions[widget.questionIndex]
                                  ['questionNo'],
                              widget.answerList,
                            );
                          }).toList()
                        ],
                      ),
                      IconButton(
                        onPressed: widget.previousPage,
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                    ],
                  )
                : Form(
                    key: _keyForm,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: [
                            Question(
                              widget.questions[0]['questionText'] as String,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: w * 0.03, right: w * 0.03),
                              child: bodyType(
                                widget.bodyChoosing,
                                h,
                                _getPartChoosing,
                                widget.partChoosing,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: widget.previousPage,
                              icon: const Icon(Icons.arrow_back_ios),
                            ),
                            IconButton(
                              onPressed: () {
                                if (widget.partChoosing != null &&
                                    _partChoosing == null) {
                                  widget.answerQuestion(widget.partChoosing);
                                } else if (_keyForm.currentState.validate()) {
                                  widget.answerQuestion(_partChoosing);
                                }
                              },
                              icon: const Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
        break;
      case 'Health':
        String healthChoosing;
        final _keyForm = GlobalKey<FormState>();
        return isQuestionnaire
            ? Form(
                key: _keyForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Question(
                          widget.questions[widget.questionIndex]['questionText']
                              as String,
                        ),
                        // ... makes separating list into a value of a list, then take it into child list.
                        ...(widget.questions[widget.questionIndex]['answerText']
                                as List<Map<String, Object>>)
                            .map((answer) {
                          return Answer(
                            () => widget.answerQuestion(answer['score']),
                            answer['text'],
                            answer['score'],
                            widget.questions[widget.questionIndex]
                                ['questionNo'],
                            widget.answerList,
                          );
                        }).toList()
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () =>
                              widget.previousPage(widget.healthChoosing),
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: h * 0.02),
                          child: Text(
                            '${widget.questionIndex + 1}/${widget.questions.length}',
                            style: TextStyle(
                              fontSize: h * 0.03,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: widget.nextPage,
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  ],
                ),
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
                        Container(
                          padding: EdgeInsets.only(
                            left: w * 0.03,
                            right: w * 0.03,
                          ),
                          child: DropdownButtonFormField2(
                            selectedItemHighlightColor: Colors.grey[300],
                            value: widget.healthChoosing,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'โปรดเลือกปัญหาสุขภาพ',
                              focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              errorBorder: const OutlineInputBorder(
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
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: widget.previousPage,
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                        IconButton(
                          onPressed: () {
                            if (widget.healthChoosing != null &&
                                healthChoosing == null) {
                              widget.answerQuestion(widget.healthChoosing);
                            } else if (_keyForm.currentState.validate()) {
                              widget.answerQuestion(healthChoosing);
                            }
                          },
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  ],
                ),
              );
        break;
      case 'Mental':
        isQuestionnaire = true;
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Question(
                  widget.questions[widget.questionIndex]['questionText']
                      as String,
                ),
                // ... makes separating list into a value of a list, then take it into child list.
                if (widget.questions.length == 4)
                  ...(widget.questions[widget.questionIndex]['answerText']
                          as List<Map<String, Object>>)
                      .map((answer) {
                    return Answer(
                      () => widget.answerQuestion(answer['score']),
                      answer['text'],
                      answer['score'],
                      widget.questions[widget.questionIndex]['questionNo'],
                      widget.answerList,
                    );
                  }).toList()
                else
                  Column(
                    children: [
                      Text(
                        _currentSliderValue.floor().toString(),
                        style: TextStyle(fontSize: h * 0.025),
                      ),
                      SizedBox(
                        width: w,
                        child: CupertinoSlider(
                            value: _currentSliderValue,
                            min: 0,
                            max: 10,
                            divisions: 10,
                            onChanged: (value) {
                              setState(() {
                                _currentSliderValue = value;
                              });
                            }),
                      )
                    ],
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                widget.questionIndex == 0 && widget.questions.length == 4
                    ? SizedBox(width: w * 0.12)
                    : IconButton(
                        onPressed: () {
                          if (widget.questions.length == 5 &&
                              widget.questionIndex != 0) {
                            _currentSliderValue =
                                (widget.answerPart2['Q${widget.questionIndex}'])
                                    .toDouble();
                          } else if (widget.questions.length > 10 &&
                              widget.questionIndex != 0) {
                            _currentSliderValue =
                                (widget.answerPart3['Q${widget.questionIndex}'])
                                    .toDouble();
                          }
                          widget.previousPage();
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                Padding(
                  padding: EdgeInsets.only(bottom: h * 0.02),
                  child: Text(
                    '${widget.questionIndex + 1}/${widget.questions.length}',
                    style: TextStyle(
                      fontSize: h * 0.03,
                    ),
                  ),
                ),
                widget.questions.length == 4
                    ? IconButton(
                        onPressed: widget.nextPage,
                        icon: const Icon(Icons.arrow_forward_ios),
                      )
                    : IconButton(
                        onPressed: () {
                          widget.answerQuestion(_currentSliderValue.floor());
                          _currentSliderValue = 0.0;
                        },
                        icon: const Icon(Icons.arrow_forward_ios),
                      ),
              ],
            ),
          ],
        );
        break;
      default:
    }
  }

  Widget bodyType(String _bodyChoosing, double h, Function getBodyPart,
      String widgetPartChoosing) {
    String partChoosing;
    TextEditingController _bodyHeadSearch = TextEditingController();
    print('Body Chosen: $_bodyChoosing');
    switch (_bodyChoosing) {
      case 'ร่างกายส่วนหัวถึงลำตัว':
        return Container(
          child: DropdownButtonFormField2(
            isExpanded: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            selectedItemHighlightColor: Colors.grey[300],
            validator: (value) {
              if (value == null) {
                return 'โปรดเลือกร่างกายส่วนหัวถึงลำตัว 1 อย่าง';
              } else {
                return null;
              }
            },
            items:
                (widget.questions[0]['ร่างกายส่วนหัวถึงลำตัว'] as List<String>)
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
            dropdownDecoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
              border: Border(),
            ),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'โปรดเลือกร่างกายที่ได้รับบาดเจ็บ',
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              errorBorder: const OutlineInputBorder(
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
              partChoosing = body;
              getBodyPart(partChoosing);
            },
            value: widgetPartChoosing,
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

      case 'ร่างกายส่วนแขนถึงนิ้วมือ':
        return Container(
          child: DropdownButtonFormField2(
            isExpanded: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            selectedItemHighlightColor: Colors.grey[300],
            validator: (value) {
              if (value == null) {
                return 'โปรดเลือกร่างกายส่วนแขนถึงนิ้วมือ 1 อย่าง';
              } else {
                return null;
              }
            },
            items: (widget.questions[0]['ร่างกายส่วนแขนถึงนิ้วมือ']
                    as List<String>)
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
            dropdownDecoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
              border: Border(),
            ),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'โปรดเลือกร่างกายที่ได้รับบาดเจ็บ',
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              errorBorder: const OutlineInputBorder(
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
              partChoosing = body;
              getBodyPart(partChoosing);
            },
            value: widgetPartChoosing,
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

      case 'ร่างกายส่วนสะโพกถึงนิ้วเท้า':
        return DropdownButtonFormField2(
          isExpanded: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          selectedItemHighlightColor: Colors.grey[300],
          validator: (value) {
            if (value == null) {
              return 'โปรดเลือกร่างกายส่วนสะโพกถึงนิ้วเท้า 1 อย่าง';
            } else {
              return null;
            }
          },
          items: (widget.questions[0]['ร่างกายส่วนสะโพกถึงนิ้วเท้า']
                  as List<String>)
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
          dropdownDecoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
            border: Border(),
          ),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'โปรดเลือกร่างกายที่ได้รับบาดเจ็บ',
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
            errorBorder: const OutlineInputBorder(
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
            partChoosing = body;
            getBodyPart(partChoosing);
          },
          value: widgetPartChoosing,
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
        );
        break;

      default:
    }
  }

  void checkQuestionnaire(String type) {
    switch (type) {
      case 'Physical':
        if (widget.questions[0]['questionText'] !=
            'โปรดเลือกอวัยวะที่ได้รับการบาดเจ็บมากที่สุด') {
          isQuestionnaire = true;
        } else {
          isQuestionnaire = false;
        }
        break;

      case 'Health':
        if (widget.questions[0]['questionText'] !=
            'โปรดเลือกปัญหาสุขภาพที่สำคัญที่สุด') {
          isQuestionnaire = true;
        } else {
          isQuestionnaire = false;
        }
        break;
      default:
    }
  }
}
