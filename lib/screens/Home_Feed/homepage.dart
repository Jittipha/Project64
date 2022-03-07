import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/components/fill_outline_button.dart';
import 'package:project/screens/Home_Feed/thisweek.dart';
import 'package:project/screens/Join_Event/Event_detail_Home.dart';
import 'package:project/screens/Join_Event/Event_detail_Search.dart';
import 'package:project/screens/Join_Event/Leave_Event_Home.dart';
import 'package:project/screens/Join_Event/Leave_Event_Search.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String Category = "";
  String Category_id = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF00BF6D),
          title: const Text(
            'Home',
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
                      child: Text("Thisweek"),
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
        body: Column(children: [
          // Container(
          //   height: MediaQuery.of(context).size.height * 0.18,
          //   padding: const EdgeInsets.fromLTRB(10, 75, 10, 0),
          //   color: const Color(0xFF00BF6D),
          //   child: Row(
          //     children: [
          //       FillOutlineButton(press: () {}, text: "Home", Num: 1),
          //       const SizedBox(width: 6.0),
          //       FillOutlineButton(
          //         press: () {},
          //         text: "To day",
          //         isFilled: false,
          //         Num: 2,
          //       ),
          //       const SizedBox(width: 6.0),
          //       FillOutlineButton(
          //           press: () {}, text: "Tomorrow", isFilled: false, Num: 3),
          //       const SizedBox(width: 6.0),
          //       FillOutlineButton(
          //           press: () {}, text: "This week", isFilled: false, Num: 4),
          //     ],
          //   ),
          // ),
          Container(
              height: MediaQuery.of(context).size.height * 0.741,
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
                      return ListView(
                          scrollDirection: Axis.vertical,
                          children: snapshot.data!.docs.map((cate) {
                            Category = cate["Name"];
                            Category_id = cate["Category_id"];
                            return Column(children: <Widget>[
                              Container(
                                  child: ListTile(
                                title: Text(
                                  "    " + cate["Name"],
                                  style: const TextStyle(
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
                                    stream: FirebaseFirestore.instance
                                        .collection("Event")
                                        //where อาเรย์
                                        .where("Interests", arrayContainsAny: [
                                      Category_id
                                    ]).snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot>
                                            snapshots) {
                                      if (snapshots.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return SizedBox(
                                            height: 239,
                                            width: 220,
                                            child: ListView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                children: snapshots.data!.docs
                                                    .map((Event) {
                                                  return Container(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 15, 10, 10),
                                                      child: SizedBox(
                                                        height: 234,
                                                        width: 220,
                                                        child: Card(
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8.0))),
                                                          child: InkWell(
                                                            onTap: () async => {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "Student")
                                                                  .doc(FirebaseAuth
                                                                      .instance
                                                                      .currentUser
                                                                      ?.uid)
                                                                  .collection(
                                                                      "Posts")
                                                                  //where เช็คค่า
                                                                  .where(
                                                                      "Event_id",
                                                                      isEqualTo:
                                                                          Event
                                                                              .id)
                                                                  .get()
                                                                  .then(
                                                                      (value) async =>
                                                                          {
                                                                            if (value.docs.isEmpty)
                                                                              {
                                                                                await FirebaseFirestore.instance.collection("Event").doc(Event.id).collection("Joined").where("Student_id", isEqualTo: FirebaseAuth.instance.currentUser?.uid).get().then((docsnapshot) => {
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
                                                                                print("Your Event")
                                                                              }
                                                                          })
                                                            },
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            8.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            8.0),
                                                                  ),
                                                                  child: Image.network(
                                                                      Event[
                                                                          "Image"],
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          150,
                                                                      fit: BoxFit
                                                                          .fill),
                                                                ),
                                                                ListTile(
                                                                  title: Text(
                                                                      Event[
                                                                          "Name"],
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              'Raleway')),
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
                            ]);
                          }).toList());
                    }
                  }))
        ]));
  }
}

Selecteditem(BuildContext context, item) {
  switch (item) {
    case 0:
      print("Today");
      break;
    case 1:
      print("Tomorrow");
      break;
    case 2:
      print("Thisweek");
      break;
    case 3:
      print("Default");
      break;
  }
}

BodyToday() {}
