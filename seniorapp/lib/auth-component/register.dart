import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorapp/component/page/add_association.dart';
import 'package:seniorapp/component/report-data/sport_list.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:seniorapp/decoration/authentication/textfield_login.dart';
import 'package:seniorapp/decoration/padding.dart';
import 'package:seniorapp/pdpa.dart';

class Register extends StatefulWidget {
  const Register({Key key}) : super(key: key);

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
  final _phoneNoController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final _firstnameFocusNode = FocusNode();
  final _lastnameFocusNode = FocusNode();
  final _phoneNoFocusNode = FocusNode();
  final _genderFocusNode = FocusNode();
  final _birthdateFocusNode = FocusNode();

  String selectedAssociation;
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
  String token;

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((tok) {
      setState(() {
        token = tok;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    isAthleteCheck();
    association.sort();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        primary: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 113, 157, 242),
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.of(context).pop();
            });
          },
          alignment: Alignment.centerRight,
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: Container(
        height: h,
        margin: EdgeInsets.only(
          right: w * 0.1,
          left: w * 0.1,
          bottom: w * 0.1,
        ),
        width: double.infinity,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Form(
                key: _keyForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email (อีเมล)',
                      style: textCustom(),
                    ),
                    PaddingDecorate(5),
                    TextFormField(
                      focusNode: _emailFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          if (!_emailFocusNode.hasFocus) {
                            _emailFocusNode.requestFocus();
                          }
                          return 'Email address is required';
                        } else {
                          return null;
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _emailController,
                      decoration: textdecorate_login(
                        Icons.email,
                        'Email Address',
                      ),
                    ),
                    PaddingDecorate(15),

                    /// Password registration
                    Text(
                      'Password (รหัสผ่าน)',
                      style: textCustom(),
                    ),
                    PaddingDecorate(5),
                    TextFormField(
                      focusNode: _passwordFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          if (!_passwordFocusNode.hasFocus) {
                            _passwordFocusNode.requestFocus();
                          }
                          return 'register_page.password_required'.tr();
                        }
                        if (value.length < 8) {
                          if (!_passwordFocusNode.hasFocus) {
                            _passwordFocusNode.requestFocus();
                          }
                          return 'register_page.password_length_error'.tr();
                        } else {
                          return null;
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _passwordController,
                      obscureText: _passwordhide,
                      decoration: InputDecoration(
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: CupertinoColors.systemGrey5,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: CupertinoColors.systemGrey5,
                          ),
                        ),
                        fillColor: CupertinoColors.systemGrey5,
                        filled: true,
                        hintText: 'register_page.password'.tr(),
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
                    Text(
                      'register_page.password_description'.tr(),
                    ),
                    PaddingDecorate(15),
                    ////
                    Text(
                      'Confirm Password \n(ยืนยันรหัสผ่าน)',
                      style: textCustom(),
                    ),
                    PaddingDecorate(5),
                    TextFormField(
                      focusNode: _confirmPasswordFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          if (!_confirmPasswordFocusNode.hasFocus) {
                            _confirmPasswordFocusNode.requestFocus();
                          }
                          return 'register_page.confirmpassword_required'.tr();
                        } else if (!passwordConfirm()) {
                          if (!_confirmPasswordFocusNode.hasFocus) {
                            _confirmPasswordFocusNode.requestFocus();
                          }
                          return 'register_page.confirmpassword_notmatch'.tr();
                        } else {
                          return null;
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _confirmPasswordController,
                      obscureText: _confirmPasswordhide,
                      decoration: InputDecoration(
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: CupertinoColors.systemGrey5,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: CupertinoColors.systemGrey5,
                          ),
                        ),
                        fillColor: CupertinoColors.systemGrey5,
                        filled: true,
                        hintText:
                            'register_page.confirmpassword_description'.tr(),
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
                              _confirmPasswordhide = !_confirmPasswordhide;
                            });
                          },
                        ),
                      ),
                    ),
                    PaddingDecorate(15),
                    Text(
                      'Username (ชื่อผู้ใช้งาน)',
                      style: textCustom(),
                    ),
                    PaddingDecorate(5),
                    //////User container
                    TextFormField(
                      focusNode: _usernameFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          if (!_usernameFocusNode.hasFocus) {
                            _usernameFocusNode.requestFocus();
                          }
                          return 'register_page.username_required'.tr();
                        } else {
                          return null;
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _usernameController,
                      decoration: textdecorate_login(
                        Icons.account_circle,
                        'register_page.username_description'.tr(),
                      ),
                    ),
                    PaddingDecorate(15),
                    Text(
                      'Firstname (ชื่อจริง)',
                      style: textCustom(),
                    ),
                    PaddingDecorate(5),
                    TextFormField(
                      focusNode: _firstnameFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          if (!_firstnameFocusNode.hasFocus) {
                            _firstnameFocusNode.requestFocus();
                          }
                          return 'register_page.firstname_required'.tr();
                        } else {
                          return null;
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _firstnameController,
                      decoration: textdecorate_login(
                        Icons.perm_identity,
                        'register_page.firstname_description'.tr(),
                      ),
                    ),
                    PaddingDecorate(15),
                    ////// Lastname textbox
                    Text(
                      'Lastname (นามสกุล)',
                      style: textCustom(),
                    ),
                    PaddingDecorate(5),
                    TextFormField(
                      focusNode: _lastnameFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          if (!_lastnameFocusNode.hasFocus) {
                            _lastnameFocusNode.requestFocus();
                          }
                          return 'register_page.lastname_required'.tr();
                        } else {
                          return null;
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _lastnameController,
                      decoration: textdecorate_login(
                        Icons.perm_identity,
                        'register_page.lastname_description'.tr(),
                      ),
                    ),
                    PaddingDecorate(15),

                    /// BirthDate Picking
                    Text(
                      'Date of Birth (วันเกิด)',
                      style: textCustom(),
                    ),
                    PaddingDecorate(5),
                    DateTimePicker(
                      focusNode: _birthdateFocusNode,
                      type: DateTimePickerType.date,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.calendar_month,
                          color: Colors.black,
                        ),
                        fillColor: CupertinoColors.systemGrey5,
                        filled: true,
                        hintText: 'register_page.birthdate_description'.tr(),
                        hintStyle: const TextStyle(fontFamily: 'OpenSans'),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: CupertinoColors.systemGrey5,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: CupertinoColors.systemGrey5,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _birthdate = DateTime.parse(value);
                        });
                      },
                      dateMask: 'MMMM d, yyyy',
                      validator: (value) {
                        if (value.isEmpty) {
                          if (!_birthdateFocusNode.hasFocus) {
                            _birthdateFocusNode.requestFocus();
                          }
                          return 'register_page.birthdate_required'.tr();
                        } else {
                          return null;
                        }
                      },
                    ),
                    PaddingDecorate(15),
                    Text(
                      'Phone No. (เบอร์โทร)',
                      style: textCustom(),
                    ),
                    PaddingDecorate(5),
                    TextFormField(
                      focusNode: _phoneNoFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          if (!_phoneNoFocusNode.hasFocus) {
                            _phoneNoFocusNode.requestFocus();
                          }
                          return 'Please insert your phone number';
                        }
                        if (value.length != 10) {
                          if (!_phoneNoFocusNode.hasFocus) {
                            _phoneNoFocusNode.requestFocus();
                          }
                          return 'Please insert all 10 numbers of your phone';
                        } else {
                          return null;
                        }
                      },
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _phoneNoController,
                      decoration: textdecorate_login(
                        Icons.phone,
                        'Phone number',
                      ),
                    ),
                    PaddingDecorate(15),
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
                                ? Focus(
                                    focusNode: _genderFocusNode,
                                    onFocusChange: (bool value) {
                                      if (!_genderFocusNode.hasFocus) {
                                        _genderFocusNode.requestFocus();
                                      }
                                    },
                                    child: Text(
                                      state.errorText,
                                      style: const TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                : Container(),
                            RadioListTile(
                              activeColor:
                                  const Color.fromARGB(255, 113, 157, 242),
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
                              activeColor:
                                  const Color.fromARGB(255, 113, 157, 242),
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
                              activeColor:
                                  const Color.fromARGB(255, 113, 157, 242),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value != true) {
                          return 'Please select a gender';
                        } else {
                          return null;
                        }
                      },
                    ),
                    PaddingDecorate(15),
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
                                    style: const TextStyle(color: Colors.red),
                                  )
                                : Container(),
                            RadioListTile(
                              activeColor:
                                  const Color.fromARGB(255, 113, 157, 242),
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
                              activeColor:
                                  const Color.fromARGB(255, 113, 157, 242),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value != true) {
                          return 'Please select the department';
                        } else {
                          return null;
                        }
                      },
                    ),
                    PaddingDecorate(10),
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
                          PaddingDecorate(5),
                          DropdownButtonFormField2<String>(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            icon: const Icon(Icons.arrow_drop_down_circle),
                            decoration: const InputDecoration(
                              fillColor: CupertinoColors.systemGrey5,
                              filled: true,
                              hintText: 'Select type of sport',
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
                                  color: CupertinoColors.systemGrey5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CupertinoColors.systemGrey5,
                                ),
                              ),
                            ),
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
                          PaddingDecorate(15),

                          /// Weight & Height
                          Text(
                            'register_page.weight'.tr(),
                            style: textCustom(),
                          ),
                          DecimalNumberPicker(
                            minValue: 30,
                            maxValue: 200,
                            decimalPlaces: 1,
                            textStyle: TextStyle(
                              color: Colors.blueGrey[100],
                              fontWeight: FontWeight.bold,
                            ),
                            selectedTextStyle: TextStyle(
                              fontSize: h * 0.03,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 113, 157, 242),
                            ),
                            value: _selectedWeight,
                            onChanged: (value) {
                              setState(() {
                                _selectedWeight = value;
                              });
                            },
                          ),
                          PaddingDecorate(10),
                          Text(
                            'register_page.height'.tr(),
                            style: textCustom(),
                          ),
                          DecimalNumberPicker(
                            textStyle: TextStyle(
                              color: Colors.blueGrey[100],
                              fontWeight: FontWeight.bold,
                            ),
                            selectedTextStyle: TextStyle(
                              fontSize: h * 0.03,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 113, 157, 242),
                            ),
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
                            icon: const Icon(Icons.arrow_drop_down_circle),
                            decoration: const InputDecoration(
                              fillColor: CupertinoColors.systemGrey5,
                              filled: true,
                              hintText: 'Select type of staff',
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
                                  color: CupertinoColors.systemGrey5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CupertinoColors.systemGrey5,
                                ),
                              ),
                            ),
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
                    PaddingDecorate(15),
                    Text(
                      'Association (องค์กร)',
                      style: textCustom(),
                    ),
                    PaddingDecorate(5),
                    DropdownButtonFormField2<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      icon: const Icon(Icons.arrow_drop_down_circle),
                      decoration: const InputDecoration(
                        fillColor: CupertinoColors.systemGrey5,
                        filled: true,
                        hintText: 'Choose an association',
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
                            color: CupertinoColors.systemGrey5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: CupertinoColors.systemGrey5,
                          ),
                        ),
                      ),
                      items: association
                          .map((association) => DropdownMenuItem(
                                child: Text(association),
                                value: association,
                              ))
                          .toList(),
                      value: selectedAssociation,
                      onChanged: (value) {
                        setState(() {
                          selectedAssociation = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'โปรดเลือกองค์กรที่คุณสังกัด';
                        } else {
                          return null;
                        }
                      },
                    ),
                    PaddingDecorate(15),

                    /// Sign Up button
                    ElevatedButton(
                      onPressed: () {
                        bool validate = _keyForm.currentState.validate();
                        if (validate == true) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PDPAWidget(
                                signUp: signup,
                              ),
                            ),
                          );
                        }
                      },
                      // onPressed: () => signup(),
                      child: Text(
                        'register_page.signup_button'.tr(),
                        style: TextStyle(
                          color: Colors.blueGrey[50],
                          fontSize: h * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(w, h * 0.07),
                        elevation: 0,
                        primary: const Color.fromARGB(255, 113, 157, 242),
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ],
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
    if (_selectedDept == 1) {
      _selectedDepartment = 'Athlete';
    } else {
      _selectedDepartment = 'Staff';
    }
  }

  Future<void> signup() async {
    try {
      bool validate = _keyForm.currentState.validate();
      age = AgeCalculator.age(_birthdate).years;

      isAthleteCheck();
      if (validate) {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim())
            .then((value) async {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim())
              .then((value) async {
            if (passwordConfirm() && _selectedDepartment == 'Athlete') {
              await FirebaseAuth.instance.currentUser
                  .updateDisplayName(_usernameController.text.trim())
                  .then((value2) async {
                String uid = FirebaseAuth.instance.currentUser.uid;

                String athlete_no = 'A';
                String split;
                int latestID;
                NumberFormat format = NumberFormat('0000000000');
                await FirebaseFirestore.instance
                    .collection('Athlete')
                    .orderBy('athlete_no', descending: true)
                    .limit(1)
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  if (querySnapshot.size == 0) {
                    athlete_no += format.format(1);
                  } else {
                    querySnapshot.docs
                        .forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
                      Map data = queryDocumentSnapshot.data();
                      split = data['athlete_no'].toString().split('A')[1];
                      latestID = int.parse(split) + 1;
                      athlete_no += format.format(latestID);
                    });
                  }
                });

                Athlete athleteModel = Athlete(
                  token: token,
                  athlete_no: athlete_no,
                  username: _usernameController.text.trim(),
                  firstname: _firstnameController.text.trim(),
                  lastname: _lastnameController.text.trim(),
                  sportType: _selectedSport,
                  birthdate: _birthdate,
                  phoneNo: _phoneNoController.text.trim(),
                  department: 'Athlete',
                  weight: _selectedWeight,
                  height: _selectedHeight,
                  email: _emailController.text.trim(),
                  gender: _selectedGender,
                  age: age,
                  pdpaAgreement: true,
                  association: selectedAssociation,
                );

                Map<String, dynamic> data = athleteModel.toMap();

                await FirebaseFirestore.instance
                    .collection('Athlete')
                    .doc(uid)
                    .set(data)
                    .then(
                      (value) => print('Insert data to Firestore successfully'),
                    );
              }).then((value) {
                FirebaseMessaging.instance.unsubscribeFromTopic('Staff');
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/athletePageChoosing', (route) => false);
              });
            } else if (passwordConfirm() && _selectedDepartment == 'Staff') {
              await FirebaseAuth.instance.currentUser
                  .updateDisplayName(_usernameController.text.trim())
                  .then((value2) async {
                String staff_no = 'S';
                String split;
                int latestID;
                NumberFormat format = NumberFormat('0000000000');
                await FirebaseFirestore.instance
                    .collection('Staff')
                    .orderBy('staff_no', descending: true)
                    .limit(1)
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  if (querySnapshot.size == 0) {
                    staff_no += format.format(1);
                  } else {
                    querySnapshot.docs
                        .forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
                      Map data = queryDocumentSnapshot.data();
                      split = data['staff_no'].toString().split('S')[1];
                      latestID = int.parse(split) + 1;
                      staff_no += format.format(latestID);
                    });
                  }
                });
                String uid = FirebaseAuth.instance.currentUser.uid;

                Staff staffModel = Staff(
                  token: token,
                  staff_no: staff_no,
                  username: _usernameController.text.trim(),
                  firstname: _firstnameController.text.trim(),
                  lastname: _lastnameController.text.trim(),
                  birthdate: _birthdate,
                  department: 'Staff',
                  phoneNo: _phoneNoController.text.trim(),
                  staffType: _selectedStaff,
                  email: _emailController.text.trim(),
                  gender: _selectedGender,
                  age: age,
                  pdpaAgreement: true,
                  association: selectedAssociation,
                );

                Map<String, dynamic> data = staffModel.toMap();

                await FirebaseFirestore.instance
                    .collection('Staff')
                    .doc(uid)
                    .set(data)
                    .then(
                      (value) => print('Insert data to Firestore successfully'),
                    );
              }).then(
                (value) {
                  FirebaseMessaging.instance.subscribeToTopic('Staff');
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/staffPageChoosing', (route) => false);
                },
              );
            }
          });
        });
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
    'Sport Scientist'
  ];
}
