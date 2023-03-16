import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:seniorapp/decoration/padding.dart';
import 'package:seniorapp/decoration/textfield_normal.dart';

class CustomerSupportPage extends StatefulWidget {
  const CustomerSupportPage({
    Key key,
    @required this.userType,
  }) : super(key: key);
  final String userType;

  @override
  State<CustomerSupportPage> createState() => _CustomerSupportPageState();
}

class _CustomerSupportPageState extends State<CustomerSupportPage> {
  final uid = FirebaseAuth.instance.currentUser.uid;
  final athleteTextEditingController = TextEditingController();
  final staffTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        primary: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Ink(
              decoration: ShapeDecoration(
                shape: const CircleBorder(),
                color: Colors.blue.shade200,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                alignment: Alignment.centerRight,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(w * 0.05),
          child: widget.userType == 'Staff'
              ? staffColumn(staffTextEditingController)
              : athleteColumn(athleteTextEditingController),
        ),
      ),
    );
  }

  Column staffColumn(TextEditingController text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Please provide your problem',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        PaddingDecorate(10),
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height / 3,
          ),
          child: SingleChildScrollView(
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please insert the detail';
                } else {
                  return null;
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              controller: text,
              decoration: textdecorate('Detail ...'),
            ),
          ),
        ),
        PaddingDecorate(10),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue[300],
            ),
            onPressed: () {
              sendEmail(text.text, uid)
                  .then((value) => Navigator.of(context).pop());
            },
            child: const Text(
              'Submit',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column athleteColumn(TextEditingController text) {
    return Column(
      children: [
        const Text(
          'กรอกรายละเอียดปัญหา',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        PaddingDecorate(10),
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height / 3,
          ),
          child: SingleChildScrollView(
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'โปรดกรอกรายละเอียดองปัญหา';
                } else {
                  return null;
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              controller: text,
              decoration: textdecorate('รายละเอียด ...'),
            ),
          ),
        ),
        PaddingDecorate(10),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue[300],
            ),
            onPressed: () {
              sendEmail(text.text, uid)
                  .then((value) => Navigator.of(context).pop());
            },
            child: const Text(
              'ยืนยัน',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> sendEmail(String detail, String uid) async {
    final Email email = Email(
      body: detail,
      subject: 'Problem report: Case by $uid',
      recipients: ['krissanapong.pal@student.mahidol.ac.th'],
      cc: [
        'pongsakorn.pib@student.mahidol.ac.th',
        'rathakit.sri@student.mahidol.edu'
      ],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }
}
