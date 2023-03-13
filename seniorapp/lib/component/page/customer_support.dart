import 'package:flutter/material.dart';
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
  final athleteTextEditingController = TextEditingController();
  final staffTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
        child: widget.userType == 'Staff'
            ? staffColumn(staffTextEditingController)
            : athleteColumn(athleteTextEditingController),
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
        TextFormField(
          decoration: textdecorate('Detail'),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: text,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please provide your problem to get help from our developer';
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }

  Column athleteColumn(TextEditingController text) {
    return Column(
      children: const [
        Text(
          'กรอกรายละเอียดปัญหา',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
