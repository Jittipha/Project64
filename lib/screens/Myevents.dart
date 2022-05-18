// ignore_for_file: file_names, prefer_adjacent_string_concatenation, prefer_is_empty

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Model/Student.dart';

import 'Join_Event/Leave_Event_Home.dart';
import 'editeventpost.dart';

class MyEvent extends StatefulWidget {
  const MyEvent({Key? key}) : super(key: key);

  @override
  _MyEventState createState() => _MyEventState();
}

class _MyEventState extends State<MyEvent> {
  Students student = Students();
  final String test = "Fuck";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 150, 140),
        appBar: AppBar(
          backgroundColor:const Color.fromARGB(255, 30, 150, 140),
          title: const Text(
            "My Events",
            style: TextStyle(fontSize: 25),
          ),
        ),
        body: Column(children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          const ListTile(
              title: Text(
            "  " + "My Posts",
            style: TextStyle(
              color: Color.fromARGB(255, 242, 253, 174),
              fontSize: 24,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w600,
            ),
          )),
          // ignore: avoid_unnecessary_containers
          Container(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Row(children: <Widget>[
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Student")
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .collection("Posts")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                      if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshots.data?.docs.length == 0) {
                        return Container(
                            padding: const EdgeInsets.fromLTRB(0, 55, 0, 0),
                            child: const Text(
                              "NOT HAS EVENT.",
                              style: TextStyle(
                                  fontFamily: "Raleway",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                              textAlign: TextAlign.center,
                            ));
                      } else {
                        return SizedBox(
                            height: 245,
                            width: 220,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children:
                                    snapshots.data!.docs.map((studenthasposts) {
                                  return Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 15, 10, 10),
                                      child: SizedBox(
                                        height: 234,
                                        width: 220,
                                        child: Card(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          child: InkWell(
                                            onTap: () async => {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditEvent(
                                                              studenthasposts:
                                                                  studenthasposts)))
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(8.0),
                                                    topRight:
                                                        Radius.circular(8.0),
                                                  ),
                                                  child: Image.network(
                                                      studenthasposts["Image"],
                                                      width: double.infinity,
                                                      height: 140,
                                                      fit: BoxFit.fill),
                                                ),
                                                ListTile(
                                                  title: Text(
                                                      studenthasposts["Name"],
                                                      style: const TextStyle(
                                                          fontFamily: 'Raleway',
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  subtitle: Text(
                                                      studenthasposts["date"] +
                                                          "  |  " +
                                                          studenthasposts[
                                                              "Time"],
                                                      style: const TextStyle(
                                                          fontFamily: 'Raleway',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ));
                                }).toList()));
                      }
                    },
                  ),
                )
              ])),
          const SizedBox(
            height: 15,
          ),
          // ignore: avoid_unnecessary_containers
          Container(
            child: const ListTile(
              title: Text(
                "  " + "My Joined",
                style: TextStyle(
                  color: Color.fromARGB(255, 242, 253, 174),
                  fontSize: 24,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // ignore: avoid_unnecessary_containers
          Container(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Row(children: <Widget>[
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Student")
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .collection("Joined")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.data?.docs.length == 0) {
                        return Container(
                            padding: const EdgeInsets.fromLTRB(0, 55, 0, 30),
                            child: const Text(
                              "NOT HAVE EVENT.",
                              style: TextStyle(
                                  fontFamily: "Raleway",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                              textAlign: TextAlign.center,
                            ));
                      } else {
                        return SizedBox(
                            height: 245,
                            width: 220,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children:
                                    snapshot.data!.docs.map((studenthaspost) {
                                  return Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 15, 10, 10),
                                      child: SizedBox(
                                        height: 234,
                                        width: 220,
                                        child: Card(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          child: InkWell(
                                            onTap: () async => {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Leaveeventhome(
                                                              snap:
                                                                  studenthaspost)))
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(8.0),
                                                    topRight:
                                                        Radius.circular(8.0),
                                                  ),
                                                  child: Image.network(
                                                      studenthaspost["Image"],
                                                      width: double.infinity,
                                                      height: 140,
                                                      fit: BoxFit.fill),
                                                ),
                                                ListTile(
                                                  title: Text(
                                                      studenthaspost["Name"],
                                                      style: const TextStyle(
                                                          fontFamily: 'Raleway',
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  subtitle: Text(
                                                      studenthaspost["date"] +
                                                          "  |  " +
                                                          studenthaspost[
                                                              "Time"],
                                                      style: const TextStyle(
                                                          fontFamily: 'Raleway',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ));
                                }).toList()));
                      }
                    },
                  ),
                )
              ])),
        ]));
  }
}
