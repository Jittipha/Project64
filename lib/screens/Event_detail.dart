// ignore_for_file: file_names, unused_import, must_be_immutable, camel_case_types, avoid_unnecessary_containers, unnecessary_import

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project/screens/homepage.dart';

class eventdetail extends StatefulWidget {
  eventdetail({
    Key? key,
    required this.snap,
  }) : super(key: key);
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
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Container(
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
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
                  style: TextStyle(fontSize: 17),
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
                  style: const TextStyle(fontSize: 17),
                  textAlign: TextAlign.start,
                )),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: const ListTile(
              title: Text("About",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      fontSize: 23)),
            ),
          )
        ]),
      ),
    );
  }
}
