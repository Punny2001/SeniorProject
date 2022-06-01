import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:seniorapp/component/language.dart';
import 'package:seniorapp/component/user-data/user.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.signOut();
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordhide = true;
  bool isEmailVerified;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [LanguageSign()],
      ),
      body: Container(
        margin: const EdgeInsets.all(30),
        width: w,
        height: h,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/mahidol_logo.png"),
                  ),
                ),
                height: h / 3.5,
                width: w / 1.5,
              ),
              const SizedBox(
                height: 30,
              ),

              /// Email text insertion
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please insert your email';
                  } else {
                    return null;
                  }
                },
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              /// Password text insertion
              TextField(
                controller: _passwordController,
                obscureText: _passwordhide,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
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

              /// Forgot Password
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/forgotPassword'),
                  child: const Text(
                    'login_page.forgotpassword_textbutton',
                  ).tr(),
                ),
              ),

              /// Sign in button
              ElevatedButton(
                onPressed: () => signin(),
                child: const Text("Log In"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(w / 1.1, h / 15),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('login_page.login_description').tr(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/register');
                    },
                    child: Text(
                      'login_page.signup_textbutton'.tr(),
                      style:
                          const TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  var allSnackbar = const SnackBar(
    content: Text('Please fill in both Email and Password'),
  );

  var emailSnack = const SnackBar(
    content: Text('Please fill in your Email'),
  );

  var passwordSnack = const SnackBar(
    content: Text('Please fill in your Password'),
  );

  var emailVerifiedSnack = const SnackBar(
    content: Text('This email has not verrify yet'),
  );

  Future signin() async {
    try {
      if (_emailController.text.isNotEmpty &
          _passwordController.text.isNotEmpty) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        )
            .then((value) async {
          isEmailVerified = FirebaseAuth.instance.currentUser.emailVerified;
          if (isEmailVerified == true) {
            String uid = value.user.uid;
            await FirebaseFirestore.instance
                .collection('User')
                .doc(uid)
                .snapshots()
                .listen((event) {
              UserData userModel = UserData.fromMap(event.data());
              switch (userModel.department) {
                case 'Athlete':
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/athletePageChoosing', (route) => false);
                  break;
                case 'Staff':
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/staffPageChoosing', (route) => false);
                  break;
                default:
              }
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(emailVerifiedSnack);
          }
        });
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
            content: const Text(
                "The Email and Password are invalid. Please refill your Email and Password"),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _passwordController.clear();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
