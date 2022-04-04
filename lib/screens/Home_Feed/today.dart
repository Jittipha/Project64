// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace, unused_import, prefer_is_empty, avoid_unnecessary_containers, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project/screens/Home_Feed/thisweek.dart';
import 'package:project/screens/Home_Feed/tomorrow.dart';
import 'package:project/screens/Join_Event/Event_detail_Home.dart';
import 'package:project/screens/homepage.dart';

import 'package:flutter/material.dart';

import '../tabbar.dart';
import 'homepage.dart';

class Today extends StatefulWidget {
  const Today({Key? key}) : super(key: key);

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  String Day = DateFormat('E').format(DateTime.now());
  String dateshow = DateFormat.yMMMMd('en_US').format(DateTime.now());

  String date = DateFormat("dd/MM/yyyy").format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          backgroundColor: const Color(0xFF00BF6D),
          title: const Text(
            "Today",
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
                      child: Text("Tomorrow"),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("This week"),
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
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Event")
              .where("date", isEqualTo: date)
              .snapshots(),
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
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => eventdetailhome(
                                            snap: Eventjusttoday,
                                          )));
                            },
                            child: Row(children: <Widget>[
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.63,
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
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 13, 10, 13),
                                  width:
                                      MediaQuery.of(context).size.width * 0.33,
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
        ));
  }

  Selecteditem(BuildContext context, item) {
    switch (item) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Tomorrow()));
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
