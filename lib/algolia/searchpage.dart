// ignore_for_file: unnecessary_const, curly_braces_in_flow_control_structures, unnecessary_new, non_constant_identifier_names, use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, await_only_futures, deprecated_member_use, prefer_is_empty, prefer_final_fields, unused_field, unused_element, unrelated_type_equality_checks
import 'package:firebase_auth/firebase_auth.dart';
import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/Join_Event/Event_detail_Search.dart';
import 'package:project/screens/Join_Event/Leave_Event_Search.dart';
import 'package:project/screens/editeventpost.dart';
import 'package:snapshot/snapshot.dart';
// import 'package:project/algolia/AlgoliaApplication.dart';
// import 'package:project/algolia/AlgoliaApplication.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchText = TextEditingController(text: "");
  List<AlgoliaObjectSnapshot> _results = [];
  bool _searching = false;

  _search() async {
    setState(() {
      _searching = true;
    });

    Algolia algolia = Algolia.init(
      applicationId: 'ZO4XKCM05Q',
      apiKey: 'b57d151dcd4821d1df6a23485e70ec2d',
    );

    AlgoliaQuery query = algolia.instance.index('Event');
    query = query.search(_searchText.text);

    _results = (await query.getObjects()).hits;

    setState(() {
      _searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(15, 75, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _searchText,
              decoration: InputDecoration(hintText: "Search....."),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  color: Colors.blue,
                  child: Text(
                    "Search",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  onPressed: _search,
                ),
              ],
            ),
            Expanded(
              child: _searching == true
                  ? Center(
                      child: Text(
                        "Searching, please wait...",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : _results.length == 0
                      ? Center(
                          child: Text(
                            "No results found.",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _results.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            AlgoliaObjectSnapshot snap = _results[index];

                            return Container(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 15, 10, 10),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: InkWell(
                                  onTap: () async {
                                    await FirebaseFirestore.instance
                                        .collection("Student")
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.uid)
                                        .collection("Posts")
                                        .where("Event_id",
                                            isEqualTo: snap.objectID)
                                        .get()
                                        .then((value) async => {
                                              if (value.docs.length == 0)
                                                {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Event")
                                                      .doc(snap.objectID)
                                                      .collection("Joined")
                                                      .where("Student_id",
                                                          isEqualTo:
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  ?.uid)
                                                      .get()
                                                      .then((docsnapshot) => {
                                                            // ignore: avoid_print
                                                            print(docsnapshot
                                                                .docs.length),
                                                            if (docsnapshot.docs
                                                                    .length ==
                                                                0)
                                                              // ignore: avoid_print
                                                              {
                                                                print(
                                                                    "dont have"),
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                eventdetail(snap: snap)))
                                                              }
                                                            else
                                                              // ignore: avoid_print
                                                              {
                                                                print("had"),
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Leaveevent(snap: snap)))
                                                              }
                                                          })
                                                }
                                              else
                                                {print("Your Event")}
                                            });
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0),
                                        ),
                                        child: Image.network(snap.data["Image"],
                                            width: 300,
                                            height: 150,
                                            fit: BoxFit.fill),
                                      ),
                                      ListTile(
                                        title: Text(snap.data["Name"],
                                            style: TextStyle(
                                                fontFamily: 'Raleway')),
                                        subtitle: Text(
                                            " " + snap.data["Description"],
                                            style: TextStyle(
                                                fontFamily: 'Raleway')),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


// -------------------------------------------------------------------------------------------------------------


//  class _SearchBarState extends State<SearchBar> {

  
//   final Algolia _algoliaApp = AlgoliaApplication.algolia;
//   // String? _searchTerm;
//   bool _searching = false;
  

  // Future<List<AlgoliaObjectSnapshot>> _operation( _searching) async {
    // List<AlgoliaObjectSnapshot> _results = [];
    
    // AlgoliaQuery query = await _algoliaApp.instance.index('Event');
    // query = await query.search(_searchTerm);

    // AlgoliaQuery query = _algoliaApp.instance.index('Event');
    // query = query.search(_searching.text);

    // _results = (await query.getObjects()).hits;

    // setState(() {
    //   _searching = false;
    // });
  // }

    // AlgoliaQuerySnapshot querySnap = await query.getObjects();
    // List<AlgoliaObjectSnapshot> results = querySnap.hits;
    // return results;
  // }

//   class _SearchBarState extends State<SearchBar> {
//   final TextEditingController _searchText = TextEditingController(text: "");
//   List<AlgoliaObjectSnapshot> _results = [];
//   bool _searching = false;

//   _search() async {
//     setState(() {
//       _searching = true;
//     });

//     Algolia algolia = Algolia.init(
//       applicationId: 'ZO4XKCM05Q',
//       apiKey: 'b57d151dcd4821d1df6a23485e70ec2d',
//     );

//     AlgoliaQuery query = algolia.instance.index('Event');
//     query = query.search(_searchText.text);

//     _results = (await query.getObjects()).hits;

//     setState(() {
//       _searching = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             " Algolia",
//             style: TextStyle(color: Colors.black),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Column(children: <Widget>[
//             TextField(
//                 onChanged:(_search)async{
//                   setState(() {
//                     _search;
//                   });
//                 },
//                 style: const TextStyle(color: Colors.black, fontSize: 20),
//                 decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     hintText: 'Search',
//                     hintStyle: const TextStyle(color: Colors.black),
//                     prefixIcon: const Icon(Icons.search, color: Colors.black))),
//             StreamBuilder<List<AlgoliaObjectSnapshot>>(
//               // stream: Stream.fromFuture((_searchTerm)),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData)
//                   return const Text(
//                     "Start Typing",
//                     style: TextStyle(color: Colors.black),
//                   );
//                 else {
//                   List<AlgoliaObjectSnapshot>? _results = snapshot.data;

//                   switch (snapshot.connectionState) {
//                     case ConnectionState.waiting:
//                       return Container();
//                     default:
//                       if (snapshot.hasError)
//                         return new Text('Error: ${snapshot.error}');
//                       else
//                         return CustomScrollView(
//                           shrinkWrap: true,
//                           slivers: <Widget>[
//                             SliverList(
//                               delegate: SliverChildBuilderDelegate(
//                                 (context, index) {
//                                   return _results!.length == 0 ?
//                                 //  _results!.length == 0 {
//                                      DisplaySearchResult(
//                                           Description: _results[index]
//                                               .data["Description"],
//                                           Name: _results[index]
//                                               .data["Name"],
//                                           interests: _results[index]
//                                               .data["interests"],
//                                         ) :
//                               Container();
                                  
//                                 },
//                               ),
//                             ),
//                           ],
//                         );
//                   }
//                 }
//               },
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }

// class DisplaySearchResult extends StatelessWidget {
//    String? Description;
//    String? Name;
//    String? interests;

//   DisplaySearchResult( 
//   {Key? key, this.Description, this.Name, this.interests}) : super(key: key);
  

//   @override
//   Widget build(BuildContext context) {
//     return Column(children: <Widget>[
//       Text(
//         Description ?? "",
//         style: const TextStyle(color: Colors.black),
//       ),
//       Text(
//         Name ?? "",
//         style: const TextStyle(color: Colors.black),
//       ),
//       Text(
//         interests ?? "",
//         style: const TextStyle(color: Colors.black),
//       ),
//       const Divider(
//         color: Colors.black,
//       ),
//       const SizedBox(height: 20)
//     ]);
//   }
// }