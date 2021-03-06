// ignore_for_file: non_constant_identifier_names, unused_import, avoid_unnecessary_containers, prefer_const_constructors, avoid_print, duplicate_ignore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:project/screens/Home_Feed/thisweek.dart';
import 'package:project/screens/Home_Feed/today.dart';
import 'package:project/screens/Home_Feed/tomorrow.dart';
import 'package:project/screens/Join_Event/Event_detail_Home.dart';
import 'package:project/screens/homepage.dart';

import 'package:flutter/material.dart';

import '../Join_Event/Leave_Event_Home.dart';
import '../tabbar.dart';
import 'homepage.dart';

class Tomorrow extends StatefulWidget {
  const Tomorrow({Key? key}) : super(key: key);

  @override
  State<Tomorrow> createState() => _TomorrowState();
}

class _TomorrowState extends State<Tomorrow> {
  String Day =
      DateFormat('E').format(DateTime.now().add(const Duration(days: 1)));
  String dateshow = DateFormat.yMMMMd('en_US')
      .format(DateTime.now().add(const Duration(days: 1)));

  String date = DateFormat("dd/MM/yyyy")
      .format(DateTime.now().add(const Duration(days: 1)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 30, 150, 140),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 13, 104, 96),
          title: const Text(
            "กิจกรรมของวันนี้",
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.black),
                child: PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("กิจกรรมของวันนี้"),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("กิจกรรมในอีก 7 วัน"),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem<int>(
                      value: 2,
                      child: Text("หน้าหลัก"),
                    ),
                  ],
                  onSelected: (item) => Selecteditem(context, item),
                ))
          ],
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Event")
                    .where("date", isEqualTo: date)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: const Center(
                            child: Text(
                          "NO EVENT.",
                          style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        )));
                  } else {
                    const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0));
                    return ListView(
                        children: snapshot.data!.docs.map((Eventjusttoday) {
                      return Container(

                          // padding: const EdgeInsets.all(10),

                          child: Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              child: InkWell(
                                  onTap: () async {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             eventdetailhome(
                                    //               snap: Eventjusttoday,
                                    //             )));
                                    await FirebaseFirestore.instance
                                        .collection("Student")
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.uid)
                                        .collection("Posts")
                                        //where เช็คค่า
                                        .where("Event_id",
                                            isEqualTo: Eventjusttoday.id)
                                        .get()
                                        .then((value) async => {
                                              if (value.docs.isEmpty)
                                                {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Event")
                                                      .doc(Eventjusttoday.id)
                                                      .collection("Joined")
                                                      .where("Student_id",
                                                          isEqualTo:
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  ?.uid)
                                                      .get()
                                                      .then((docsnapshot) => {
                                                            // ignore: avoid_print
                                                            print(docsnapshot
                                                                .docs.length),
                                                            if (docsnapshot
                                                                .docs.isEmpty)
                                                              // ignore: avoid_print
                                                              {
                                                                // ignore: avoid_print
                                                                print(
                                                                    "dont have"),
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                eventdetailhome(snap: Eventjusttoday)))
                                                              }
                                                            else
                                                              // ignore: avoid_print
                                                              {
                                                                print("had"),
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Leaveeventhome(snap: Eventjusttoday)))
                                                              }
                                                          })
                                                }
                                              else
                                                {
                                                  Fluttertoast.showToast(
                                                      msg: "Your Event!",
                                                      gravity:
                                                          ToastGravity.CENTER),
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Leaveeventhome(
                                                                snap:
                                                                    Eventjusttoday,
                                                                yourevent: "1",
                                                              )))
                                                }
                                            });
                                  },
                                  child: Row(children: <Widget>[
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.63,
                                        child: ListBody(children: <Widget>[
                                          Text(
                                            Day +
                                                ' , ' +
                                                dateshow +
                                                " , " +
                                                Eventjusttoday["Time"],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.w800,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(height: 19),
                                          Text(Eventjusttoday["Name"],
                                              style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 14,
                                                fontFamily: 'Raleway',
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.start),
                                          const SizedBox(height: 12),
                                          Row(children: <Widget>[
                                            const Icon(
                                              Icons.location_on_outlined,
                                              size: 15,
                                            ),
                                            Text(
                                              "  " + Eventjusttoday["Location"],
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Raleway',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ])
                                        ])),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 13, 10, 13),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.33,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8.0)),
                                          child: Image.network(
                                              Eventjusttoday["Image"],
                                              width: double.infinity,
                                              height: 100,
                                              fit: BoxFit.fill),
                                        ))
                                  ]))));
                    }).toList());
                  }
                },
              ),
            ),
          ],
        ));
  }

  Selecteditem(BuildContext context, item) {
    switch (item) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Today()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const thisweek()));
        break;
      case 2:

        // print(body);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Tabbar()),
          (Route<dynamic> route) => false,
        );
    }
  }
}
