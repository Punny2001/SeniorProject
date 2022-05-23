import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorapp/auth-component/login.dart';
import 'package:seniorapp/auth-component/userdata.dart';
import 'package:date_time_picker/date_time_picker.dart';

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
  String _selectedSport = 'Football';
  bool _passwordhide = true;
  bool _confirmPasswordhide = true;
  DateTime _date;
  final _keyForm = GlobalKey<FormState>();

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
            key: _keyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Email registeration
                Text(
                  'Email',
                  style: textCustom(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
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
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Password registration
                Text(
                  'Password',
                  style: textCustom(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _passwordhide,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
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
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Confirm registration
                Text(
                  'Confirm password',
                  style: textCustom(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _confirmPasswordhide,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
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
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Username textbox
                Text(
                  'Username',
                  style: textCustom(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Username',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Firstname textbox
                Text(
                  'Firstname',
                  style: textCustom(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                TextFormField(
                  controller: _firstnameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Firstname',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Lastname textbox
                Text(
                  'Lastname',
                  style: textCustom(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                TextFormField(
                  controller: _lastnameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Lastname',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// BirthDate Picking
                Text(
                  'Birthdate',
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
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Sport Type choosing
                Text(
                  'Sport Type',
                  style: textCustom(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                DropdownButtonFormField<String>(
                  // isExpanded: true,
                  decoration: InputDecoration(
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
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),

                /// Sign Up button
                ElevatedButton(
                  onPressed: () => signup(),
                  child: Text("Sign Up"),
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
    return TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  }

  bool passwordConfirm() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim())
      return true;
    else
      return false;
  }

  Future signup() async {
    try {
      if (_emailController.text.isNotEmpty &
          _passwordController.text.isNotEmpty &
          _confirmPasswordController.text.isNotEmpty &
          _usernameController.text.isNotEmpty &
          _firstnameController.text.isNotEmpty &
          _lastnameController.text.isNotEmpty &
          _selectedSport.isNotEmpty &
          _date.toString().isNotEmpty) {
        bool validate = _keyForm.currentState.validate();
        if (passwordConfirm()) {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());
          UserData(
                  _usernameController.text.trim(),
                  _firstnameController.text.trim(),
                  _lastnameController.text.trim(),
                  _selectedSport.trim(),
                  _date)
              .userSetup();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
            (Route<dynamic> route) => false,
          );
        } else
          ScaffoldMessenger.of(context).showSnackBar(passwordNotEqual);
      } else
        ScaffoldMessenger.of(context).showSnackBar(completeSnackBar);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        print('The password is too weak');
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Registration failed!'),
            content: Text('Your inserted password is weak. Please refill it.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else if (error.code == 'email-already-in-use') {
        print('Email is already exist');
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Registration failed!'),
            content: Text(
                'The account that used this email is already exist. Plase change your email.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'))
            ],
          ),
        );
      } else if (error.code == 'invalid-email') {
        print('Invalid email format');
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Registration failed!'),
            content: Text(
                'The format of email is invalid. Please correct the email.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'))
            ],
          ),
        );
      }
    } catch (error) {
      print(error);
    }
  }

  var completeSnackBar = const SnackBar(
    content: Text('Please fill in the information completely.'),
  );

  var passwordNotEqual = const SnackBar(
    content: Text('The password is not match with the confirm password.'),
  );

  List<String> sportList = [
    'Football',
    'Basketball',
    'Badminton',
    'Boxing',
    'Judo',
    'Rugby',
    'VolleyBall'
  ];
}
