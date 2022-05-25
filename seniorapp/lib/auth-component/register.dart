import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:seniorapp/auth-component/login.dart';
import 'package:seniorapp/component/athlete/athlete-data.dart';
import 'package:date_time_picker/date_time_picker.dart';

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
  String _selectedDepartment = '';
  int selectedDepartmentValue = 0;
  String _selectedSport = 'Football';
  String _selectedStaff = 'Coach';
  bool _passwordhide = true;
  bool _confirmPasswordhide = true;
  DateTime _date;
  final _keyForm = GlobalKey<FormState>();
  bool isVisibleAthlete = false;
  bool isVisibleStaff = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
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
                  'Email',
                  style: textCustom(),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email address',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Email is required';
                    } else {
                      return null;
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Password registration
                Text(
                  'Password',
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
                    hintText: 'Password must morethan 6 characters',
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Password is required';
                    } else if (value.length < 6) {
                      return 'Please fill in password morethan 6 characters';
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
                  'Confirm password',
                  style: textCustom(),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                TextFormField(
                  enableSuggestions: true,
                  controller: _confirmPasswordController,
                  obscureText: _confirmPasswordhide,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Confirm password',
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Confirm password is required';
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
                  'Username',
                  style: textCustom(),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Username',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Username is required';
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
                  'Firstname',
                  style: textCustom(),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                TextFormField(
                  controller: _firstnameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Firstname',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Firstname is required';
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
                  'Lastname',
                  style: textCustom(),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                TextFormField(
                  controller: _lastnameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Lastname',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Lastname is required';
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
                  'Birthdate',
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Birthdate',
                    suffixIcon: Icon(Icons.calendar_month),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _date = DateTime.parse(value);
                    });
                  },
                  dateMask: 'MMMM d, yyyy',
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Birthdate is required';
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
                  'Department Type',
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
                          title: const Text(
                            'Athlete',
                          ),
                          onChanged: (value) {
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
                                'Sport Type',
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
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSport = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        /// Staff
                        RadioListTile(
                          value: 2,
                          groupValue: selectedDepartmentValue,
                          title: const Text(
                            'Staff',
                          ),
                          onChanged: (value) {
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
                                'Staff Type',
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
                  validator: (value) {
                    if (value != true) {
                      return 'Please select your department.';
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
                  child: const Text("Sign Up"),
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
      _selectedDepartment = 'Athelete';
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

  Future signup() async {
    try {
      bool validate = _keyForm.currentState.validate();
      if (validate &&
          _selectedSport.isNotEmpty &&
          _selectedDepartment.isNotEmpty) {
        if (passwordConfirm() && selectedDepartmentValue == 1) {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());
          Athlete(
                  _usernameController.text.trim(),
                  _firstnameController.text.trim(),
                  _lastnameController.text.trim(),
                  _date,
                  _selectedDepartment,
                  _selectedSport)
              .atheleSetup();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(completeSnackBar);
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        print('The password is too weak');
        setState(() {
          _passwordController != _passwordController;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Registration failed!'),
            content:
                const Text('Your inserted password is weak. Please refill it.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (error.code == 'email-already-in-use') {
        print('Email is already exist');
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Registration failed!'),
            content: const Text(
                'The account that used this email is already exist. Please change your email.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'))
            ],
          ),
        );
      } else if (error.code == 'invalid-email') {
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
                  child: const Text('OK'))
            ],
          ),
        );
      }
    } catch (error) {
      print(error);
    }
  }

  List<String> sportList = [
    'Football',
    'Basketball',
    'Badminton',
    'Boxing',
    'Judo',
    'Rugby',
    'VolleyBall'
  ];

  List<String> staffList = [
    'Coach',
    'Doctor',
    'Psychologist',
    'Physical Therapist'
  ];

  var completeSnackBar = const SnackBar(
    content: Text('Please fill in the information completely.'),
  );
}
