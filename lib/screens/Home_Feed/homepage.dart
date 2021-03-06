// ignore_for_file: unused_import, non_constant_identifier_names, avoid_unnecessary_containers, avoid_print, duplicate_ignore, must_be_immutable, use_key_in_widget_constructors, prefer_is_empty, prefer_typing_uninitialized_variables

import 'dart:math';

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
import 'package:provider/provider.dart';

import '../../blocs/auth_bloc.dart';
import '../editeventpost.dart';
import '../login.dart';

class Homefeed extends StatefulWidget {
  @override
  _HomefeedState createState() => _HomefeedState();
}

class _HomefeedState extends State<Homefeed> {
  String Category = "";
  String Category_id = "";
  List ListCate = [];
  List Listcheckmax = [];
  List Cateshow = [];
  String? id;
  var listedit;
  var list;
  QuerySnapshot? b;

  Future<void> adddataCategory() async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection("Category").get();
    List allData = snap.docs.map((doc) => doc.data()).toList();
    ListCate = allData;
    for (int a = 0; a < ListCate.length; a++) {
      QuerySnapshot snaps = await FirebaseFirestore.instance
          .collection("Category")
          .where('Name', isEqualTo: ListCate[a]['Name'])
          .where('Description', isEqualTo: ListCate[a]['Description'])
          .get();
      snaps.docs.forEach((element) {
        id = element.id;
      });

      var check = await FirebaseFirestore.instance.collection("Event").where(
        "Interests",
        arrayContainsAny: [id],
      ).get();
      var lenght = check.docs.length;
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('Student')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Categories')
          .where('Category_id', isEqualTo: id)
          .get();

      snap.docs.forEach((element) async {
        await FirebaseFirestore.instance
            .collection('Student')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('Categories')
            .doc(element.id)
            .update({'Count_Event': lenght});
      });
    }
  }

  @override
  void initState() {
    adddataCategory();
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    authBloc.currentUser.listen((User) async {
      if (User == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });
    super.initState();
  }

  // Future addtolist() async {
  //   QuerySnapshot snapforchoosed = await FirebaseFirestore.instance
  //       .collection("Student")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection("Categories")
  //       .get();
  //   List hasData = snapforchoosed.docs.map((doc) => doc.data()).toList();
  //   ListCate = hasData;
  //   for (int a = 0; a < ListCate.length; a++) {
  //     QuerySnapshot Countevent = await FirebaseFirestore.instance
  //         .collection('Event')
  //         .where('Interests',
  //             arrayContainsAny: [ListCate[a]['Category_id']]).get();
  //     Listcheckmax.add(Countevent.docs.length);
  //   }

  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 30, 150, 140),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 30, 150, 140),
          // title: const Text(
          //   "????????????????????????",
          //   style: TextStyle(
          //     fontSize: 22,
          //     fontFamily: 'Raleway',
          //     fontWeight: FontWeight.w400,
          //   ),
          // ),
          actions: [
            Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.black),
                child: PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    // const PopupMenuItem<int>(
                    //   value: 4,
                    //   child: Text("Starting soon!"),
                    // ),
                    // const PopupMenuDivider(),
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("????????????????????????????????????????????????"),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("??????????????????????????????????????????????????????"),
                    ),
                    const PopupMenuItem<int>(
                      value: 2,
                      child: Text("???????????????????????????????????? 7 ?????????"),
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
        body: Container(
          // height: double.infinity,
          //   width: double.infinity,
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //         image: NetworkImage(
          //             //"https://images.pexels.com/photos/7135115/pexels-photo-7135115.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
          //             //"https://images.pexels.com/photos/12117995/pexels-photo-12117995.jpeg"
          //             "https://i.pinimg.com/originals/04/0c/17/040c17aaaca451eb4626e2ada7fa4b58.jpg"),
          //         fit: BoxFit.cover),
          //   ),
          child: ListView(children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.765,
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Student')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .collection('Categories')
                        .orderBy('Count_Event', descending: true)
                        .orderBy('Name', descending: true)
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
          ]),
        ));
  }

  Future getLength(Category_id, Category) async {
    var check = await FirebaseFirestore.instance.collection("Event").where(
      "Interests",
      arrayContainsAny: [Category_id],
    ).get();

    var lenght = check.docs.length;

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
                              //where ??????????????????

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
                                                        //where ?????????????????????
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
                                                        title: Text(Event["Name"],
                                                            style: const TextStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
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
        ;
        // print(body);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Today()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Tomorrow()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const thisweek()));
    }
  }
}
