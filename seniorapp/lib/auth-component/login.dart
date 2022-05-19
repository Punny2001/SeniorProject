import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorapp/component/home.dart';
import 'package:seniorapp/auth-component/register.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var allSnackbar = const SnackBar(
    content: Text('Please fill in both Email and Password'),
  );

  var emailSnack = const SnackBar(
    content: Text('Please fill in your Email'),
  );

  var passwordSnack = const SnackBar(
    content: Text('Please fill in your Password'),
  );

  Future signin() async {
    try {
      if (_emailController.text.isNotEmpty &
          _passwordController.text.isNotEmpty) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return HomePage();
          }),
        );
      } else if (_emailController.text.isNotEmpty &
          _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(passwordSnack);
      } else if (_emailController.text.isEmpty &
          _passwordController.text.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(emailSnack);
      } else if (_emailController.text.isEmpty &
          _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(allSnackbar);
      }
    } catch (error) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error Authentication'),
            content: Text(
                "The Email and Password are invalid. Please refill your Email and Password"),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _emailController.clear();
                  _passwordController.clear();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   // centerTitle: true,
      //   // title: Text(
      //   //   'SP2022',
      //   //   style: TextStyle(color: Colors.black87),
      //   // ),
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      // ),
      body: Container(
        padding: EdgeInsets.only(top: 50),
        margin: EdgeInsets.all(30),
        width: w,
        height: h,
        child: Column(
          children: [
            Container(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/mahidol_logo.png"),
                  ),
                ),
                height: h / 3.25,
                width: w / 1.5,
              ),
            ),
            SizedBox(
              height: 30,
            ),

            /// Email text insertion
            Container(
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Email'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Password'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => signin(),
              child: Text("Log In"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(w / 1.1, h / 15),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: ((context) {
                          return Register();
                        }),
                      ),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
