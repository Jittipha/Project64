// ignore_for_file: file_names, unused_import, camel_case_types, must_be_immutable, avoid_unnecessary_containers, unnecessary_import

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/algolia/searchpage.dart';
import 'package:project/screens/Home_Feed/homepage.dart';

class eventdetail extends StatefulWidget {
  eventdetail({Key? key, required this.snap}) : super(key: key);
  //final QueryDocumentSnapshot<Object?> studenthasposts;
  AlgoliaObjectSnapshot snap;

  @override
  _eventdetailState createState() => _eventdetailState();
}

class _eventdetailState extends State<eventdetail> {
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
                  widget.snap.data["date"] + '     ' + widget.snap.data["Time"],
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
                title: Text(
              "   " + widget.snap.data["Description"],
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
                      NetworkImage("${widget.snap.data['Host'][0]['Photo']}"),
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
        ]),
      ),

      //ปุ่มจอย++++++++++++++++++++++++++++++++++++++
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection("Event")
              .doc(widget.snap.objectID)
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
              .doc(widget.snap.objectID)
              .get();
          if (checkid.exists) {
            await FirebaseFirestore.instance
                .collection("Notification")
                .doc(widget.snap.objectID)
                .update({
              'Student_id': FieldValue.arrayUnion(
                  [FirebaseAuth.instance.currentUser?.uid])
            });
          } else {
            await FirebaseFirestore.instance
                .collection("Notification")
                .doc(widget.snap.objectID)
                .set({
              "Photo": widget.snap.data["Image"],
              "Name": widget.snap.data["Name"],
              "Student_id": [
                FirebaseAuth.instance.currentUser?.uid,
              ]
            });
          }
          // await FirebaseFirestore.instance
          //     .collection("Notification")
          //     .doc(widget.snap.objectID)
          //     .update({
          //   "Photo": widget.snap.data["Image"],
          //   "Name": widget.snap.data["Name"]
          // });
          // await FirebaseFirestore.instance
          //     .collection("Notification")
          //     .doc(widget.snap.objectID)
          //     .update({
          //   'Student_id':
          //       FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])

          // });
          await FirebaseFirestore.instance
              .collection("Student")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection("Joined")
              .doc(widget.snap.objectID)
              .set({
            "Image": widget.snap.data["Image"],
            "Name": widget.snap.data["Name"],
            "Description": widget.snap.data["Description"],
            "Time": widget.snap.data["Time"],
            "date": widget.snap.data["date"],
            "Location": widget.snap.data["Location"],
            "Host": [
              {
                "Student_id": widget.snap.data['Host'][0]['Student_id'],
                "Name": widget.snap.data['Host'][0]['Name'],
                "Photo": widget.snap.data['Host'][0]['Photo'],
                "Email": widget.snap.data['Host'][0]['Email']
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
