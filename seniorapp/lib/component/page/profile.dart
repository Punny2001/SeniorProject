import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:seniorapp/decoration/padding.dart';
import 'package:seniorapp/decoration/textfield_normal.dart';

class ProfilePage extends StatefulWidget {
  final Athlete athlete;
  final Staff staff;
  final userType;
  const ProfilePage({
    Key key,
    this.athlete,
    this.staff,
    this.userType,
  }) : super(key: key);
  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final String uid = FirebaseAuth.instance.currentUser.uid;

  TextEditingController nameController;
  TextEditingController usernameController;
  TextEditingController departmentController;
  TextEditingController emailController;
  TextEditingController sportController;
  TextEditingController staffTypeController;
  TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    if (widget.userType == 'Athlete') {
      nameController = TextEditingController(
          text: widget.athlete.firstname + ' ' + widget.athlete.lastname);
      usernameController = TextEditingController(text: widget.athlete.username);
      departmentController =
          TextEditingController(text: widget.athlete.department);
      sportController = TextEditingController(text: widget.athlete.sportType);
      emailController = TextEditingController(text: widget.athlete.email);
      phoneController = TextEditingController(text: widget.athlete.phoneNo);
    } else {
      nameController = TextEditingController(
          text: widget.staff.firstname + ' ' + widget.staff.lastname);
      usernameController = TextEditingController(text: widget.staff.username);
      departmentController =
          TextEditingController(text: widget.staff.department);
      staffTypeController = TextEditingController(text: widget.staff.staffType);
      emailController = TextEditingController(text: widget.staff.email);
      phoneController = TextEditingController(text: widget.staff.phoneNo);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    departmentController.dispose();
    emailController.dispose();
    sportController.dispose();
    staffTypeController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  bool isEditing = false;

  void startEditing() {
    setState(() {
      isEditing = true;
    });
  }

  void cancelEditing() {
    if (widget.userType == 'Athlete') {
      setState(() {
        isEditing = false;
        nameController.text =
            widget.athlete.firstname + ' ' + widget.athlete.lastname;
        usernameController.text = widget.athlete.username;
        phoneController.text = widget.athlete.phoneNo;
      });
    } else {
      setState(() {
        isEditing = false;
        nameController.text =
            widget.staff.firstname + ' ' + widget.staff.lastname;
        usernameController.text = widget.staff.username;
        phoneController.text = widget.staff.phoneNo;
      });
    }
  }

  void saveChanges() {
    setState(() {
      isEditing = false;
    });
  }

  Future<void> saveData() async {
    if (widget.userType == 'Athlete') {
      await FirebaseAuth.instance.currentUser
          .updateDisplayName(
        usernameController.text.trim(),
      )
          .then((value) async {
        await FirebaseFirestore.instance.collection('Athlete').doc(uid).update(
          {
            'firstname': nameController.text.split(' ')[0],
            'lastname': nameController.text.split(' ')[1],
            'username': usernameController.text.trim(),
            'phoneNo': phoneController.text.trim()
          },
        );
      });
    } else {
      await FirebaseAuth.instance.currentUser
          .updateDisplayName(
        usernameController.text.trim(),
      )
          .then((value) async {
        await FirebaseFirestore.instance.collection('Staff').doc(uid).update(
          {
            'firstname': nameController.text.split(' ')[0],
            'lastname': nameController.text.split(' ')[1],
            'username': usernameController.text.trim(),
            'phoneNo': phoneController.text.trim()
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        primary: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Ink(
                  decoration: ShapeDecoration(
                    shape: const CircleBorder(),
                    color: widget.athlete != null
                        ? Colors.green[300]
                        : Colors.blue[200],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    alignment: Alignment.centerRight,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                ),
                if (widget.userType == 'Athlete')
                  Text(widget.athlete.athlete_no)
                else
                  Text(widget.staff.staff_no),
              ],
            ),
            if (!isEditing)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: startEditing,
              ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: widget.userType == 'Athlete'
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // CircleAvatar(
                    //   radius: 50,
                    //   backgroundImage: NetworkImage(
                    //     'https://www.example.com/profile.jpg',
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameController,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      enabled: isEditing,
                      textAlign: TextAlign.center,
                      decoration: isEditing
                          ? textdecorate('')
                          : const InputDecoration(
                              disabledBorder: InputBorder.none,
                            ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 2,
                    ),
                    const SizedBox(height: 10),

                    TextField(
                      controller: usernameController,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      enabled: isEditing,
                      textAlign: TextAlign.center,
                      decoration: isEditing
                          ? textdecorate('')
                          : const InputDecoration(
                              disabledBorder: InputBorder.none,
                              prefix: Text('ชื่อผู้ใช้งาน:'),
                            ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      enabled: false,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        disabledBorder: InputBorder.none,
                        prefix: Text('อีเมล:'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: departmentController,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      enabled: false,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        disabledBorder: InputBorder.none,
                        prefix: Text('ประเภทผู้ใช้งาน:'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: sportController,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      enabled: false,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        disabledBorder: InputBorder.none,
                        prefix: Text('ประเภทกีฬา:'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phoneController,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      enabled: isEditing,
                      textAlign: TextAlign.center,
                      decoration: isEditing
                          ? textdecorate('')
                          : const InputDecoration(
                              disabledBorder: InputBorder.none,
                              prefix: Text('เบอร์โทรศัพท์:'),
                            ),
                    ),
                    PaddingDecorate(20),
                    Visibility(
                      visible: isEditing,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red[300],
                            ),
                            onPressed: () => cancelEditing(),
                            child: const Text('ยกเลิก'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green[600],
                            ),
                            onPressed: () => saveData().then(
                              (value) => saveChanges(),
                            ),
                            child: const Text('ยอมรับ'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // CircleAvatar(
                    //   radius: 50,
                    //   backgroundImage: NetworkImage(
                    //     'https://www.example.com/profile.jpg',
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameController,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      enabled: isEditing,
                      textAlign: TextAlign.center,
                      decoration: isEditing
                          ? textdecorate('')
                          : const InputDecoration(
                              disabledBorder: InputBorder.none,
                            ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 2,
                    ),
                    const SizedBox(height: 10),

                    TextField(
                      controller: usernameController,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      enabled: isEditing,
                      textAlign: TextAlign.center,
                      decoration: isEditing
                          ? textdecorate('')
                          : const InputDecoration(
                              disabledBorder: InputBorder.none,
                              prefix: Text('Username:'),
                            ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      enabled: false,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        disabledBorder: InputBorder.none,
                        prefix: Text('Email:'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: departmentController,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      enabled: false,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        disabledBorder: InputBorder.none,
                        prefix: Text('Department:'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: staffTypeController,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      enabled: false,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        disabledBorder: InputBorder.none,
                        prefix: Text('Sports:'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phoneController,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      enabled: isEditing,
                      textAlign: TextAlign.center,
                      decoration: isEditing
                          ? textdecorate('')
                          : const InputDecoration(
                              disabledBorder: InputBorder.none,
                              prefix: Text('Phone Number:'),
                            ),
                    ),
                    PaddingDecorate(20),
                    Visibility(
                      visible: isEditing,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red[300],
                            ),
                            onPressed: () => cancelEditing(),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green[600],
                            ),
                            onPressed: () => saveData().then(
                              (value) => saveChanges(),
                            ),
                            child: const Text('Save Changes'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
