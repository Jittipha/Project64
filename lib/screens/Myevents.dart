import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Model/Student.dart';

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
        appBar: AppBar(
          title: const Text(
            "My Events",
            style: TextStyle(fontSize: 25),
          ),
        ),
        body: Center(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Student')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .collection('Posts')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                    // scrollDirection: Axis.horizontal,
                    children: snapshot.data!.docs.map((studenthasposts) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditEvent(
                                      studenthasposts: studenthasposts)));
                        },
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                              child: Image.network(studenthasposts["Image"],
                                  width: 300, height: 150, fit: BoxFit.fill),
                            ),
                            ListTile(
                              title: Text(studenthasposts["Name"],
                                  style: const TextStyle(
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w400,
                                  )),
                              subtitle:
                                  Text(" " + studenthasposts["Description"],
                                      style: const TextStyle(
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w300,
                                      )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                  // Container(
                  //   child: ListTile(
                  //     title: Text(studenthasposts["Name"]),
                  //     onTap: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => EditEvent(
                  //                   studenthasposts: studenthasposts)));
                  //     },
                  //   ),
                  // );
                }).toList());
              }),
        ));
  }
}
