import 'package:flutter/material.dart';

class addcate extends StatefulWidget {
  const addcate({Key? key}) : super(key: key);

  @override
  State<addcate> createState() => _addcateState();
}

class _addcateState extends State<addcate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xFF00BF6D),
            title: const Text(
              "Create Category",
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w600,
              ),
            )));
  }
}
