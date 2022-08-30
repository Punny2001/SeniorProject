import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seniorapp/component/report-data/illness_report_data.dart';
import 'package:seniorapp/component/report-data/sport_list.dart';

class IllnessReport extends StatefulWidget {
  const IllnessReport({Key key}) : super(key: key);

  @override
  _IllnessReportState createState() => _IllnessReportState();
}

class _IllnessReportState extends State<IllnessReport> {
  final _illnessKey = GlobalKey<FormState>();
  final _mainSymptomListKey = GlobalKey<FormState>();
  final _athleteNo = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _codeAffectedSystem = TextEditingController();
  final _otherAffectedSystem = TextEditingController();
  final _codeMainSymptom = TextEditingController();
  final _otherMainSymptom = TextEditingController();
  final _codeIllnessCause = TextEditingController();
  final _absenceDayController = TextEditingController();
  final _otherIllnessCause = TextEditingController();
  final _sportSearch = TextEditingController();
  final _affectedSearch = TextEditingController();
  final _mainSymptomSearch = TextEditingController();
  final _illnessCauseSearch = TextEditingController();
  DateTime _occuredDate;
  String _selectedSport;
  String _selectedAffected;
  String _selectedMainSymptom;
  String _selectedIllnessCause;
  bool isVisibleOtherAffectedSystem = false;
  bool isVisibleOtherMainSymptom = false;
  bool isVisibleOtherIllnessCause = false;
  final List<MainSymptomList> mainSymptoms = [];
  final List<String> getMainSymptomVal = [];
  final List<int> getMainSymptomCode = [];

