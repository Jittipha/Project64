// ignore_for_file: file_names, unused_import, must_be_immutable, camel_case_types, avoid_unnecessary_containers, prefer_const_constructors

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/algolia/searchpage.dart';
import 'package:project/screens/Home_Feed/homepage.dart';

class eventdetailhome extends StatefulWidget {
  eventdetailhome({Key? key, required this.snap}) : super(key: key);
  //final QueryDocumentSnapshot<Object?> studenthasposts;
  QueryDocumentSnapshot snap;

  @override
  _eventdetailhomeState createState() => _eventdetailhomeState();
}

class _eventdetailhomeState extends State<eventdetailhome> {
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
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            child: Image.network(
              widget.snap["Image"],
              fit: BoxFit.fitWidth,
              height: 230,
              width: 500,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 23, 10, 15),
            child: Text(
              widget.snap["Name"],
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
                  widget.snap["date"] + '     ' + widget.snap["Time"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
                )),
          ),
          //
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(width: 0.5, color: Color(0xFF7F7F7F)),
            )),
            child: ListTile(
                leading: const Icon(Icons.location_on_outlined, size: 30),
                title: Text(
                  widget.snap["Location"],
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
                title: Text(
              "   " + widget.snap["Description"],
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w400,
              ),
            )),
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
                  radius: 24.0,
                  backgroundImage:
                      NetworkImage("${widget.snap['Host'][0]['Photo']}"),
                  backgroundColor: Colors.transparent,
                ),
                title: Text(
                  widget.snap['Host'][0]['Name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
                )),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection("Event")
              .doc(widget.snap.id)
              .collection("Joined")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .set({
            "Student_id": FirebaseAuth.instance.currentUser?.uid,
            "Name": FirebaseAuth.instance.currentUser?.displayName,
            "Photo": FirebaseAuth.instance.currentUser?.photoURL,
            "Email": FirebaseAuth.instance.currentUser?.email
          });

          var checkid = await FirebaseFirestore.instance
              .collection("Notification")
              .doc(widget.snap.id)
              .get();
          if (checkid.exists) {
            await FirebaseFirestore.instance
                .collection("Notification")
                .doc(widget.snap.id)
                .update({
              'Student_id': FieldValue.arrayUnion(
                  [FirebaseAuth.instance.currentUser?.uid])
            });
          } else {
            await FirebaseFirestore.instance
                .collection("Notification")
                .doc(widget.snap.id)
                .set({
              "Photo": widget.snap["Image"],
              "Name": widget.snap["Name"],
              "Student_id": [
                FirebaseAuth.instance.currentUser?.uid,
              ]
            });
          }

          await FirebaseFirestore.instance
              .collection("Student")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection("Joined")
              .doc(widget.snap.id)
              .set({
            "Image": widget.snap["Image"],
            "Name": widget.snap["Name"],
            "Description": widget.snap["Description"],
            "Time": widget.snap["Time"],
            "date": widget.snap["date"],
            "Location": widget.snap["Location"],
            "Host": [
              {
                "Student_id": widget.snap['Host'][0]['Student_id'],
                "Name": widget.snap['Host'][0]['Name'],
                "Photo": widget.snap['Host'][0]['Photo'],
                "Email": widget.snap['Host'][0]['Email']
              }
            ]
          }).then((value) {
            Fluttertoast.showToast(
                msg: "เข้าร่วมกิจกรรมแล้ว!", gravity: ToastGravity.CENTER);
            Navigator.pop(context);
          });
        },
        label: const Text('JOIN'),
        icon: const Icon(Icons.person_add_alt),
        backgroundColor: Colors.green[400],
      ),
    );
  }
}
