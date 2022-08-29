import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seniorapp/component/report-data/injury_report_data.dart';
import 'package:seniorapp/component/report-data/sport_list.dart';

class InjuryReport extends StatefulWidget {
  const InjuryReport({Key key}) : super(key: key);

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

  // void dispose() {
  //   _sportSearch.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Container(
        margin: const EdgeInsets.all(30),
        width: w,
        height: h,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _injuryKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Athlete No.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: const InputDecoration(
                      fillColor: Color.fromRGBO(217, 217, 217, 100),
                      filled: true,
                      labelText: 'Athlete No.',
                      border: InputBorder.none),
                  controller: _athleteNo,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Athlete No. is required';
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                ),
                const Text(
                  'Sport and Event',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                DropdownButtonFormField2<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color.fromRGBO(217, 217, 217, 100),
                    filled: true,
                  ),
                  hint: const Text('Select sport and event'),
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
                      return 'Please select the sport and event';
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                ),
                const Text(
                  'Round, Heat, or Training',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color.fromRGBO(217, 217, 217, 100),
                    filled: true,
                    label: Text('Round, Heat, or Training'),
                    hintText: 'Example: quater final / 1st heat',
                  ),
                  controller: _rhtController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Round, Heat, or Training is required';
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                ),
                const Text(
                  'Date & Time',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                DateTimePicker(
                  dateLabelText: 'Date',
                  timeLabelText: 'Time',
                  dateMask: 'MMMM d, yyyy',
                  icon: const Icon(Icons.event),
                  type: DateTimePickerType.dateTimeSeparate,
                  lastDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  initialDate: DateTime.now(),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color.fromRGBO(217, 217, 217, 100),
                    filled: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _datetime = DateTime.parse(value);
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Date and Time is required';
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                ),
                const Text(
                  'Injured body part',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                DropdownButtonFormField2<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color.fromRGBO(217, 217, 217, 100),
                    filled: true,
                  ),
                  hint: const Text('Select body type'),
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
                      return 'Please select the type of body';
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                Visibility(
                  visible: isHeadTrunkPart,
                  child: DropdownButtonFormField2<String>(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    fillColor: Color.fromRGBO(217, 217, 217, 100),
                    filled: true,
                    ),
                    dropdownMaxHeight: h / 2,
                    hint: const Text('Select head and trunk part'),
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
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    fillColor: Color.fromRGBO(217, 217, 217, 100),
                    filled: true,
                    ),
                    dropdownMaxHeight: h / 2,
                    hint: const Text('Select upper extremity part'),
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
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    fillColor: Color.fromRGBO(217, 217, 217, 100),
                    filled: true,
                    ),
                    dropdownMaxHeight: h / 2,
                    hint: const Text('Select lower extremity part'),
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
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
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
                    if (value != true) {
                      return 'Please select the side of body part';
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                ),
                const Text(
                  'Type of Injury',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color.fromRGBO(217, 217, 217, 100),
                    filled: true,
                    labelText: 'Code',
                  ),
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please fill in the code of injury types';
                    } else if (int.parse(value) == 0 || int.parse(value) > 20) {
                      return 'The code can be between 1-20';
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                DropdownButtonFormField2<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color.fromRGBO(217, 217, 217, 100),
                    filled: true,
                  ),
                  hint: const Text('Select type of injury'),
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
                  validator: (value) {
                    if (value == null) {
                      return 'Please select the type of injury';
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                Visibility(
                  visible: isVisibleOtherInjuryType,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    fillColor: Color.fromRGBO(217, 217, 217, 100),
                    filled: true,
                      labelText: 'Your type of injury',
                    ),
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
                const Padding(
                  padding: EdgeInsets.all(20),
                ),
                const Text(
                  'Cause of injury',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color.fromRGBO(217, 217, 217, 100),
                    filled: true,
                    labelText: 'Code',
                  ),
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please fill in the code of cause of injury';
                    } else if (int.parse(value) == 0 ||
                        (int.parse(value) > 4 && int.parse(value) < 11) ||
                        (int.parse(value) > 14 && int.parse(value) < 21) ||
                        int.parse(value) > 24) {
                      return 'The input code is invalid';
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                DropdownButtonFormField2<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color.fromRGBO(217, 217, 217, 100),
                    filled: true,
                  ),
                  dropdownMaxHeight: h / 2,
                  hint: const Text('Select cause of injury'),
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
                  validator: (value) {
                    if (value == null) {
                      return 'Please select the cause of injury';
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                Visibility(
                  visible: isVisibleOtherInjuryCause,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    fillColor: Color.fromRGBO(217, 217, 217, 100),
                    filled: true,
                      labelText: 'Your cause of injury',
                    ),
                    controller: _otherInjuryCause,
                    autovalidateMode: isVisibleOtherInjuryCause
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please fill in your cause of injury';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                ),
                const Text(
                  'Absence in days',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color.fromRGBO(217, 217, 217, 100),
                    filled: true,
                    label: Text('Absence in days'),
                    hintText: 'Example: 10 days',
                    suffixText: 'days',
                  ),
                  controller: _absenceDayController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Absence days are required';
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                SizedBox(
                  width: w,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => saveInjuryReport(),
                    child: const Text('Save'),
                  ),
                ),
              ],
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
    var uid = FirebaseAuth.instance.currentUser.uid;
    changeBodySidetoString();
    bool isValidate = _injuryKey.currentState.validate();
    if (isVisibleOtherInjuryCause == true) {
      _selectedInjuryCause += ', ${_otherInjuryCause.text.trim()}';
    }
    if (isVisibleOtherInjuryType == true) {
      _selectedInjuryType += ', ${_otherInjuryType.text.trim()}';
    }
    if (isValidate) {
      if (bodyType == 1) {
        InjuryReportData injuryReportModel = InjuryReportData(
          staff_uid: uid,
          athlete_no: _athleteNo.text.trim(),
          report_type: 'Injury',
          sport_event: _selectedSport,
          round_heat_training: _rhtController.text.trim(),
          injuryDateTime: _datetime,
          injuryBodyCode: int.parse(_codeBodyPart.text.trim()),
          injuryBody: _selectedBodyHTPart,
          injuryTypeCode: int.parse(_codeInjuryType.text.trim()),
          injuryType: _selectedInjuryType,
          injuryCauseCode: int.parse(_codeInjuryCause.text.trim()),
          injuryCause: _selectedInjuryCause,
          no_day: _absenceDayController.text.trim(),
        );

        Map<String, dynamic> data = injuryReportModel.toMap();

        final collectionReference =
            FirebaseFirestore.instance.collection('Report');
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
          staff_uid: uid,
          athlete_no: _athleteNo.text.trim(),
          report_type: 'Injury',
          sport_event: _selectedSport,
          round_heat_training: _rhtController.text.trim(),
          injuryDateTime: _datetime,
          injuryBodyCode: int.parse(_codeBodyPart.text.trim()),
          injuryBody: _selectedBodyUpperPart + ', ' + _selectedSideString,
          injuryTypeCode: int.parse(_codeInjuryType.text.trim()),
          injuryType: _selectedInjuryType,
          injuryCauseCode: int.parse(_codeInjuryCause.text.trim()),
          injuryCause: _selectedInjuryCause,
          no_day: _absenceDayController.text.trim(),
        );

        Map<String, dynamic> data = injuryReportModel.toMap();

        final collectionReference =
            FirebaseFirestore.instance.collection('Report');
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
          staff_uid: uid,
          athlete_no: _athleteNo.text.trim(),
          report_type: 'Injury',
          sport_event: _selectedSport,
          round_heat_training: _rhtController.text,
          injuryDateTime: _datetime,
          injuryBodyCode: int.parse(_codeBodyPart.text.trim()),
          injuryBody: _selectedBodyLowerPart + ', ' + _selectedSideString,
          injuryTypeCode: int.parse(_codeInjuryType.text.trim()),
          injuryType: _selectedInjuryType,
          injuryCauseCode: int.parse(_codeInjuryCause.text.trim()),
          injuryCause: _selectedInjuryCause,
          no_day: _absenceDayController.text.trim(),
        );

        Map<String, dynamic> data = injuryReportModel.toMap();

        final collectionReference =
            FirebaseFirestore.instance.collection('Report');
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
}
