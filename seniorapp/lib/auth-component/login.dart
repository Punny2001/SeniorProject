import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:seniorapp/decoration/authentication/textfield_login.dart';
import 'package:seniorapp/decoration/padding.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordhide = true;
  bool isEmailVerified;
  final _keyForm = GlobalKey<FormState>();
  bool isRegister;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        height: h,
        margin: EdgeInsets.only(
          left: w * 0.1,
          right: w * 0.1,
        ),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.jpg',
              fit: BoxFit.fitWidth,
            ),
            PaddingDecorate(10),
            Form(
              key: _keyForm,
              child: Column(
                children: [
                  //////Email container
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'login_page.email_required'.tr();
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _emailController,
                    decoration: textdecorate_login(
                      Icons.email,
                      'Email',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 15),
                  ),
                  //////Password container
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'login_page.password_required'.tr();
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
                      hintText: 'Password',
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
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/forgotPassword'),
                      child: const Text(
                        'Forgot password',
                        style: TextStyle(
                          color: Color.fromARGB(255, 113, 157, 242),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => signin(),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: h * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(w, h * 0.07),
                        elevation: 0,
                        primary: const Color.fromARGB(255, 113, 157, 242),
                        shape: const StadiumBorder()),
                  ),
                  PaddingDecorate(10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right: w * 0.05),
                          child: Divider(
                            thickness: 2,
                            height: h * 0.05,
                            indent: 0,
                          ),
                        ),
                      ),
                      Text('OR'),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: w * 0.05),
                          child: Divider(
                            thickness: 2,
                            height: h * 0.05,
                            indent: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  PaddingDecorate(10),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/register'),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: h * 0.025,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 113, 157, 242),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(w, h * 0.07),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 113, 157, 242),
                        width: 3,
                      ),
                      elevation: 0,
                      primary: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future signin() async {
    bool validate = _keyForm.currentState.validate();
    try {
      if (validate) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        )
            .then((value) async {
          String uid = value.user.uid;
          final db = FirebaseFirestore.instance;
          DocumentReference athleteRef = db.collection('Athlete').doc(uid);
          DocumentReference staffRef = db.collection('Staff').doc(uid);
          DocumentSnapshot athleteDoc = await athleteRef.get();
          DocumentSnapshot staffDoc = await staffRef.get();
          if (athleteDoc.exists) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/athletePageChoosing', (route) => false);
          } else if (staffDoc.exists) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/staffPageChoosing', (route) => false);
          } else {
            Navigator.of(context).pushNamed(
              '/register',
            );
          }
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        print(error.message);
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('login_page.error_dialog'.tr()),
              content: Text('login_page.invalidemail'.tr()),
              actions: <Widget>[
                TextButton(
                  child: Text('login_page.ok'.tr()),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _passwordController.clear();
                  },
                ),
              ],
            );
          },
        );
      } else if (error.code == 'user-not-found') {
        print(error.message);
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('login_page.error_dialog'.tr()),
              content: Text('login_page.usernotfound'.tr()),
              actions: <Widget>[
                TextButton(
                  child: Text('login_page.ok'.tr()),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _passwordController.clear();
                  },
                ),
              ],
            );
          },
        );
      } else if (error.code == 'wrong-password') {
        print(error.message);
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('login_page.error_dialog'.tr()),
              content: Text('login_page.invalidpassword'.tr()),
              actions: <Widget>[
                TextButton(
                  child: Text('login_page.ok'.tr()),
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
    } catch (error) {
      print(error);
    }
  }

  void checkRegister() {
    String username = FirebaseAuth.instance.currentUser.displayName;
    if (username == null) {
      isRegister = false;
    } else {
      isRegister = true;
    }
  }
}
