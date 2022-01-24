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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
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
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                    children: snapshot.data!.docs.map((studenthasposts) {
                  return Container(
                    child: ListTile(
                      title: Text(studenthasposts["Name"]),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => EditEvent(
                                      studenthasposts: studenthasposts,
                                    )));
                      },
                    ),
                  );
                }).toList());
              }),
        ));
  }
}
