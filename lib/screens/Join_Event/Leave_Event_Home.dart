import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../SearchBar.dart';

class Leaveeventhome extends StatefulWidget {
  Leaveeventhome({Key? key, required this.snap}) : super(key: key);
  QueryDocumentSnapshot snap;

  @override
  _LeaveeventhomeState createState() => _LeaveeventhomeState();
}

class _LeaveeventhomeState extends State<Leaveeventhome> {
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
            child: const ListTile(
                leading: Icon(Icons.date_range, size: 30),
                title: Text(
                  "",
                  style: TextStyle(
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
              widget.snap["Description"],
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
              .delete();
          await FirebaseFirestore.instance
              .collection("Notification")
              .doc(widget.snap.id)
              .update({
            'Student_id':
                FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])
          });

          await FirebaseFirestore.instance
              .collection("Student")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection("Joined")
              .doc(widget.snap.id)
              .delete()
              .then((value) {
            Fluttertoast.showToast(
                msg: "ออกจากกิจกรรมแล้ว!", gravity: ToastGravity.CENTER);
            Navigator.pop(context,
                MaterialPageRoute(builder: (context) => const SearchBar()));
          });
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
}
