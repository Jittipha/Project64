// ignore_for_file: file_names, unused_import, unused_local_variable, unused_element, deprecated_member_use, must_be_immutable, camel_case_types, duplicate_ignore, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, prefer_is_empty, prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:project/screens/Categories/DetailCate.dart';
import 'package:project/main.dart';
import 'package:project/screens/mainpage.dart';
import 'package:snapshot/snapshot.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../tabbar.dart';

// ignore: camel_case_types
class interestedited extends StatefulWidget {
  QueryDocumentSnapshot<Object?> documents;
  interestedited(this.documents, {Key? key}) : super(key: key);

  @override
  _interesteditedState createState() => _interesteditedState();
}

class _interesteditedState extends State<interestedited> {
  List Cate_id = [];
  List Listchoosed = [];

  List listshow = [];
  int length = 0;
  String id = "";
  @override
  void initState() {
    super.initState();
    addtolist();
  }

  Future addtolist() async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection("Category").get();
    List allData = snap.docs.map((doc) => doc.data()).toList();
    listshow = allData;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 150, 140),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 104, 96),
        title: const Text(
          " Interests",
          style: TextStyle(
            letterSpacing: 1,
            fontSize: 23,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () async {
              if (Listchoosed.isNotEmpty) {
                for (int a = 0; a < Listchoosed.length; a++) {
                  QuerySnapshot snaps = await FirebaseFirestore.instance
                      .collection("Category")
                      .where('Name', isEqualTo: Listchoosed[a]['Name'])
                      .where('Description',
                          isEqualTo: Listchoosed[a]['Description'])
                      .get();
                  snaps.docs.forEach((element) {
                    id = element.id;
                  });
                  FirebaseFirestore.instance
                      .collection('Event')
                      .doc(widget.documents.id)
                      .update({
                    "Interests": FieldValue.arrayUnion([id])
                  });
                  // ignore: non_constant_identifier_names
                  QuerySnapshot Postsid = await FirebaseFirestore.instance
                      .collection('Student')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('Posts')
                      .where("Event_id", isEqualTo: widget.documents.id)
                      .get();
                  // ignore: avoid_function_literals_in_foreach_calls
                  Postsid.docs.forEach((document) async {
                    FirebaseFirestore.instance
                        .collection('Student')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .collection('Posts')
                        .doc(document.id)
                        .update({
                      "Interests": FieldValue.arrayUnion([id])
                    });
                  });
                }
                Fluttertoast.showToast(
                    msg: "Success!", gravity: ToastGravity.CENTER);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Tabbar()),
                  (Route<dynamic> route) => false,
                );
              } else {
                showAlertDialog(context);
              }
            },
            child: const Text(
              "NEXT",
              style: TextStyle(
                letterSpacing: 1,
                fontSize: 10,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w900,
              ),
            ),
            shape:
                const CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: Container(
          child: Listchoosed.length == 0
              ? Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: const Text(
                        "แตะเพื่อเลือกความน่าสนใจของกิจกรรม",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      height: MediaQuery.of(context).size.height * 0.765,
                      child: ListView.builder(
                          itemCount: listshow.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.blueGrey[100],
                                child: CircleAvatar(
                                  radius: 23,
                                  backgroundImage:
                                      NetworkImage(listshow[index]['Image']),
                                ),
                              ),
                              title: Text(
                                listshow[index]['Name'].toString(),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                listshow[index]["Description"].toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                maxLines: 1,
                              ),
                              onTap: () {
                                setState(() {
                                  Listchoosed.add(listshow[index]);
                                  listshow.remove(listshow[index]);
                                });
                              },
                            );
                          }),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: const Text(
                        "แตะเพื่อเลือกหมวดหมู่ที่คุณสนใจ",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      height: MediaQuery.of(context).size.height * 0.60,
                      child: ListView.builder(
                          itemCount: listshow.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.blueGrey[100],
                                child: CircleAvatar(
                                  radius: 23,
                                  backgroundImage:
                                      NetworkImage(listshow[index]['Image']),
                                ),
                              ),
                              title: Text(
                                listshow[index]['Name'].toString(),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                listshow[index]["Description"].toString(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                maxLines: 1,
                              ),
                              onTap: () {
                                setState(() {
                                  Listchoosed.add(listshow[index]);
                                  listshow.remove(listshow[index]);
                                });
                              },
                            );
                          }),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top:
                                  BorderSide(color: Colors.black, width: 0.4))),
                      child: Column(
                        children: [
                          Container(
                            height: 30,
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: const Text(
                              "Selected",
                              style: TextStyle(
                                letterSpacing: 1,
                                fontSize: 17,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            height: MediaQuery.of(context).size.height * 0.13,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: Listchoosed.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (Listchoosed.isEmpty) {
                                    return const Center(
                                      child: Text("NOTHING"),
                                    );
                                  } else {
                                    return SizedBox(
                                        height: 100,
                                        width: 90,
                                        child: Column(children: [
                                          ListTile(
                                            leading: CircleAvatar(
                                              radius: 27,
                                              backgroundColor:
                                                  Colors.greenAccent[100],
                                              child: CircleAvatar(
                                                  radius: 25,
                                                  backgroundImage: NetworkImage(
                                                      Listchoosed[index]
                                                          ['Image']),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        listshow.add(
                                                            Listchoosed[index]);
                                                        Listchoosed.remove(
                                                            Listchoosed[index]);
                                                      });
                                                    },
                                                    child: const Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: CircleAvatar(
                                                        radius: 13,
                                                        child: Icon(
                                                          Icons.close_rounded,
                                                          size: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            Listchoosed[index]['Name']
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ]));
                                  }
                                }),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    // ignore: non_constant_identifier_names
    Widget OKButton = FlatButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context, 'Cancel');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Warning!!"),
      content: const Text("กรุณาเลือกหมวดหมู่"),
      actions: [OKButton],
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
