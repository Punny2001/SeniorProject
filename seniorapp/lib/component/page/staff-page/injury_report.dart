import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/language.dart';

class InjuryReport extends StatefulWidget {
  @override
  _InjuryReportState createState() => _InjuryReportState();
}

class _InjuryReportState extends State<InjuryReport> {
  final _injuryKey = GlobalKey<FormState>();
  final _athleteNo = TextEditingController();
  final  _sportEvent = TextEditingController();
  final _codeInjuryType = TextEditingController();
  final _otherInjuryType = TextEditingController();
  final _codeInjuryCause = TextEditingController();
  final _otherInjuryCause = TextEditingController();
  DateTime _datetime;
  String _selectedInjuryType = 'Select type of injury';
  String _selectedInjuryCause = 'Select cause of injury';
  bool isVisibleOtherInjuryType = false;
  bool isVisibleOtherInjuryCause = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: [
          LanguageSign(),
        ],
      ),
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
                    }
                    else {
                      return null;
                    }
                  },
                ),
                Padding(padding: EdgeInsets.all(10),),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text('Sport and Event'),
                    hintText: 'Example: swimming - 4x100m freestyle relay (women)',
                    hintStyle: TextStyle(fontSize: 13),
                  ),
                  controller: _sportEvent,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Sport and Event is required';
                    }
                    else {
                      return null;
                    }
                  },
                ),
                Padding(padding: EdgeInsets.all(10),),
                DateTimePicker(
                  dateLabelText: 'Date',
                  timeLabelText: 'Time',
                  dateMask: 'MMMM d, yyyy',
                  icon: Icon(Icons.event),
                  type: DateTimePickerType.dateTimeSeparate,
                  lastDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  initialDate: DateTime.now(),
                  onChanged: (value) {
                    setState(() {
                      _datetime = DateTime.parse(value);
                    });
                  },
                  validator: (value) {
                    if(value.isEmpty) {
                      return 'Date and Time is required';
                    }
                    else {
                      return null;
                    }
                  },
                ),
                Padding(padding: EdgeInsets.all(20),),
                Text('Type of Injury', 
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Padding(padding: EdgeInsets.all(10),),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Code',
                  ),
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
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please fill in the code of injury types';
                    }
                    else if (int.parse(value) == 0 || int.parse(value) > 20) {
                      return 'The code can be between 1-20';
                    }
                  },
                ),
                Padding(padding: EdgeInsets.all(10),),
    
                DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(border: OutlineInputBorder(),),
                  items: _injuryType.map((key, value) {
                    return MapEntry(key, DropdownMenuItem(value: value, child: Text(value),));
                  }).values.toList(),
                  value: _selectedInjuryType,
                  onChanged: (value) {
                    checkOtherType(value);
                    onChangedMethodTypeValue(value);
                    setState(() {
                      _selectedInjuryType = value;
                    });
                  },
                  validator: (value) {
                    if (value == 'Select type of injury') {
                      return 'Please select the type of injury';
                    }
                    else {
                      return null;
                    }
                  },
                ),
                Padding(padding: EdgeInsets.all(10),),
                Visibility(
                  visible: isVisibleOtherInjuryType,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Your type of injury',
                    ),
                    controller: _otherInjuryType,
                    autovalidateMode: isVisibleOtherInjuryType ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please fill in your typre of injury';
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.all(10),),

                Text('Cause of injury', 
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Padding(padding: EdgeInsets.all(10),),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Code',
                  ),
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
                    }
                    else if (int.parse(value) == 0 || (int.parse(value) > 4 && int.parse(value) < 11) || (int.parse(value) > 14 && int.parse(value) < 21) || int.parse(value) > 24) {
                      return 'The input code is invalid';
                    }
                  },
                ),
                Padding(padding: EdgeInsets.all(10),),
                DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(border: OutlineInputBorder(),),
                  items: _causeOfInjury.map((key, value) {
                    return MapEntry(key, DropdownMenuItem(value: value, child: Text(value),));
                  }).values.toList(),
                  value: _selectedInjuryCause,
                  onChanged: (value) {
                    checkOtherCause(value);
                    onChangedMethodCauseValue(value);
                    setState(() {
                      _selectedInjuryCause = value;
                    });
                  },
                  validator: (value) {
                    if (value == 'Select cause of injury') {
                      return 'Please select the cause of injury';
                    }
                    else {
                      return null;
                    }
                  },
                ),
                Padding(padding: EdgeInsets.all(10),),
                Visibility(
                  visible: isVisibleOtherInjuryCause,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Your cause of injury',
                    ),
                    controller: _otherInjuryCause,
                    autovalidateMode: isVisibleOtherInjuryCause ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please fill in your cause of injury';
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onChangedMethodTypeValue(String value) {
    var injuryTypeMapKey = _injuryType.keys.firstWhere(
    (k) => _injuryType[k] == value, orElse: () => null);

    _codeInjuryType.text = injuryTypeMapKey;
  }
  
  String onChangedMethodTypeKey(String value) {
    String injuryTypeValue = _injuryType[value];
    return injuryTypeValue;
  }

  void onChangedMethodCauseValue(String value) {
    var injuryCauseMapKey = _causeOfInjury.keys.firstWhere(
    (k) => _causeOfInjury[k] == value, orElse: () => null);

    _codeInjuryCause.text = injuryCauseMapKey;
  }
  
  String onChangedMethodCauseKey(String value) {
    String injuryCauseValue = _causeOfInjury[value];
    return injuryCauseValue;
  }

  void checkOtherType(String value) {
    if (value == '20' || value == 'Other') {
      isVisibleOtherInjuryType = true;
    }
    else {
      isVisibleOtherInjuryType = false;
    }
  }

  void checkOtherCause(String value) {
    if (value == '24' || value == 'Other') {
      isVisibleOtherInjuryCause = true;
    }
    else {
      isVisibleOtherInjuryCause = false;
    }
  }

  final _injuryType = {
    '0': 'Select type of injury',
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
  
  final _injuryTypeTH = {
    '0': 'เลือกประเภทของการบาดเจ็บ',
    '1': 'การถูกกระทบกระแทก',
    '2': 'กระดูกหัก (บาดแผล)',
    '3': 'การแตกหักของความเครียด (การใช้มากเกินไป)',
    '4': 'อาการบาดเจ็บที่กระดูกอื่นๆ',
    '5': 'ความคลาดเคลื่อน, Subluxation',
    '6': 'เอ็นแตก',
    '7': 'เอ็นแตก',
    '8': 'แพลง',
    '9': 'รอยโรคของวงเดือนหรือกระดูกอ่อน',
    '10': 'ความเครียด / กล้ามเนื้อแตก / การฉีกขาด',
    '11': 'ฟกช้ำ / ห้อ / ช้ำ',
    '12': 'Tendinosis / Tendinipathy',
    '13': 'ข้ออักเสบ / ไขข้ออักเสบ / Bursitis',
    '14': 'อาการบาดเจ็บจากโรค Fasciitis / Aponeourosis',
    '15': 'การปะทะ',
    '16': 'การฉีกขาด / การถลอก / รอยโรคที่ผิวหนัง',
    '17': 'ฟันบาดเจ็บ / ฟันหัก',
    '18': 'อาการบาดเจ็บที่เส้นประสาท / อาการบาดเจ็บที่ไขสันหลัง',
    '19': 'กล้ามเนื้อเป็นตะคริวหรือกระตุก',
    '20': 'อื่นๆ',
  };

  final _causeOfInjury = {
    '0': 'Select cause of injury',
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
}