import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:seniorapp/component/report-data/injury_report_data.dart';
import 'package:seniorapp/component/report-data/sport_list.dart';
import 'package:seniorapp/component/result-data/physical_result_data.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:seniorapp/decoration/format_datetime.dart';
import 'package:seniorapp/decoration/padding.dart';
import 'package:seniorapp/decoration/textfield_normal.dart';

class InjuryReport extends StatefulWidget {
  final Map<String, dynamic> data;

  const InjuryReport(
    this.data,
  );

  @override
  _InjuryReportState createState() => _InjuryReportState();
}

class _InjuryReportState extends State<InjuryReport> {
  final _injuryKey = GlobalKey<FormState>();
  final _athleteNo = TextEditingController();
  final _rhtController = TextEditingController();
  final _codeBodyPart = TextEditingController();
  final _codeInjuryType = TextEditingController();
  final _otherInjuryType = TextEditingController();
  final _codeInjuryCause = TextEditingController();
  final _otherInjuryCause = TextEditingController();
  final _absenceDayController = TextEditingController();
  final _sportSearch = TextEditingController();
  final _bodyTypeSearch = TextEditingController();
  final _headtrunkSearch = TextEditingController();
  final _upperbodySearch = TextEditingController();
  final _lowerbodySearch = TextEditingController();
  final _injuryTypeSearch = TextEditingController();
  final _injuryCauseSearch = TextEditingController();
  final _messageController = TextEditingController();

  final _athleteFocusNode = FocusNode();
  final _sporteventFocusNode = FocusNode();
  final _occuredDateTimeFocusNode = FocusNode();
  final _injuredPartFocusNode = FocusNode();
  final _absenceDayFocusNode = FocusNode();

  DateTime _datetime;
  String _selectedSport;
  String _selectedBodyType;
  String _selectedBodyHTPart;
  String _selectedBodyUpperPart;
  String _selectedBodyLowerPart;
  String _selectedInjuryType;
  String _selectedInjuryCause;
  int _selectedSide = 0;
  bool isVisibleOtherInjuryType = false;
  bool isVisibleOtherInjuryCause = false;
  bool isHeadTrunkPart = false;
  bool isUpperPart = false;
  bool isLowerPart = false;
  bool hasSide = false;
  int bodyType;
  String _selectedSideString;
  Athlete athlete;
  bool isLoading = false;
  Timer _timer;

  Staff staff;
  String uid;

