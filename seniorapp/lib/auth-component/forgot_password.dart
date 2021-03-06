import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:seniorapp/component/language.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        actions: [LanguageSign()],
      ),
      body: Container(
        margin: const EdgeInsets.all(30),
        width: w,
        height: h,
        child: Column(
          children: [
            Text('forgotpassword_page.email_input'.tr()),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'forgotpassword_page.email_hinttext'.tr(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            ElevatedButton(
              onPressed: () {
                resetPassword();
              },
              child: Text('forgotpassword_page.reset_button'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('forgotpassword_page.dialog_title'.tr()),
          content: Text('forgotpassword_page.dialog_content'.tr()),
        ),
      );
      await Future.delayed(const Duration(seconds: 3), () {});
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        print('Invalid email format');
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('forgotpassword_page.error_title'.tr()),
            content: Text('forgotpassword_page.invalidemail_description'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('forgotpassword_page.ok'.tr()),
              ),
            ],
          ),
        );
      } else if (error.code == 'user-not-found') {
        print('User not found');
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('forgotpassword_page.usernotfound_title'.tr()),
            content: Text('forgotpassword_page.usernotfound_description'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('forgotpassword_page.ok'.tr()),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      print(error);
    }
  }
}
