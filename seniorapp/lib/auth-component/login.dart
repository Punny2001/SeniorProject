import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:seniorapp/auth-component/register.dart';
import 'package:seniorapp/decoration/authentication/textfield_login.dart';
import 'package:seniorapp/decoration/authentication/page_title_bar.dart';
import 'package:seniorapp/component/language.dart';

class Login extends StatefulWidget {
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
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: w,
        height: h,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: w,
                height: h / 1.4,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Background_login.PNG"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const PageTitleBar(imgUrl: "assets/images/mahidol_logo.png"),
              Padding(
                padding: const EdgeInsets.only(top: 390.0),
                child: Container(
                  margin: const EdgeInsets.all(42),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: _passwordController,
                              obscureText: _passwordhide,
                              decoration: InputDecoration(
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
                                    color: Color(0xFFCFD8DC),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFCFD8DC),
                                  ),
                                ),
                                fillColor: const Color(0xFFCFD8DC),
                                filled: true,
                                hintText: 'Password',
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
                            Container(
                              alignment: const Alignment(1.05, 0.2),
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: TextStyle(
                                      color: Color.fromARGB(255, 113, 157, 242),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed('/forgotPassword'),
                                  child: const Text(
                                    'Forgot password',
                                  )),
                            ),
                            ElevatedButton(
                              onPressed: () => signin(),
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                  fontSize: h * 0.025,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(w, h * 0.07),
                                  elevation: 0,
                                  primary: Color.fromARGB(255, 113, 157, 242),
                                  shape: StadiumBorder()),
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
