import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/constants.dart';

class detailnoti extends StatefulWidget {
  detailnoti({Key? key, required this.snap}) : super(key: key);
  QueryDocumentSnapshot snap;

  @override
  State<detailnoti> createState() => _detailnotiState();
}

class _detailnotiState extends State<detailnoti> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: iconColor,
        title: const Text(
          "Event",
          style: TextStyle(
              fontSize: 25, fontFamily: 'Raleway', fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(bottom: 70, top: 10, right: 10, left: 10),
        child: Column(children: <Widget>[
          Container(
            child: Image.network(
              widget.snap["Image"],
              fit: BoxFit.cover,
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
              bottom: BorderSide(
                  width: 0.5, color: Color.fromARGB(255, 248, 244, 244)),
            )),
            child: ListTile(
                leading:
                    const Icon(Icons.date_range, color: iconColor, size: 30),
                title: Text(
                  widget.snap["date"] + '   |   ' + widget.snap["Time"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.start,
                )),
          ),
          //
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(
                  width: 0.5, color: Color.fromARGB(255, 248, 244, 244)),
            )),
            child: ListTile(
                leading: const Icon(Icons.location_on_outlined,
                    color: iconColor, size: 30),
                title: Text(
                  widget.snap["Location"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w700,
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
              bottom: BorderSide(
                  width: 0.5, color: Color.fromARGB(255, 248, 244, 244)),
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
              bottom: BorderSide(
                  width: 0.5, color: Color.fromARGB(255, 248, 244, 244)),
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
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                )),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection("Notification")
              .doc(widget.snap.id)
              .update({
            "Student_id":
                FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
          }).then((value) {
            Fluttertoast.showToast(
                msg: "อ่านแจ้งเตือนแล้ว", gravity: ToastGravity.CENTER);
            Navigator.pop(context);
          });
        },
        label: const Text('อ่านแล้ว'),
        icon: const Icon(Icons.done_outline),
        backgroundColor: Colors.green[400],
      ),
    );
  }
}