  void getStaff() {
    uid = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance
        .collection('Staff')
        .doc(uid)
        .get()
        .then((snapshot) {
      Map data = snapshot.data();
      staff = Staff.fromMap(data);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data != null) {
      _athleteNo.text = widget.data['athleteNo'];
      _selectedSport = widget.data['sportType'];
      _datetime = widget.data['doDate'].toDate();
    }
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        primary: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Ink(
              decoration: ShapeDecoration(
                shape: const CircleBorder(),
                color: Colors.blue.shade200,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                alignment: Alignment.centerRight,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
        width: w,
        height: h,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.only(
                left: w * 0.1, right: w * 0.1, bottom: h * 0.015),
            child: Form(
              key: _injuryKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Athlete No.
                  const Text(
                    'Athlete No.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  widget.data != null
                      ? TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: textdecorate('Athlete No.'),
                          readOnly: true,
                          controller: _athleteNo,
                          onChanged: (value) {},
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Athlete No. is required';
                            } else {
                              return null;
                            }
                          },
                        )
                      : TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          focusNode: _athleteFocusNode,
                          decoration: textdecorate('Athlete No.'),
                          controller: _athleteNo,
                          onChanged: (value) {},
                          validator: (value) {
                            if (value.isEmpty) {
                              if (!_athleteFocusNode.hasFocus) {
                                _athleteFocusNode.requestFocus();
                              }
                              return 'Athlete No. is required';
                            } else {
                              return null;
                            }
                          },
                        ),
                  //
                  PaddingDecorate(20),
                  // Sport and Event
                  const Text(
                    'Sport and Event',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  DropdownButtonFormField2<String>(
                    focusNode: _sporteventFocusNode,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: textdecorate('Select sport and event'),
                    items: sortedSport(sportList)
                        .map((sport) => DropdownMenuItem(
                              child: Text(sport),
                              value: sport,
                            ))
                        .toList(),
                    value: _selectedSport,
                    onChanged: (value) {
                      setState(() {
                        _selectedSport = value;
                        _sportSearch.clear();
                      });
                    },
                    searchController: _sportSearch,
                    searchInnerWidget: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 10,
                        top: 10,
                      ),
                      child: TextFormField(
                        controller: _sportSearch,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => _sportSearch.clear(),
                            icon: const Icon(Icons.close),
                          ),
                          hintText: 'Search ...',
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      return (item.value.toString().toLowerCase().contains(
                            searchValue.toLowerCase(),
                          ));
                    },
                    validator: (value) {
                      if (value == null) {
                        if (!_sporteventFocusNode.hasFocus) {
                          _sporteventFocusNode.requestFocus();
                        }
                        return 'Please select the sport and event';
                      } else {
                        return null;
                      }
                    },
                  ),
                  //
                  PaddingDecorate(20),
                  // Round, Heat, or Training
                  const Text(
                    'Round, Heat, or Training',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  PaddingDecorate(5),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: textdecorate('Round, Heat, or Training'),
                    controller: _rhtController,
                  ),
                  //
                  PaddingDecorate(20),
                  // Date & Time
                  const Text(
                    'Date & Time',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  PaddingDecorate(5),
                  DateTimePicker(
                    focusNode: _occuredDateTimeFocusNode,
                    initialValue: widget.data['questionnaireID'] == null
                        ? null
                        : formatDate(_datetime, 'Staff'),
                    dateLabelText: 'Date',
                    timeLabelText: 'Time',
                    dateMask: 'MMMM d, yyyy hh:mm a',
                    icon: const Icon(Icons.event),
                    type: DateTimePickerType.dateTime,
                    lastDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    initialDate: DateTime.now(),
                    decoration: const InputDecoration(
                      fillColor: Color.fromRGBO(217, 217, 217, 100),
                      filled: true,
                      hintText: 'Occured date & time',
                      hintStyle: TextStyle(fontFamily: 'OpenSans'),
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
                          color: Color.fromRGBO(217, 217, 217, 100),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(217, 217, 217, 100),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _datetime = DateTime.tryParse(value);
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        if (!_occuredDateTimeFocusNode.hasFocus) {
                          _occuredDateTimeFocusNode.requestFocus();
                        }
                        return 'Date and Time is required';
                      } else {
                        return null;
                      }
                    },
                  ),
                  //
                  PaddingDecorate(20),
                  // Injured Body Part
                  const Text(
                    'Injured body part',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  PaddingDecorate(5),
                  DropdownButtonFormField2<String>(
                    focusNode: _injuredPartFocusNode,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: textdecorate('Select body type'),
                    items: _bodyType
                        .map((bodyType) => DropdownMenuItem(
                              child: Text(bodyType),
                              value: bodyType,
                            ))
                        .toList(),
                    value: _selectedBodyType,
                    onChanged: (value) {
                      checkBodyType(value);
                      setState(() {
                        _selectedBodyType = value;
                        hasSide = false;
                        _bodyTypeSearch.clear();
                      });
                    },
                    searchController: _bodyTypeSearch,
                    searchInnerWidget: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 10,
                        top: 10,
                      ),
                      child: TextFormField(
                        controller: _bodyTypeSearch,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => _bodyTypeSearch.clear(),
                            icon: const Icon(Icons.close),
                          ),
                          hintText: 'Search ...',
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      return (item.value.toString().toLowerCase().contains(
                            searchValue.toLowerCase(),
                          ));
                    },
                    validator: (value) {
                      if (value == null) {
                        if (!_injuredPartFocusNode.hasFocus) {
                          _injuredPartFocusNode.requestFocus();
                        }
                        return 'Please select the type of body';
                      } else {
                        return null;
                      }
                    },
                  ),
                  PaddingDecorate(5),
                  Visibility(
                    visible: isHeadTrunkPart,
                    child: DropdownButtonFormField2<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: textdecorate('Select head and trunk part'),
                      dropdownMaxHeight: h / 2,
                      items: _bodyHeadPart
                          .map((key, value) {
                            return MapEntry(
                                key,
                                DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ));
                          })
                          .values
                          .toList(),
                      value: _selectedBodyHTPart,
                      onChanged: (value) {
                        onChangedMethodBodyPartValue(value);
                        setState(() {
                          _selectedBodyHTPart = value;
                          hasSide = false;
                          _headtrunkSearch.clear();
                        });
                      },
                      searchController: _headtrunkSearch,
                      searchInnerWidget: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 10,
                          top: 10,
                        ),
                        child: TextFormField(
                          controller: _headtrunkSearch,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => _headtrunkSearch.clear(),
                              icon: const Icon(Icons.close),
                            ),
                            hintText: 'Search ...',
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return (item.value.toString().toLowerCase().contains(
                              searchValue.toLowerCase(),
                            ));
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select the part of body';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: isUpperPart,
                    child: DropdownButtonFormField2<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: textdecorate('Select upper extremity part'),
                      dropdownMaxHeight: h / 2,
                      items: _bodyUpperPart
                          .map((key, value) {
                            return MapEntry(
                                key,
                                DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ));
                          })
                          .values
                          .toList(),
                      value: _selectedBodyUpperPart,
                      onChanged: (value) {
                        onChangedMethodBodyPartValue(value);
                        setState(() {
                          _selectedBodyUpperPart = value;
                          hasSide = true;
                          _upperbodySearch.clear();
                        });
                      },
                      searchController: _upperbodySearch,
                      searchInnerWidget: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 10,
                          top: 10,
                        ),
                        child: TextFormField(
                          controller: _upperbodySearch,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => _upperbodySearch.clear(),
                              icon: const Icon(Icons.close),
                            ),
                            hintText: 'Search ...',
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return (item.value.toString().toLowerCase().contains(
                              searchValue.toLowerCase(),
                            ));
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select the part of body';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: isLowerPart,
                    child: DropdownButtonFormField2<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: textdecorate('Select lower extremity part'),
                      dropdownMaxHeight: h / 2,
                      items: _bodyLowerPart
                          .map((key, value) {
                            return MapEntry(
                                key,
                                DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ));
                          })
                          .values
                          .toList(),
                      value: _selectedBodyLowerPart,
                      onChanged: (value) {
                        onChangedMethodBodyPartValue(value);
                        setState(() {
                          _selectedBodyLowerPart = value;
                          hasSide = true;
                          _lowerbodySearch.clear();
                        });
                      },
                      searchController: _lowerbodySearch,
                      searchInnerWidget: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 10,
                          top: 10,
                        ),
                        child: TextFormField(
                          controller: _lowerbodySearch,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => _lowerbodySearch.clear(),
                              icon: const Icon(Icons.close),
                            ),
                            hintText: 'Search ...',
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return (item.value.toString().toLowerCase().contains(
                              searchValue.toLowerCase(),
                            ));
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select the part of body';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  PaddingDecorate(5),
                  FormField(
                    builder: (FormFieldState<bool> state) {
                      return Visibility(
                        visible: hasSide,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            state.hasError
                                ? Text(
                                    state.errorText,
                                    style: const TextStyle(color: Colors.red),
                                  )
                                : Container(),
                            RadioListTile(
                              value: 1,
                              title: const Text('Left'),
                              groupValue: _selectedSide,
                              onChanged: (value) {
                                state.setValue(true);
                                setState(() {
                                  _selectedSide = value;
                                });
                              },
                            ),
                            RadioListTile(
                              value: 2,
                              title: const Text('Right'),
                              groupValue: _selectedSide,
                              onChanged: (value) {
                                state.setValue(true);
                                setState(() {
                                  _selectedSide = value;
                                });
                              },
                            ),
                            RadioListTile(
                              value: 3,
                              title: const Text('Both'),
                              groupValue: _selectedSide,
                              onChanged: (value) {
                                state.setValue(true);
                                setState(() {
                                  _selectedSide = value;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value != true && hasSide == true) {
                        return 'Please select the side of body part';
                      } else {
                        return null;
                      }
                    },
                  ),
                  //
                  PaddingDecorate(20),
                  // Type of Injury
                  const Text(
                    'Type of Injury',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  PaddingDecorate(5),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: textdecorate('Code'),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    controller: _codeInjuryType,
                    onSaved: (value) {
                      setState(() {
                        _codeInjuryType.text = value;
                      });
                    },
                    onChanged: (value) {
                      checkOtherType(value);
                      setState(() {
                        _selectedInjuryType = onChangedMethodTypeKey(value);
                        // print(_codeInjuryType.text);
                      });
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  PaddingDecorate(5),
                  DropdownButtonFormField2<String>(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: textdecorate('Select type of injury'),
                    items: _injuryType
                        .map((key, value) {
                          return MapEntry(
                              key,
                              DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ));
                        })
                        .values
                        .toList(),
                    value: _selectedInjuryType,
                    onChanged: (value) {
                      checkOtherType(value);
                      onChangedMethodTypeValue(value);
                      setState(() {
                        _selectedInjuryType = value;
                        _injuryTypeSearch.clear();
                      });
                    },
                    searchController: _injuryTypeSearch,
                    searchInnerWidget: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 10,
                        top: 10,
                      ),
                      child: TextFormField(
                        controller: _injuryTypeSearch,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => _injuryTypeSearch.clear(),
                            icon: const Icon(Icons.close),
                          ),
                          hintText: 'Search ...',
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      return (item.value.toString().toLowerCase().contains(
                            searchValue.toLowerCase(),
                          ));
                    },
                  ),
                  PaddingDecorate(5),
                  Visibility(
                    visible: isVisibleOtherInjuryType,
                    child: TextFormField(
                      decoration: textdecorate('Your type of injury'),
                      controller: _otherInjuryType,
                      autovalidateMode: isVisibleOtherInjuryType
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please fill in your type of injury';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  //
                  PaddingDecorate(20),
                  // Cause of Injury
                  const Text(
                    'Cause of injury',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  PaddingDecorate(5),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: textdecorate('Code'),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    controller: _codeInjuryCause,
                    onSaved: (value) {
                      setState(() {
                        _codeInjuryCause.text = value;
                      });
                    },
                    onChanged: (value) {
                      checkOtherCause(value);
                      setState(() {
                        _selectedInjuryCause = onChangedMethodCauseKey(value);
                      });
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  PaddingDecorate(5),
                  DropdownButtonFormField2<String>(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: textdecorate('Select cause of injury'),
                    dropdownMaxHeight: h / 2,
                    items: _causeOfInjury
                        .map((key, value) {
                          return MapEntry(
                            key,
                            DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          );
                        })
                        .values
                        .toList(),
                    value: _selectedInjuryCause,
                    onChanged: (value) {
                      checkOtherCause(value);
                      onChangedMethodCauseValue(value);
                      setState(() {
                        _selectedInjuryCause = value;
                        _injuryCauseSearch.clear();
                      });
                    },
                    searchController: _injuryCauseSearch,
                    searchInnerWidget: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 10,
                        top: 10,
                      ),
                      child: TextFormField(
                        controller: _injuryCauseSearch,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => _injuryCauseSearch.clear(),
                            icon: const Icon(Icons.close),
                          ),
                          hintText: 'Search ...',
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      return (item.value.toString().toLowerCase().contains(
                            searchValue.toLowerCase(),
                          ));
                    },
                  ),
                  PaddingDecorate(5),
                  Visibility(
                    visible: isVisibleOtherInjuryCause,
                    child: TextFormField(
                      decoration: textdecorate('Your cause of injury'),
                      controller: _otherInjuryCause,
                      autovalidateMode: isVisibleOtherInjuryCause
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                    ),
                  ),
                  //
                  PaddingDecorate(20),
                  // Absence in days
                  const Text(
                    'Absence in days',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  PaddingDecorate(5),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: textdecorateinday('Absence in days'),
                    controller: _absenceDayController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Absence days are required';
                      } else {
                        return null;
                      }
                    },
                  ),
                  PaddingDecorate(20),
                  const Text(
                    'Advice Message',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PaddingDecorate(5),
                  TextFormField(
                    maxLines: 10,
                    keyboardType: TextInputType.text,
                    controller: _messageController,
                    decoration: textdecorate('Description...'),
                  ),
                  //
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding:
            EdgeInsets.only(left: w * 0.2, right: w * 0.2, bottom: h * 0.03),
        child: SizedBox(
          width: w,
          height: h * 0.06,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: const StadiumBorder(),
                primary: Colors.blue.shade200),
            onPressed: () {
              bool isValidate = _injuryKey.currentState.validate();
              if (isValidate) {
                if (widget.data['questionnaireID'] != null) {
                  updateData(widget.data['questionnaireID']);
                }
                if (widget.data['athleteUID'] != null) {
                  sendPushMessage(widget.data['token'], staff);
                }
                // saveMessage();
                saveInjuryReport();
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  void onChangedMethodBodyPartValue(String value) {
    if (bodyType == 1) {
      var bodyPartMapKey = _bodyHeadPart.keys
          .firstWhere((k) => _bodyHeadPart[k] == value, orElse: () => null);
      _codeBodyPart.text = bodyPartMapKey;
    } else if (bodyType == 2) {
      var bodyPartMapKey = _bodyUpperPart.keys
          .firstWhere((k) => _bodyUpperPart[k] == value, orElse: () => null);
      _codeBodyPart.text = bodyPartMapKey;
    } else if (bodyType == 3) {
      var bodyPartMapKey = _bodyLowerPart.keys
          .firstWhere((k) => _bodyLowerPart[k] == value, orElse: () => null);
      _codeBodyPart.text = bodyPartMapKey;
    }
  }

  String onChangedMethodBodyPartKey(String value) {
    if (bodyType == 1) {
      String _bodyHeadPartValue = _bodyHeadPart[value];
      return _bodyHeadPartValue;
    } else if (bodyType == 2) {
      String _bodyUpperPartValue = _bodyUpperPart[value];
      return _bodyUpperPartValue;
    } else if (bodyType == 3) {
      String _bodyLowerPartValue = _bodyLowerPart[value];
      return _bodyLowerPartValue;
    }
    return null;
  }

  void onChangedMethodTypeValue(String value) {
    var injuryTypeMapKey = _injuryType.keys
        .firstWhere((k) => _injuryType[k] == value, orElse: () => null);

    _codeInjuryType.text = injuryTypeMapKey;
  }

  String onChangedMethodTypeKey(String value) {
    String injuryTypeValue = _injuryType[value];
    return injuryTypeValue;
  }

  void onChangedMethodCauseValue(String value) {
    var injuryCauseMapKey = _causeOfInjury.keys
        .firstWhere((k) => _causeOfInjury[k] == value, orElse: () => null);

    _codeInjuryCause.text = injuryCauseMapKey;
  }

  String onChangedMethodCauseKey(String value) {
    String injuryCauseValue = _causeOfInjury[value];
    return injuryCauseValue;
  }

  void checkOtherType(String value) {
    if (value == '20' || value == 'Other') {
      isVisibleOtherInjuryType = true;
    } else {
      isVisibleOtherInjuryType = false;
    }
  }

  void checkOtherCause(String value) {
    if (value == '24' || value == 'Other') {
      isVisibleOtherInjuryCause = true;
    } else {
      isVisibleOtherInjuryCause = false;
    }
  }

  void checkBodyType(String value) {
    if (value == 'Head and Trunk') {
      bodyType = 1;
      isHeadTrunkPart = true;
      isLowerPart = false;
      isUpperPart = false;
    } else if (value == 'Upper extremity') {
      bodyType = 2;
      isHeadTrunkPart = false;
      isLowerPart = false;
      isUpperPart = true;
    } else if (value == 'Lower extremity') {
      bodyType = 3;
      isHeadTrunkPart = false;
      isLowerPart = true;
      isUpperPart = false;
    } else {
      bodyType = 0;
      isHeadTrunkPart = false;
      isLowerPart = false;
      isUpperPart = false;
    }
  }

  final _bodyType = [
    'Head and Trunk',
    'Upper extremity',
    'Lower extremity',
  ];

  final _bodyHeadPart = {
    '1': 'Face',
    '2': 'Head',
    '3': 'Neck / Cervical spine',
    '4': 'Thoracic spine / upper back',
    '5': 'Sternum / ribs',
    '6': 'Lumbar spine / Lower back',
    '7': 'Abdomen',
    '8': 'Pelvis / Sacrum / Buttock',
  };

  final _bodyUpperPart = {
    '11': 'Shoulder / Clavicle',
    '12': 'Upper arm',
    '13': 'Elbow',
    '14': 'Forearm',
    '15': 'Wrist',
    '16': 'Hand',
    '17': 'Finger',
    '18': 'Thumb',
  };

  final _bodyLowerPart = {
    '21': 'Hip',
    '22': 'Groin',
    '23': 'Thigh',
    '24': 'Knee',
    '25': 'Lower leg',
    '26': 'Acilles tendon',
    '27': 'Ankle',
    '28': 'Foot / Toe',
  };

  final _injuryType = {
    '1': 'Concussion',
    '2': 'Fracture (Traumatic)',
    '3': 'Stress fracture (Overuse)',
    '4': 'Other bone injuries',
    '5': 'Dislocation, Subluxation',
    '6': 'Tendon rupture',
    '7': 'Ligamentous rupture',
    '8': 'Sprain',
    '9': 'Lesion of meniscus or cartilage',
    '10': 'Strain / Muscle rupture / Tear',
    '11': 'Contusion / Haematoma / Bruise',
    '12': 'Tendinosis / Tendinipathy',
    '13': 'Arthritis / Synovitis / Bursitis',
    '14': 'Fasciitis / Aponeourosis injury',
    '15': 'Impingement',
    '16': 'Laceration / Abrasion / Skin lesion',
    '17': 'Dental injury / Broken tooth',
    '18': 'Nerver injury / Spinal cord injury',
    '19': 'Muscle cramps or spasm',
    '20': 'Other',
  };

  final _causeOfInjury = {
    '1': 'Overuse (Gradual onset)',
    '2': 'Overuse (Sudden onset)',
    '3': 'Non-contact trauma',
    '4': 'Recurrence of previous injury',
    '11': 'Contact with another athlete',
    '12': 'Contact: Moving object',
    '13': 'Contact: Stagnant object',
    '14': 'Violation of rules',
    '21': 'Field of play conditions',
    '22': 'Weather condition',
    '23': 'Equipment failure',
    '24': 'Other',
  };

  void changeBodySidetoString() {
    switch (_selectedSide) {
      case 1:
        _selectedSideString = 'Left';
        break;
      case 2:
        _selectedSideString = 'Right';
        break;
      case 3:
        _selectedSideString = 'Both';
        break;
      default:
        break;
    }
  }

  Future<void> saveInjuryReport() async {
    print('to save file');
    var uid = FirebaseAuth.instance.currentUser.uid;
    changeBodySidetoString();
    bool isValidate = _injuryKey.currentState.validate();
    if (isVisibleOtherInjuryCause == true) {
      _selectedInjuryCause += ', ${_otherInjuryCause.text.trim()}';
    }
    if (isVisibleOtherInjuryType == true) {
      _selectedInjuryType += ', ${_otherInjuryType.text.trim()}';
    }
    print(isValidate);

    if (isValidate) {
      String report_no = 'IJR';
      String split;
      int latestID;
      NumberFormat format = NumberFormat('0000000000');
      await FirebaseFirestore.instance
          .collection('InjuryRecord')
          .orderBy('report_no', descending: true)
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size == 0) {
          report_no += format.format(1);
        } else {
          querySnapshot.docs
              .forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
            Map data = queryDocumentSnapshot.data();
            split = data['report_no'].toString().split('IJR')[1];
            latestID = int.tryParse(split) + 1;
            report_no += format.format(latestID);
          });
        }
      });
      if (bodyType == 1) {
        InjuryReportData injuryReportModel = InjuryReportData(
            caseUid: widget.data['questionnaireID'],
            report_no: report_no,
            staff_uid: uid,
            athlete_no: _athleteNo.text.trim(),
            report_type: 'Injury',
            sport_event: _selectedSport,
            round_heat_training: _rhtController.text.trim(),
            injuryDateTime: _datetime,
            injuryBodyCode: int.tryParse(_codeBodyPart.text.trim()),
            injuryBody: _selectedBodyHTPart,
            injuryTypeCode: int.tryParse(_codeInjuryType.text.trim()),
            injuryType: _selectedInjuryType,
            injuryCauseCode: int.tryParse(_codeInjuryCause.text.trim()),
            injuryCause: _selectedInjuryCause,
            no_day: _absenceDayController.text.trim(),
            doDate: DateTime.now());

        Map<String, dynamic> data = injuryReportModel.toMap();

        final collectionReference =
            FirebaseFirestore.instance.collection('InjuryRecord');
        DocumentReference docReference = collectionReference.doc();
        docReference.set(data).then((value) {
          showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Insert data successfully'),
                      content: Text(
                          'Your report ID ${docReference.id} is successfully inserted!!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamedAndRemoveUntil(
                                  '/staffPageChoosing', (route) => false),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  })
              .then((value) => print('Insert data to Firestore successfully'));
        });
      } else if (bodyType == 2) {
        InjuryReportData injuryReportModel = InjuryReportData(
            caseUid: widget.data['questionnaireID'],
            report_no: report_no,
            staff_uid: uid,
            athlete_no: _athleteNo.text.trim(),
            report_type: 'Injury',
            sport_event: _selectedSport,
            round_heat_training: _rhtController.text.trim(),
            injuryDateTime: _datetime,
            injuryBodyCode: int.tryParse(_codeBodyPart.text.trim()),
            injuryBody: _selectedBodyUpperPart + ', ' + _selectedSideString,
            injuryTypeCode: int.tryParse(_codeInjuryType.text.trim()),
            injuryType: _selectedInjuryType,
            injuryCauseCode: int.tryParse(_codeInjuryCause.text.trim()),
            injuryCause: _selectedInjuryCause,
            no_day: _absenceDayController.text.trim(),
            doDate: DateTime.now());

        Map<String, dynamic> data = injuryReportModel.toMap();

        final collectionReference =
            FirebaseFirestore.instance.collection('InjuryRecord');
        DocumentReference docReference = collectionReference.doc();
        docReference.set(data).then((value) {
          showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Insert data successfully'),
                      content: Text(
                          'Your report ID ${docReference.id} is successfully inserted!!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamedAndRemoveUntil(
                                  '/staffPageChoosing', (route) => false),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  })
              .then((value) => print('Insert data to Firestore successfully'));
        });
      } else if (bodyType == 3) {
        InjuryReportData injuryReportModel = InjuryReportData(
            caseUid: widget.data['questionnaireID'],
            report_no: report_no,
            staff_uid: uid,
            athlete_no: _athleteNo.text.trim(),
            report_type: 'Injury',
            sport_event: _selectedSport,
            round_heat_training: _rhtController.text,
            injuryDateTime: _datetime,
            injuryBodyCode: int.tryParse(_codeBodyPart.text.trim()),
            injuryBody: _selectedBodyLowerPart + ', ' + _selectedSideString,
            injuryTypeCode: int.tryParse(_codeInjuryType.text.trim()),
            injuryType: _selectedInjuryType,
            injuryCauseCode: int.tryParse(_codeInjuryCause.text.trim()),
            injuryCause: _selectedInjuryCause,
            no_day: _absenceDayController.text.trim(),
            doDate: DateTime.now());

        Map<String, dynamic> data = injuryReportModel.toMap();

        final collectionReference =
            FirebaseFirestore.instance.collection('InjuryRecord');
        DocumentReference docReference = collectionReference.doc();
        docReference.set(data).then((value) {
          showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Insert data successfully'),
                      content: Text(
                          'Your report ID ${docReference.id} is successfully inserted!!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamedAndRemoveUntil(
                                  '/staffPageChoosing', (route) => false),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  })
              .then((value) => print('Insert data to Firestore successfully'));
        });
      }
    }
  }

  void sendPushMessage(String token, Staff staff) async {
    print(token);
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAOmXVBT0:APA91bFonAMAsnJl3UDp2LQHXvThSOQd2j7q01EL1afdZI13TP7VEZxRa7q_Odj3wUL_urjyfS7e0wbgEbwKbUKPkm8p5LFLAVE498z3X4VgNaR5iMF4M9JMpv8s14YsGqI2plf_lCBK',
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'title': 'ข้อมูล ${widget.data['questionnaireNo']} บันทึกเสร็จสิ้น',
            'body':
                'ข้อมูล ${widget.data['questionnaireNo']} ถูกบันทึกโดยสตาฟ ${staff.firstname} ${staff.lastname} ณ วันที่ ${formatDate(DateTime.now(), 'Athlete')} เวลา ${formatTime(DateTime.now())} น.',
          },
          'notification': {
            'title': 'ข้อมูล ${widget.data['questionnaireNo']} บันทึกเสร็จสิ้น',
            'body':
                'ข้อมูล ${widget.data['questionnaireNo']} ถูกบันทึกโดยสตาฟ${staff.firstname} ${staff.lastname} ณ วันที่ ${formatDate(DateTime.now(), 'Athlete')} เวลา ${formatTime(DateTime.now())} น.',
          },
          'to': token,
        }),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateData(String docID) async {
    await FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .doc(docID)
        .update({
      'caseFinished': true,
      'caseFinishedDateTime': DateTime.now(),
      'adviceMessage': _messageController.text,
      'messageReceived': false,
    }).then((value) {
      print('Updated data successfully');
    });
  }
}
