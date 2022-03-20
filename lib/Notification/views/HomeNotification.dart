// ignore_for_file: file_names, non_constant_identifier_names, avoid_print, duplicate_ignore


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/Join_Event/Leave_Event_Home.dart';

class HomeNotification extends StatefulWidget {
  const HomeNotification({Key? key}) : super(key: key);

  @override
  State<HomeNotification> createState() => _HomeNotificationState();
}

class _HomeNotificationState extends State<HomeNotification> {
  String Student_id = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00BF6D),
        title: const Text("Notification"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Notification")
            // where อาเรย์
            .where("Student_id", arrayContainsAny: [
          FirebaseAuth.instance.currentUser?.uid
        ]).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
                child: ListView(
                    scrollDirection: Axis.vertical,
                    children: snapshots.data!.docs.map((document) {
                      return Container(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                        child: SizedBox(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  Leaveeventhome(snap: getsnap(context, document),)),
                              );
                            },
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      topRight: Radius.circular(8.0),
                                    ),
                                    child: Image.network(document["Photo"],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 200,
                                  height: 100,
                                  child: ListTile(
                                    title: Text(
                                      document["Name"],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle:
                                        const Text("This event has changed.",
                                            style: TextStyle(
                                              // fontSize: 18,
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.w600,
                                            )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // ),
                      );
                      // );
                    }).toList()));
          }
        },
      ),
    );
  }
  getsnap(BuildContext context,document) async {
  QueryDocumentSnapshot<Object?> snap =
      FirebaseFirestore.instance.collection("Event").doc(document.id) as QueryDocumentSnapshot<Object?>;
   return snap;
}
}
