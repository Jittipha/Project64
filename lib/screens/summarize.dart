import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class Summarize extends StatefulWidget {
  const Summarize({Key? key}) : super(key: key);

  @override
  State<Summarize> createState() => _SummarizeState();
}

class _SummarizeState extends State<Summarize> {
  List listfutureshow = [];
  List listLastshow = [];
  String? time;
  String Length = "";
  String Day = DateFormat("dd").format(DateTime.now());
  String Month = DateFormat("MM").format(DateTime.now());
  String Year = DateFormat("yyyy").format(DateTime.now());
  void TimeNow() {
    final now = DateTime.now();

    setState(() {
      time = DateFormat.Hms().format(now);
    });
    print('time$time');
  }

  Future<void> addlengthtodata() async {
    QuerySnapshot snaps =
        await FirebaseFirestore.instance.collection('Event').get();
    snaps.docs.forEach((element) async {
      QuerySnapshot snaps = await FirebaseFirestore.instance
          .collection('Event')
          .doc(element.id)
          .collection("Joined")
          .get();

      await FirebaseFirestore.instance
          .collection('Event')
          .doc(element.id)
          .update({'Count_join': snaps.docs.length});
    });
  }

  Future<void> addlistdata() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Event")
        .orderBy('Count_join', descending: true)
        .get();
    List allData = snap.docs.map((doc) => doc.data()).toList();
    int year = int.parse(Year);
    int month = int.parse(Month);
    int day = int.parse(Day);

    for (int a = 0; a < allData.length; a++) {
      var Date = allData[a]["date"].split("/");

      int yearevent = int.parse(Date[2]);
      int monthevent = int.parse(Date[1]);
      int dayevent = int.parse(Date[0]);

      if (yearevent >= year) {
        if (monthevent >= month) {
          if (dayevent >= day) {
            listfutureshow.add(allData[a]);
          } else if (dayevent < day && monthevent == month) {
            listLastshow.add(allData[a]);
          } else if (dayevent < day && monthevent > month) {
            listfutureshow.add(allData[a]);
          }
        } else if (monthevent < month) {
          listLastshow.add(allData[a]);
        }
      } else if (yearevent < year) {
        listLastshow.add(allData[a]);
      }
    }
    print(listLastshow);
    setState(() {});
  }

  @override
  void initState() {
    addlengthtodata();
    addlistdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Summarize'),
      ),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(13, 13, 22, 10),
              child: ListTile(
                  title: Text("กิจกรรมที่กำลังจะถึง",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Raleway',
                          fontSize: 18)))),
          Container(
              height: 250,
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Row(children: <Widget>[
                Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listfutureshow.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (listfutureshow.length == 0) {
                            return Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 55, 0, 30),
                                child: const Text(
                                  "NOT HAVE EVENT.",
                                  style: TextStyle(
                                      fontFamily: "Raleway",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.center,
                                ));
                          } else {
                            return SizedBox(
                                height: 245,
                                width: 250,
                                child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 15, 10, 10),
                                    child: SizedBox(
                                      height: 234,
                                      width: 220,
                                      child: Card(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: InkWell(
                                          // onTap: () async => {
                                          //   Navigator.push(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //           builder: (context) =>
                                          //               Leaveeventhome(
                                          //                   snap:
                                          //                       studenthaspost)))
                                          // },
                                          child: Column(
                                            children: <Widget>[
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(8.0),
                                                  topRight:
                                                      Radius.circular(8.0),
                                                ),
                                                child: Image.network(
                                                    listfutureshow[index]
                                                        ["Image"],
                                                    width: double.infinity,
                                                    height: 140,
                                                    fit: BoxFit.fill),
                                              ),
                                              ListTile(
                                                title: Text(
                                                    listfutureshow[index]
                                                            ["Name"] +
                                                        ' | เข้าร่วม : ' +
                                                        listfutureshow[index]
                                                                ["Count_join"]
                                                            .toString(),
                                                    style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontFamily: 'Raleway',
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                subtitle: Text(
                                                    listfutureshow[index]
                                                            ["date"] +
                                                        "  |  " +
                                                        listfutureshow[index]
                                                            ["Time"],
                                                    style: const TextStyle(
                                                        fontFamily: 'Raleway',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )));
                          }
                        }))
              ])),
          Container(
              padding: const EdgeInsets.fromLTRB(13, 13, 22, 10),
              child: ListTile(
                  title: Text("กิจกรรมที่ผ่านไปแล้ว",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Raleway',
                          fontSize: 18)))),
          Container(
              height: 250,
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Row(children: <Widget>[
                Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listLastshow.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (listLastshow.length == 0) {
                            return Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 55, 0, 30),
                                child: const Text(
                                  "NOT HAVE EVENT.",
                                  style: TextStyle(
                                      fontFamily: "Raleway",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.center,
                                ));
                          } else {
                            return SizedBox(
                                height: 245,
                                width: 250,
                                child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 15, 10, 10),
                                    child: SizedBox(
                                      height: 234,
                                      width: 220,
                                      child: Card(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: InkWell(
                                          // onTap: () async => {
                                          //   Navigator.push(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //           builder: (context) =>
                                          //               Leaveeventhome(
                                          //                   snap:
                                          //                       studenthaspost)))
                                          // },
                                          child: Column(
                                            children: <Widget>[
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(8.0),
                                                  topRight:
                                                      Radius.circular(8.0),
                                                ),
                                                child: Image.network(
                                                    listLastshow[index]
                                                        ["Image"],
                                                    width: double.infinity,
                                                    height: 140,
                                                    fit: BoxFit.fill),
                                              ),
                                              ListTile(
                                                title: Text(
                                                    listLastshow[index]
                                                            ["Name"] +
                                                        ' | เข้าร่วม : ' +
                                                        listLastshow[index]
                                                                ["Count_join"]
                                                            .toString(),
                                                    style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontFamily: 'Raleway',
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                subtitle: Text(
                                                    listLastshow[index]
                                                            ["date"] +
                                                        "  |  " +
                                                        listLastshow[index]
                                                            ["Time"],
                                                    style: const TextStyle(
                                                        fontFamily: 'Raleway',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )));
                          }
                        }))
              ])),
        ],
      ),
    );
  }
}
