import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:seniorapp/decoration/padding.dart';

class AddAssociation extends StatefulWidget {
  final String userType;
  const AddAssociation({
    Key key,
    @required this.userType,
  }) : super(key: key);
  @override
  _AddAssociationState createState() => _AddAssociationState();
}

class _AddAssociationState extends State<AddAssociation> {
  String selectedAssociation;
  final associationKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        primary: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 113, 157, 242),
        leading: IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut().then(
                  (value) => Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (route) => false),
                );
          },
          alignment: Alignment.centerRight,
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          left: w * 0.05,
          right: w * 0.05,
        ),
        child: Form(
          key: associationKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'เนื่องจากมีการอัพเดทแอพลิเคชัน\nผู้ใช้งานทุกคนจำเป็นต้องเลือกองค์กร (Association)\n\n',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: h * 0.025,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'หากคุณไม่มีองค์กร โปรดเลือก Individual\n',
                style: TextStyle(
                  fontSize: h * 0.02,
                ),
                textAlign: TextAlign.center,
              ),
              DropdownButtonFormField2<String>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                icon: const Icon(Icons.arrow_drop_down_circle),
                decoration: const InputDecoration(
                  fillColor: CupertinoColors.systemGrey5,
                  filled: true,
                  hintText: 'โปรดเลือกองค์กร',
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
                      color: CupertinoColors.systemGrey5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: CupertinoColors.systemGrey5,
                    ),
                  ),
                ),
                items: association
                    .map((association) => DropdownMenuItem(
                          child: Text(association),
                          value: association,
                        ))
                    .toList(),
                value: selectedAssociation,
                onChanged: (value) {
                  setState(() {
                    selectedAssociation = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'โปรดเลือกองค์กรที่คุณสังกัด';
                  } else {
                    return null;
                  }
                },
              ),
              PaddingDecorate(20),
              ElevatedButton(
                onPressed: () {
                  bool validate = associationKey.currentState.validate();
                  if (validate) {
                    updateAssc(selectedAssociation, widget.userType);
                  } else {
                    print('The value is null');
                  }
                },
                child: Text(
                  'บันทึก',
                  style: TextStyle(
                    color: Colors.blueGrey[50],
                    fontSize: h * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(w, h * 0.07),
                  elevation: 0,
                  primary: const Color.fromARGB(255, 113, 157, 242),
                  shape: const StadiumBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateAssc(String _selectedAssociation, String userType) {
    String uid = FirebaseAuth.instance.currentUser.uid;
    // print('Hello Updated');
    FirebaseFirestore.instance
        .collection(userType)
        .doc(uid)
        .update({'association': _selectedAssociation}).then(
      (value) => showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text(
              'อัพเดทข้อมูลเสร็จสิ้น',
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  if (userType == 'Athlete') {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/athletePageChoosing', (route) => false);
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/staffPageChoosing', (route) => false);
                  }
                },
                child: const Text('ตกลง'),
              ),
            ],
          );
        },
      ),
    );
  }
}

List<String> association = ['Mahidol University', 'Individual'];
