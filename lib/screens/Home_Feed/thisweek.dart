// ignore_for_file: camel_case_types, prefer_is_empty, non_constant_identifier_names, avoid_unnecessary_containers, avoid_print, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:project/screens/Home_Feed/today.dart';
import 'package:project/screens/Home_Feed/tomorrow.dart';
import 'package:project/screens/Join_Event/Event_detail_Home.dart';

import 'package:flutter/material.dart';

import '../Join_Event/Leave_Event_Home.dart';
import '../tabbar.dart';

class thisweek extends StatefulWidget {
  const thisweek({Key? key}) : super(key: key);

  @override
  State<thisweek> createState() => _thisweekState();
}

class _thisweekState extends State<thisweek> {
  String date7 = DateFormat("dd/MM/yyyy")
      .format(DateTime.now().add(const Duration(days: 7)));
  String date1 = DateFormat("dd/MM/yyyy")
      .format(DateTime.now().add(const Duration(days: 1)));
  String date2 = DateFormat("dd/MM/yyyy")
      .format(DateTime.now().add(const Duration(days: 2)));
  String date3 = DateFormat("dd/MM/yyyy")
      .format(DateTime.now().add(const Duration(days: 3)));
  String date4 = DateFormat("dd/MM/yyyy")
      .format(DateTime.now().add(const Duration(days: 4)));
  String date5 = DateFormat("dd/MM/yyyy")
      .format(DateTime.now().add(const Duration(days: 5)));
  String date6 = DateFormat("dd/MM/yyyy")
      .format(DateTime.now().add(const Duration(days: 6)));
  String date = DateFormat("dd/MM/yyyy").format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 30, 150, 140),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 13, 104, 96),
          title: const Text(
            "This week",
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.black),
                child: PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Today"),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("Tomorrow"),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem<int>(
                      value: 2,
                      child: Text("Default"),
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
                    .where("date", whereIn: [
                  date,
                  date1,
                  date2,
                  date3,
                  date4,
                  date5,
                  date6,
                  date7
                ]).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data?.docs.length == 0) {
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
                    return ListView(
                        children: snapshot.data!.docs.map((Eventjusttoday) {
                      return Container(
                          child: Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              child: InkWell(
                                  onTap: () async{
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
                                                { Fluttertoast.showToast(
                                                                      msg:
                                                                          "Your Event!",
                                                                      gravity:
                                                                          ToastGravity
                                                                              .CENTER),
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => Leaveeventhome(
                                                                                snap: Eventjusttoday,
                                                                                yourevent: "1",
                                                                              )))}
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
                                            Conditiondays(
                                                Eventjusttoday["date"],
                                                Eventjusttoday["Time"]),
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
            context, MaterialPageRoute(builder: (context) => const Tomorrow()));
        break;
      case 2:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Tabbar()),
          (Route<dynamic> route) => false,
        );
    }
  }

  Conditiondays(getday, time) {
    String date = DateFormat("dd/MM/yyyy").format(DateTime.now());
    String date1 = DateFormat("dd/MM/yyyy")
        .format(DateTime.now().add(const Duration(days: 1)));
    String date2 = DateFormat("dd/MM/yyyy")
        .format(DateTime.now().add(const Duration(days: 2)));
    String date3 = DateFormat("dd/MM/yyyy")
        .format(DateTime.now().add(const Duration(days: 3)));
    String date4 = DateFormat("dd/MM/yyyy")
        .format(DateTime.now().add(const Duration(days: 4)));
    String date5 = DateFormat("dd/MM/yyyy")
        .format(DateTime.now().add(const Duration(days: 5)));
    String date6 = DateFormat("dd/MM/yyyy")
        .format(DateTime.now().add(const Duration(days: 6)));
    String date7 = DateFormat("dd/MM/yyyy")
        .format(DateTime.now().add(const Duration(days: 7)));
    String Day;
    String Text;
    String dateshow;
    if (getday == date) {
      Day = DateFormat('E').format(DateTime.now());
      dateshow = DateFormat.yMMMMd('en_US').format(DateTime.now());
      Text = Day + ' , ' + dateshow + " , " + time;
      return Text;
    } else if (getday == date1) {
      Day = DateFormat('E').format(DateTime.now().add(const Duration(days: 1)));
      dateshow = DateFormat.yMMMMd('en_US')
          .format(DateTime.now().add(const Duration(days: 1)));
      Text = Day + ' , ' + dateshow + " , " + time;
      return Text;
    } else if (getday == date2) {
      Day = DateFormat('E').format(DateTime.now().add(const Duration(days: 2)));
      dateshow = DateFormat.yMMMMd('en_US')
          .format(DateTime.now().add(const Duration(days: 2)));
      Text = Day + ' , ' + dateshow + " , " + time;
      return Text;
    } else if (getday == date3) {
      Day = DateFormat('E').format(DateTime.now().add(const Duration(days: 3)));
      dateshow = DateFormat.yMMMMd('en_US')
          .format(DateTime.now().add(const Duration(days: 3)));
      Text = Day + ' , ' + dateshow + " , " + time;
      return Text;
    } else if (getday == date4) {
      Day = DateFormat('E').format(DateTime.now().add(const Duration(days: 4)));
      dateshow = DateFormat.yMMMMd('en_US')
          .format(DateTime.now().add(const Duration(days: 4)));
      Text = Day + ' , ' + dateshow + " , " + time;
      return Text;
    } else if (getday == date5) {
      Day = DateFormat('E').format(DateTime.now().add(const Duration(days: 5)));
      dateshow = DateFormat.yMMMMd('en_US')
          .format(DateTime.now().add(const Duration(days: 5)));
      Text = Day + ' , ' + dateshow + " , " + time;
      return Text;
    } else if (getday == date6) {
      Day = DateFormat('E').format(DateTime.now().add(const Duration(days: 6)));
      dateshow = DateFormat.yMMMMd('en_US')
          .format(DateTime.now().add(const Duration(days: 6)));
      Text = Day + ' , ' + dateshow + " , " + time;
      return Text;
    } else if (getday == date7) {
      Day = DateFormat('E').format(DateTime.now().add(const Duration(days: 7)));
      dateshow = DateFormat.yMMMMd('en_US')
          .format(DateTime.now().add(const Duration(days: 7)));
      Text = Day + ' , ' + dateshow + " , " + time;
      return Text;
    }
  }
}
