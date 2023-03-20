// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';
// import 'package:seniorapp/decoration/padding.dart';
// import 'package:seniorapp/decoration/textfield_normal.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
// import 'package:url_launcher/url_launcher.dart';

// class CustomerSupportPage extends StatefulWidget {
//   const CustomerSupportPage({
//     Key key,
//     @required this.userType,
//   }) : super(key: key);
//   final String userType;

//   @override
//   State<CustomerSupportPage> createState() => _CustomerSupportPageState();
// }

// class _CustomerSupportPageState extends State<CustomerSupportPage> {
//   final uid = FirebaseAuth.instance.currentUser.uid;
//   final athleteTextEditingController = TextEditingController();
//   final staffTextEditingController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;
//     return Scaffold(

//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.all(w * 0.05),
//           child: widget.userType == 'Staff'
//               ? staffColumn(staffTextEditingController)
//               : athleteColumn(athleteTextEditingController),
//         ),
//       ),
//     );
//   }

//   Column staffColumn(TextEditingController text) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         const Text(
//           'Please provide your problem',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         PaddingDecorate(10),
//         Container(
//           constraints: BoxConstraints(
//             maxHeight: MediaQuery.of(context).size.height / 3,
//           ),
//           child: SingleChildScrollView(
//             child: TextFormField(
//               validator: (value) {
//                 if (value.isEmpty) {
//                   return 'Please insert the detail';
//                 } else {
//                   return null;
//                 }
//               },
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//               maxLines: null,
//               keyboardType: TextInputType.multiline,
//               controller: text,
//               decoration: textdecorate('Detail ...'),
//             ),
//           ),
//         ),
//         PaddingDecorate(10),
//         SizedBox(
//           width: MediaQuery.of(context).size.width / 2,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               primary: Colors.blue[300],
//             ),
//             onPressed: () {
//               sendEmail(text.text, uid)
//                   .then((value) => Navigator.of(context).pop());
//             },
//             child: const Text(
//               'Submit',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Column athleteColumn(TextEditingController text) {
//     return Column(
//       children: [
//         const Text(
//           'กรอกรายละเอียดปัญหา',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         PaddingDecorate(10),
//         Container(
//           constraints: BoxConstraints(
//             maxHeight: MediaQuery.of(context).size.height / 3,
//           ),
//           child: SingleChildScrollView(
//             child: TextFormField(
//               validator: (value) {
//                 if (value.isEmpty) {
//                   return 'โปรดกรอกรายละเอียดองปัญหา';
//                 } else {
//                   return null;
//                 }
//               },
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//               maxLines: null,
//               keyboardType: TextInputType.multiline,
//               controller: text,
//               decoration: textdecorate('รายละเอียด ...'),
//             ),
//           ),
//         ),
//         PaddingDecorate(10),
//         SizedBox(
//           width: MediaQuery.of(context).size.width / 2,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               primary: Colors.green[300],
//             ),
//             onPressed: () {
//               sendEmail(text.text, uid)
//                   .then((value) => Navigator.of(context).pop());
//             },
//             child: const Text(
//               'ยืนยัน',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Future<void> sendEmail(String detail, String uid) async {
//     String email = 'krissanapong.pal@student.mahidol.ac.th';
//     String subject = 'Problem report: Case by $uid';

//     final url = 'mailto:$email?subject=$subject&body=$detail';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//     // final Email _email = Email(
//     //   body: detail,
//     //   subject: 'Problem report: Case by $uid',
//     //   recipients: ['krissanapong.pal@student.mahidol.ac.th'],
//     //   cc: [
//     //     'pongsakorn.pib@student.mahidol.ac.th',
//     //     'rathakit.sri@student.mahidol.edu'
//     //   ],
//     //   isHTML: false,
//     // );

//     // await FlutterEmailSender.send(email);
//   }

//   void _sendEmail() async {
//     String username = 'your-email@gmail.com';
//     String password = 'your-email-password';

//     final smtpServer = gmail(username, password);

//     // Create a message
//     final message = Message()
//       ..from = Address(username, 'Your Name')
//       ..recipients.add('recipient-email@gmail.com')
//       ..subject = 'Test Email'
//       ..text = 'This is a test email from Flutter app'
//       ..html = '<h1>This is a test email from Flutter app</h1>';

//     // Send the message
//     try {
//       final sendReport = await send(message, smtpServer);
//       print('Message sent: ' + sendReport.toString());
//     } catch (e) {
//       print('Error: ' + e.toString());
//     }
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seniorapp/decoration/textfield_normal.dart';
import 'package:http/http.dart' as http;

class CustomerSupportPage extends StatefulWidget {
  final String userType;
  const CustomerSupportPage({
    Key key,
    @required this.userType,
  }) : super(key: key);
  @override
  _CustomerSupportPageState createState() => _CustomerSupportPageState();
}

class _CustomerSupportPageState extends State<CustomerSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  Future<void> _launchEmailApp() async {
    final email = _emailController.text;
    final subject = _subjectController.text;
    final body = _messageController.text;

    const serviceID = 'service_ey8ia2f';
    const templateID = 'template_gfvbgid';
    const userID = 'o_MrIhjCcDiWnr01m';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'service_id': serviceID,
        'template_id': templateID,
        'user_id': userID,
        'template_params': {
          'user_email': email,
          'user_subject': subject,
          'user_message': body
        },
      }),
    );

    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    SnackBar snackbar = SnackBar(
      content: widget.userType == 'Staff'
          ? const Text('Email was sent')
          : const Text('อีเมลถูกส่งเรียบร้อย'),
    );
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
                color: widget.userType == 'Staff'
                    ? Colors.blue[200]
                    : Colors.green[300],
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userType == 'Staff'
                    ? 'Email us for support:'
                    : 'อีเมลหาเราเพื่อต้องการความช่วยเหลือ:',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: widget.userType == 'Staff'
                    ? textdecorate('Email Address')
                    : textdecorate('อีเมล'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    if (widget.userType == 'Staff') {
                      return 'Please enter your email address';
                    } else {
                      return 'โปรดกรอกที่อยู่อีเมลของคุณ';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _subjectController,
                decoration: widget.userType == 'Staff'
                    ? textdecorate('Subject')
                    : textdecorate('หัวข้อ'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    if (widget.userType == 'Staff') {
                      return 'Please enter a subject';
                    } else {
                      return 'โปรดใส่ชื่อหัวข้อปัญหา';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _messageController,
                maxLines: null,
                decoration: widget.userType == 'Staff'
                    ? textdecorate('Detail')
                    : textdecorate('รายละเอียด'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    if (widget.userType == 'Staff') {
                      return 'Please enter a message';
                    } else {
                      return 'โปรดใส่รายละเอียดของปัญหา';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    fixedSize:
                        Size.fromWidth(MediaQuery.of(context).size.width / 2),
                    primary: widget.userType == 'Staff'
                        ? Colors.blue[600]
                        : Colors.green[700],
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _launchEmailApp().then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        setState(() {
                          _emailController.clear();
                          _messageController.clear();
                          _subjectController.clear();
                        });
                      });
                    }
                  },
                  child: Text(
                      widget.userType == 'Staff' ? 'Send Email' : 'ส่งอีเมล'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
