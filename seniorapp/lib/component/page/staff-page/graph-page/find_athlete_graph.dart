import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/staff-page/graph-page/staff_personnel_graph.dart';
import 'package:seniorapp/component/page/staff-page/staff_page_choosing.dart';
import 'package:seniorapp/decoration/padding.dart';

class FindAthleteGraph extends StatefulWidget {
  const FindAthleteGraph({
    Key key,
  }) : super(key: key);
  @override
  _FindAthleteGraphState createState() => _FindAthleteGraphState();
}

Map<String, List<String>> groupStringsByFirstCharacter() {
  Map<String, List<String>> groupedStrings = {};

  for (var i = 0; i < athleteList.length; i++) {
    final firstChar = athleteList[i]['firstname'][0];

    if (!groupedStrings.containsKey(firstChar)) {
      groupedStrings[firstChar] = [];
    }

    groupedStrings[firstChar]
        .add(athleteList[i]['firstname'] + ' ' + athleteList[i]['lastname']);
  }

  return groupedStrings;
}

class _FindAthleteGraphState extends State<FindAthleteGraph> {
  String searchName = '';
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    athleteList.sort((a, b) =>
        a['firstname'].toLowerCase().compareTo(b['firstname'].toLowerCase()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final groupedStrings = groupStringsByFirstCharacter();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        primary: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue[200],
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.of(context).pop();
            });
          },
          alignment: Alignment.centerRight,
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: w * 0.02, right: w * 0.02),
            child: CupertinoSearchTextField(
              controller: textController,
              suffixMode: OverlayVisibilityMode.editing,
              suffixIcon: const Icon(
                CupertinoIcons.clear_thick_circled,
              ),
              onSuffixTap: () {
                setState(() {
                  textController.clear();
                  searchName = '';
                });
              },
              onChanged: (value) {
                setState(() {
                  searchName = value;
                });
              },
              onSubmitted: (value) {
                setState(() {
                  searchName = value;
                });
              },
            ),
          ),
          PaddingDecorate(5),
          Expanded(
            child: ListView.builder(
              // separatorBuilder: (BuildContext context, int index) {
              //   return const Divider();
              // },
              itemCount: athleteList.length,
              itemBuilder: (BuildContext context, int firstIndex) {
                final firstChar = groupedStrings.keys.elementAt(firstIndex);
                final strings = groupedStrings[firstChar];

                return Column(
                  children: [
                    Container(
                      color: CupertinoColors.systemGrey5,
                      width: w,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        firstChar.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: strings.length,
                      itemBuilder: (BuildContext context, int secondIndex) {
                        if (strings[secondIndex]
                            .toLowerCase()
                            .contains(searchName.toLowerCase())) {
                          return ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      StaffPersonnelGraph(
                                    athleteData: athleteList[firstIndex],
                                  ),
                                ),
                              );
                            },
                            title: Text(
                              strings[secondIndex],
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          )
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: athleteList.length,
          //     itemBuilder: (context, index) {
          //       Map<String, dynamic> athleteData = athleteList[index];
          //       String fullname =
          //           athleteData['firstname'] + ' ' + athleteData['lastname'];
          //       if (fullname.toLowerCase().contains(searchName.text)) {
          //         return GestureDetector(
          //           onTap: () {
          //             Navigator.of(context).push(
          //               MaterialPageRoute(
          //                 builder: (BuildContext context) =>
          //                     StaffPersonnelGraph(
          //                   athleteUID: athleteData['athleteUID'],
          //                 ),
          //               ),
          //             );
          //           },
          //           child: Card(
          //               child: Container(
          //             alignment: Alignment.centerLeft,
          //             height: h * 0.05,
          //             child: Text(
          //               '${athleteData['firstname']} ${athleteData['lastname']} ',
          //               style: TextStyle(
          //                 fontSize: h * 0.025,
          //               ),
          //             ),
          //           )),
          //         );
          //       } else {
          //         return SizedBox();
          //       }
          //     },
          //   ),
        ],
      ),
    );
  }
}
