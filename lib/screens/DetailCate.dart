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
            style: TextStyle(fontSize: 40),
          ),
          Text(
            widget.category["Description"],
            textAlign: TextAlign.center,
          ),
          Text(""),
          Text(""),
          Text(""),
          Text(""),
        ],
      )),
    );
  }
}
