import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/auth-component/login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:seniorapp/component/language.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  Timer timer;
  Timer timerDeletedAccount;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkVerifiedEmail(),
      );

      timerDeletedAccount = Timer.periodic(const Duration(seconds: 59), (_) {
        String uid = FirebaseAuth.instance.currentUser.uid;
        FirebaseFirestore.instance.collection('User').doc(uid).delete();
        FirebaseAuth.instance.currentUser.delete();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => false);
      });
    }
  }

  @override
  void dispose() {
    timer.cancel();
    timerDeletedAccount.cancel();

    super.dispose();
  }

  Future checkVerifiedEmail() async {
    // Call after email verification
    await FirebaseAuth.instance.currentUser.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser.emailVerified;
    });

    if (isEmailVerified) {
      timer.cancel();
    }
  }

  Future sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    await user.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return isEmailVerified
        ? Login()
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('verifyemail_page.title'.tr()),
              actions: [LanguageSign()],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('verifyemail_page.description'.tr()),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Text(
                    'verifyemail_page.warning'.tr(),
                    style: TextStyle(
                        color: Colors.red[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 50),
                  )
                ],
              ),
            ),
          );
  }
}
