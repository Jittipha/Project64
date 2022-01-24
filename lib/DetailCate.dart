import 'package:flutter/material.dart';
import 'main.dart';
import 'package:project/chooseCate.dart';

class Detail_Cate extends StatelessWidget {
  final Cate cate;

  Detail_Cate(this.cate);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cate.Name)),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            cate.Name,
            style: TextStyle(fontSize: 40),
          ),
          Text(
            cate.Description,
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
