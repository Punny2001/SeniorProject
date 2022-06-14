import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/language.dart';

class IllnessReport extends StatefulWidget {
  @override
  _IllnessReportState createState() => _IllnessReportState();
}

class _IllnessReportState extends State<IllnessReport> {
  final _injuryKey = GlobalKey<FormState>();
  final _athleteNo = TextEditingController();
  final _sportEvent = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _codeAffectedSystem = TextEditingController();
  final _otherAffectedSystem = TextEditingController();
  final _codeMainSymptom = TextEditingController();
  final _otherMainSymptom = TextEditingController();
  final _absenceDayController = TextEditingController();
  DateTime _occuredDate;
  String _selectedAffected = 'Select affected systems';
  String _selectedMainSymptom = 'Select main symptom(s)';
  bool isVisibleOtherAffectedSystem = false;
  bool isVisibleOtherMainSymptom = false;

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
            key: _injuryKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
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
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text('Sport and Event'),
                    hintText: 'Example: football (men)',
                  ),
                  controller: _sportEvent,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Sport and Event is required';
                    } else {
                      return null;
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                TextFormField(
                  decoration: InputDecoration(
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
                Padding(
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
                Padding(
                  padding: EdgeInsets.all(20),
                ),
                Text(
                  'Affected System',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
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
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
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
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Visibility(
                  visible: isVisibleOtherAffectedSystem,
                  child: TextFormField(
                    decoration: InputDecoration(
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
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Text(
                  'Main Symptom(s)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
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
                      _selectedMainSymptom = onChangedMethodSymptomKey(value);
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please fill in the code of main symptoms';
                    } else if (int.parse(value) == 0 || int.parse(value) > 12) {
                      return 'The input code is invalid';
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
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
                    if (value == 'Select the main symptom(s)') {
                      return 'Please select the main symptom(s)';
                    } else {
                      return null;
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Visibility(
                  visible: isVisibleOtherMainSymptom,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Your main symptom(s)',
                    ),
                    controller: _otherMainSymptom,
                    autovalidateMode: isVisibleOtherMainSymptom
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
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
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
}
