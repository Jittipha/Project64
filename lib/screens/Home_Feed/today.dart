// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project/screens/Home_Feed/thisweek.dart';
import 'package:project/screens/Home_Feed/tomorrow.dart';
import 'package:project/screens/homepage.dart';

import 'package:flutter/material.dart';

class Today extends StatefulWidget {
  const Today({Key? key}) : super(key: key);

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  String Day = DateFormat('E').format(DateTime.now());
  String dateshow = DateFormat.yMMMMd('en_US').format(DateTime.now());

  String date = DateFormat("dd/MM/yyyy").format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00BF6D),
          title: const Text(
            "Today",
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.black),
                child: PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Today"),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("Tomorrow"),
                    ),
                    const PopupMenuItem<int>(
                      value: 2,
                      child: Text("This week"),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem<int>(
                      value: 3,
                      child: Text("Default"),
                    ),
                  ],
                  onSelected: (item) => Selecteditem(context, item),
                ))
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Event")
              .where("date", isEqualTo: date)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0));
              return ListView(
                  children: snapshot.data!.docs.map((Eventjusttoday) {
                return Row(children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Column(children: <Widget>[
                        Text(
                          Day + ' , ' + dateshow + " " + Eventjusttoday["Time"],
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(Eventjusttoday["Name"],
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.start),
                        Text(
                          Eventjusttoday["Location"],
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ])),
                  Container(
                      padding: const EdgeInsets.fromLTRB(5, 13, 10, 13),
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                        child: Image.network(Eventjusttoday["Image"],
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.fill),
                      ))
                ]);
              }).toList());
            }
          },
        ));
  }

  Selecteditem(BuildContext context, item) {
    switch (item) {
      case 0:

        // print(body);
        return const Today();
      case 1:

        // print(body);
        return Tomorrow();
      case 2:

        // print(body);
        return thisweek();
      case 3:

        // print(body);
        return const Home();
    }
  }
}
