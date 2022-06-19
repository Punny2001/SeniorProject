import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/report-data/illness_report_data.dart';
import 'package:seniorapp/component/report-data/sport_data.dart';

class IllnessReport extends StatefulWidget {
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
  DateTime _occuredDate;
  String _selectedSport = 'Select sport and event';
  String _selectedAffected = 'Select affected systems';
  String _selectedMainSymptom = 'Select main symptom(s)';
  String _selectedIllnessCause = 'Select cause of illness';
  bool isVisibleOtherAffectedSystem = false;
  bool isVisibleOtherMainSymptom = false;
  bool isVisibleOtherIllnessCause = false;
  final List<mainSymptomList> mainSymptoms = [];
  bool isRepeat = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.all(30),
        width: w,
        height: h,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: _illnessKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text('Athlete No.'),
                  ),
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
                DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: sport
                      .map((sport) => DropdownMenuItem(
                            child: Text(sport),
                            value: sport,
                          ))
                      .toList(),
                  value: _selectedSport,
                  onChanged: (value) {
                    setState(() {
                      _selectedSport = value;
                    });
                  },
                  validator: (value) {
                    if (value == 'Select sport and event') {
                      return 'Please select the sport and event';
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Diagnosis'),
                    hintText: 'Example: tonsillitis, cold',
                  ),
                  controller: _diagnosisController,
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
                DateTimePicker(
                  dateLabelText: 'Occured Date',
                  dateMask: 'MMMM d, yyyy',
                  icon: Icon(Icons.event),
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
                    border: OutlineInputBorder(),
                    labelText: 'Code',
                  ),
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
                DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
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
                  onChanged: (value) {
                    checkOtherAffectedSystem(value);
                    onChangedMethodAffectedValue(value);
                    setState(() {
                      _selectedAffected = value;
                    });
                  },
                  validator: (value) {
                    if (value == 'Select affected systems') {
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
                          border: OutlineInputBorder(),
                          labelText: 'Code',
                        ),
                        controller: _codeMainSymptom,
                        onSaved: (value) {
                          setState(() {
                            _codeMainSymptom.text = value;
                          });
                        },
                        onChanged: (value) {
                          checkOtherSymptom(value);
                          setState(() {
                            _selectedMainSymptom =
                                onChangedMethodSymptomKey(value);
                          });
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (mainSymptoms.isEmpty) {
                            if (value.isEmpty) {
                              return 'Please fill in the code of main symptoms';
                            } else if (int.parse(value) == 0 ||
                                int.parse(value) > 12) {
                              return 'The input code is invalid';
                            } else {
                              return null;
                            }
                          } else if (isRepeat) {
                            return 'This symptom is already selected';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      DropdownButtonFormField<String>(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
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
                        onChanged: (value) {
                          checkOtherSymptom(value);
                          onChangedMethodSymptomValue(value);
                          setState(() {
                            _selectedMainSymptom = value;
                          });
                        },
                        validator: (value) {
                          if (value == 'Select main symptom(s)' &&
                              mainSymptoms.isEmpty) {
                            return 'Please select the main symptom(s)';
                          } else if (isRepeat) {
                            return 'This symptom is already selected';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
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
                      addMainSymptomList();
                      setState(() {
                        _selectedMainSymptom = 'Select main symptom(s)';
                        _codeMainSymptom.clear();
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                  alignment: Alignment.centerRight,
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Code',
                  ),
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
                      return 'Please fill in the code of cause of injury';
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
                DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: _causeIllnessList
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
                  value: _selectedIllnessCause,
                  onChanged: (value) {
                    checkOtherCause(value);
                    onChangedMethodCauseValue(value);
                    setState(() {
                      _selectedIllnessCause = value;
                    });
                  },
                  validator: (value) {
                    if (value == 'Select cause of illness') {
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
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
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
                    onPressed: () => saveIllnessReport(),
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
    String AffectedSystemValue = _affectedList[value];
    return AffectedSystemValue;
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
    '0': 'Select affected systems',
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
    '0': 'Select main symptom(s)',
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
    '0': 'Select cause of illness',
    '1': 'Pre-existing',
    '2': 'Infection',
    '3': 'Exercise-induced',
    '4': 'Environmental',
    '5': 'Reaction to medication',
    '6': 'Other',
  };

  void addMainSymptomList() {
    isRepeat = false;
    bool addingValidator = _mainSymptomListKey.currentState.validate();
    mainSymptomList newSymptom = mainSymptomList(
        selectedMainSymptom: _selectedMainSymptom,
        selectedMainSymptomCode: _codeMainSymptom.text);
    if (addingValidator) {
      if (_codeMainSymptom.text != '0' &&
          _selectedMainSymptom != 'Select main symptom(s)') {
        if (mainSymptoms.every((element) =>
            element.selectedMainSymptomCode !=
            newSymptom.selectedMainSymptomCode)) {
          mainSymptoms.add(mainSymptomList(
            selectedMainSymptom: _selectedMainSymptom,
            selectedMainSymptomCode: _codeMainSymptom.text.toString(),
          ));
        } else {
          isRepeat = true;
        }
      }
    }
  }

  Future<void> saveIllnessReport() async {
    var uid = FirebaseAuth.instance.currentUser.uid;
    bool isValidate = _illnessKey.currentState.validate();
    bool addingValidator = _mainSymptomListKey.currentState.validate();
    List<String> getMainSymptomVal = [];

    for (var item in mainSymptoms) {
      getMainSymptomVal.add(item.selectedMainSymptom);
    }

    if (isValidate && addingValidator) {
      IllnessReportData illnessReportModel = IllnessReportData(
          staff_uid: uid,
          athlete_no: _athleteNo.text.trim(),
          report_type: 'Illness',
          sport_event: _selectedSport,
          diagnosis: _diagnosisController.text.trim(),
          occured_date: _occuredDate,
          affected_system: _selectedAffected,
          mainSymptoms: getMainSymptomVal,
          illness_cause: _selectedIllnessCause,
          no_day: _absenceDayController.text.trim());

      Map<String, dynamic> data = illnessReportModel.toMap();

      await FirebaseFirestore.instance
          .collection('Report')
          .doc()
          .set(data)
          .then((value) => print('Insert data to Firestore successfully'))
          .then((value) => Navigator.of(context)
              .pushNamedAndRemoveUntil('/staffPageChoosing', (route) => false));
    }
  }
}

class mainSymptomList {
  final String selectedMainSymptom;
  final String selectedMainSymptomCode;

  mainSymptomList({
    @required this.selectedMainSymptom,
    @required this.selectedMainSymptomCode,
  });
}
