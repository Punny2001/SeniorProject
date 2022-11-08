import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:seniorapp/component/page/staff-page/staff_profile.dart';

class StaffPersonal extends StatefulWidget {
  const StaffPersonal({Key key,  @required this.staff_no,
    @required this.email,
    @required this.firstname,
    @required this.lastname,}) : super(key: key);
  final String staff_no;
  final String email;
  final String firstname;
  final String lastname;
  @override
  State<StaffPersonal> createState() => _StaffPersonalState();
}

class _StaffPersonalState extends State<StaffPersonal> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: MediaQuery.of(context).size.height / 10,
          elevation: 0,
          scrolledUnderElevation: 1,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Ink(
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: Colors.blue.shade200,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    alignment: Alignment.centerRight,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
        ),
        body:Container(
          padding: const EdgeInsets.all(30),
          height: h,
          width: w,
          child: Column(
            children: [
              Container(
                    height: h * 0.6,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double innerHeight = constraints.maxHeight;
                        double innerWidth = constraints.maxWidth;
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                              bottom:0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: innerHeight * 0.9,
                                width: innerWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.blue.shade50,
                                  boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                                ),
                              ),
                            ),
                            Center(
                              child: Stack(
                              children: [
                                Positioned(
                              top:0,
                              left:0,
                              right:0,
                                child: Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 4,
                                            color: Theme.of(context).scaffoldBackgroundColor),
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 2,
                                              blurRadius: 10,
                                              color: Colors.black.withOpacity(0.1),
                                              offset: Offset(0, 10))
                                        ],
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
                                            ))),
                                  ),
                            ),

                                Positioned(
                                  top: -200,
                                    bottom: 0,
                                    left: 200,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 4,
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                        ),
                                        color: Colors.blue.shade200,
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    )),
                                    ],
                                    ),
                                    ),
                              Column(
                                children: [
                                  SizedBox(
                                      height: 140,
                                    ),
                                    Text(
                                      widget.firstname + ' ' + widget.lastname,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Nunito',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'ID : '+widget.staff_no,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Nunito',
                                        fontSize: 19,
                                      ),
                                    ),
                                    Text(
                                      'Email : '+widget.email,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Nunito',
                                        fontSize: 19,
                                      ),
                                    ),
                                        
                                ],
                              ),
                          ],
                        );
                      }
                    ),
                    
              ),
              ],
              ),
              ),


    );
    
  }
}