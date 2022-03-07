// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class Today extends StatefulWidget {
//   const Today({Key? key}) : super(key: key);

//   @override
//   _TodayState createState() => _TodayState();
// }

// class _TodayState extends State<Today> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: StreamBuilder(
//             stream: FirebaseFirestore.instance.collection("Event").snapshots(),
//             builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else if (snapshot.data?.docs.length == 0) {
//                 return Container(
//                     padding: const EdgeInsets.fromLTRB(0, 55, 0, 30),
//                     child: const Text(
//                       "NOT HAVE EVENT.",
//                       style: TextStyle(
//                           fontFamily: "Raleway",
//                           fontSize: 16,
//                           fontWeight: FontWeight.w300),
//                       textAlign: TextAlign.center,
//                     ));
//               } else {
//                 return  ListView(
//                           children: snapshot.data!.docs.map((today) {
                        
//                         return Container(
//                           padding: const EdgeInsets.all(10),
//                           decoration: const BoxDecoration(
//                               border: Border(
//                             top: BorderSide(
//                                 width: 0.5, color: Color(0xFF7F7F7F)),
//                             right: BorderSide(
//                                 width: 1.0, color: Color(0xFF7F7F7F)),
//                             bottom: BorderSide(
//                                 width: 0.5, color: Color(0xFF7F7F7F)),
//                           )),
//                           child: ListTile(
//                             leading: CircleAvatar(
//                               child: Text(today["Name"]),
//                               backgroundColor: Colors.orange[300],
//                             ),
//                             title: Text(
//                               today["Name"],
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                             onTap: () {
                             
//                             },
//                           ),
//                         );
//                       }).toList());
//               }
//             }));
//   }
// }
