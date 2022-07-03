// ignore_for_file: file_names, non_constant_identifier_names, avoid_print, duplicate_ignore, avoid_function_literals_in_foreach_calls, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart';
import 'package:project/Notification/views/Homedetailnoto.dart';
import 'package:project/screens/Join_Event/Leave_Event_Home.dart';
import 'package:provider/provider.dart';

import '../../blocs/auth_bloc.dart';
import '../../screens/login.dart';

class HomeNotification extends StatefulWidget {
  const HomeNotification({Key? key}) : super(key: key);

  @override
  State<HomeNotification> createState() => _HomeNotificationState();
}

class _HomeNotificationState extends State<HomeNotification> {
  String Student_id = "";

  // Future<void> getdata() async{
  //   QuerySnapshot snap = await FirebaseFirestore.instance.collection('Notification').get();
  //   snap.docs.forEach((element) {
  //     element['']
  //   })
  // }
 @override
  void initState() {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 150, 140),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 150, 140),
        // title: const Text(
        //   "Notification",
        //   style: TextStyle(
        //     letterSpacing: 1,
        //     fontSize: 22,
        //     fontFamily: 'Raleway',
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
      ),
      body: Container(
        // height: double.infinity,
        //     width: double.infinity,
        //     decoration: const BoxDecoration(
        //       image: DecorationImage(
        //           image: NetworkImage(
        //               //"https://images.pexels.com/photos/7135115/pexels-photo-7135115.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
        //               //"https://images.pexels.com/photos/12117995/pexels-photo-12117995.jpeg"
        //               "https://i.pinimg.com/originals/04/0c/17/040c17aaaca451eb4626e2ada7fa4b58.jpg"),
        //           fit: BoxFit.cover),
        //     ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Notification")
              .orderBy('date', descending: true)
              .orderBy('Time', descending: true)
              // where อาเรย์
              .where("Student_id",arrayContainsAny: [
            FirebaseAuth.instance.currentUser?.uid
          ]

          
          ).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshots.data!.docs.isEmpty) {
              return const Center(
                child: Text('no notification',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                    )),
              );
            } else {
              return Center(
                  child: ListView(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      scrollDirection: Axis.vertical,
                      children: snapshots.data!.docs.map((document) {
                        return Container(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: InkWell(
                              onTap: () async {
                                getsnap(context, document);
                              },
                              child: Row(
                                children: <Widget>[
                                  const Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5)),
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
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
                                    width: 220,
                                    height: 90,
                                    child: ListTile(
                                      title: Text(
                                        (document["Name"]) +
                                            ("\n") +
                                            (document["date"]) +
                                            ("\n") +
                                            (document["Time"]),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          // fontFamily: 'Smooch',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(Textsubtitle(document),
                                          style: const TextStyle(
                                            color:
                                                Color.fromARGB(173, 11, 11, 11),
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
      ),
    );
  }

  Textsubtitle(document) {
    late String text;
    if (document['Type'] == '1') {
      text = "This event has changed.";
    } 
    // else if(){

    // }
    else {
      if (document['StatusofApproved'] == 'correct') {
        text = "This category is correct.";
      } else {
        text = "This category is incorrect.";
      }
    }

    return text;
  }

  getsnap(BuildContext context, document) async {
    QuerySnapshot snaps = await FirebaseFirestore.instance
        .collection('Event')
        .where("Name", isEqualTo: document["Name"])
        .where("Image", isEqualTo: document["Photo"])
        .get();

    snaps.docs.forEach((element) async {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => detailnoti(snap: element)));
    });
  }
}
