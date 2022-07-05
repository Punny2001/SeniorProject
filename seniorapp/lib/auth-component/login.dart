import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:seniorapp/auth-component/register.dart';
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
          child: Form(
            key: _keyForm,
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
                      return 'login_page.email_required'.tr();
                    } else {
                      return null;
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'login_page.email_hinttext'.tr(),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                /// Password text insertion
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
                    border: const OutlineInputBorder(),
                    hintText: 'login_page.password_hinttext'.tr(),
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
                  child: Text('login_page.login_button'.tr()),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(w / 1.1, h / 15),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Text('login_page.login_description').tr(),
                //     TextButton(
                //       onPressed: () {
                //         Navigator.of(context).pushNamed('/register');
                //       },
                //       child: Text(
                //         'login_page.signup_textbutton'.tr(),
                //         style: const TextStyle(
                //             decoration: TextDecoration.underline),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  var emailVerifiedSnack = const SnackBar(
    content: Text('This email has not verrify yet'),
  );

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
            await FirebaseFirestore.instance
                .collection('User')
                .doc(uid)
                .get()
                .then((snapshot) {
              Map<String, dynamic> data = snapshot.data();
              print(data['department']);
              switch (data['department']) {
                case 'Athlete':
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/athletePageChoosing', (route) => false);
                  break;
                case 'Staff':
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/staffPageChoosing', (route) => false);
                  break;
                default:
                
                break;
              }
            });
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
}
