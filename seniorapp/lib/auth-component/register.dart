import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorapp/component/language.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  String _selectedDepartment = '';
  String _selectedSport = 'Badminton';
  String _selectedStaff = 'Coach';
  bool _passwordhide = true;
  bool _confirmPasswordhide = true;
  DateTime _date;
  final _keyForm = GlobalKey<FormState>();
  bool isAthlete = false;
  double _selectedWeight = 60.0;
  double _selectedHeight = 170.0;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;  
    isAthleteCheck();

    return Scaffold(
      appBar: AppBar(
        actions: [LanguageSign()],
      ),
      body: Container(
        margin: const EdgeInsets.all(30),
        width: w,
        height: h,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _keyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Password registration
                Text(
                  'register_page.password'.tr(),
                  style: textCustom(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _passwordhide,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'register_page.password_description'.tr(),
                    suffixIcon: IconButton(
                      icon: Icon(_passwordhide
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordhide = !_passwordhide;
                        });
                      },
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'register_page.password_required'.tr();
                    }
                    if (value.length < 8) {
                      return 'register_page.password_length_error'.tr();
                    } 
                    else {
                      return null;
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Confirm registration
                Text(
                  'register_page.confirm_password'.tr(),
                  style: textCustom(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _confirmPasswordhide,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'register_page.confirmpassword_description'.tr(),
                    suffixIcon: IconButton(
                      icon: Icon(_confirmPasswordhide
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _confirmPasswordhide = !_confirmPasswordhide;
                        });
                      },
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'register_page.confirmpassword_required'.tr();
                    } else if (!passwordConfirm()) {
                      return 'register_page.confirmpassword_notmatch'.tr();
                    } else {
                      return null;
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Username textbox
                Text(
                  'register_page.username'.tr(),
                  style: textCustom(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'register_page.username_description'.tr(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'register_page.username_required'.tr();
                    } else {
                      return null;
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Firstname textbox
                Text(
                  'register_page.firstname'.tr(),
                  style: textCustom(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                TextFormField(
                  controller: _firstnameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'register_page.firstname_description'.tr(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'register_page.firstname_required'.tr();
                    } else {
                      return null;
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Lastname textbox
                Text(
                  'register_page.lastname'.tr(),
                  style: textCustom(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                TextFormField(
                  controller: _lastnameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'register_page.lastname_description'.tr(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'register_page.lastname_required'.tr();
                    } else {
                      return null;
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// BirthDate Picking
                Text(
                  'register_page.birthdate'.tr(),
                  style: textCustom(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                DateTimePicker(
                  type: DateTimePickerType.date,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'register_page.birthdate_description'.tr(),
                    suffixIcon: const Icon(Icons.calendar_month),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _date = DateTime.parse(value);
                    });
                  },
                  dateMask: 'MMMM d, yyyy',
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'register_page.birthdate_required'.tr();
                    } else {
                      return null;
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                        isAthlete ? 
//Athlete
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'register_page.sportType'.tr(),
                                style: textCustom(),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                              ),
                              DropdownButtonFormField2<String>(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                items: sportList
                                    .map((sport) => DropdownMenuItem(
                                          child: Text(sport),
                                          value: sport,
                                        ))
                                    .toList(),
                                value: _selectedSport,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSport = value;
                                  });
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 20),
                              ),

                              /// Weight & Height
                              Text(
                                'register_page.weight'.tr(),
                                style: textCustom(),
                              ),
                              DecimalNumberPicker(
                                minValue: 30,
                                maxValue: 200,
                                decimalPlaces: 1,
                                value: _selectedWeight,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedWeight = value;
                                  });
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                              ),
                              Text(
                                'register_page.height'.tr(),
                                style: textCustom(),
                              ),
                              DecimalNumberPicker(
                                minValue: 150,
                                maxValue: 200,
                                decimalPlaces: 1,
                                value: _selectedHeight,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedHeight = value;
                                  });
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                              ),
                            ],
                          ),
                        )

                        :

                        /// Staff
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'register_page.staffType'.tr(),
                                style: textCustom(),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                              ),
                              DropdownButtonFormField2<String>(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                items: staffList
                                    .map((staff) => DropdownMenuItem(
                                          child: Text(staff),
                                          value: staff,
                                        ))
                                    .toList(),
                                value: _selectedStaff,
                                hint: const Text('Select type of staff'),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedStaff = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Sign Up button
                ElevatedButton(
                  onPressed: () => signup(),
                  child: Text('register_page.signup_button'.tr()),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(w / 1.1, h / 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle textCustom() {
    return const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  }

  bool passwordConfirm() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  Future isAthleteCheck() async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance.collection('User').doc(uid).get().then((value) {
      if (value['department'] == 'Athlete') {
        isAthlete = true;
      }
      else {
        isAthlete = false;
      }
    });
  }

  Future signup() async {
    try {
      bool validate = _keyForm.currentState.validate();
      String uid = FirebaseAuth.instance.currentUser.uid;
      print(uid);
      print(_selectedDepartment);
      if (validate &&
          _selectedSport.isNotEmpty) {
        if (passwordConfirm() && _selectedDepartment == 'Athlete') {
            await FirebaseAuth.instance.currentUser.updateProfile(displayName: _usernameController.text.trim())
                .then((value2) async {
              String uid = FirebaseAuth.instance.currentUser.uid;

              Athlete athleteModel = Athlete(
                  username: _usernameController.text.trim(),
                  firstname: _firstnameController.text.trim(),
                  lastname: _lastnameController.text.trim(),
                  sportType: _selectedSport,
                  date: _date,
                  department: _selectedDepartment,
                  weight: _selectedWeight,
                  height: _selectedHeight);

              Map<String, dynamic> data = athleteModel.toMap();

              await FirebaseFirestore.instance
                  .collection('User')
                  .doc(uid)
                  .set(data)
                  .then(
                    (value) => print('Insert data to Firestore successfully'),
                  );
            })
          .then(
            (value) => Navigator.of(context)
                .pushNamedAndRemoveUntil('/staffPageChoosing', (route) => false),
          );
        } else if (passwordConfirm() && _selectedDepartment == 'Staff') {
            await FirebaseAuth.instance.currentUser
                .updateProfile(displayName: _usernameController.text.trim())
                .then((value2) async {
              Staff staffModel = Staff(
                  username: _usernameController.text.trim(),
                  firstname: _firstnameController.text.trim(),
                  lastname: _lastnameController.text.trim(),
                  birthdate: _date,
                  department: _selectedDepartment,
                  staffType: _selectedStaff);

              Map<String, dynamic> data = staffModel.toMap();

              await FirebaseFirestore.instance
                  .collection('User')
                  .doc(uid)
                  .set(data)
                  .then(
                    (value) => print('Insert data to Firestore successfully'),
                  );
            }).then(
            (value) => Navigator.of(context)
                .pushNamedAndRemoveUntil('/staffPageChoosing', (route) => false),
          );
        }
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        print('Invalid email format');
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Registration failed!'),
            content: const Text(
                'The format of email is invalid. Please correct the email.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      print(error);
    }
  }

  List<String> sportList = [
    'Badminton',
    'Basketball',
    'Boxing',
    'Football',
    'Judo',
    'Rugby',
    'VolleyBall'
  ];

  List<String> staffList = [
    'Coach',
    'Doctor',
    'Physical Therapist',
    'Psychologist',
  ];
}
