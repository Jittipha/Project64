// ignore_for_file: file_names, unused_import, camel_case_types, override_on_non_overriding_member, must_be_immutable, annotate_overrides

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:project/screens/listcate.dart';
import 'package:project/Model/Category.dart';

class Detail_Cate extends StatefulWidget {
  Detail_Cate({
    Key? key,
    required this.category,
  }) : super(key: key);
  //final QueryDocumentSnapshot<Object?> studenthasposts;
  QueryDocumentSnapshot<Object?> category;

  @override
  _Detail_CateState createState() => _Detail_CateState();
}

class _Detail_CateState extends State<Detail_Cate> {
  @override
  Cates cates = Cates();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category["Name"])),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            widget.category["Name"] + ".",
            style: const TextStyle(fontSize: 40),
          ),
          Text(
            widget.category["Description"],
            textAlign: TextAlign.center,
          ),
          const Text(""),
          const Text(""),
          const Text(""),
          const Text(""),
        ],
      )),
    );
  }
}
