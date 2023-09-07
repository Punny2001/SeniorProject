import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:seniorapp/component/appointment_data.dart';
import 'package:seniorapp/decoration/format_datetime.dart';
import 'package:seniorapp/decoration/padding.dart';
import 'package:seniorapp/decoration/textfield_normal.dart';

import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const AppointmentPage({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime _datetime;
  bool hasError = false;
  final _keyForm = GlobalKey<FormState>();
  final _detailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text(
          'Appointment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Form(
          key: _keyForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Choose a date'),
              PaddingDecorate(5),
              Row(
                children: [
                  const Icon(Icons.event),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        fixedSize: Size.fromHeight(50),
                        primary: const Color.fromRGBO(217, 217, 217, 100),
                        onPrimary:
                            _datetime == null ? Colors.grey[700] : Colors.black,
                        alignment: Alignment.centerLeft,
                        side: BorderSide(
                            width: 1,
                            color: _keyForm.currentState == null ||
                                    _keyForm.currentState.validate() != false
                                ? const Color.fromRGBO(217, 217, 217, 100)
                                : Colors.red),
                        textStyle: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NunitoSans',
                        ),
                      ),
                      child: Text(
                        _datetime != null
                            ? formatDateAndTime(_datetime)
                            : 'Date & Time',
                      ),
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              color: CupertinoColors.systemGrey5,
                              height: 300,
                              child: CupertinoDatePicker(
                                initialDateTime: _datetime ?? DateTime.now(),
                                onDateTimeChanged: (DateTime newDateTime) {
                                  setState(() {
                                    _datetime = newDateTime;
                                    hasError = false;
                                  });
                                },
                                mode: CupertinoDatePickerMode.dateAndTime,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              PaddingDecorate(5),
              Visibility(
                child: Text(
                  'Please insert an appointment date',
                  style: TextStyle(
                    fontFamily: 'NunitoSans',
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
                visible: hasError,
              ),
              PaddingDecorate(10),
              const Text('Detail'),
              PaddingDecorate(5),
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 100,
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
                    controller: _detailController,
                    style: const TextStyle(fontFamily: 'NunitoSans'),
                    decoration: textdecorate('Appointment Detail ...'),
                  ),
                ),
              ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red[300],
            ),
            onPressed: () {
              // _datetime = null;
              _detailController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
            onPressed: () {
              print(_datetime);
              print(_keyForm.currentState.validate());
              if (_keyForm.currentState.validate() == false &&
                  _datetime == null) {
                setState(() {
                  hasError = true;
                  _keyForm.currentState.validate();
                });
              } else {
                hasError = false;
                save_appointment();
              }
            },
            child: const Text('Accept'),
          ),
        ]);
  }

  Future<void> save_appointment() async {
    var uid = FirebaseAuth.instance.currentUser.uid;
    bool isValidate = _keyForm.currentState.validate();
    String appointNo = 'AP';
    String split;
    int latestID;
    NumberFormat format = NumberFormat('0000000000');
    await FirebaseFirestore.instance
        .collection('AppointmentRecord')
        .orderBy('appointmentNo', descending: true)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size == 0) {
        appointNo += format.format(1);
      } else {
        querySnapshot.docs
            .forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
          Map data = queryDocumentSnapshot.data();
          split = data['appointmentNo'].toString().split('AP')[1];
          latestID = int.tryParse(split) + 1;
          appointNo += format.format(latestID);
        });
      }
    });

    if (isValidate && _datetime != null) {
      AppointmentData appointmentDataModel = AppointmentData(
        caseID: widget.data['questionnaireID'],
        appointmentNo: appointNo,
        appointDate: _datetime,
        detail: _detailController.text,
        doDate: DateTime.now(),
        staffUID: uid,
        athleteUID: widget.data['athleteUID'],
        appointStatus: null,
        receivedDate: DateTime(1900),
        receivedStatus: false,
        staffReadDate: DateTime(1900),
        staffReadStatus: false,
      );

      Map<String, dynamic> data = appointmentDataModel.toMap();

      final collectionReference =
          FirebaseFirestore.instance.collection('AppointmentRecord');
      DocumentReference docReference = collectionReference.doc();
      docReference.set(data).then((value) {
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Making appointment success'),
                content: Text(
                    'Your appointment number $appointNo is successfully reserved!!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil(
                            '/staffPageChoosing', (route) => false),
                    child: const Text('OK'),
                  ),
                ],
              );
            }).then(
          (value) => print('Insert data to Firestore successfully'),
        );
      });
    }
  }
}