  bool isRepeat = false;
  bool valueAdded = false;

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
            key: _illnessKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Athlete no.',
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
                      label: Text('Athlete No.'),
                      fillColor: Color.fromRGBO(217, 217, 217, 100),
                      filled: true,
                      border: InputBorder.none),
                  controller: _athleteNo,
                  onChanged: (value) {},
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Athlete No. is required';
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
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
                      fillColor: Color.fromRGBO(217, 217, 217, 100),
                      filled: true,
                      border: InputBorder.none),
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
                  padding: EdgeInsets.all(10),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                const Text(
                  'Diagnosis',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                      label: Text('Diagnosis'),
                      hintText: 'Example: tonsillitis, cold',
                      fillColor: Color.fromRGBO(217, 217, 217, 100),
                      filled: true,
                      border: InputBorder.none),
                  controller: _diagnosisController,
                  onChanged: (value) {},
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Diagnosis is required';
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                const Text(
                  'Occured Date',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                DateTimePicker(
                  dateLabelText: 'Occured Date',
                  dateMask: 'MMMM d, yyyy',
                  decoration: const InputDecoration(
                    labelText: 'Occured Date',
                    border: InputBorder.none,
                    fillColor: Color.fromRGBO(217, 217, 217, 100),
                    filled: true,
                    suffixIcon: Icon(Icons.event),
                  ),
                  type: DateTimePickerType.date,
                  lastDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  initialDate: DateTime.now(),
                  onChanged: (value) {
                    setState(() {
                      _occuredDate = DateTime.parse(value);
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Occured date is required';
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                ),
                const Text(
                  'Affected System',
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
                  controller: _codeAffectedSystem,
                  onSaved: (value) {
                    setState(() {
                      _codeAffectedSystem.text = value;
                    });
                  },
                  onChanged: (value) {
                    checkOtherAffectedSystem(value);
                    setState(() {
                      _selectedAffected = onChangedMethodAffectedKey(value);
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please fill in the code of affected system';
                    } else if (int.parse(value) == 0 || int.parse(value) > 12) {
                      return 'The code can be between 1-12';
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
                  hint: const Text('Select affected systems'),
                  items: _affectedList
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
                  value: _selectedAffected,
                  dropdownMaxHeight: h / 2,
                  onChanged: (value) {
                    checkOtherAffectedSystem(value);
                    onChangedMethodAffectedValue(value);
                    setState(() {
                      _selectedAffected = value;
                      _affectedSearch.clear();
                    });
                  },
                  searchController: _affectedSearch,
                  searchInnerWidget: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 10,
                      top: 10,
                    ),
                    child: TextFormField(
                      controller: _affectedSearch,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => _affectedSearch.clear(),
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
                      return 'Please select the affected systems';
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                Visibility(
                  visible: isVisibleOtherAffectedSystem,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Your affected system',
                    ),
                    controller: _otherAffectedSystem,
                    autovalidateMode: isVisibleOtherAffectedSystem
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please fill in your affected system';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                const Text(
                  'Main Symptom(s)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                Form(
                  key: _mainSymptomListKey,
                  child: Column(
                    children: [
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
                        controller: _codeMainSymptom,
                        onChanged: (value) {
                          print(int.parse(value));
                          checkOtherSymptom(value);
                          setState(() {
                            _selectedMainSymptom =
                                onChangedMethodSymptomKey(value);
                          });
                          chkRepeat();
                          _mainSymptomListKey.currentState.validate();
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (mainSymptoms.isEmpty) {
                            if (valueAdded == false) {
                              return 'Please add at least 1 main symptom';
                            } else if (value.isNotEmpty &&
                                (int.parse(value) == 0 ||
                                    int.parse(value) > 12)) {
                              return 'The input code is invalid';
                            } else {
                              return null;
                            }
                          } else if (mainSymptoms.isNotEmpty) {
                            if (value.isEmpty || value == null) {
                              return null;
                            } else if (value.isNotEmpty &&
                                (int.parse(value) == 0 ||
                                    int.parse(value) > 12)) {
                              return 'The input code is invalid';
                            } else if (isRepeat == true) {
                              return 'This symptom is already selected';
                            }
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
                        hint: const Text('Select main symptom(s)'),
                        items: _mainSymptomList
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
                        value: _selectedMainSymptom,
                        dropdownMaxHeight: h / 2,
                        onChanged: (value) {
                          checkOtherSymptom(value);
                          onChangedMethodSymptomValue(value);
                          setState(() {
                            _selectedMainSymptom = value;
                            _mainSymptomSearch.clear();
                          });
                          chkRepeat();
                          _mainSymptomListKey.currentState.validate();
                        },
                        searchController: _mainSymptomSearch,
                        searchInnerWidget: Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 10,
                            top: 10,
                          ),
                          child: TextFormField(
                            controller: _mainSymptomSearch,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () => _mainSymptomSearch.clear(),
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
                          if (mainSymptoms.isEmpty && valueAdded == false) {
                            return 'Please add at least 1 main symptom';
                          }
                          if (isRepeat == true && mainSymptoms.isNotEmpty) {
                            return 'This symptom is already selected';
                          } else {
                            return null;
                          }
                        },
                      ),
                      Visibility(
                        visible: isVisibleOtherMainSymptom,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Your main symptom(s)',
                              ),
                              controller: _otherMainSymptom,
                              autovalidateMode: isVisibleOtherMainSymptom
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please fill in your main symptom';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: IconButton(
                          onPressed: () {
                            if (_selectedMainSymptom.isNotEmpty) {
                              addMainSymptomList();
                              setState(() {
                                _selectedMainSymptom = null;
                                _codeMainSymptom.clear();
                              });
                            }
                          },
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    ],
                  ),
                ),
                mainSymptoms.isNotEmpty
                    ? Column(
                        children: <Widget>[
                          for (var item in mainSymptoms)
                            Card(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(item.selectedMainSymptomCode),
                                    Text(item.selectedMainSymptom),
                                    IconButton(
                                      alignment: Alignment.centerRight,
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        setState(() {
                                          mainSymptoms.remove(item);
                                          isAdded();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      )
                    : const Padding(
                        padding: EdgeInsets.all(0),
                      ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                const Text(
                  'Cause of illness',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
                    fillColor: Color.fromRGBO(217, 217, 217, 100),
                    filled: true,
                    labelText: 'Code',
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  controller: _codeIllnessCause,
                  onSaved: (value) {
                    setState(() {
                      _codeIllnessCause.text = value;
                    });
                  },
                  onChanged: (value) {
                    checkOtherCause(value);
                    setState(() {
                      _selectedIllnessCause = onChangedMethodCauseKey(value);
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please fill in the code of cause of illness';
                    } else if (int.parse(value) < 1 || int.parse(value) > 6) {
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
                  hint: Text('Select cause of illness'),
                  items: _causeIllnessList
                      .map((key, value) {
                        return MapEntry(
                            key,
                            DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ));
                      })
                      .values
                      .toList(),
                  value: _selectedIllnessCause,
                  onChanged: (value) {
                    checkOtherCause(value);
                    onChangedMethodCauseValue(value);
                    setState(() {
                      _selectedIllnessCause = value;
                      _illnessCauseSearch.clear();
                    });
                  },
                  dropdownMaxHeight: h / 3,
                  searchController: _illnessCauseSearch,
                  searchInnerWidget: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 10,
                      top: 10,
                    ),
                    child: TextFormField(
                      controller: _illnessCauseSearch,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => _illnessCauseSearch.clear(),
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
                  visible: isVisibleOtherIllnessCause,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Your cause of illness',
                    ),
                    controller: _otherIllnessCause,
                    autovalidateMode: isVisibleOtherIllnessCause
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please fill in your cause of illness';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
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
                    onPressed: () {
                      saveIllnessReport();
                      setState(() {});
                    },
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

  void onChangedMethodAffectedValue(String value) {
    var affectedMapKey = _affectedList.keys
        .firstWhere((k) => _affectedList[k] == value, orElse: () => null);

    _codeAffectedSystem.text = affectedMapKey;
  }

  String onChangedMethodAffectedKey(String value) {
    String affectedSystemValue = _affectedList[value];
    return affectedSystemValue;
  }

  void onChangedMethodSymptomValue(String value) {
    var injuryCauseMapKey = _mainSymptomList.keys
        .firstWhere((k) => _mainSymptomList[k] == value, orElse: () => null);

    _codeMainSymptom.text = injuryCauseMapKey;
  }

  String onChangedMethodSymptomKey(String value) {
    String mainSymptomValue = _mainSymptomList[value];
    return mainSymptomValue;
  }

  void checkOtherAffectedSystem(String value) {
    if (value == '12' || value == 'Other') {
      isVisibleOtherAffectedSystem = true;
    } else {
      isVisibleOtherAffectedSystem = false;
    }
  }

  void checkOtherSymptom(String value) {
    if (value == '12' || value == 'Other') {
      isVisibleOtherMainSymptom = true;
    } else {
      isVisibleOtherMainSymptom = false;
    }
  }

  void onChangedMethodCauseValue(String value) {
    var illnessCauseMapKey = _causeIllnessList.keys
        .firstWhere((k) => _causeIllnessList[k] == value, orElse: () => null);

    _codeIllnessCause.text = illnessCauseMapKey;
  }

  String onChangedMethodCauseKey(String value) {
    String illnessCauseValue = _causeIllnessList[value];
    return illnessCauseValue;
  }

  void checkOtherCause(String value) {
    if (value == '6' || value == 'Other') {
      isVisibleOtherIllnessCause = true;
    } else {
      isVisibleOtherIllnessCause = false;
    }
  }

  final _affectedList = {
    '1': 'Respiratory / ear, nose, throat',
    '2': 'Gastro-intestinal',
    '3': 'Uro-genital / Gynaecological',
    '4': 'Cardio-vascular',
    '5': 'Allergic / Immunological',
    '6': 'Metabolic / Endocrinological',
    '7': 'Haematological',
    '8': 'Neurological / Psychiatric',
    '9': 'Dermatologic',
    '10': 'Musculo-skeletal',
    '11': 'Dental',
    '12': 'Other',
  };

  final _mainSymptomList = {
    '1': 'Fever',
    '2': 'Pain',
    '3': 'Diarrhoea, Vomiting',
    '4': 'Dyspnoea, Cough',
    '5': 'Palpitations',
    '6': 'Hyper-thermia',
    '7': 'Hypo-thermia',
    '8': 'Dehydration',
    '9': 'Syncope, Collapse',
    '10': 'Anaphylaxis',
    '11': 'Lethargy, Dizziness',
    '12': 'Other',
  };

  final _causeIllnessList = {
    '1': 'Pre-existing',
    '2': 'Infection',
    '3': 'Exercise-induced',
    '4': 'Environmental',
    '5': 'Reaction to medication',
    '6': 'Other'
  };

  void addMainSymptomList() {
    isRepeat = false;
    valueAdded = true;
    bool addingValidator = _mainSymptomListKey.currentState.validate();
    if (isVisibleOtherMainSymptom == true) {
      _selectedMainSymptom += ', ${_otherMainSymptom.text.trim()}';
    }
    MainSymptomList newSymptom = MainSymptomList(
        selectedMainSymptom: _selectedMainSymptom,
        selectedMainSymptomCode: _codeMainSymptom.text);
    if (addingValidator) {
      if (int.parse(_codeMainSymptom.text) != 0 &&
          int.parse(_codeMainSymptom.text) <= 12 &&
          _selectedMainSymptom.isNotEmpty) {
        if (mainSymptoms.every((element) =>
            element.selectedMainSymptomCode !=
            newSymptom.selectedMainSymptomCode)) {
          mainSymptoms.add(MainSymptomList(
            selectedMainSymptom: _selectedMainSymptom,
            selectedMainSymptomCode: _codeMainSymptom.text.toString(),
          ));
        }
      }
    }
  }

  void chkRepeat() {
    print(isRepeat);
    print(_selectedMainSymptom + ', ' + _codeMainSymptom.text);
    if (isVisibleOtherMainSymptom == true) {
      _selectedMainSymptom += ', ${_otherMainSymptom.text.trim()}';
    }
    MainSymptomList chkSymptom = MainSymptomList(
        selectedMainSymptom: _selectedMainSymptom,
        selectedMainSymptomCode: _codeMainSymptom.text);
    if (mainSymptoms.any((element) =>
        chkSymptom.selectedMainSymptomCode == element.selectedMainSymptomCode ||
        chkSymptom.selectedMainSymptom == element.selectedMainSymptom)) {
      isRepeat = true;
    } else {
      isRepeat = false;
    }
  }

  void isAdded() {
    if (mainSymptoms.isEmpty) {
      valueAdded = false;
    } else {
      valueAdded = true;
    }
  }

  Future<void> saveIllnessReport() async {
    var uid = FirebaseAuth.instance.currentUser.uid;
    bool isValidate = _illnessKey.currentState.validate();
    bool addingValidator = _mainSymptomListKey.currentState.validate();
    if (isVisibleOtherAffectedSystem == true) {
      _selectedAffected += ', ${_otherAffectedSystem.text.trim()}';
    }
    if (isVisibleOtherIllnessCause == true) {
      _selectedIllnessCause += ', ${_otherIllnessCause.text.trim()}';
    }

    for (var item in mainSymptoms) {
      getMainSymptomVal.add(item.selectedMainSymptom);
      getMainSymptomCode.add(int.parse(item.selectedMainSymptomCode));
    }

    if (isValidate && (addingValidator || valueAdded == true)) {
      IllnessReportData illnessReportModel = IllnessReportData(
          staff_uid: uid,
          athlete_no: _athleteNo.text.trim(),
          report_type: 'Illness',
          sport_event: _selectedSport,
          diagnosis: _diagnosisController.text.trim(),
          occured_date: _occuredDate,
          affected_system: _selectedAffected,
          affected_system_code: int.parse(_codeAffectedSystem.text.trim()),
          mainSymptoms: getMainSymptomVal,
          mainSymptomsCode: getMainSymptomCode,
          illness_cause: _selectedIllnessCause,
          illness_cause_code: int.parse(_codeIllnessCause.text.trim()),
          no_day: _absenceDayController.text.trim());

      Map<String, dynamic> data = illnessReportModel.toMap();

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
            }).then((value) => print('Insert data to Firestore successfully'));
      });
    }
  }
}

class MainSymptomList {
  final String selectedMainSymptom;
  final String selectedMainSymptomCode;

  MainSymptomList({
    @required this.selectedMainSymptom,
    @required this.selectedMainSymptomCode,
  });
}
