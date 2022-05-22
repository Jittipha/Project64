// ignore_for_file: unused_import, non_constant_identifier_names, avoid_unnecessary_containers, avoid_print, duplicate_ignore, must_be_immutable, use_key_in_widget_constructors, prefer_is_empty, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/algolia/searchpage.dart';
import 'package:project/components/fill_outline_button.dart';
import 'package:project/screens/Home_Feed/thisweek.dart';
import 'package:project/screens/Home_Feed/today.dart';
import 'package:project/screens/Home_Feed/tomorrow.dart';
import 'package:project/screens/Join_Event/Event_detail_Home.dart';
import 'package:project/screens/Join_Event/Event_detail_Search.dart';
import 'package:project/screens/Join_Event/Leave_Event_Home.dart';
import 'package:project/screens/Join_Event/Leave_Event_Search.dart';
import 'package:project/screens/Myevents.dart';

import '../editeventpost.dart';

class Homefeed extends StatefulWidget {
  @override
  _HomefeedState createState() => _HomefeedState();
}

class _HomefeedState extends State<Homefeed> {
  String Category = "";
  String Category_id = "";
  String body = "Home";
  var listedit;
  var list;
  QuerySnapshot? b;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 30, 150, 140),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 13, 104, 96),
          title: Text(
            body,
            style: const TextStyle(
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
                      value: 4,
                      child: Text("Starting soon!"),
                    ),
                    const PopupMenuDivider(),
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
                    // const PopupMenuDivider(),
                    // const PopupMenuItem<int>(
                    //   value: 3,
                    //   child: Text("Default"),
                    // ),
                  ],
                  onSelected: (item) => Selecteditem(context, item),
                ))
          ],
        ),
        body: ListView(children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.765,
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Student')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('Categories')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return HomeBody(snapshot);
                    }
                  }))
        ]));
  }

  Future getLength(Category_id, Category) async {
    var check = await FirebaseFirestore.instance.collection("Event").where(
      "Interests",
      arrayContainsAny: [Category_id],
    ).get();
    print(Category);
    var lenght = check.docs.length;
    print(lenght);
    return lenght;
  }

  HomeBody(snapshot) {
    return ListView(
        scrollDirection: Axis.vertical,
        children: snapshot.data!.docs.map<Widget>((cate) {
          Category = cate["Name"];
          Category_id = cate["Category_id"];
          return Container(
            // ignore: unrelated_type_equality_checks
            child: getLength(Category_id, Category) == 0
                ? Container()
                : Column(children: <Widget>[
                    Container(
                        child: ListTile(
                      title: Text(
                        "    " + cate["Name"],
                        style: const TextStyle(
                          color: Color.fromARGB(255, 242, 253, 174),
                          letterSpacing: 0.5,
                          fontSize: 22,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )),
                    Container(
                        child: Row(children: <Widget>[
                      Expanded(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("Event")
                              //where อาเรย์

                              .where(
                            "Interests",
                            arrayContainsAny: [Category_id],
                          ).snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> snapshots) {
                            if (snapshots.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                              // ignore: prefer_is_empty
                            } else if (snapshots.data?.docs.length == 0) {
                              return Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 55, 0, 55),
                                  child: const Text(
                                    "NOT HAS EVENT.",
                                    style: TextStyle(
                                        fontFamily: "Raleway",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.center,
                                  ));
                            } else {
                              return SizedBox(
                                  height: 245,
                                  width: 220,
                                  child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children:
                                          snapshots.data!.docs.map((Event) {
                                        return Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 15, 10, 10),
                                            child: SizedBox(
                                              height: 234,
                                              width: 220,
                                              child: Card(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8.0))),
                                                child: InkWell(
                                                  onTap: () async => {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("Student")
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .collection("Posts")
                                                        //where เช็คค่า
                                                        .where("Event_id",
                                                            isEqualTo: Event.id)
                                                        .get()
                                                        .then((value) async => {
                                                              if (value
                                                                  .docs.isEmpty)
                                                                {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "Event")
                                                                      .doc(Event
                                                                          .id)
                                                                      .collection(
                                                                          "Joined")
                                                                      .where(
                                                                          "Student_id",
                                                                          isEqualTo: FirebaseAuth
                                                                              .instance
                                                                              .currentUser
                                                                              ?.uid)
                                                                      .get()
                                                                      .then(
                                                                          (docsnapshot) =>
                                                                              {
                                                                                // ignore: avoid_print
                                                                                print(docsnapshot.docs.length),
                                                                                if (docsnapshot.docs.isEmpty)
                                                                                  // ignore: avoid_print
                                                                                  {
                                                                                    print("dont have"),
                                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => eventdetailhome(snap: Event)))
                                                                                  }
                                                                                else
                                                                                  // ignore: avoid_print
                                                                                  {
                                                                                    print("had"),
                                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Leaveeventhome(snap: Event)))
                                                                                  }
                                                                              })
                                                                }
                                                              else
                                                                {
                                                                  Fluttertoast.showToast(
                                                                      msg:
                                                                          "Your Event!",
                                                                      gravity:
                                                                          ToastGravity
                                                                              .CENTER),
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => Leaveeventhome(
                                                                                snap: Event,
                                                                                yourevent: "1",
                                                                              )))
                                                                }
                                                            })
                                                  },
                                                  child: Column(
                                                    children: <Widget>[
                                                      ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  8.0),
                                                        ),
                                                        child: Image.network(
                                                            Event["Image"],
                                                            width:
                                                                double.infinity,
                                                            height: 140,
                                                            fit: BoxFit.fill),
                                                      ),
                                                      ListTile(
                                                        title: Text(
                                                            Event["Name"],
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Raleway',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                        subtitle: Text(
                                                            Event["date"] +
                                                                "  |  " +
                                                                Event["Time"],
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Raleway',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ));
                                      }).toList()));
                            }
                          },
                        ),
                      )
                    ]))
                  ]),
          );
        }).toList());
  }

  Selecteditem(BuildContext context, item) {
    switch (item) {
      case 0:
        body = 'Today';
        // print(body);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Today()));
        break;
      case 1:
        body = 'Tomorrow';
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Tomorrow()));
        break;
      case 2:
        body = 'This Week';
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const thisweek()));
    }
  }
}
