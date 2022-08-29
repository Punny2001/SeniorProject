import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorapp/component/language.dart';
import 'package:seniorapp/component/report-data/sport_list.dart';
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
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  String _selectedSport;
  String _selectedStaff;
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
          //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [LanguageSign()],
      ),
      body: SizedBox(
        width: w,
        height: h,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              Container(
                width: 650,
                height: 286/1.2,
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
                  height: MediaQuery.of(context).size.height * 1.485,
                  decoration: const BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(top:300.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 170.0),
                child: Container(
                  margin: const EdgeInsets.all(42),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.lightBlue,
                  ),
                  child: Column(
                    children: [
                      Form(
                        key: _keyForm,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
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
                                  return 'register_page.password_length_error'.tr();
                                } else {
                                  return null;
                                }
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: _passwordController,
                              obscureText: _passwordhide,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: const Color(0xFFCFD8DC),
                                filled: true,
                                hintText: 'register_page.password_description'.tr(),
                                hintStyle: const TextStyle(fontFamily: 'OpenSans'),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(_passwordhide
                                      ? Icons.visibility
                                      : Icons.visibility_off, color: Colors.black,),
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
                                  return 'register_page.confirmpassword_required'.tr();
                                } else if (!passwordConfirm()) {
                                  return 'register_page.confirmpassword_notmatch'.tr();
                                } else {
                                  return null;
                                }
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: _confirmPasswordController,
                              obscureText: _confirmPasswordhide,
                              decoration: InputDecoration(
                                fillColor: const Color(0xFFCFD8DC),
                                filled: true,
                                border: InputBorder.none,
                                hintText: 'register_page.confirmpassword_description'.tr(),
                                hintStyle: const TextStyle(fontFamily: 'OpenSans'),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(_confirmPasswordhide
                                      ? Icons.visibility
                                      : Icons.visibility_off, color: Colors.black,),
                                  onPressed: () {
                                    setState(() {
                                      _confirmPasswordhide = !_confirmPasswordhide;
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
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: _usernameController,
                              decoration: InputDecoration(
                                  fillColor: const Color(0xFFCFD8DC),
                                  filled: true,
                                  prefixIcon: const Icon(
                                    Icons.account_circle,
                                    color: Colors.black,
                                  ),
                                  hintText: 'register_page.username_description'.tr(),
                                  hintStyle: const TextStyle(fontFamily: 'OpenSans'),
                                  border: InputBorder.none
                              ),
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
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: _firstnameController,
                              decoration: InputDecoration(
                                  fillColor: const Color(0xFFCFD8DC),
                                  filled: true,
                                  prefixIcon: const Icon(
                                    Icons.perm_identity,
                                    color: Colors.black,
                                  ),
                                  hintText: 'register_page.firstname_description'.tr(),
                                  hintStyle: const TextStyle(fontFamily: 'OpenSans'),
                                  border: InputBorder.none
                              ),
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
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: _lastnameController,
                              decoration: InputDecoration(
                                  fillColor: const Color(0xFFCFD8DC),
                                  filled: true,
                                  prefixIcon: const Icon(
                                    Icons.perm_identity,
                                    color: Colors.black,
                                  ),
                                  hintText: 'register_page.lastname_description'.tr(),
                                  hintStyle: const TextStyle(fontFamily: 'OpenSans'),
                                  border: InputBorder.none
                              ),
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
                            //           _date = DateTime.parse(value);
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

                            isAthlete
                                ?
                            //Athlete
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
                                  padding: EdgeInsets.only(bottom: 155),
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
                                  padding: EdgeInsets.only(bottom: 15),
                                ),
                              ],
                            )
                                :

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
      } else {
        isAthlete = false;
      }
    });
  }

  Future signup() async {
    try {
      bool validate = _keyForm.currentState.validate();
      String uid = FirebaseAuth.instance.currentUser.uid;
      print(uid);
      isAthleteCheck();
      if (validate) {
        if (passwordConfirm() && isAthlete == true) {
          await FirebaseAuth.instance.currentUser
              .updatePassword(_passwordController.text.trim());
          await FirebaseAuth.instance.currentUser
              .updateProfile(displayName: _usernameController.text.trim())
              .then((value2) async {
            String uid = FirebaseAuth.instance.currentUser.uid;

            Athlete athleteModel = Athlete(
                username: _usernameController.text.trim(),
                firstname: _firstnameController.text.trim(),
                lastname: _lastnameController.text.trim(),
                sportType: _selectedSport,
                date: _date,
                department: 'Athlete',
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
          }).then(
            (value) => Navigator.of(context).pushNamedAndRemoveUntil(
                '/athletePageChoosing', (route) => false),
          );
        } else if (passwordConfirm() && isAthlete == false) {
          await FirebaseAuth.instance.currentUser
              .updateProfile(displayName: _usernameController.text.trim())
              .then((value2) async {
            Staff staffModel = Staff(
                username: _usernameController.text.trim(),
                firstname: _firstnameController.text.trim(),
                lastname: _lastnameController.text.trim(),
                birthdate: _date,
                department: 'Staff',
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
