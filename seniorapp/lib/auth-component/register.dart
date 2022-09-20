import 'dart:math';

import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorapp/component/language.dart';
import 'package:seniorapp/component/report-data/sport_list.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/component/user-data/id_generator.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:seniorapp/decoration/padding.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  String _selectedSport;
  String _selectedStaff;
  int _selectedDept;
  bool _passwordhide = true;
  bool _confirmPasswordhide = true;
  DateTime _birthdate;
  final _keyForm = GlobalKey<FormState>();
  bool isAthlete = false;
  bool isStaff = false;
  String _selectedDepartment;
  double _selectedWeight = 60.0;
  double _selectedHeight = 170.0;
  String _selectedGender;
  int age;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    isAthleteCheck();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          LanguageSign(),
          IconButton(
              onPressed: () => Navigator.of(context).pushNamed('/login'),
              icon: Icon(Icons.arrow_back))
        ],
      ),
      backgroundColor: Colors.lightBlue,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            Container(
              width: w,
              height: h / 1.55,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Background_register.PNG"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 300.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 170.0),
              child: Container(
                margin: const EdgeInsets.all(42),
                decoration: const BoxDecoration(
                  color: Colors.lightBlue,
                ),
                child: Column(
                  children: [
                    Form(
                      key: _keyForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Password registration
                          Text(
                            'register_page.password'.tr(),
                            style: textCustom(),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'register_page.password_required'.tr();
                              }
                              if (value.length < 8) {
                                return 'register_page.password_length_error'
                                    .tr();
                              } else {
                                return null;
                              }
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _passwordController,
                            obscureText: _passwordhide,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: const Color(0xFFCFD8DC),
                              filled: true,
                              hintText:
                                  'register_page.password_description'.tr(),
                              hintStyle:
                                  const TextStyle(fontFamily: 'OpenSans'),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordhide
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordhide = !_passwordhide;
                                  });
                                },
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                          ),
                          Text(
                            'register_page.confirm_password'.tr(),
                            style: textCustom(),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'register_page.confirmpassword_required'
                                    .tr();
                              } else if (!passwordConfirm()) {
                                return 'register_page.confirmpassword_notmatch'
                                    .tr();
                              } else {
                                return null;
                              }
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _confirmPasswordController,
                            obscureText: _confirmPasswordhide,
                            decoration: InputDecoration(
                              fillColor: const Color(0xFFCFD8DC),
                              filled: true,
                              border: InputBorder.none,
                              hintText:
                                  'register_page.confirmpassword_description'
                                      .tr(),
                              hintStyle:
                                  const TextStyle(fontFamily: 'OpenSans'),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _confirmPasswordhide
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _confirmPasswordhide =
                                        !_confirmPasswordhide;
                                  });
                                },
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                          ),
                          Text(
                            'register_page.username'.tr(),
                            style: textCustom(),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                          ),
                          //////Email container
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'register_page.username_required'.tr();
                              } else {
                                return null;
                              }
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _usernameController,
                            decoration: InputDecoration(
                                fillColor: const Color(0xFFCFD8DC),
                                filled: true,
                                prefixIcon: const Icon(
                                  Icons.account_circle,
                                  color: Colors.black,
                                ),
                                hintText:
                                    'register_page.username_description'.tr(),
                                hintStyle:
                                    const TextStyle(fontFamily: 'OpenSans'),
                                border: InputBorder.none),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                          ),
                          Text(
                            'register_page.firstname'.tr(),
                            style: textCustom(),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'register_page.firstname_required'.tr();
                              } else {
                                return null;
                              }
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _firstnameController,
                            decoration: InputDecoration(
                                fillColor: const Color(0xFFCFD8DC),
                                filled: true,
                                prefixIcon: const Icon(
                                  Icons.perm_identity,
                                  color: Colors.black,
                                ),
                                hintText:
                                    'register_page.firstname_description'.tr(),
                                hintStyle:
                                    const TextStyle(fontFamily: 'OpenSans'),
                                border: InputBorder.none),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                          ),
                          ////// Lastname textbox
                          Text(
                            'register_page.lastname'.tr(),
                            style: textCustom(),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'register_page.lastname_required'.tr();
                              } else {
                                return null;
                              }
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _lastnameController,
                            decoration: InputDecoration(
                                fillColor: const Color(0xFFCFD8DC),
                                filled: true,
                                prefixIcon: const Icon(
                                  Icons.perm_identity,
                                  color: Colors.black,
                                ),
                                hintText:
                                    'register_page.lastname_description'.tr(),
                                hintStyle:
                                    const TextStyle(fontFamily: 'OpenSans'),
                                border: InputBorder.none),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                          ),

                          /// BirthDate Picking
                          Text(
                            'register_page.birthdate'.tr(),
                            style: textCustom(),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                          ),
                          DateTimePicker(
                            type: DateTimePickerType.date,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: const Color(0xFFCFD8DC),
                              filled: true,
                              hintText:
                                  'register_page.birthdate_description'.tr(),
                              suffixIcon: const Icon(Icons.calendar_month),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _birthdate = DateTime.parse(value);
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
                          // TextFieldContainer(
                          //   child: TextFormField(
                          //     controller: dateCtl,
                          //     decoration: InputDecoration(
                          //         border: InputBorder.none,
                          //         fillColor: const Color(0xFFCFD8DC),
                          //         filled: true,
                          //         hintText: 'register_page.birthdate_description'.tr(),
                          //         suffixIcon: const Icon(Icons.calendar_month),
                          //       ),
                          //       onChanged: (value) {
                          //         setState(() {
                          //           _birthdate = DateTime.parse(value);
                          //         });
                          //       },
                          //       validator: (value) {
                          //         if (value.isEmpty) {
                          //           return 'register_page.birthdate_required'.tr();
                          //         } else {
                          //           return null;
                          //         }
                          //       },
                          //   onTap: () async{
                          //     DateTime date = DateTime(1900);
                          //     FocusScope.of(context).requestFocus(FocusNode());
                          //
                          //     date = await showDatePicker(
                          //         context: context,
                          //         initialDate:DateTime.now(),
                          //         firstDate:DateTime(1900),
                          //         lastDate: DateTime(2100));
                          //
                          //     dateCtl.text = date.toString();
                          //     },
                          //   ),
                          // ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                          ),

                          Text(
                            'Gender',
                            style: textCustom(),
                          ),
                          FormField(
                            builder: (FormFieldState<bool> state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  state.hasError
                                      ? Text(
                                          state.errorText,
                                          style: const TextStyle(
                                              color: Colors.red),
                                        )
                                      : Container(),
                                  RadioListTile(
                                    value: 'Male',
                                    title: const Text('Male'),
                                    groupValue: _selectedGender,
                                    onChanged: (value) {
                                      state.setValue(true);
                                      setState(() {
                                        _selectedGender = value;
                                      });
                                    },
                                  ),
                                  RadioListTile(
                                    value: 'Female',
                                    title: const Text('Female'),
                                    groupValue: _selectedGender,
                                    onChanged: (value) {
                                      state.setValue(true);
                                      setState(() {
                                        _selectedGender = value;
                                      });
                                    },
                                  ),
                                  RadioListTile(
                                    value: 'LGBTQ+',
                                    title: const Text('LGBTQ+'),
                                    groupValue: _selectedGender,
                                    onChanged: (value) {
                                      state.setValue(true);
                                      setState(() {
                                        _selectedGender = value;
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value != true) {
                                return 'Please select a gender';
                              } else {
                                return null;
                              }
                            },
                          ),
                          Text(
                            'Department',
                            style: textCustom(),
                          ),
                          FormField(
                            builder: (FormFieldState<bool> state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  state.hasError
                                      ? Text(
                                          state.errorText,
                                          style: const TextStyle(
                                              color: Colors.red),
                                        )
                                      : Container(),
                                  RadioListTile(
                                    activeColor: Colors.white,
                                    value: 1,
                                    title: const Text('Athlete'),
                                    groupValue: _selectedDept,
                                    onChanged: (value) {
                                      state.setValue(true);
                                      setState(() {
                                        _selectedDept = value;
                                        isAthlete = true;
                                        isStaff = false;
                                      });
                                    },
                                  ),
                                  RadioListTile(
                                    value: 2,
                                    title: const Text('Staff'),
                                    groupValue: _selectedDept,
                                    onChanged: (value) {
                                      state.setValue(true);
                                      setState(() {
                                        _selectedDept = value;
                                        isAthlete = false;
                                        isStaff = true;
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value != true) {
                                return 'Please select the department';
                              } else {
                                return null;
                              }
                            },
                          ),

                          Visibility(
                            visible: isAthlete,
                            child: //Athlete
                                Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'register_page.sportType'.tr(),
                                  style: textCustom(),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                ),
                                DropdownButtonFormField2<String>(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Color(0xFFCFD8DC),
                                    filled: true,
                                  ),
                                  hint: const Text('Select type of sport'),
                                  items: sportList
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
                                    if (value == null) {
                                      return 'Please select the sport';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                PaddingDecorate(20),

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
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 40),
                                ),
                                PaddingDecorate(10),
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
                              ],
                            ),
                          ),

                          Visibility(
                            visible: isStaff,
                            child:

                                /// Staff
                                Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'register_page.staffType'.tr(),
                                  style: textCustom(),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                ),
                                DropdownButtonFormField2<String>(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Color(0xFFCFD8DC),
                                    filled: true,
                                  ),
                                  hint: const Text('Select type of staff'),
                                  items: staffList
                                      .map((staff) => DropdownMenuItem(
                                            child: Text(staff),
                                            value: staff,
                                          ))
                                      .toList(),
                                  value: _selectedStaff,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedStaff = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select the sport and event';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 17),
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
                  ],
                ),
              ),
            ),
          ],
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
    if (_selectedDept == 1) {
      _selectedDepartment = 'Athlete';
    } else {
      _selectedDepartment = 'Staff';
    }
  }

  Future signup() async {
    try {
      bool validate = _keyForm.currentState.validate();
      String uid = FirebaseAuth.instance.currentUser.uid;
      String email = FirebaseAuth.instance.currentUser.email.toString();
      age = AgeCalculator.age(_birthdate).years;

      print(uid);
      isAthleteCheck();
      if (validate) {
        if (passwordConfirm() && _selectedDepartment == 'Athlete') {
          await FirebaseAuth.instance.currentUser
              .updatePassword(_passwordController.text.trim());
          await FirebaseAuth.instance.currentUser
              .updateProfile(displayName: _usernameController.text.trim())
              .then((value2) async {
            String uid = FirebaseAuth.instance.currentUser.uid;
            String athlete_no = 'A';
            athlete_no += get_athleteID();

            Athlete athleteModel = Athlete(
                athlete_no: athlete_no,
                username: _usernameController.text.trim(),
                firstname: _firstnameController.text.trim(),
                lastname: _lastnameController.text.trim(),
                sportType: _selectedSport,
                birthdate: _birthdate,
                department: 'Athlete',
                weight: _selectedWeight,
                height: _selectedHeight,
                email: email,
                gender: _selectedGender,
                age: age);

            Map<String, dynamic> data = athleteModel.toMap();

            await FirebaseFirestore.instance
                .collection('Athlete')
                .doc(uid)
                .set(data)
                .then(
                  (value) => print('Insert data to Firestore successfully'),
                );
          }).then(
            (value) => Navigator.of(context).pushNamedAndRemoveUntil(
                '/athletePageChoosing', (route) => false),
          );
        } else if (passwordConfirm() && _selectedDepartment == 'Staff') {
          await FirebaseAuth.instance.currentUser
              .updateProfile(displayName: _usernameController.text.trim())
              .then((value2) async {
            String staff_no = 'S';
            staff_no += get_staffID();

            Staff staffModel = Staff(
                staff_no: staff_no,
                username: _usernameController.text.trim(),
                firstname: _firstnameController.text.trim(),
                lastname: _lastnameController.text.trim(),
                birthdate: _birthdate,
                department: 'Staff',
                staffType: _selectedStaff,
                email: email,
                gender: _selectedGender,
                age: age);

            Map<String, dynamic> data = staffModel.toMap();

            await FirebaseFirestore.instance
                .collection('Staff')
                .doc(uid)
                .set(data)
                .then(
                  (value) => print('Insert data to Firestore successfully'),
                );
          }).then(
            (value) => Navigator.of(context).pushNamedAndRemoveUntil(
                '/staffPageChoosing', (route) => false),
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

  List<String> staffList = [
    'Coach',
    'Doctor',
    'Physical Therapist',
    'Psychologist',
  ];
}
