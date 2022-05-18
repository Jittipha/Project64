import 'package:flutter/material.dart';
import 'package:project/Background/bg.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
          "Home",
          style: TextStyle(fontSize: 25, color: Colors.black),
        )),
        body: StreamBuilder(
          stream: null,
          builder: (context, snapshot) {
            return const Background(child: Text('nono'));
          },
        ));
  }
}
