// ignore_for_file: file_names, unused_import, must_be_immutable, avoid_unnecessary_containers, prefer_const_constructors, deprecated_member_use

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/algolia/searchpage.dart';
import 'package:project/screens/bg.dart';

class Leaveevent extends StatefulWidget {
  Leaveevent({Key? key, required this.snap}) : super(key: key);
  AlgoliaObjectSnapshot snap;

  @override
  _LeaveeventState createState() => _LeaveeventState();
}

class _LeaveeventState extends State<Leaveevent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Event",
          style: TextStyle(
              fontSize: 25, fontFamily: 'Raleway', fontWeight: FontWeight.w600),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Event')
              .doc(widget.snap.objectID)
              .collection('Joined')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Background(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Column(children: <Widget>[
                Container(
                  child: Image.network(
                    widget.snap.data["Image"],
                    fit: BoxFit.fitWidth,
                    height: 230,
                    width: 500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 23, 10, 15),
                  child: Text(
                    widget.snap.data["Name"],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway',
                        fontSize: 25),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  decoration: const BoxDecoration(
                      border: Border(
                    bottom: BorderSide(width: 0.5, color: Color(0xFF7F7F7F)),
                  )),
                  child: ListTile(
                      leading: const Icon(Icons.date_range, size: 30),
                      title: Text(
                        widget.snap.data["date"] +
                            '     ' +
                            widget.snap.data["Time"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.start,
                      )),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: const BoxDecoration(
                      border: Border(
                    bottom: BorderSide(width: 0.5, color: Color(0xFF7F7F7F)),
                  )),
                  child: ListTile(
                      leading: const Icon(Icons.location_on_outlined, size: 30),
                      title: Text(
                        widget.snap.data["Location"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.start,
                      )),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 13, 10, 2),
                  child: const ListTile(
                    title: Text("About",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Raleway',
                            fontSize: 25)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(28, 0, 10, 10),
                  decoration: const BoxDecoration(
                      border: Border(
                    bottom: BorderSide(width: 0.5, color: Color(0xFF7F7F7F)),
                  )),
                  child: ListTile(
                    title: Text(widget.snap.data["Description"],
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Raleway',
                        )),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 13, 10, 2),
                  child: const ListTile(
                    title: Text("Host",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Raleway',
                            fontSize: 25)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(13, 0, 0, 10),
                  decoration: const BoxDecoration(
                      border: Border(
                    bottom: BorderSide(width: 0.5, color: Color(0xFF7F7F7F)),
                  )),
                  child: ListTile(
                      leading: CircleAvatar(
                        radius: 26.0,
                        backgroundImage: NetworkImage(
                            "${widget.snap.data['Host'][0]['Photo']}"),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(
                        widget.snap.data['Host'][0]['Name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.start,
                      )),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 13, 10, 2),
                  child: const ListTile(
                    title: Text("Joined",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Raleway',
                            fontSize: 25)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(13, 0, 0, 10),
                  decoration: const BoxDecoration(
                      border: Border(
                    bottom: BorderSide(width: 0.5, color: Color(0xFF7F7F7F)),
                  )),
                  height: 200,
                  width: 500,
                  child: ListView(
                      children: snapshot.data!.docs.map((doc) {
                    return Card(
                        color: Colors.purple[50],
                        child: ListTile(
                          leading: Image.network(doc['Photo']),
                          title: Text(doc['Name']),
                        ));
                  }).toList()),
                )
              ]),
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          showAlertDialog(context);
        },
        label: const Text(
          'LEAVE',
          style: TextStyle(fontFamily: 'RobotoMono-Light'),
        ),
        icon: const Icon(Icons.exit_to_app_outlined),
        backgroundColor: Colors.pink[400],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () async {
        await FirebaseFirestore.instance
            .collection("Event")
            .doc(widget.snap.objectID)
            .collection("Joined")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .delete();
        await FirebaseFirestore.instance
            .collection("Notification")
            .doc(widget.snap.objectID)
            .update({
          'Student_id':
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])
        });
        await FirebaseFirestore.instance
            .collection("Student")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection("Joined")
            .doc(widget.snap.objectID)
            .delete()
            .then((value) {
          Fluttertoast.showToast(
              msg: "ออกจากกิจกรรมแล้ว!", gravity: ToastGravity.CENTER);
          Navigator.pop(context);
          Navigator.pop(context);
        });
      },
    );
    Widget cancleButton = FlatButton(
      child: Text("CANCLE"),
      onPressed: () {
        Navigator.pop(context, 'Cancel');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("LEAVE EVENT !"),
      content: Text("Are you sure?"),
      actions: [cancleButton, okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
