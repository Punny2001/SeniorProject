import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/staff-page/graph-page/staff_personnel_graph.dart';

class FindAthleteGraph extends StatefulWidget {
  final List<Map<String, dynamic>> athleteList;

  const FindAthleteGraph({
    Key key,
    @required this.athleteList,
  }) : super(key: key);
  @override
  _FindAthleteGraphState createState() => _FindAthleteGraphState();
}

class _FindAthleteGraphState extends State<FindAthleteGraph> {
  final searchName = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        primary: true,
        elevation: 0,
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: w * 0.01, right: w * 0.01),
            child: CupertinoSearchTextField(
              controller: searchName,
              onSuffixTap: () {
                setState(() {
                  searchName.clear();
                });
              },
              onSubmitted: (value) {
                searchName.text = value;
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.athleteList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> athleteData = widget.athleteList[index];
                String fullname =
                    athleteData['firstname'] + ' ' + athleteData['lastname'];
                if (fullname.toLowerCase().contains(searchName.text)) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              StaffPersonnelGraph(
                            athleteUID: athleteData['athleteUID'],
                          ),
                        ),
                      );
                    },
                    child: Card(
                        child: Container(
                      alignment: Alignment.centerLeft,
                      height: h * 0.05,
                      child: Text(
                        '${athleteData['firstname']} ${athleteData['lastname']} ',
                        style: TextStyle(
                          fontSize: h * 0.025,
                        ),
                      ),
                    )),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
