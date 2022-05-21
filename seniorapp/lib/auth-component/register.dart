import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorapp/auth-component/login.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Email registeration
              Text(
                'Email',
                style: textCustom(),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email address',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),

              /// Password  registeration
              Text(
                'Password',
                style: textCustom(),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),

              /// Confirm registeration
              Text(
                'Confirm password',
                style: textCustom(),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Confirm password',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
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
          _confirmPasswordController.text.isNotEmpty) {
        if (passwordConfirm()) {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
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
                  child: Text('OK'))
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
                'The account that used this email is already exist. Plase change your email'),
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
}
