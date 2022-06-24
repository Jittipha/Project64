// ignore_for_file: file_names, must_be_immutable, avoid_unnecessary_containers, prefer_const_constructors, unused_import, deprecated_member_use, duplicate_import, non_constant_identifier_names, annotate_overrides

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:project/Model/Comment.dart';
import 'package:project/Model/Comment.dart';
import 'package:project/Model/Student.dart';

import 'package:project/algolia/searchpage.dart';
import 'package:project/constants.dart';
import 'package:project/screens/Home_Feed/homepage.dart';
import 'package:project/screens/Myevents.dart';
import 'package:project/screens/homepage.dart';

import '../tabbar.dart';
import 'Event_detail_Home.dart';

class Leaveeventhome extends StatefulWidget {
  Leaveeventhome({Key? key, required this.snap, this.yourevent})
      : super(key: key);
  QueryDocumentSnapshot snap;
  String? yourevent = "2";
  @override
  _LeaveeventhomeState createState() => _LeaveeventhomeState();
}

class _LeaveeventhomeState extends State<Leaveeventhome> {
  String Length = "";
  final _formKey = GlobalKey<FormState>();
  comment comments = comment();
  Students students = Students();

  @override
  void initState() {
    super.initState();
    getLength();
  }

  Future<void> getLength() async {
    Length = await getArrayLength();
    setState(() {});
  }

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
        padding: const EdgeInsets.only(bottom: 60, top: 0, right: 2, left: 2),
        child: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                  width: 0.25, color: Color.fromARGB(255, 248, 244, 244)),
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
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(
                  width: 0.50, color: Color.fromARGB(255, 248, 244, 244)),
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
                  width: 0.50, color: Color.fromARGB(255, 248, 244, 244)),
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
              bottom: BorderSide(
                  width: 0.50, color: Color.fromARGB(255, 248, 244, 244)),
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
          Container(
              padding: const EdgeInsets.fromLTRB(13, 13, 22, 10),
              child: ListTile(
                  trailing: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 19,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(Length,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Raleway',
                                fontSize: 25),
                            textAlign: TextAlign.start),
                      )),
                  title: Text("Joined",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Raleway',
                          fontSize: 25)))),

          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(
                  width: 0.50, color: Color.fromARGB(255, 248, 244, 244)),
            )),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Event')
                    .doc(widget.snap.id)
                    .collection('Joined')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return SizedBox(
                    height: 75,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data!.docs.map((doc) {
                          return SizedBox(
                            height: 10,
                            width: 300,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(doc['Photo']),
                              ),
                              title: Text(doc['Name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Raleway',
                                      fontSize: 20)),
                            ),
                          );
                        }).toList()),
                  );
                }),
          ),
          //Comment
          Container(
            padding: const EdgeInsets.fromLTRB(15, 13, 10, 7),
            child: const ListTile(
              title: Text("Comment",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Raleway',
                      fontSize: 25)),
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
              child: Column(
                children: [
                  TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(110),
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: backgroundColor,
                      hintText: 'กรอกข้อความที่นี้...',
                      hintStyle: TextStyle(
                        fontSize: 17.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: iconColor, width: 2),
                          borderRadius: BorderRadius.circular(5)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: iconColor, width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    maxLines: 4,
                    validator: RequiredValidator(errorText: "comment!"),
                    onSaved: (value) {
                      comments.text = value;
                    },
                  ),
                  SizedBox(height: 7),
                  SizedBox(
                    width: 130,
                    height: 45,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(backgroundColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(color: iconColor, width: 2),
                          ))),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection("Student")
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .get()
                            .then((value) => {
                                  setState(() {
                                    students.Name = value.data()?["Name"];
                                    students.Photo = value.data()?["Photo"];
                                  })
                                });

                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _formKey.currentState!.reset();
                          await FirebaseFirestore.instance
                              .collection('Comment')
                              .doc()
                              .set({
                            "text": comments.text,
                            "eId": widget.snap.id,
                            "sId": FirebaseAuth.instance.currentUser?.uid,
                            "name": students.Name,
                            "year": DateFormat('yyyy').format(DateTime.now()),
                            "hour": DateFormat('kk').format(DateTime.now()),
                            "min": DateFormat('mm').format(DateTime.now()),
                            "month": DateFormat('MM').format(DateTime.now()),
                            "day": DateFormat('dd').format(DateTime.now()),
                            "Photo": students.Photo,
                          });
                        }
                      },
                      child: Text("Send Comment"),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(
                  width: 0.50, color: Color.fromARGB(255, 248, 244, 244)),
            )),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Comment')
                    .where('eId', isEqualTo: widget.snap.id)
                    .orderBy('year', descending: true)
                    .orderBy('month', descending: true)
                    .orderBy('day', descending: true)
                    .orderBy('hour', descending: true)
                    .orderBy('min', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return SizedBox(
                    height: 130,
                    child: ListView(
                        scrollDirection: Axis.vertical,
                        children: snapshot.data!.docs.map((doc) {
                          return SizedBox(
                            height: 70,
                            width: 400,
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 21,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(doc["Photo"]),
                                  radius: 20,
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    doc['name'],
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text('   '),
                                  Text(
                                    doc['day'] +
                                        '/' +
                                        doc['month'] +
                                        '/' +
                                        doc['year'] +
                                        ' - ' +
                                        doc['hour'] +
                                        ':' +
                                        doc['min'],
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(doc['text'],
                                  style: TextStyle(
                                      letterSpacing: 0.3,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                            ),
                          );
                        }).toList()),
                  );
                }),
          ),
        ]),
      ),
      floatingActionButton: _getfloat(),
    );
  }

  Widget _getfloat() {
    if (widget.yourevent == "1") {
      return Container();
    } else {
      return FloatingActionButton.extended(
        onPressed: () async {
          showAlertDialog(context);
        },
        label: const Text(
          'LEAVE',
          style: TextStyle(fontFamily: 'RobotoMono-Light'),
        ),
        icon: const Icon(Icons.exit_to_app_outlined),
        backgroundColor: Colors.pink[400],
      );
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
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
            .then((value) async {
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

  // Getjoinedlength(String Joinedlength) {
  //    QuerySnapshot snaps = await FirebaseFirestore.instance
  //        .collection('Event')
  //       .where("Name", isEqualTo: widget.snap["Name"])
  //       .where("Location", isEqualTo: widget.snap["Location"])
  //        .get();
  //   Joinedlenght = snaps.docs.length.toString();
  //   Joinedlength = "olo";
  //   return Joinedlength;
  // }
  Future<String> getArrayLength() async {
    QuerySnapshot snaps = await FirebaseFirestore.instance
        .collection('Event')
        .doc(widget.snap.id)
        .collection("Joined")
        .get();
    return snaps.docs.length.toString();
  }
}
