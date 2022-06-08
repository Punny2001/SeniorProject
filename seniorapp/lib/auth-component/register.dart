import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorapp/component/language.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:numberpicker/numberpicker.dart';

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
  int selectedDepartmentValue = 0;
  String _selectedSport = 'Badminton';
  String _selectedStaff = 'Coach';
  bool _passwordhide = true;
  bool _confirmPasswordhide = true;
  DateTime _date;
  final _keyForm = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  bool isVisibleAthlete = false;
  bool isVisibleStaff = false;
  double _selectedWeight = 60.0;
  double _selectedHeight = 170.0;
  bool _emailInUse = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

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
                /// Email registeration
                Text(
                  'register_page.email'.tr(),
                  style: textCustom(),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                TextFormField(
                  key: _emailKey,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'register_page.email_description'.tr(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) {
                    if (email.isEmpty) {
                      return 'register_page.email_required'.tr();
                    } else if (email.isNotEmpty) {
                      print(_emailInUse);
                      print(_emailController.value.text);
                      checkEmailInUse();
                      if (_emailInUse == true) {
                        return 'register_page.email_already_in_use'.tr();
                      } else if (!EmailValidator.validate(email)) {
                        return 'register_page.invalid_email'.tr();
                      }
                    }
                    return null;
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Password registration
                Text(
                  'register_page.password'.tr(),
                  style: textCustom(),
                ),
                const Padding(
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
                    } else if (value.length < 8) {
                      return 'register_page.password_length_error'.tr();
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Confirm registration
                Text(
                  'register_page.confirm_password'.tr(),
                  style: textCustom(),
                ),
                const Padding(
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
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Username textbox
                Text(
                  'register_page.username'.tr(),
                  style: textCustom(),
                ),
                const Padding(
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
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Firstname textbox
                Text(
                  'register_page.firstname'.tr(),
                  style: textCustom(),
                ),
                const Padding(
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
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Lastname textbox
                Text(
                  'register_page.lastname'.tr(),
                  style: textCustom(),
                ),
                const Padding(
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
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// BirthDate Picking
                Text(
                  'register_page.birthdate'.tr(),
                  style: textCustom(),
                ),
                const Padding(
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
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Department choosing
                Text(
                  'register_page.department'.tr(),
                  style: textCustom(),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                FormField(
                  builder: (FormFieldState<bool> state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        state.hasError
                            ? Text(
                                state.errorText,
                                style: const TextStyle(color: Colors.red),
                              )
                            : Container(),

                        /// Athlete
                        RadioListTile(
                          value: 1,
                          groupValue: selectedDepartmentValue,
                          title: Text(
                            'register_page.athlete'.tr(),
                          ),
                          onChanged: (value) {
                            state.setValue(true);
                            setState(() {
                              selectedDepartmentValue = value;
                              getDepartmentText(value);
                              isVisibleAthlete = true;
                              isVisibleStaff = false;
                            });
                          },
                        ),
                        Visibility(
                          visible: isVisibleAthlete,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'register_page.sportType'.tr(),
                                style: textCustom(),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                              ),
                              DropdownButtonFormField<String>(
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
                              const Padding(
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
                              const Padding(
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
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                              ),
                            ],
                          ),
                        ),

                        /// Staff
                        RadioListTile(
                          value: 2,
                          groupValue: selectedDepartmentValue,
                          title: Text(
                            'register_page.staff'.tr(),
                          ),
                          onChanged: (value) {
                            state.setValue(true);
                            setState(() {
                              selectedDepartmentValue = value;
                              getDepartmentText(value);
                              isVisibleStaff = true;
                              isVisibleAthlete = false;
                            });
                          },
                        ),
                        Visibility(
                          visible: isVisibleStaff,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'register_page.staffType'.tr(),
                                style: textCustom(),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                              ),
                              DropdownButtonFormField<String>(
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
                      ],
                    );
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value != true) {
                      return 'register_page.department_required'.tr();
                    }
                    return null;
                  },
                ),
                const Padding(
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

  void getDepartmentText(value) {
    if (value == 1) {
      _selectedDepartment = 'Athlete';
    } else if (selectedDepartmentValue == 2) {
      _selectedDepartment = 'Staff';
    } else {
      _selectedDepartment = '';
    }
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

  Future<bool> checkEmailInUse() async {
    try {
      final emailList = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(_emailController.value.text);

      if (emailList.isNotEmpty) {
        _emailInUse = true;
      } else {
        _emailInUse = false;
      }
    } catch (error) {
      print(error);
    }
  }

  Future signup() async {
    try {
      bool validate = _keyForm.currentState.validate();
      print(_selectedDepartment);
      if (validate &&
          _selectedSport.isNotEmpty &&
          _selectedDepartment.isNotEmpty) {
        if (passwordConfirm() && selectedDepartmentValue == 1) {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim())
              .then((value) async {
            await value.user
                .updateProfile(displayName: _usernameController.text.trim())
                .then((value2) async {
              String uid = value.user.uid;

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
            });
          }).then(
            (value) => Navigator.of(context)
                .pushNamedAndRemoveUntil('/verifyEmail', (route) => false),
          );
        } else if (passwordConfirm() && selectedDepartmentValue == 2) {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim())
              .then((value) async {
            await value.user
                .updateProfile(displayName: _usernameController.text.trim())
                .then((value2) async {
              String uid = value.user.uid;

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
            });
          }).then(
            (value) => Navigator.of(context)
                .pushNamedAndRemoveUntil('/verifyEmail', (route) => false),
          );
        }
      }
    } on FirebaseAuthException catch (error) {
      // if (error.code == 'weak-password') {
      //   print('The password is too weak');
      //   setState(() {
      //     _passwordController != _passwordController;
      //   });
      //   showDialog(
      //     context: context,
      //     builder: (BuildContext context) => AlertDialog(
      //       title: const Text('Registration failed!'),
      //       content:
      //           const Text('Your inserted password is weak. Please refill it.'),
      //       actions: [
      //         TextButton(
      //           onPressed: () => Navigator.of(context).pop(),
      //           child: const Text('OK'),
      //         ),
      //       ],
      //     ),
      //   );
      // } else if (error.code == 'email-already-in-use') {
      //   print('Email is already exist');
      //   showDialog(
      //     context: context,
      //     builder: (BuildContext context) => AlertDialog(
      //       title: const Text('Registration failed!'),
      //       content: const Text(
      //           'The account that used this email is already exist. Please change your email.'),
      //       actions: [
      //         TextButton(
      //             onPressed: () => Navigator.of(context).pop(),
      //             child: const Text('OK'))
      //       ],
      //     ),
      //   );
      // }
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
